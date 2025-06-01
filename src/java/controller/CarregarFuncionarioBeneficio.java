package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Beneficio;
import model.BeneficioDAO;
import model.FuncionarioBeneficioDAO;

@WebServlet(name = "CarregarFuncionarioBeneficio", urlPatterns = {"/CarregarFuncionarioBeneficio"})
public class CarregarFuncionarioBeneficio extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idFuncionario = Integer.parseInt(request.getParameter("id"));

            BeneficioDAO bDAO = new BeneficioDAO();
            FuncionarioBeneficioDAO fbDAO = new FuncionarioBeneficioDAO();

            List<Beneficio> todos = bDAO.listar(); // ✔️ nome do método correto
            List<Beneficio> doFuncionario = fbDAO.listarBeneficiosDoFuncionario(idFuncionario);

            for (Beneficio b : todos) {
                for (Beneficio vinculado : doFuncionario) {
                    if (b.getIdBeneficio() == vinculado.getIdBeneficio()) {
                        b.setAtivoParaFuncionario(true);
                        b.setValorTemporario(vinculado.getValorTemporario());
                    }
                }
            }

            request.setAttribute("listaBeneficios", todos);
            request.setAttribute("idFuncionario", idFuncionario);
            request.getRequestDispatcher("form_funcionario_beneficio.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("listar_funcionario.jsp?erro=carregamento");
        }
    }
}
