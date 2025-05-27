package controller;

import model.Imposto;
import model.ImpostoDAO;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "GerenciarImposto", urlPatterns = {"/GerenciarImposto"})
public class GerenciarImposto extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String acao = request.getParameter("acao");
            ImpostoDAO idao = new ImpostoDAO();

            if (acao.equals("listar")) {
                request.setAttribute("lista", idao.getLista());
                RequestDispatcher rd = request.getRequestDispatcher("listar_imposto.jsp");
                rd.forward(request, response);
            } else if (acao.equals("excluir")) {
                int id = Integer.parseInt(request.getParameter("idImposto"));
                idao.excluir(id);
                response.sendRedirect("GerenciarImposto?acao=listar");
            } else if (acao.equals("editar")) {
                int id = Integer.parseInt(request.getParameter("idImposto"));
                Imposto i = idao.getCarregaPorID(id);
                request.setAttribute("imposto", i);
                RequestDispatcher rd = request.getRequestDispatcher("form_imposto.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Erro no doGet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Erro no processamento: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Imposto i = new Imposto();

            String id = request.getParameter("idImposto");
            if (id != null && !id.isEmpty()) {
                i.setIdImposto(Integer.parseInt(id));
            } else {
                i.setIdImposto(0);
            }

            i.setNome(request.getParameter("nome"));
            i.setPercentual(Double.parseDouble(request.getParameter("percentual")));
            i.setStatus(Integer.parseInt(request.getParameter("status")));

            ImpostoDAO idao = new ImpostoDAO();
            idao.gravar(i);

            response.sendRedirect("GerenciarImposto?acao=listar");
        } catch (Exception e) {
            System.out.println("Erro no doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Erro ao processar o imposto: " + e.getMessage());
        }
    }
}
