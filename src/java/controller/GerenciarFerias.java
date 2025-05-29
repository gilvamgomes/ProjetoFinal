package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import model.Ferias;
import model.FeriasDAO;

public class GerenciarFerias extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarFerias.response = response;

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idFerias = request.getParameter("idFerias");
        String acao = request.getParameter("acao");
        Ferias f = new Ferias();

        try {
            FeriasDAO fDAO = new FeriasDAO();
            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (idFerias != null && !idFerias.isEmpty()) {
                        f = fDAO.getCarregaPorID(Integer.parseInt(idFerias));
                        if (f.getIdFerias() > 0) {
                            RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_ferias.jsp");
                            request.setAttribute("ferias", f);
                            disp.forward(request, response);
                            return;
                        } else {
                            mensagem = "Férias não encontrada";
                        }
                    } else {
                        mensagem = "ID inválido";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

            if ("excluir".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (idFerias != null && !idFerias.isEmpty()) {
                        f.setIdFerias(Integer.parseInt(idFerias));
                        if (fDAO.excluir(f)) {
                            mensagem = "Férias excluída com sucesso";
                        } else {
                            mensagem = "Erro ao excluir as férias";
                        }
                    } else {
                        mensagem = "ID inválido";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro ao acessar o banco de dados: " + e.getMessage();
        }

        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='listar_ferias.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarFerias.response = response;
        response.setContentType("text/html");

        String idFerias = request.getParameter("idFerias");
        String dataInicio = request.getParameter("dataInicio");
        String dataFim = request.getParameter("dataFim");
        String status = request.getParameter("status");
        String funcionarioId = request.getParameter("funcionario_idFfuncionario");

        ArrayList<String> erros = new ArrayList<>();

        if (dataInicio == null || dataInicio.trim().isEmpty()) erros.add("Preencha a data de início");
        if (dataFim == null || dataFim.trim().isEmpty()) erros.add("Preencha a data de fim");
        if (status == null || status.trim().isEmpty()) erros.add("Preencha o status");
        if (funcionarioId == null || funcionarioId.trim().isEmpty()) erros.add("Informe o ID do funcionário");

        if (!erros.isEmpty()) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s): " + campos, false);
        } else {
            Ferias f = new Ferias();
            try {
                if (idFerias != null && !idFerias.isEmpty()) {
                    f.setIdFerias(Integer.parseInt(idFerias));
                }

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                f.setDataInicio(sdf.parse(dataInicio));
                f.setDataFim(sdf.parse(dataFim));
                f.setStatus(status);
                f.setFuncionario_idFfuncionario(Integer.parseInt(funcionarioId));

                FeriasDAO fDAO = new FeriasDAO();
                if (fDAO.gravar(f)) {
                    exibirMensagem("Férias gravada com sucesso", true);
                } else {
                    exibirMensagem("Erro ao gravar as férias", false);
                }

            } catch (Exception e) {
                e.printStackTrace();
                exibirMensagem("Erro ao processar os dados: " + e.getMessage(), false);
            }
        }
    }

    private static void exibirMensagem(String mensagem, boolean resposta) {
        try {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('" + mensagem + "');");
            if (resposta) {
                out.println("location.href='listar_ferias.jsp';");
            } else {
                out.println("history.back();");
            }
            out.println("</script>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Gerencia férias no sistema da Ótica";
    }
}
