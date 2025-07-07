<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Cadastro de Imposto</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container formulario-funcionario">
    <div class="form-funcionario">
        <h2>Cadastro de Imposto</h2>

        <form action="GerenciarImposto" method="POST">
            <input type="hidden" id="idImposto" name="idImposto" value="${imposto.idImposto}"/>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="descricao">Descrição</label>
                    <input type="text" id="descricao" name="descricao" required value="${imposto.descricao}" class="form-control">
                </div>

                <div class="campo-form">
                    <label for="tipo">Tipo</label>
                    <select id="tipo" name="tipo" class="form-control" required>
                        <option value="">Selecione o tipo</option>
                        <option value="INSS" <c:if test="${imposto.tipo == 'INSS'}">selected</c:if>>INSS</option>
                        <option value="IRRF" <c:if test="${imposto.tipo == 'IRRF'}">selected</c:if>>IRRF</option>
                    </select>
                </div>
            </div>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="faixaInicio">Faixa Início (R$)</label>
                    <input type="number" step="0.01" id="faixaInicio" name="faixaInicio" required value="${imposto.faixaInicio}" class="form-control">
                </div>

                <div class="campo-form">
                    <label for="faixaFim">Faixa Fim (R$)</label>
                    <input type="number" step="0.01" id="faixaFim" name="faixaFim" value="${imposto.faixaFim}" class="form-control">
                </div>
            </div>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="aliquota">Alíquota (%)</label>
                    <input type="number" step="0.01" id="aliquota" name="aliquota" required value="${imposto.aliquota}" class="form-control">
                </div>

                <div class="campo-form">
                    <label for="parcelaDeduzir">Parcela a Deduzir (R$)</label>
                    <input type="number" step="0.01" id="parcelaDeduzir" name="parcelaDeduzir" required value="${imposto.parcelaDeduzir}" class="form-control">
                </div>
            </div>

            <div class="botoes-form mt-4">
                <button type="submit" class="btn btn-success">
                     Gravar
                </button>
                <a href="listar_imposto.jsp" class="btn btn-warning text-dark">
                    Voltar
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
