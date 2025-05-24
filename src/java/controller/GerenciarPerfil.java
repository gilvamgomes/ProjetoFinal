package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.Perfil;
import model.PerfilDAO;

public class GerenciarPerfil extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idPerfil = request.getParameter("idPerfil");
        String acao = request.getParameter("acao");
        Perfil p = new Perfil();

        try {
            PerfilDAO pDAO = new PerfilDAO();
            if ("alterar".equals(acao)) {

                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        p = pDAO.getCarregaPorID(Integer.parseInt(idPerfil));
                    } catch (Exception ex) {
                        Logger.getLogger(GerenciarPerfil.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    if (p.getIdPerfil() > 0) {
                        RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_perfil.jsp");
                        request.setAttribute("p", p);
                        disp.forward(request, response);
                        return; // interrompe para não exibir alerta depois
                    } else {
                        mensagem = "Perfil não encontrado";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

            if ("excluir".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (Integer.parseInt(idPerfil) != 0) {
                        p.setIdPerfil(Integer.parseInt(idPerfil));
                        if (pDAO.excluir(p)) {
                            mensagem = "Perfil desativado com sucesso";
                        } else {
                            mensagem = "Erro ao desativar o perfil";
                        }
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }
        } catch (Exception e) {
            out.println(e);
            mensagem = "Erro ao acessar o banco de dados";
        }

        // Exibir mensagem e redirecionar
        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='listar_perfil.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String nome = request.getParameter("nome");
        String idPerfil = request.getParameter("idPerfil");
        String status = request.getParameter("status");
        String mensagem = "";

        if (nome == null || nome.trim().isEmpty() || status == null) {
            mensagem = "Os campos obrigatórios deverão ser preenchidos";
        } else {
            Perfil p = new Perfil();
            if (idPerfil != null && !idPerfil.isEmpty()) {
                try {
                    p.setIdPerfil(Integer.parseInt(idPerfil));
                } catch (NumberFormatException e) {
                    mensagem = "ID de perfil inválido";
                }
            }
            p.setNome(nome);
            p.setStatus(Integer.parseInt(status));

            try {
                PerfilDAO pDAO = new PerfilDAO();
                if (pDAO.gravar(p)) {
                    mensagem = "Gravado com sucesso";
                } else {
                    mensagem = "Erro ao gravar o perfil";
                }
            } catch (Exception e) {
                e.printStackTrace();
                mensagem = "Erro ao gravar no banco de dados. Tente novamente mais tarde.";
            }
        }

        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='listar_perfil.jsp';");
        out.println("</script>");
    }

    @Override
    public String getServletInfo() {
        return "Servlet que gerencia Perfil no sistema da Ótica";
    }
}