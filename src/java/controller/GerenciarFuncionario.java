package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import model.Funcionario;
import model.FuncionarioDAO;
import model.Usuario;
import model.UsuarioDAO;

public class GerenciarFuncionario extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarFuncionario.response = response;

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idFuncionario = request.getParameter("idFuncionario");
        String acao = request.getParameter("acao");
        Funcionario f = new Funcionario();

        try {
            FuncionarioDAO fDAO = new FuncionarioDAO();
            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    f = fDAO.getCarregaPorID(Integer.parseInt(idFuncionario));
                    if (f.getIdFuncionario() > 0) {
                        RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_funcionario.jsp");
                        request.setAttribute("f", f);
                        disp.forward(request, response);
                        return;
                    } else {
                        mensagem = "Funcionário não encontrado";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

            if ("excluir".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (Integer.parseInt(idFuncionario) != 0) {
                        f.setIdFuncionario(Integer.parseInt(idFuncionario));
                        if (fDAO.excluir(f)) {
                            mensagem = "Funcionário desativado com sucesso";
                        } else {
                            mensagem = "Erro ao desativar o funcionário";
                        }
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro ao acessar o banco de dados: " + e.getMessage();
        }

        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='listar_funcionario.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarFuncionario.response = response;
        response.setContentType("text/html");

        String idFuncionario = request.getParameter("idFuncionario");
        String nome = request.getParameter("nome");
        String dataNasc = request.getParameter("dataNasc");
        String cpf = request.getParameter("cpf");
        String cargo = request.getParameter("cargo");
        String status = request.getParameter("status");
        String idUsuario = request.getParameter("idUsuario");

        ArrayList<String> erros = new ArrayList<>();

        if (nome == null || nome.trim().isEmpty()) erros.add("Preencha o nome");
        if (dataNasc == null || dataNasc.trim().isEmpty()) erros.add("Preencha a data de nascimento");
        if (cpf == null || cpf.trim().isEmpty()) erros.add("Preencha o CPF");
        if (cargo == null || cargo.trim().isEmpty()) erros.add("Preencha o cargo");
        if (status == null || status.trim().isEmpty()) erros.add("Preencha o status");
        if (idUsuario == null || idUsuario.trim().isEmpty()) erros.add("Selecione o usuário");

        if (!erros.isEmpty()) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s): " + campos, false);
        } else {
            Funcionario f = new Funcionario();
            if (idFuncionario != null && !idFuncionario.isEmpty()) {
                try {
                    f.setIdFuncionario(Integer.parseInt(idFuncionario));
                } catch (NumberFormatException e) {
                    exibirMensagem("ID de funcionário inválido", false);
                    return;
                }
            }

            f.setNome(nome);

            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            try {
                f.setDataNasc(df.parse(dataNasc));
            } catch (ParseException ex) {
                ex.printStackTrace();
                exibirMensagem("Data de nascimento inválida", false);
                return;
            }

            f.setCpf(cpf);
            f.setCargo(cargo);
            f.setStatus(Integer.parseInt(status));

            Usuario u = new Usuario();
            u.setIdUsuario(Integer.parseInt(idUsuario));
            f.setUsuario(u);

            try {
                FuncionarioDAO fDAO = new FuncionarioDAO();
                if (fDAO.gravar(f)) {
                    exibirMensagem("Gravado com sucesso", true);
                } else {
                    exibirMensagem("Erro ao gravar o funcionário", false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                exibirMensagem("Erro ao gravar no banco de dados", false);
            }
        }
    }

    private static void exibirMensagem(String mensagem, boolean resposta) {
        try {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('" + mensagem + "');");
            if (resposta) {
                out.println("location.href='listar_funcionario.jsp';");
            } else {
                out.println("history.back();");
            }
            out.println("</script>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Gerencia funcionários no sistema da Ótica";
    }
}