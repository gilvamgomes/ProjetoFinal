package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.Beneficio;
import model.BeneficioDAO;

public class GerenciarBeneficio extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarBeneficio.response = response;

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idBeneficio = request.getParameter("idBeneficio");
        String acao = request.getParameter("acao");
        Beneficio b = new Beneficio();

        try {
            BeneficioDAO bDAO = new BeneficioDAO();
            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (idBeneficio != null && !idBeneficio.isEmpty()) {
                        b = bDAO.getCarregaPorID(Integer.parseInt(idBeneficio));
                        if (b.getIdBeneficio() > 0) {
                            RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_beneficio.jsp");
                            request.setAttribute("b", b);
                            disp.forward(request, response);
                            return;
                        } else {
                            mensagem = "Benefício não encontrado";
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
                    if (idBeneficio != null && !idBeneficio.isEmpty()) {
                        b.setIdBeneficio(Integer.parseInt(idBeneficio));
                        if (bDAO.excluir(b)) {
                            mensagem = "Benefício desativado com sucesso";
                        } else {
                            mensagem = "Erro ao desativar o benefício";
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
        out.println("location.href='listar_beneficio.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarBeneficio.response = response;
        response.setContentType("text/html");

        String idBeneficio = request.getParameter("idBeneficio");
        String nome = request.getParameter("nome");
        String descricao = request.getParameter("descricao");
        String status = request.getParameter("status");

        ArrayList<String> erros = new ArrayList<>();

        if (nome == null || nome.trim().isEmpty()) erros.add("Preencha o nome");
        if (descricao == null || descricao.trim().isEmpty()) erros.add("Preencha a descrição");
        if (status == null || status.trim().isEmpty()) erros.add("Preencha o status");

        if (!erros.isEmpty()) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s): " + campos, false);
        } else {
            Beneficio b = new Beneficio();
            if (idBeneficio != null && !idBeneficio.isEmpty()) {
                try {
                    b.setIdBeneficio(Integer.parseInt(idBeneficio));
                } catch (NumberFormatException e) {
                    exibirMensagem("ID de benefício inválido", false);
                    return;
                }
            }

            b.setNome(nome);
            b.setDescricao(descricao);
            b.setStatus(Integer.parseInt(status));

            try {
                BeneficioDAO bDAO = new BeneficioDAO();
                if (bDAO.gravar(b)) {
                    exibirMensagem("Gravado com sucesso", true);
                } else {
                    exibirMensagem("Erro ao gravar o benefício", false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                exibirMensagem("Erro ao gravar no banco de dados", false);
            }
        }
    }

    private static void exibirMensagem(String mensagem, boolean resposta) {
        try {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('" + mensagem + "');");
            if (resposta) {
                out.println("location.href='listar_beneficio.jsp';");
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
        return "Gerencia benefícios no sistema da Ótica";
    }
}