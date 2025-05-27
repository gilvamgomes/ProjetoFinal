package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.Perfil;
import model.Usuario;
import model.UsuarioDAO;

public class GerenciarUsuario extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarUsuario.response = response;

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idUsuario = request.getParameter("idUsuario");
        String acao = request.getParameter("acao");
        Usuario u = new Usuario();

        try {
            UsuarioDAO uDAO = new UsuarioDAO();
            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    u = uDAO.getCarregaPorID(Integer.parseInt(idUsuario));
                    if (u.getIdUsuario() > 0) {
                        RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_usuario.jsp");
                        request.setAttribute("u", u);
                        disp.forward(request, response);
                        return;
                    } else {
                        mensagem = "Usuário não encontrado";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

            if ("excluir".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (Integer.parseInt(idUsuario) != 0) {
                        u.setIdUsuario(Integer.parseInt(idUsuario));
                        if (uDAO.excluir(u)) {
                            mensagem = "Usuário desativado com sucesso";
                        } else {
                            mensagem = "Erro ao desativar o usuário";
                        }
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
        out.println("location.href='listar_usuario.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarUsuario.response = response;
        response.setContentType("text/html");

        String idUsuario = request.getParameter("idUsuario");
        String nome = request.getParameter("nome");
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");
        
        String status = request.getParameter("status");
        String idPerfil = request.getParameter("idPerfil");

        ArrayList<String> erros = new ArrayList<>();

        if (nome == null || nome.trim().isEmpty()) erros.add("Preencha o nome");
        if (login == null || login.trim().isEmpty()) erros.add("Preencha o login");
        if (senha == null || senha.trim().isEmpty()) erros.add("Preencha a senha");
        
        if (status == null || status.trim().isEmpty()) erros.add("Preencha o status");
        if (idPerfil == null || idPerfil.trim().isEmpty()) erros.add("Selecione o perfil");

        if (!erros.isEmpty()) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s): " + campos, false);
        } else {
            Usuario u = new Usuario();
            if (idUsuario != null && !idUsuario.isEmpty()) {
                try {
                    u.setIdUsuario(Integer.parseInt(idUsuario));
                } catch (NumberFormatException e) {
                    exibirMensagem("ID de usuário inválido", false);
                    return;
                }
            }

            u.setNome(nome);
            u.setLogin(login);
            u.setSenha(senha);

            

            u.setStatus(Integer.parseInt(status));

            Perfil p = new Perfil();
            p.setIdPerfil(Integer.parseInt(idPerfil));
            u.setPerfil(p);

            try {
                UsuarioDAO uDAO = new UsuarioDAO();
                if (uDAO.gravar(u)) {
                    exibirMensagem("Gravado com sucesso", true);
                } else {
                    exibirMensagem("Erro ao gravar o usuário", false);
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
                out.println("location.href='listar_usuario.jsp';");
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
        return "Gerencia usuários no sistema da Ótica";
    }
}