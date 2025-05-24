package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import model.Menu;
import model.MenuDAO;

public class GerenciarMenu extends HttpServlet {

    private static HttpServletResponse response;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        String mensagem = "";
        String idMenu = request.getParameter("idMenu");
        String acao = request.getParameter("acao");
        Menu m = new Menu();

        try {
            MenuDAO mDAO = new MenuDAO();
            if ("alterar".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    try {
                        m = mDAO.getCarregaPorID(Integer.parseInt(idMenu));
                    } catch (Exception ex) {
                        Logger.getLogger(GerenciarMenu.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    if (m.getIdMenu() > 0) {
                        RequestDispatcher disp = getServletContext().getRequestDispatcher("/form_menu.jsp");
                        request.setAttribute("m", m);
                        disp.forward(request, response);
                        return;
                    } else {
                        mensagem = "Menu não encontrado";
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }
            if ("excluir".equals(acao)) {
                if (GerenciarLogin.verificarPermissao(request, response)) {
                    if (Integer.parseInt(idMenu) != 0) {
                        m.setIdMenu(Integer.parseInt(idMenu));
                        if (mDAO.excluir(m)) {
                            mensagem = "Menu excluído com sucesso";
                        } else {
                            mensagem = "Erro ao excluir o menu";
                        }
                    }
                } else {
                    mensagem = "Acesso Negado";
                }
            }
        } catch (Exception e) {
            out.println(e);
            mensagem = "Erro ao acessar o banco de dados";
        }

        out.println("<script type='text/javascript'>");
        out.println("alert('" + mensagem + "');");
        out.println("location.href='listar_menu.jsp';");
        out.println("</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GerenciarMenu.response = response;
        response.setContentType("text/html");

        String idMenu = request.getParameter("idMenu");
        String nome = request.getParameter("nome");
        String link = request.getParameter("link");
        String icone = request.getParameter("icone");
        String exibir = request.getParameter("exibir");

        ArrayList<String> erros = new ArrayList<>();

        if (nome == null || nome.trim().isEmpty())
            erros.add("Preencha o nome");
        if (link == null || link.trim().isEmpty())
            erros.add("Preencha o link");
        if (icone == null || icone.trim().isEmpty())
            erros.add("Preencha o ícone");
        if (exibir == null || exibir.trim().isEmpty())
            erros.add("Selecione o exibir");

        if (erros.size() > 0) {
            String campos = "";
            for (String erro : erros) {
                campos += "\\n - " + erro;
            }
            exibirMensagem("Preencha o(s) campo(s): " + campos, false);
        } else {
            Menu m = new Menu();
            if (idMenu != null && !idMenu.isEmpty()) {
                try {
                    m.setIdMenu(Integer.parseInt(idMenu));
                } catch (NumberFormatException e) {
                    exibirMensagem("ID menu inválido", false);
                    return;
                }
            }
            m.setNome(nome);
            m.setLink(link);
            m.setIcone(icone);
            m.setExibir(Integer.parseInt(exibir));

            try {
                MenuDAO mDAO = new MenuDAO();
                if (mDAO.gravar(m)) {
                    exibirMensagem("Gravado com sucesso", true);
                } else {
                    exibirMensagem("Erro ao gravar o menu", false);
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
            if (resposta)
                out.println("location.href='listar_menu.jsp';");
            else
                out.println("history.back();");
            out.println("</script>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet que gerencia Menu no sistema da Ótica";
    }
}