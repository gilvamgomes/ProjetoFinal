package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.ContraCheque;
import model.ContraChequeDAO;
import model.RegistroPontoDAO;

public class GerenciarContraCheque extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mensagem = "";
        String idContraCheque = request.getParameter("idContraCheque");
        String acao = request.getParameter("acao");
        ContraCheque c = new ContraCheque();

        try {
            ContraChequeDAO cDAO = new ContraChequeDAO();

            if ("gerar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        String idFuncionarioStr = request.getParameter("idFuncionario");
                        String anoStr = request.getParameter("ano");
                        String mesStr = request.getParameter("mes");

                        if (idFuncionarioStr == null || anoStr == null || mesStr == null ||
                            idFuncionarioStr.isEmpty() || anoStr.isEmpty() || mesStr.isEmpty()) {
                            mensagem = "Parâmetros ausentes para gerar contracheque.";
                        } else {
                            int idFuncionario = Integer.parseInt(idFuncionarioStr);
                            int ano = Integer.parseInt(anoStr);
                            int mes = Integer.parseInt(mesStr);
                            boolean trabalhaSabado = true;

                            RegistroPontoDAO rDAO = new RegistroPontoDAO();
                            double horasTrabalhadas = rDAO.getTotalHorasTrabalhadasMes(idFuncionario, mes, ano);

                            boolean sucesso = cDAO.gerarContraCheque(idFuncionario, ano, mes, trabalhaSabado, horasTrabalhadas);
                            mensagem = sucesso ? "Contracheque gerado com sucesso!" : "Erro ao gerar contracheque.";
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        mensagem = "Erro na geração do contracheque: " + ex.getMessage();
                    }

                    request.getSession().setAttribute("mensagem", mensagem);
                    response.sendRedirect("listar_contra_cheque.jsp");
                    return;
                } else {
                    mensagem = "Acesso negado.";
                }
            }

            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (idContraCheque != null && !idContraCheque.isEmpty()) {
                        c = cDAO.getCarregaPorID(Integer.parseInt(idContraCheque));
                        if (c.getIdContraCheque() > 0) {
                            RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_contra_cheque.jsp");
                            request.setAttribute("c", c);
                            disp.forward(request, response);
                            return;
                        } else {
                            mensagem = "Contracheque não encontrado";
                        }
                    } else {
                        mensagem = "ID inválido";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

            if ("excluir".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (idContraCheque != null && !idContraCheque.isEmpty()) {
                        c.setIdContraCheque(Integer.parseInt(idContraCheque));
                        if (cDAO.excluir(c)) {
                            mensagem = "Contracheque excluído com sucesso";
                        } else {
                            mensagem = "Erro ao excluir o contracheque";
                        }
                    } else {
                        mensagem = "ID inválido";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro ao acessar o banco de dados: " + e.getMessage();
        }

        request.getSession().setAttribute("mensagem", mensagem);
        response.sendRedirect("listar_contra_cheque.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        String idContraCheque = request.getParameter("idContraCheque");
        String valorBruto = request.getParameter("valorBruto");
        String descontos = request.getParameter("descontos");
        String valorLiquido = request.getParameter("valorLiquido");
        String funcionarioId = request.getParameter("funcionarioId");
        String mesStr = request.getParameter("mes");
        String anoStr = request.getParameter("ano");

        ArrayList<String> erros = new ArrayList<>();

        if (valorBruto == null || valorBruto.trim().isEmpty()) erros.add("Preencha o valor bruto");
        if (descontos == null || descontos.trim().isEmpty()) erros.add("Preencha os descontos");
        if (valorLiquido == null || valorLiquido.trim().isEmpty()) erros.add("Preencha o valor líquido");
        if (funcionarioId == null || funcionarioId.trim().isEmpty()) erros.add("Informe o ID do funcionário");
        if (mesStr == null || mesStr.trim().isEmpty()) erros.add("Informe o mês");
        if (anoStr == null || anoStr.trim().isEmpty()) erros.add("Informe o ano");

        if (!erros.isEmpty()) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            request.getSession().setAttribute("mensagem", "Preencha o(s) campo(s): " + campos);
            response.sendRedirect("form_contra_cheque.jsp");
        } else {
            ContraCheque c = new ContraCheque();
            if (idContraCheque != null && !idContraCheque.isEmpty()) {
                try {
                    c.setIdContraCheque(Integer.parseInt(idContraCheque));
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("mensagem", "ID de contracheque inválido");
                    response.sendRedirect("form_contra_cheque.jsp");
                    return;
                }
            }

            try {
                c.setValorBruto(new java.math.BigDecimal(valorBruto));
                c.setDescontos(new java.math.BigDecimal(descontos));
                c.setValorLiquido(new java.math.BigDecimal(valorLiquido));
                c.setFuncionarioId(Integer.parseInt(funcionarioId));

                // Captura e validação de mês e ano
                try {
                    int mes = Integer.parseInt(mesStr);
                    int ano = Integer.parseInt(anoStr);

                    if (mes < 1 || mes > 12) {
                        throw new Exception("Mês inválido! Escolha entre 1 e 12.");
                    }

                    c.setMes(mes);
                    c.setAno(ano);
                } catch (NumberFormatException e) {
                    throw new Exception("Mês e ano devem ser números válidos.");
                }

                ContraChequeDAO cDAO = new ContraChequeDAO();
                if (cDAO.gravar(c)) {
                    request.getSession().setAttribute("mensagem", "Gravado com sucesso");
                    response.sendRedirect("listar_contra_cheque.jsp");
                } else {
                    request.getSession().setAttribute("mensagem", "Erro ao gravar o contracheque");
                    response.sendRedirect("form_contra_cheque.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("mensagem", "Erro ao processar dados: " + e.getMessage());
                response.sendRedirect("form_contra_cheque.jsp");
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Gerencia contracheques no sistema da Ótica";
    }
}
