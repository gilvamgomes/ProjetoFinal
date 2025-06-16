package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.*;

public class GerenciarLogin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().removeAttribute("ulogado");
        response.sendRedirect("form_login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login");
        String senha = request.getParameter("senha");

        ArrayList<String> erros = new ArrayList<>();

        if (login == null || login.isEmpty()) {
            erros.add("Preencha o login");
        }
        if (senha == null || senha.isEmpty()) {
            erros.add("Preencha a senha");
        }

        if (!erros.isEmpty()) {
            request.setAttribute("erro", String.join("<br>", erros));
            RequestDispatcher dispatcher = request.getRequestDispatcher("form_login.jsp");
            dispatcher.forward(request, response);
        } else {
            try {
                UsuarioDAO uDAO = new UsuarioDAO();
                Usuario u = uDAO.getRecuperarUsuario(login);

                if (u.getIdUsuario() > 0 && u.getSenha().equals(senha)) {
                    FuncionarioDAO fDAO = new FuncionarioDAO();
                    Funcionario func = fDAO.getFuncionarioPorUsuario(u.getIdUsuario());
                    u.setFuncionario(func);

                    HttpSession sessao = request.getSession();
                    sessao.setAttribute("ulogado", u);
                    response.sendRedirect("index.jsp");
                } else {
                    request.setAttribute("erro", "Usuário ou senha inválidos!");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("form_login.jsp");
                    dispatcher.forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("erro", "Usuário ou perfil não encontrado.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("form_login.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    public static Usuario verificarAcesso(HttpServletRequest request, HttpServletResponse response) {
        Usuario u = null;
        try {
            HttpSession sessao = request.getSession();
            if (sessao.getAttribute("ulogado") == null) {
                response.sendRedirect("form_login.jsp");
            } else {
                String uri = request.getRequestURI();
                String queryString = request.getQueryString();
                if (queryString != null) {
                    uri += "?" + queryString;
                }

                u = (Usuario) sessao.getAttribute("ulogado");

                if (u == null) {
                    sessao.setAttribute("mensagem", "Você não está autenticado");
                    response.sendRedirect("form_login.jsp");
                } else {
                    boolean possuiAcesso = false;

                    for (Menu m : u.getPerfil().getMenus()) {
                        if (uri.contains("/" + m.getLink())) {
                            possuiAcesso = true;
                            break;
                        }
                    }

                    // Liberando especificamente o GerenciarFerias
                    if (uri.contains("GerenciarFerias")) {
                        possuiAcesso = true;
                    }

                    if (!possuiAcesso && !uri.contains("Gerenciar")) {
                        response.getWriter().println("<script>alert('Acesso Negado'); location.href='index.jsp';</script>");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    public static boolean verificarPermissao(HttpServletRequest request, HttpServletResponse response) {
        Usuario u = null;
        boolean possuiAcesso = false;
        try {
            HttpSession sessao = request.getSession();
            if (sessao.getAttribute("ulogado") == null) {
                response.sendRedirect("form_login.jsp");
            } else {
                String uri = request.getRequestURI();
                String queryString = request.getQueryString();
                if (queryString != null) {
                    uri += "?" + queryString;
                }

                u = (Usuario) sessao.getAttribute("ulogado");
                if (u == null) {
                    sessao.setAttribute("mensagem", "Você não está autenticado");
                    response.sendRedirect("form_login.jsp");
                } else {
                    for (Menu m : u.getPerfil().getMenus()) {
                        if (uri.contains("/" + m.getLink())) {
                            possuiAcesso = true;
                            break;
                        }
                    }

                    // Liberando especificamente o GerenciarFerias
                    if (uri.contains("GerenciarFerias")) {
                        possuiAcesso = true;
                    }

                    if (!possuiAcesso && !uri.contains("Gerenciar")) {
                        response.getWriter().println("<script>alert('Acesso Negado'); location.href='index.jsp';</script>");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return possuiAcesso;
    }

    @Override
    public String getServletInfo() {
        return "Gerencia login e permissões no sistema da Ótica";
    }
}
