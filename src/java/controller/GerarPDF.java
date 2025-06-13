package controller;

import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import model.ContraCheque;
import model.ContraChequeDAO;
import model.EventoContraCheque;
import model.Imposto;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class GerarPDF extends HttpServlet {

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

        ContraChequeDAO dao = null;
        ContraCheque c = null;
        try {
            dao = new ContraChequeDAO();
            c = dao.getCarregaPorID(id);
        } catch (Exception ex) {
            // Se falhar ao conectar/buscar, mostra erro simples e retorna
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>Erro ao acessar o banco de dados: " + ex.getMessage() + "</h3>");
            return;
        }

        // 2) Se não encontrou, exibe mensagem e retorna
        if (c == null || c.getIdContraCheque() == 0) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>Contra-cheque não encontrado.</h3>");
            return;
        }

        // 3) Busca eventos e impostos associados
        List<EventoContraCheque> eventos;
        List<Imposto> impostos;
        try {
            eventos = dao.getEventosPorContraCheque(id);
            impostos = dao.getImpostosPorContraCheque(id);
        } catch (Exception ex) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<h3>Erro ao carregar eventos ou impostos: " + ex.getMessage() + "</h3>");
            return;
        }

        // 4) Monta conteúdo HTML que será transformado em PDF
        String nomeFuncionario = (c.getNomeFuncionario() == null || c.getNomeFuncionario().trim().isEmpty())
                ? "Funcionário ID " + c.getFuncionarioId()
                : c.getNomeFuncionario();

        // 5) Monta tabela de eventos
        StringBuilder eventosHtml = new StringBuilder();
        for (EventoContraCheque e : eventos) {
            eventosHtml.append("<tr>")
                       .append("<td>").append(e.getDescricao()).append("</td>")
                       .append("<td>").append(e.isEhDesconto() ? "Desconto" : "Vencimento").append("</td>")
                       .append("<td>R$ ").append(safe(e.getValor())).append("</td>")
                       .append("</tr>");
        }

        // 6) Monta tabela de impostos
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

        // 7) Constrói o HTML completo
        StringBuilder html = new StringBuilder();
        html.append("<html><head><meta charset='UTF-8'>")
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
            .append("<table>")
            .append("<tr><th>Descrição</th><th>Tipo</th><th>Valor</th></tr>")
            .append(eventosHtml)
            .append("</table>")
            .append("<br/><h3>Impostos</h3>")
            .append("<table>")
            .append("<tr><th>Descrição</th><th>Alíquota</th><th>Valor</th></tr>")
            .append(impostosHtml)
            .append("</table>")
            .append("<div class='resumo'><p>Gerado automaticamente pelo sistema RH – Ótica Milano</p></div>")
            .append("</body></html>");

        // 8) Opcional: grava HTML em disco para debugar
        try {
            File dir = new File("C:/temp");
            if (!dir.exists()) dir.mkdirs();
            try (FileOutputStream fos = new FileOutputStream("C:/temp/html_debug.html")) {
                fos.write(html.toString().getBytes(StandardCharsets.UTF_8));
            }
        } catch (Exception ex) {
            System.out.println("Erro ao salvar HTML de debug: " + ex.getMessage());
        }

        // 9) Configura a resposta como PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=contra_cheque_" + id + ".pdf");

        // 10) Gera o PDF (sem chamar getWriter())
        try {
            Document document = new Document();
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            InputStream htmlStream = new ByteArrayInputStream(html.toString().getBytes(StandardCharsets.UTF_8));
            XMLWorkerHelper.getInstance().parseXHtml(writer, document, htmlStream, StandardCharsets.UTF_8);
            document.close();
        } catch (Exception exPdf) {
            // Se algo der errado durante a geração, apenas registra no log.
            // Não tentamos chamar getWriter() depois de já ter aberto o OutputStream.
            System.out.println("❌ Erro ao gerar PDF: " + exPdf.getMessage());
            exPdf.printStackTrace();
            // Opcional: poderíamos chamar response.reset() e depois exibir uma mensagem plain-text:
            // try {
            //     response.reset();
            //     response.setContentType("text/html; charset=UTF-8");
            //     response.getWriter().println("<h3>Falha na geração do PDF: " + exPdf.getMessage() + "</h3>");
            // } catch (IOException ignore) {}
        }
    }

    /**
     * Utility: se o objeto for nulo, retorna "0.00"; senão faz toString().
     */
    private String safe(Object o) {
        return (o == null) ? "0.00" : o.toString();
    }
}
