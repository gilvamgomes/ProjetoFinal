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
    <title>Formulário de Imposto</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Imposto</h2>
        <form action="GerenciarImposto" method="POST">
            <legend>Formulário de Imposto</legend>

            <input type="hidden" id="idImposto" name="idImposto" value="${imposto.idImposto}"/>

            <label for="descricao" class="control-label">Descrição</label>
            <input type="text" class="form-control" id="descricao" name="descricao" required value="${imposto.descricao}">

            <label for="tipo" class="control-label">Tipo</label>
            <select class="form-control" id="tipo" name="tipo" required>
                <option value="">Selecione o tipo</option>
                <option value="INSS" ${imposto.tipo == 'INSS' ? 'selected' : ''}>INSS</option>
                <option value="IRRF" ${imposto.tipo == 'IRRF' ? 'selected' : ''}>IRRF</option>
            </select>

            <label for="faixaInicio" class="control-label">Faixa Início (R$)</label>
            <input type="number" step="0.01" class="form-control" id="faixaInicio" name="faixaInicio" required value="${imposto.faixaInicio}">

            <label for="faixaFim" class="control-label">Faixa Fim (R$)</label>
            <input type="number" step="0.01" class="form-control" id="faixaFim" name="faixaFim" value="${imposto.faixaFim}">

            <label for="aliquota" class="control-label">Alíquota (%)</label>
            <input type="number" step="0.01" class="form-control" id="aliquota" name="aliquota" required value="${imposto.aliquota}">

            <label for="parcelaDeduzir" class="control-label">Parcela a Deduzir (R$)</label>
            <input type="number" step="0.01" class="form-control" id="parcelaDeduzir" name="parcelaDeduzir" required value="${imposto.parcelaDeduzir}">

            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_imposto.jsp" class="btn btn-warning">Voltar</a>
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
