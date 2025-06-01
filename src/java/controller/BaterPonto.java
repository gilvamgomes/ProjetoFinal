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

        // 🚨 Proteção extra: só funcionários podem bater ponto
        if (!"Funcionario".equalsIgnoreCase(ulogado.getPerfil().getNome())) {
            sessao.setAttribute("mensagem", "Apenas funcionários podem bater ponto.");
            response.sendRedirect("GerenciarRegistroPonto?acao=listar");
            return;
        }

        String mensagem = "";
        try {
            RegistroPontoDAO dao = new RegistroPontoDAO();

            // Pega o ID do funcionário vinculado ao usuário logado
            int idFuncionario = dao.getIdFuncionarioPorUsuario(ulogado.getIdUsuario());

            // Chama a lógica que preenche as 4 etapas da batida
            mensagem = dao.registrarPonto(idFuncionario);

            // Salva mensagem na sessão pra exibir no listar
            sessao.setAttribute("mensagem", mensagem);

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro ao bater ponto: " + e.getMessage();
            sessao.setAttribute("mensagem", mensagem);
        }

        // Redireciona pro listar
        response.sendRedirect("GerenciarRegistroPonto?acao=listar");
    }
}
