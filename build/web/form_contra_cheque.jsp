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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Cadastro de Contra-Cheque</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container formulario-funcionario">
    <div class="form-funcionario">
        <h2><i class="fa fa-file-text"></i> Cadastro de Contra-Cheque</h2>

        <form action="GerenciarContraCheque" method="POST">
            <input type="hidden" id="idContraCheque" name="idContraCheque" value="${c.idContraCheque}"/>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="valorBruto">Valor Bruto</label>
                    <input type="number" step="0.01" id="valorBruto" name="valorBruto" required value="${c.valorBruto}" />
                </div>

                <div class="campo-form">
                    <label for="descontos">Descontos</label>
                    <input type="number" step="0.01" id="descontos" name="descontos" required value="${c.descontos}" />
                </div>

                <div class="campo-form">
                    <label for="valorLiquido">Valor Líquido</label>
                    <input type="number" step="0.01" id="valorLiquido" name="valorLiquido" required value="${c.valorLiquido}" />
                </div>

                <div class="campo-form">
                    <label for="funcionarioId">ID do Funcionário</label>
                    <input type="number" id="funcionarioId" name="funcionarioId" required value="${c.funcionarioId}" />
                </div>

                <div class="campo-form">
                    <label for="mes">Mês</label>
                    <input type="number" min="1" max="12" id="mes" name="mes" required value="${c.mes}" />
                </div>

                <div class="campo-form">
                    <label for="ano">Ano</label>
                    <input type="number" id="ano" name="ano" required value="${c.ano}" />
                </div>
            </div>

            <div class="botoes-form">
                <button type="submit" class="btn btn-success">
                    <i class="fa fa-save"></i> Gravar
                </button>
                <a href="listar_contra_cheque.jsp" class="btn btn-warning">
                    <i class="fa fa-arrow-left"></i> Voltar
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleMenu(){
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
