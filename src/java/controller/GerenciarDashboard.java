package controller;

import model.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;


@WebServlet(name = "GerenciarDashboard", urlPatterns = {"/GerenciarDashboard"})
public class GerenciarDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DashboardDAO dao = new DashboardDAO();

            int totalFuncionarios = dao.contarFuncionarios();
            int totalFerias = dao.contarFerias();
            int totalRegistrosPonto = dao.contarRegistrosPonto();
            int totalBeneficios = dao.contarBeneficios();
            int totalImpostos = dao.contarImpostos();

            request.setAttribute("totalFuncionarios", totalFuncionarios);
            request.setAttribute("totalFerias", totalFerias);
            request.setAttribute("totalRegistrosPonto", totalRegistrosPonto);
            request.setAttribute("totalBeneficios", totalBeneficios);
            request.setAttribute("totalImpostos", totalImpostos);

            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Erro em GerenciarDashboard: " + e.getMessage());
            response.sendRedirect("erro.jsp");
        }
    }
}
