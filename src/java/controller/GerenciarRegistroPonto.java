package controller;

import model.Funcionario;
import model.FuncionarioDAO;
import model.RegistroPonto;
import model.RegistroPontoDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "GerenciarRegistroPonto", urlPatterns = {"/GerenciarRegistroPonto"})
public class GerenciarRegistroPonto extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object ulogadoObj = session.getAttribute("ulogado");
        if (ulogadoObj == null || !(ulogadoObj instanceof model.Usuario)) {
            response.sendRedirect("login.jsp");
            return;
        }

        model.Usuario ulogado = (model.Usuario) ulogadoObj;
        String perfilNome = ulogado.getPerfil().getNome();

        try {
            String acao = request.getParameter("acao");
            if (acao == null) acao = "listar";

            RegistroPontoDAO rdao = new RegistroPontoDAO();
            FuncionarioDAO fdao = new FuncionarioDAO();

            Funcionario funcionarioLogado = fdao.getFuncionarioPorUsuario(ulogado.getIdUsuario());

            if (acao.equals("listar")) {
                if (perfilNome.equalsIgnoreCase("Funcionario")) {
                    if (funcionarioLogado != null) {
                        request.setAttribute("lista", rdao.listarPorFuncionario(funcionarioLogado.getIdFuncionario()));
                    } else {
                        request.setAttribute("lista", java.util.Collections.emptyList());
                    }
                } else {
                    request.setAttribute("lista", rdao.listarTodos());
                }

                RequestDispatcher rd = request.getRequestDispatcher("listar_registro_ponto.jsp");
                rd.forward(request, response);

            } else if (acao.equals("excluir")) {
                if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                    int id = Integer.parseInt(request.getParameter("idRegistro"));
                    rdao.excluir(id);
                }
                response.sendRedirect("GerenciarRegistroPonto?acao=listar");

            } else if (acao.equals("editar")) {
                if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                    int id = Integer.parseInt(request.getParameter("idRegistro"));
                    RegistroPonto r = rdao.getCarregaPorID(id);
                    request.setAttribute("registroPonto", r);

                    List<Funcionario> listaFuncionarios = fdao.listar();
                    request.setAttribute("listaFuncionarios", listaFuncionarios);

                    List<RegistroPonto> registrosFuncionario = rdao.listarPorFuncionario(r.getFuncionario_idFfuncionario());
                    request.setAttribute("listaRegistrosFuncionario", registrosFuncionario);

                    RequestDispatcher rd = request.getRequestDispatcher("form_registro_ponto.jsp");
                    rd.forward(request, response);
                } else {
                    response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                }

            } else if (acao.equals("novo")) {
                if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                    RegistroPonto r = new RegistroPonto();
                    request.setAttribute("registroPonto", r);

                    List<Funcionario> listaFuncionarios = fdao.listar();
                    request.setAttribute("listaFuncionarios", listaFuncionarios);

                    RequestDispatcher rd = request.getRequestDispatcher("form_registro_ponto.jsp");
                    rd.forward(request, response);
                } else {
                    response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                }

            } else {
                response.sendRedirect("GerenciarRegistroPonto?acao=listar");
            }

        } catch (Exception e) {
            System.out.println("Erro no doGet GerenciarRegistroPonto: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Erro no processamento: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object ulogadoObj = session.getAttribute("ulogado");
        if (ulogadoObj == null || !(ulogadoObj instanceof model.Usuario)) {
            response.sendRedirect("login.jsp");
            return;
        }

        model.Usuario ulogado = (model.Usuario) ulogadoObj;
        String perfilNome = ulogado.getPerfil().getNome();

        try {
            String acao = request.getParameter("acao");
            System.out.println("Ação recebida: " + acao);

            RegistroPontoDAO rdao = new RegistroPontoDAO();
            FuncionarioDAO fdao = new FuncionarioDAO();

            if ("registrarEntrada".equals(acao) || "registrarSaida".equals(acao)) {
                Funcionario funcionarioLogado = fdao.getFuncionarioPorUsuario(ulogado.getIdUsuario());

                if (funcionarioLogado == null) {
                    System.out.println("⚠ Nenhum funcionário vinculado ao usuário logado.");
                    response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                    return;
                }

                if ("registrarEntrada".equals(acao)) {
                    boolean completo = rdao.temRegistroCompletoHoje(funcionarioLogado.getIdFuncionario(), java.time.LocalDate.now());

                    if (!completo) {
                        RegistroPonto existente = rdao.getRegistroSemSaida(funcionarioLogado.getIdFuncionario(), java.time.LocalDate.now());

                        if (existente == null) {
                            RegistroPonto novo = new RegistroPonto();
                            novo.setFuncionario_idFfuncionario(funcionarioLogado.getIdFuncionario());
                            novo.setData(java.sql.Date.valueOf(java.time.LocalDate.now()));
                            novo.setHoraEntrada(java.sql.Time.valueOf(java.time.LocalTime.now()));

                            boolean sucesso = rdao.gravarEntrada(novo);
                            System.out.println("Registro de entrada: " + sucesso);
                        } else {
                            System.out.println("Entrada já registrada hoje.");
                        }
                    } else {
                        System.out.println("Registro completo (entrada e saída) já existe hoje.");
                    }
                }

                if ("registrarSaida".equals(acao)) {
                    RegistroPonto aberto = rdao.getRegistroSemSaida(funcionarioLogado.getIdFuncionario(), java.time.LocalDate.now());

                    if (aberto != null) {
                        aberto.setHoraSaida(java.sql.Time.valueOf(java.time.LocalTime.now()));
                        boolean sucesso = rdao.atualizarSaida(aberto);
                        System.out.println("Atualização de saída: " + sucesso);
                    } else {
                        System.out.println("Nenhum registro aberto para saída.");
                    }
                }

                response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                return;
            }

            if ("gravar".equals(acao) || "alterar".equals(acao)) {
                if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                    RegistroPonto r = new RegistroPonto();

                    try {
                        String idStr = request.getParameter("idRegistro_ponto");
                        String dataStr = request.getParameter("data");
                        String horaEntradaStr = request.getParameter("horaEntrada");
                        String horaSaidaStr = request.getParameter("horaSaida");
                        String funcIdStr = request.getParameter("funcionario_idFfuncionario");

                        if (dataStr == null || horaEntradaStr == null || funcIdStr == null ||
                                dataStr.isEmpty() || horaEntradaStr.isEmpty() || funcIdStr.isEmpty()) {
                            throw new Exception("Campos obrigatórios não preenchidos.");
                        }

                        if (idStr != null && !idStr.isEmpty()) {
                            r.setIdRegistro_ponto(Integer.parseInt(idStr));
                        }

                        r.setData(java.sql.Date.valueOf(dataStr));
                        r.setHoraEntrada(java.sql.Time.valueOf(horaEntradaStr));

                        if (horaSaidaStr != null && !horaSaidaStr.isEmpty()) {
                            r.setHoraSaida(java.sql.Time.valueOf(horaSaidaStr));
                        }

                        r.setFuncionario_idFfuncionario(Integer.parseInt(funcIdStr));

                        boolean sucesso = rdao.gravar(r);
                        System.out.println("Gravação de registro: " + sucesso);
                    } catch (Exception ex) {
                        System.out.println("Erro ao preencher campos do registro: " + ex.getMessage());
                        throw ex;
                    }
                }
                response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                return;
            }

            response.sendRedirect("GerenciarRegistroPonto?acao=listar");

        } catch (Exception e) {
            System.out.println("Erro no doPost GerenciarRegistroPonto: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Erro ao processar registro de ponto: " + e.getMessage());
        }
    }
}
