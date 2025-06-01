package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import model.RegistroPontoDAO;
import model.Usuario;

@WebServlet(name = "BaterPonto", urlPatterns = {"/BaterPonto"})
public class BaterPonto extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sessao = request.getSession(false);
        if (sessao == null || sessao.getAttribute("ulogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario ulogado = (Usuario) sessao.getAttribute("ulogado");

        String mensagem = "";
        try {
            RegistroPontoDAO dao = new RegistroPontoDAO();

            // 🧠 Pega o ID do funcionário associado ao usuário logado
            int idFuncionario = dao.getIdFuncionarioPorUsuario(ulogado.getIdUsuario());

            // 🕒 Chama o método que lida com os 4 registros do dia
            mensagem = dao.registrarPonto(idFuncionario);

            // Armazena a mensagem na sessão pra exibir depois
            sessao.setAttribute("mensagem", mensagem);

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro ao bater ponto: " + e.getMessage();
            sessao.setAttribute("mensagem", mensagem);
        }

        // Redireciona corretamente para a listagem
        response.sendRedirect("GerenciarRegistroPonto?acao=listar");
    }
}
