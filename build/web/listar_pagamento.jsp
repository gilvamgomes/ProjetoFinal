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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Lista de Pagamentos</title>
</head>
<body>


   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Lista de Pagamentos</h2>
        <a href="form_pagamento.jsp" class="btn btn-primary">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display" id="listarPagamento">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tipo</th>
                    <th>Valor</th>
                    <th>Data</th>
                    <th>ID Funcionário</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Tipo</th>
                    <th>Valor</th>
                    <th>Data</th>
                    <th>ID Funcionário</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.PagamentoDAO" id="pDAO"/>
            <tbody>
                <c:forEach var="p" items="${pDAO.lista}">
                    <tr>
                        <td>${p.idPagamento}</td>
                        <td>${p.tipoPagamento}</td>
                        <td>
                            <fmt:formatNumber value="${p.valor}" type="currency"/>
                        </td>
                        <td>
                            <fmt:formatDate value="${p.dataPagamento}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td>${p.funcionario_idFfuncionario}</td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarPagamento?acao=editar&idPagamento=${p.idPagamento}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${p.idPagamento}, '${p.tipoPagamento}')">
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
            $("#listarPagamento").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idPagamento, tipoPagamento) {
            if (confirm('Deseja realmente excluir o pagamento do tipo ' + tipoPagamento + '?')) {
                location.href = 'GerenciarPagamento?acao=excluir&idPagamento=' + idPagamento;
            }
        }

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
