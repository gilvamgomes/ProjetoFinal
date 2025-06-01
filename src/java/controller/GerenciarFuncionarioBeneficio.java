package controller;

import model.FuncionarioBeneficioDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "GerenciarFuncionarioBeneficio", urlPatterns = {"/GerenciarFuncionarioBeneficio"})
public class GerenciarFuncionarioBeneficio extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idFuncionario = Integer.parseInt(request.getParameter("idFuncionario"));
            String[] selecionados = request.getParameterValues("beneficioSelecionado");

            FuncionarioBeneficioDAO dao = new FuncionarioBeneficioDAO();
            dao.removerTodosDeFuncionario(idFuncionario);

            if (selecionados != null) {
                for (String idBeneficioStr : selecionados) {
                    int idBeneficio = Integer.parseInt(idBeneficioStr);
                    double valor = 0.0;

                    try {
                        valor = Double.parseDouble(request.getParameter("valor_" + idBeneficio));
                    } catch (NumberFormatException e) {
                        valor = 0.0;
                    }

                    dao.adicionarBeneficioFuncionario(idFuncionario, idBeneficio, valor);
                }
            }

            response.sendRedirect("listar_funcionario.jsp?status=beneficio_sucesso");


        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("form_funcionario_beneficio.jsp?erro=1");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // não usado, mas pode ser usado no futuro se quiser listar ou consultar
        doPost(request, response);
    }
}
