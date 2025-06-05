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
    <title>Pagamento</title>
</head>
<body>

   
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Pagamento</h2>
        <form action="GerenciarPagamento" method="POST">
            <legend>Formulário de Pagamento</legend>
            
            <input type="hidden" id="idPagamento" name="idPagamento" value="${pagamento.idPagamento}"/>
            
            <label for="tipoPagamento" class="control-label">Tipo de Pagamento</label>
            <input type="text" class="form-control" id="tipoPagamento" name="tipoPagamento" required value="${pagamento.tipoPagamento}">
            
            <label for="valor" class="control-label">Valor</label>
            <input type="number" step="0.01" class="form-control" id="valor" name="valor" required value="${pagamento.valor}">
            
            <label for="dataPagamento" class="control-label">Data do Pagamento</label>
            <input type="date" class="form-control" id="dataPagamento" name="dataPagamento" required 
                   value="<fmt:formatDate value='${pagamento.dataPagamento}' pattern='yyyy-MM-dd'/>">
            
            <label for="funcionario_idFfuncionario" class="control-label">ID do Funcionário</label>
            <input type="number" class="form-control" id="funcionario_idFfuncionario" name="funcionario_idFfuncionario" required value="${pagamento.funcionario_idFfuncionario}">
            
            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_pagamento.jsp" class="btn btn-warning">Voltar</a>
        </form>
    </div>

    <script>
        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
