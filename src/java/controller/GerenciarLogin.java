package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.Menu;
import model.Usuario;
import model.UsuarioDAO;

public class GerenciarLogin extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GerenciarLogin.response = response;
        request.getSession().removeAttribute("ulogado");
        response.sendRedirect("form_login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GerenciarLogin.response = response;

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
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s):" + campos);
        } else {
            try {
                UsuarioDAO uDAO = new UsuarioDAO();
                Usuario u = uDAO.getRecuperarUsuario(login);

                if (u.getIdUsuario() > 0 && u.getSenha().equals(senha)) {
                    HttpSession sessao = request.getSession();
                    sessao.setAttribute("ulogado", u);
                    response.sendRedirect("index.jsp");
                } else {
                    exibirMensagem("Usuário ou senha inválida!");
                }
            } catch (Exception e) {
                exibirMensagem("Usuário ou perfil não encontrado");
            }
        }
    }

    private static void exibirMensagem(String mensagem) {
        try {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('" + mensagem + "')");
            out.println("history.back();");
            out.println("</script>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Usuario verificarAcesso(HttpServletRequest request, HttpServletResponse response) {
        Usuario u = null;
        GerenciarLogin.response = response;
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

                System.out.println("URI capturada: " + uri);

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

                    System.out.println("### URI capturada: " + uri);
                    System.out.println("#### possuiAcesso: " + possuiAcesso);

                    if (!possuiAcesso) {
                        if (uri.contains("Gerenciar")) {
                            possuiAcesso = true;
                        } else {
                            exibirMensagem("Acesso Negado");
                        }
                    }
                }
            }
        } catch (Exception e) {
            exibirMensagem(e.getMessage());
        }
        return u;
    }

    public static boolean verificarPermissao(HttpServletRequest request, HttpServletResponse response) {
        Usuario u = null;
        GerenciarLogin.response = response;
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

                System.out.println("URI capturada: " + uri);

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

                    System.out.println("#### possuiAcesso: " + possuiAcesso);

                    if (!possuiAcesso) {
                        if (uri.contains("Gerenciar")) {
                            possuiAcesso = true;
                        } else {
                            exibirMensagem("Acesso Negado");
                        }
                    }
                }
            }
        } catch (Exception e) {
            exibirMensagem(e.getMessage());
        }
        return possuiAcesso;
    }

    @Override
    public String getServletInfo() {
        return "Gerencia login e permissões no sistema da Ótica";
    }
}