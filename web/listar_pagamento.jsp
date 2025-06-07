<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome 4.7 compatível com Bootstrap 3 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <title>Pagamentos</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <div class="clearfix" style="margin-bottom: 20px;">
                <h2 class="pull-left"><i class="fa fa-money"></i> Pagamentos</h2>
                <a href="form_pagamento.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                    <i class="fa fa-plus"></i> Novo Cadastro
                </a>
            </div>

            <jsp:useBean class="model.PagamentoDAO" id="pDAO"/>

            <div class="row">
                <c:forEach var="p" items="${pDAO.lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-credit-card"></i> ${p.tipoPagamento}</h4>
                            <p><strong>ID:</strong> ${p.idPagamento}</p>
                            <p><strong>Valor:</strong> <fmt:formatNumber value="${p.valor}" type="currency"/></p>
                            <p><strong>Data:</strong> <fmt:formatDate value="${p.dataPagamento}" pattern="dd/MM/yyyy"/></p>
                            <p><strong>ID Funcionário:</strong> ${p.funcionario_idFfuncionario}</p>

                            <a class="btn btn-primary btn-sm" href="GerenciarPagamento?acao=editar&idPagamento=${p.idPagamento}">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${p.idPagamento}, '${p.tipoPagamento}')">
                                <i class="fa fa-trash"></i> Excluir
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmarExclusao(idPagamento, tipoPagamento) {
        if (confirm('Deseja realmente excluir o pagamento do tipo ' + tipoPagamento + '?')) {
            location.href = 'GerenciarPagamento?acao=excluir&idPagamento=' + idPagamento;
        }
    }
</script>

</body>
</html>
