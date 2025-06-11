<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Lista de Impostos</title>
</head>
<body>

  
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Lista de Impostos</h2>
        <a href="form_imposto.jsp" class="btn btn-primary">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display" id="listarImposto">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Percentual (%)</th>
                    <th>Status</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Percentual (%)</th>
                    <th>Status</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.ImpostoDAO" id="iDAO"/>
            <tbody>
                <c:forEach var="i" items="${iDAO.lista}">
                    <tr>
                        <td>${i.idImposto}</td>
                        <td>${i.nome}</td>
                        <td>${i.percentual} %</td>
                        <td>
                            <c:choose>
                                <c:when test="${i.status == 1}">Ativo</c:when>
                                <c:when test="${i.status == 2}">Inativo</c:when>
                                <c:otherwise>Desconhecido</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarImposto?acao=editar&idImposto=${i.idImposto}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${i.idImposto}, '${i.nome}')">
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
            $("#listarImposto").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idImposto, nome) {
            if (confirm('Deseja realmente excluir o imposto ' + nome + '?')) {
                location.href = 'GerenciarImposto?acao=excluir&idImposto=' + idImposto;
            }
        }

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
