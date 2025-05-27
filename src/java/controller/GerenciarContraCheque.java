package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.ContraCheque;
import model.ContraChequeDAO;

public class GerenciarContraCheque extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarContraCheque.response = response;

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idContraCheque = request.getParameter("idContraCheque");
        String acao = request.getParameter("acao");
        ContraCheque c = new ContraCheque();

        try {
            ContraChequeDAO cDAO = new ContraChequeDAO();
            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (idContraCheque != null && !idContraCheque.isEmpty()) {
                        c = cDAO.getCarregaPorID(Integer.parseInt(idContraCheque));
                        if (c.getIdContraCheque() > 0) {
                            RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_contra_cheque.jsp");
                            request.setAttribute("c", c);
                            disp.forward(request, response);
                            return;
                        } else {
                            mensagem = "Contra-cheque não encontrado";
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
                    if (idContraCheque != null && !idContraCheque.isEmpty()) {
                        c.setIdContraCheque(Integer.parseInt(idContraCheque));
                        if (cDAO.excluir(c)) {
                            mensagem = "Contra-cheque excluído com sucesso";
                        } else {
                            mensagem = "Erro ao excluir o contra-cheque";
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
        out.println("location.href='listar_contra_cheque.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarContraCheque.response = response;
        response.setContentType("text/html");

        String idContraCheque = request.getParameter("idContraCheque");
        String valorBruto = request.getParameter("valorBruto");
        String descontos = request.getParameter("descontos");
        String valorLiquido = request.getParameter("valorLiquido");
        String funcionarioId = request.getParameter("funcionarioId");

        ArrayList<String> erros = new ArrayList<>();

        if (valorBruto == null || valorBruto.trim().isEmpty()) erros.add("Preencha o valor bruto");
        if (descontos == null || descontos.trim().isEmpty()) erros.add("Preencha os descontos");
        if (valorLiquido == null || valorLiquido.trim().isEmpty()) erros.add("Preencha o valor líquido");
        if (funcionarioId == null || funcionarioId.trim().isEmpty()) erros.add("Informe o ID do funcionário");

        if (!erros.isEmpty()) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s): " + campos, false);
        } else {
            ContraCheque c = new ContraCheque();
            if (idContraCheque != null && !idContraCheque.isEmpty()) {
                try {
                    c.setIdContraCheque(Integer.parseInt(idContraCheque));
                } catch (NumberFormatException e) {
                    exibirMensagem("ID de contra-cheque inválido", false);
                    return;
                }
            }

            try {
                c.setValorBruto(new java.math.BigDecimal(valorBruto));
                c.setDescontos(new java.math.BigDecimal(descontos));
                c.setValorLiquido(new java.math.BigDecimal(valorLiquido));
                c.setFuncionarioId(Integer.parseInt(funcionarioId));

                ContraChequeDAO cDAO = new ContraChequeDAO();
                if (cDAO.gravar(c)) {
                    exibirMensagem("Gravado com sucesso", true);
                } else {
                    exibirMensagem("Erro ao gravar o contra-cheque", false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                exibirMensagem("Erro ao processar dados: " + e.getMessage(), false);
            }
        }
    }

    private static void exibirMensagem(String mensagem, boolean resposta) {
        try {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('" + mensagem + "');");
            if (resposta) {
                out.println("location.href='listar_contra_cheque.jsp';");
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
        return "Gerencia contra-cheques no sistema da Ótica";
    }
}
