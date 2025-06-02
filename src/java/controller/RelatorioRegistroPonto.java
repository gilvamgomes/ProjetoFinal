package controller;

import model.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "RelatorioRegistroPonto", urlPatterns = {"/RelatorioRegistroPonto"})
public class RelatorioRegistroPonto extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Verifica se está logado
            Usuario ulogado = (Usuario) request.getSession().getAttribute("ulogado");
            if (ulogado == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int idUsuarioLogado = ulogado.getIdUsuario();

            FuncionarioDAO funcionarioDAO = new FuncionarioDAO();
            RegistroPontoDAO pontoDAO = new RegistroPontoDAO();

            // Descobre o funcionário do usuário logado
            Funcionario funcionarioLogado = funcionarioDAO.getFuncionarioPorUsuario(idUsuarioLogado);
            int idFuncionarioLogado = funcionarioLogado.getIdFuncionario();

            // Recebe o ID do funcionário que está sendo consultado
            int idFuncionarioConsulta = Integer.parseInt(request.getParameter("idFuncionario"));

            // Verifica se o logado pode ver o relatório (ADM/Gerente ou dono)
            Perfil perfilObj = funcionarioLogado.getUsuario().getPerfil();
            int idPerfil = (perfilObj != null) ? perfilObj.getIdPerfil() : 0;

            if (!(idPerfil == 1 || idPerfil == 2 || idFuncionarioConsulta == idFuncionarioLogado)) {
                response.sendRedirect("acesso_negado.jsp");
                return;
            }

            // Puxa dados do funcionário a ser exibido no relatório
            Funcionario funcionario = funcionarioDAO.getCarregaPorID(idFuncionarioConsulta);
            List<RegistroPonto> registros = pontoDAO.listarPorFuncionario(idFuncionarioConsulta);

            // Filtra só os do mês atual
            LocalDate primeiroDiaMes = LocalDate.now().withDayOfMonth(1);
            LocalDate hoje = LocalDate.now();

            registros = registros.stream()
                .filter(r -> !r.getData().isBefore(primeiroDiaMes) && !r.getData().isAfter(hoje))
                .collect(Collectors.toList());

            // Soma horas trabalhadas no mês
            double totalHoras = registros.stream()
                .mapToDouble(RegistroPonto::getHorasTrabalhadas)
                .sum();

            double saldo = totalHoras - 176.0;

            // Envia pra JSP
            request.setAttribute("funcionario", funcionario);
            request.setAttribute("registros", registros);
            request.setAttribute("totalHoras", totalHoras);
            request.setAttribute("saldo", saldo);

            request.getRequestDispatcher("relatorio_registro_ponto.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("erro.jsp");
        }
    }

}
