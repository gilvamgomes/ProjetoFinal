<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Menu</title>
</head>
<body>


   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Lista de Menus</h2>
        <a href="form_menu.jsp" class="btn btn-primary">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display" id="listarMenu">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Link</th>
                    <th>Ícone</th>
                    <th>Exibir</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Link</th>
                    <th>Ícone</th>
                    <th>Exibir</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.MenuDAO" id="mDAO"/>
            <tbody>
                <c:forEach var="m" items="${mDAO.lista}">
                    <tr>
                        <td>${m.idMenu}</td>
                        <td>${m.nome}</td>
                        <td>${m.link}</td>
                        <td>${m.icone}</td>
                        <td>
                            <c:if test="${m.exibir == 1}">Sim</c:if>
                            <c:if test="${m.exibir == 2}">Não</c:if>
                        </td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarMenu?acao=alterar&idMenu=${m.idMenu}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${m.idMenu}, '${m.nome}')">
                                <i class="glyphicon glyphicon-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script type="text/javascript" src="datatables/jquery.js"></script>
    <script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#listarMenu").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idMenu, nome) {
            if (confirm('Deseja realmente desativar o menu ' + nome + ' ?')) {
                location.href = 'GerenciarMenu?acao=excluir&idMenu=' + idMenu;
            }
        }
    </script>

    <script>
        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>