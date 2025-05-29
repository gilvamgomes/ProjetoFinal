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
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <title>Cadastro de Férias</title>
</head>
<body>

<div class="banner">
    <%@include file="banner.jsp" %>
</div>

<%@include file="menu.jsp" %>

<div class="content">
    <h2>Cadastrar Férias</h2>
    <form action="GerenciarFerias" method="POST">
        <legend>Formulário de Férias</legend>

        <input type="hidden" id="idFerias" name="idFerias" value="${ferias.idFerias}"/>

        <label for="dataInicio" class="control-label">Data Início</label>
        <input type="date" class="form-control" id="dataInicio" name="dataInicio" required
               value="<fmt:formatDate value='${ferias.dataInicio}' pattern='yyyy-MM-dd'/>"/>

        <label for="dataFim" class="control-label">Data Fim</label>
        <input type="date" class="form-control" id="dataFim" name="dataFim" required
               value="<fmt:formatDate value='${ferias.dataFim}' pattern='yyyy-MM-dd'/>"/>

        <label for="status" class="control-label">Status</label>
        <input type="text" class="form-control" id="status" name="status" required value="${ferias.status}"/>

        <label for="funcionario_idFfuncionario" class="control-label">ID Funcionário</label>
        <input type="number" class="form-control" id="funcionario_idFfuncionario"
               name="funcionario_idFfuncionario" required value="${ferias.funcionario_idFfuncionario}"/>

        <br>
        <button class="btn btn-success">Gravar</button>
        <a href="listar_ferias.jsp" class="btn btn-warning">Voltar</a>
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
