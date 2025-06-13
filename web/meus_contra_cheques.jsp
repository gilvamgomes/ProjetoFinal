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
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Meus Contra-Cheques</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Meus Contra-Cheques</h2>

        <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
        <c:set var="minhaLista" value="${cDAO.lista}" />

        <table class="table table-hover table-striped table-bordered display" id="minhaTabela">
            <thead>
                <tr>
                    <th>Mês</th>
                    <th>Ano</th>
                    <th>Valor Bruto</th>
                    <th>Descontos</th>
                    <th>Valor Líquido</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>Mês</th>
                    <th>Ano</th>
                    <th>Valor Bruto</th>
                    <th>Descontos</th>
                    <th>Valor Líquido</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <tbody>
                <c:forEach var="c" items="${minhaLista}">
                    <c:if test="${c.funcionarioId == ulogado.funcionario.idFuncionario}">
                        <tr>
                            <td>${c.mes}</td>
                            <td>${c.ano}</td>
                            <td>${c.valorBruto}</td>
                            <td>${c.descontos}</td>
                            <td>${c.valorLiquido}</td>
                            <td>
                                <a class="btn btn-info" target="_blank" href="GerarPDF?idContraCheque=${c.idContraCheque}">
                                    <i class="glyphicon glyphicon-print"></i> PDF
                                </a>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script type="text/javascript" src="datatables/jquery.js"></script>
    <script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#minhaTabela").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
