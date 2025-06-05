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
    <title>Lista de Contra-Cheques</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2 class="titulo-usuario">Lista de Contra-Cheques</h2>
        <a href="form_contra_cheque.jsp" class="btn btn-usuario">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display painel-usuario" id="listarContraCheque">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Valor Bruto</th>
                    <th>Descontos</th>
                    <th>Valor Líquido</th>
                    <th>ID Funcionário</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Valor Bruto</th>
                    <th>Descontos</th>
                    <th>Valor Líquido</th>
                    <th>ID Funcionário</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
            <tbody>
                <c:forEach var="c" items="${cDAO.lista}">
                    <tr>
                        <td>${c.idContraCheque}</td>
                        <td><fmt:formatNumber value="${c.valorBruto}" type="currency"/></td>
                        <td><fmt:formatNumber value="${c.descontos}" type="currency"/></td>
                        <td><fmt:formatNumber value="${c.valorLiquido}" type="currency"/></td>
                        <td>${c.funcionarioId}</td>
                        <td>
                            <a class="btn btn-usuario" href="GerenciarContraCheque?acao=alterar&idContraCheque=${c.idContraCheque}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-usuario" onclick="confirmarExclusao(${c.idContraCheque})">
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
            $("#listarContraCheque").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idContraCheque) {
            if (confirm('Deseja realmente excluir o contra-cheque ID ' + idContraCheque + ' ?')) {
                location.href = 'GerenciarContraCheque?acao=excluir&idContraCheque=' + idContraCheque;
            }
        }

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
