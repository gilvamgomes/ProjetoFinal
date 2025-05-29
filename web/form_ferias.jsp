<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%@page import="java.text.SimpleDateFormat" %>

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
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
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
            <input type="hidden" name="idFerias" value="${ferias.idFerias}" />

            <label for="dataInicio">Data Início:</label>
            <input type="date" name="dataInicio" class="form-control"
                value="<fmt:formatDate value='${ferias.dataInicio}' pattern='yyyy-MM-dd'/>" required />

            <label for="dataFim">Data Fim:</label>
            <input type="date" name="dataFim" class="form-control"
                value="<fmt:formatDate value='${ferias.dataFim}' pattern='yyyy-MM-dd'/>" required />

            <label for="status">Status:</label>
            <input type="text" name="status" class="form-control" value="${ferias.status}" required />

            <label for="funcionario_idFfuncionario">ID Funcionário:</label>
            <input type="number" name="funcionario_idFfuncionario" class="form-control" value="${ferias.funcionario_idFfuncionario}" required />

            <br>
            <button type="submit" class="btn btn-success">Gravar</button>
            <a href="listar_ferias.jsp" class="btn btn-warning">Voltar</a>
        </form>
    </div>

</body>
</html>
