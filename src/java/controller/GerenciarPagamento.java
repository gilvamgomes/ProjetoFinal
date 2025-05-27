package controller;

import model.Pagamento;
import model.PagamentoDAO;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "GerenciarPagamento", urlPatterns = {"/GerenciarPagamento"})
public class GerenciarPagamento extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String acao = request.getParameter("acao");
            PagamentoDAO pdao = new PagamentoDAO();

            if (acao.equals("listar")) {
                request.setAttribute("lista", pdao.getLista());
                RequestDispatcher rd = request.getRequestDispatcher("listar_pagamento.jsp");
                rd.forward(request, response);

            } else if (acao.equals("excluir")) {
                int id = Integer.parseInt(request.getParameter("idPagamento"));
                pdao.excluir(id);
                response.sendRedirect("GerenciarPagamento?acao=listar");

            } else if (acao.equals("editar")) {
                int id = Integer.parseInt(request.getParameter("idPagamento"));
                Pagamento p = pdao.getCarregaPorID(id);
                request.setAttribute("pagamento", p);
                RequestDispatcher rd = request.getRequestDispatcher("form_pagamento.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Erro no doGet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Erro no processamento: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Iniciando gravação de pagamento...");

            Pagamento p = new Pagamento();

            String id = request.getParameter("idPagamento");
            if (id != null && !id.isEmpty()) {
                p.setIdPagamento(Integer.parseInt(id));
                System.out.println("ID Pagamento: " + id);
            } else {
                p.setIdPagamento(0);
                System.out.println("Novo pagamento, ID = 0");
            }

            String tipoPagamento = request.getParameter("tipoPagamento");
            String valorStr = request.getParameter("valor");
            String dataPagamentoStr = request.getParameter("dataPagamento");
            String funcionarioIdStr = request.getParameter("funcionario_idFfuncionario");

            System.out.println("Tipo: " + tipoPagamento);
            System.out.println("Valor: " + valorStr);
            System.out.println("Data: " + dataPagamentoStr);
            System.out.println("Funcionário ID: " + funcionarioIdStr);

            if (tipoPagamento != null) {
                p.setTipoPagamento(tipoPagamento);
            }

            if (valorStr != null && !valorStr.isEmpty()) {
                p.setValor(Double.parseDouble(valorStr));
            } else {
                p.setValor(0.0);
            }

            if (dataPagamentoStr != null && !dataPagamentoStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dataPagamento = sdf.parse(dataPagamentoStr);
                p.setDataPagamento(dataPagamento);
            } else {
                throw new Exception("Data do pagamento é obrigatória!");
            }

            if (funcionarioIdStr != null && !funcionarioIdStr.isEmpty()) {
                p.setFuncionario_idFfuncionario(Integer.parseInt(funcionarioIdStr));
            } else {
                throw new Exception("ID do funcionário é obrigatório!");
            }

            PagamentoDAO pdao = new PagamentoDAO();
            boolean gravado = pdao.gravar(p);

            if (gravado) {
                System.out.println("Pagamento gravado com sucesso!");
            } else {
                System.out.println("Erro ao gravar pagamento!");
            }

            response.sendRedirect("GerenciarPagamento?acao=listar");

        } catch (Exception e) {
            System.out.println("Erro no doPost: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Erro ao processar o pagamento: " + e.getMessage());
        }
    }
}
