package controller;

import model.Funcionario;
import model.FuncionarioDAO;
import model.RegistroPonto;
import model.RegistroPontoDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
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

            switch (acao) {
                case "listar":
                    if (perfilNome.equalsIgnoreCase("Funcionario")) {
                        if (funcionarioLogado != null) {
                            request.setAttribute("lista", rdao.listarPorFuncionario(funcionarioLogado.getIdFuncionario()));
                        } else {
                            request.setAttribute("lista", java.util.Collections.emptyList());
                        }
                    } else {
                        request.setAttribute("lista", rdao.listarTodos());
                    }
                    request.setAttribute("ulogado", ulogado);
                    request.getRequestDispatcher("listar_registro_ponto.jsp").forward(request, response);
                    break;

                case "excluir":
                    if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                        int id = Integer.parseInt(request.getParameter("idRegistro"));
                        rdao.excluir(id);
                    }
                    response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                    break;

                case "editar":
                    if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                        int id = Integer.parseInt(request.getParameter("idRegistro"));
                        RegistroPonto r = rdao.getCarregaPorID(id);
                        request.setAttribute("registroPonto", r);
                        request.setAttribute("listaFuncionarios", fdao.listar());
                        request.setAttribute("listaRegistrosFuncionario", rdao.listarPorFuncionario(r.getFuncionario_idFfuncionario()));
                        request.getRequestDispatcher("form_registro_ponto.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                    }
                    break;

                case "novo":
                    if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                        RegistroPonto novo = new RegistroPonto();
                        request.setAttribute("registroPonto", novo);
                        request.setAttribute("listaFuncionarios", fdao.listar());
                        request.getRequestDispatcher("form_registro_ponto.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                    }
                    break;

                default:
                    response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                    break;
            }

        } catch (Exception e) {
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
            RegistroPontoDAO rdao = new RegistroPontoDAO();
            FuncionarioDAO fdao = new FuncionarioDAO();

            if ("gravar".equals(acao) || "alterar".equals(acao)) {
                if (!perfilNome.equalsIgnoreCase("Funcionario")) {
                    RegistroPonto r = new RegistroPonto();

                    String idStr = request.getParameter("idRegistro_ponto");
                    String dataStr = request.getParameter("data");
                    String horaEntradaStr = request.getParameter("horaEntrada");
                    String horaSaidaAlmocoStr = request.getParameter("horaSaidaAlmoco");
                    String horaVoltaAlmocoStr = request.getParameter("horaVoltaAlmoco");
                    String horaSaidaFinalStr = request.getParameter("horaSaidaFinal");
                    String funcIdStr = request.getParameter("funcionario_idFfuncionario");

                    if (idStr != null && !idStr.isEmpty()) {
                        r.setIdRegistro_ponto(Integer.parseInt(idStr));
                    }

                    if (dataStr != null && !dataStr.isEmpty()) {
                        r.setData(LocalDate.parse(dataStr));
                    }

                    if (horaEntradaStr != null && !horaEntradaStr.isEmpty()) {
                        r.setHoraEntrada(LocalTime.parse(horaEntradaStr));
                    }

                    if (horaSaidaAlmocoStr != null && !horaSaidaAlmocoStr.isEmpty()) {
                        r.setHoraSaidaAlmoco(LocalTime.parse(horaSaidaAlmocoStr));
                    }

                    if (horaVoltaAlmocoStr != null && !horaVoltaAlmocoStr.isEmpty()) {
                        r.setHoraVoltaAlmoco(LocalTime.parse(horaVoltaAlmocoStr));
                    }

                    if (horaSaidaFinalStr != null && !horaSaidaFinalStr.isEmpty()) {
                        r.setHoraSaidaFinal(LocalTime.parse(horaSaidaFinalStr));
                    }

                    r.setFuncionario_idFfuncionario(Integer.parseInt(funcIdStr));
                    rdao.gravar(r);
                }

                response.sendRedirect("GerenciarRegistroPonto?acao=listar");
                return;
            }

            if ("registrarPonto".equals(acao)) {
                if (perfilNome.equalsIgnoreCase("Funcionario")) {
                    Funcionario funcionarioLogado = fdao.getFuncionarioPorUsuario(ulogado.getIdUsuario());
                    if (funcionarioLogado != null) {
                        String msg = rdao.registrarPonto(funcionarioLogado.getIdFuncionario());
                        request.setAttribute("mensagem", msg);
                        request.setAttribute("ulogado", ulogado);
                        request.setAttribute("lista", rdao.listarPorFuncionario(funcionarioLogado.getIdFuncionario()));
                        request.getRequestDispatcher("listar_registro_ponto.jsp").forward(request, response);
                        return;
                    }
                }
            }

            response.sendRedirect("GerenciarRegistroPonto?acao=listar");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erro ao processar registro de ponto: " + e.getMessage());
        }
    }
}
