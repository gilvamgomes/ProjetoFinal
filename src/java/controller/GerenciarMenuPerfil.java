package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.*;
import javax.servlet.http.*;
import model.Perfil;
import model.PerfilDAO;

public class GerenciarMenuPerfil extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idPerfil = request.getParameter("idPerfil");
        String acao = request.getParameter("acao");

        try {
            Perfil p = new Perfil();
            PerfilDAO pDAO = new PerfilDAO();
            if ("gerenciar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    p = pDAO.getCarregaPorID(Integer.parseInt(idPerfil));
                    if (p.getIdPerfil() > 0) {
                        RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_menu_perfil.jsp");
                        request.setAttribute("perfilv", p);
                        disp.forward(request, response);
                        return;
                    } else {
                        mensagem = "Perfil não encontrado!";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }
            if ("desvincular".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    String idMenu = request.getParameter("idMenu");
                    if (idMenu == null || idMenu.isEmpty()) {
                        mensagem = "O menu deve ser selecionado";
                    } else {
                        if (pDAO.desvincular(Integer.parseInt(idPerfil), Integer.parseInt(idMenu))) {
                            mensagem = "Desvinculado com sucesso";
                        } else {
                            mensagem = "Erro ao desvincular";
                        }
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }
        } catch (Exception e) {
            out.print(e);
        }

        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='GerenciarMenuPerfil?acao=gerenciar&idPerfil=" + idPerfil + "';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        String idMenu = request.getParameter("idMenu");
        String idPerfil = request.getParameter("idPerfil");
        String mensagem = "";

        try {
            PerfilDAO pDAO = new PerfilDAO();
            if (idMenu == null || idMenu.isEmpty() || idPerfil == null || idPerfil.isEmpty()) {
                mensagem = "Campos obrigatórios deverão ser preenchidos";
            } else {
                if (pDAO.vincular(Integer.parseInt(idPerfil), Integer.parseInt(idMenu))) {
                    mensagem = "Vinculado com sucesso";
                } else {
                    mensagem = "Erro ao vincular";
                }
            }
        } catch (Exception e) {
            out.print(e);
        }

        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='GerenciarMenuPerfil?acao=gerenciar&idPerfil=" + idPerfil + "';");
        out.println("</script>");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gerenciar menus vinculados aos perfis no sistema da Ótica";
    }
}