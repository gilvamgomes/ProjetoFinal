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
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Contra-Cheque</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Contra-Cheque</h2>
        <form action="GerenciarContraCheque" method="POST">
            <legend>Formulário de Contra-Cheque</legend>
            
            <input type="hidden" id="idContraCheque" name="idContraCheque" value="${c.idContraCheque}"/>
            
            <label for="valorBruto" class="control-label">Valor Bruto</label>
            <input type="number" step="0.01" class="form-control" id="valorBruto" name="valorBruto" required value="${c.valorBruto}">
            
            <label for="descontos" class="control-label">Descontos</label>
            <input type="number" step="0.01" class="form-control" id="descontos" name="descontos" required value="${c.descontos}">
            
            <label for="valorLiquido" class="control-label">Valor Líquido</label>
            <input type="number" step="0.01" class="form-control" id="valorLiquido" name="valorLiquido" required value="${c.valorLiquido}">
            
            <label for="funcionarioId" class="control-label">ID do Funcionário</label>
            <input type="number" class="form-control" id="funcionarioId" name="funcionarioId" required value="${c.funcionarioId}">

            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_contra_cheque.jsp" class="btn btn-warning">Voltar</a>
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
