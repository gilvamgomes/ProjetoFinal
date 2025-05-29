package controller;

import model.Ferias;
import model.FeriasDAO;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "GerenciarFerias", urlPatterns = {"/GerenciarFerias"})
public class GerenciarFerias extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String acao = request.getParameter("acao");
            FeriasDAO fdao = new FeriasDAO();

            if (acao.equals("listar")) {
                request.setAttribute("lista", fdao.getLista());
                RequestDispatcher rd = request.getRequestDispatcher("listar_ferias.jsp");
                rd.forward(request, response);
            } else if (acao.equals("excluir")) {
                int id = Integer.parseInt(request.getParameter("idFerias"));
                fdao.excluir(id);
                response.sendRedirect("GerenciarFerias?acao=listar");
            } else if (acao.equals("editar")) {
                int id = Integer.parseInt(request.getParameter("idFerias"));
                Ferias f = fdao.getCarregaPorID(id);
                request.setAttribute("ferias", f);
                RequestDispatcher rd = request.getRequestDispatcher("form_ferias.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro no processamento: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Ferias f = new Ferias();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            f.setIdFerias(request.getParameter("idFerias") == null || request.getParameter("idFerias").isEmpty() ? 0 : Integer.parseInt(request.getParameter("idFerias")));
            f.setDataInicio(sdf.parse(request.getParameter("dataInicio")));
            f.setDataFim(sdf.parse(request.getParameter("dataFim")));
            f.setStatus(request.getParameter("status"));
            f.setFuncionario_idFfuncionario(Integer.parseInt(request.getParameter("funcionario_idFfuncionario")));

            FeriasDAO fdao = new FeriasDAO();
            fdao.gravar(f);
            response.sendRedirect("GerenciarFerias?acao=listar");
        } catch (Exception e) {
            response.getWriter().println("Erro ao gravar férias: " + e.getMessage());
        }
    }
}
