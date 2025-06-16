package controller;

import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import model.ContraCheque;
import model.ContraChequeDAO;
import model.EventoContraCheque;
import model.Imposto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "GerarPDF", urlPatterns = {"/GerarPDF"})
public class GerarPDF extends HttpServlet {

    private static final Logger logger = Logger.getLogger(GerarPDF.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Lê o parâmetro "idContraCheque" da URL
        int id;
        try {
            id = Integer.parseInt(request.getParameter("idContraCheque"));
        } catch (NumberFormatException ex) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>ID de contra-cheque inválido.</h3>");
            return;
        }

        // 2) Carrega o contra-cheque
        ContraChequeDAO dao;
        ContraCheque c;
        try {
            dao = new ContraChequeDAO();
            c = dao.getCarregaPorID(id);
        } catch (Exception ex) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>Erro ao acessar o banco de dados: " + ex.getMessage() + "</h3>");
            logger.log(Level.SEVERE, "Falha ao carregar ContraCheque ID=" + id, ex);
            return;
        }

        if (c == null || c.getIdContraCheque() == 0) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>Contra-cheque não encontrado.</h3>");
            logger.warning("ContraCheque não encontrado para ID=" + id);
            return;
        }

        // 3) Busca eventos e impostos
        List<EventoContraCheque> eventos;
        List<Imposto> impostos;
        try {
            eventos = dao.getEventosPorContraCheque(id);
            impostos = dao.getImpostosPorContraCheque(id);
            logger.info("getEventosPorContraCheque retornou " + eventos.size() + " eventos; "
                      + "getImpostosPorContraCheque retornou " + impostos.size() + " impostos para ID=" + id);
        } catch (Exception ex) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>Erro ao carregar eventos ou impostos: " + ex.getMessage() + "</h3>");
            logger.log(Level.SEVERE, "Erro ao buscar eventos/impostos para ID=" + id, ex);
            return;
        }

        // 4) Monta HTML (note que agora o <meta> está autoclosing para evitar erro de tags inválidas)
        String nomeFuncionario = (c.getNomeFuncionario() == null || c.getNomeFuncionario().trim().isEmpty())
                ? "Funcionário ID " + c.getFuncionarioId()
                : c.getNomeFuncionario();

        StringBuilder eventosHtml = new StringBuilder();
        for (EventoContraCheque e : eventos) {
            eventosHtml.append("<tr>")
                       .append("<td>").append(e.getDescricao()).append("</td>")
                       .append("<td>").append(e.isEhDesconto() ? "Desconto" : "Vencimento").append("</td>")
                       .append("<td>R$ ").append(safe(e.getValor())).append("</td>")
                       .append("</tr>");
        }

        StringBuilder impostosHtml = new StringBuilder();
        if (impostos != null && !impostos.isEmpty()) {
            for (Imposto i : impostos) {
                BigDecimal valorImp = (i.getValorDescontado() != null ? i.getValorDescontado() : BigDecimal.ZERO);
                impostosHtml.append("<tr>")
                            .append("<td>").append(i.getDescricao()).append("</td>")
                            .append("<td>").append(safe(i.getAliquota())).append("%</td>")
                            .append("<td>R$ ").append(safe(valorImp)).append("</td>")
                            .append("</tr>");
            }
        } else {
            impostosHtml.append("<tr><td colspan='3' style='text-align:center;'>Nenhum imposto registrado.</td></tr>");
        }

        StringBuilder html = new StringBuilder();
        html.append("<html xmlns='http://www.w3.org/1999/xhtml'><head>")
            .append("<meta charset='UTF-8'/>")  // self-closed meta
            .append("<style>")
            .append("body { font-family: Arial, sans-serif; font-size: 10pt; }")
            .append("h1 { color: #003366; font-size: 16pt; }")
            .append("table { width: 100%; border-collapse: collapse; }")
            .append("th, td { border: 1px solid #ccc; padding: 4px; }")
            .append("th { background-color: #f0f0f0; }")
            .append(".resumo { margin-top: 20px; font-size: 8pt; color: #666; }")
            .append("</style></head><body>")
            .append("<h1>Contra-Cheque - Ótica Milano</h1>")
            .append("<p><strong>Funcionário:</strong> ").append(nomeFuncionario).append("</p>")
            .append("<p><strong>Mês/Ano:</strong> ").append(c.getMes()).append("/").append(c.getAno()).append("</p>")
            .append("<p><strong>Valor Bruto:</strong> R$ ").append(safe(c.getValorBruto())).append("</p>")
            .append("<p><strong>Descontos:</strong> R$ ").append(safe(c.getDescontos())).append("</p>")
            .append("<p><strong>Valor Líquido:</strong> R$ ").append(safe(c.getValorLiquido())).append("</p>")
            .append("<br/><h3>Eventos</h3>")
            .append("<table><tr><th>Descrição</th><th>Tipo</th><th>Valor</th></tr>")
            .append(eventosHtml)
            .append("</table>")
            .append("<br/><h3>Impostos</h3>")
            .append("<table><tr><th>Descrição</th><th>Alíquota</th><th>Valor</th></tr>")
            .append(impostosHtml)
            .append("</table>")
            .append("<div class='resumo'><p>Gerado automaticamente pelo sistema RH – Ótica Milano</p></div>")
            .append("</body></html>");

        // 5) Salva HTML de debug (opcional)
        try {
            Files.createDirectories(Paths.get("C:/temp"));
            Files.write(Paths.get("C:/temp/html_debug.html"), html.toString().getBytes(StandardCharsets.UTF_8));
        } catch (Exception ex) {
            logger.log(Level.WARNING, "Erro ao salvar HTML de debug: " + ex.getMessage(), ex);
        }

        // 6) Configura resposta PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=contra_cheque_" + id + ".pdf");

        // 7) Gera o PDF com log de sucesso/erro
        try {
            Document document = new Document();
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            InputStream htmlStream = new ByteArrayInputStream(html.toString().getBytes(StandardCharsets.UTF_8));
            XMLWorkerHelper.getInstance().parseXHtml(writer, document, htmlStream, StandardCharsets.UTF_8);
            document.close();
            logger.info("PDF gerado com sucesso para idContraCheque=" + id);
        } catch (Exception exPdf) {
            logger.log(Level.SEVERE, "Erro ao gerar PDF para idContraCheque=" + id + ": " + exPdf.getMessage(), exPdf);
            response.reset();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<h2>Falha ao gerar o PDF</h2>" +
                "<pre>" + exPdf.getMessage() + "</pre>"
            );
        }
    }

    /**
     * Utility: retorna string de null-safe ou toString().
     */
    private String safe(Object o) {
        return (o == null) ? "0.00" : o.toString();
    }
}
