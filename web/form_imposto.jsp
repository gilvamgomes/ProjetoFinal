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
<<<<<<< HEAD
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Cadastro de Imposto</title>
=======
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
>>>>>>> Juntar_codigo
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container formulario-funcionario">
    <div class="form-funcionario">
<<<<<<< HEAD
        <h2><i class="fa fa-file-invoice-dollar"></i> Cadastrar Imposto</h2>
=======
        <h2>Cadastro de Imposto</h2>

>>>>>>> Juntar_codigo
        <form action="GerenciarImposto" method="POST">
            <input type="hidden" id="idImposto" name="idImposto" value="${imposto.idImposto}"/>

            <div class="grupo-campos">
                <div class="campo-form">
<<<<<<< HEAD
                    <label for="nome">Nome do Imposto</label>
                    <input type="text" id="nome" name="nome" required value="${imposto.nome}">
                </div>

                <div class="campo-form">
                    <label for="percentual">Percentual (%)</label>
                    <input type="number" step="0.01" id="percentual" name="percentual" required value="${imposto.percentual}">
                </div>

                <div class="campo-form">
                    <label for="status">Status</label>
                    <select name="status" id="status" required>
                        <c:choose>
                            <c:when test="${imposto.status == 1}">
                                <option value="1" selected>Ativo</option>
                                <option value="2">Inativo</option>
                            </c:when>
                            <c:when test="${imposto.status == 2}">
                                <option value="1">Ativo</option>
                                <option value="2" selected>Inativo</option>
                            </c:when>
                            <c:otherwise>
                                <option value="0" selected>Escolha uma opção</option>
                                <option value="1">Ativo</option>
                                <option value="2">Inativo</option>
                            </c:otherwise>
                        </c:choose>
=======
                    <label for="descricao">Descrição</label>
                    <input type="text" id="descricao" name="descricao" required value="${imposto.descricao}" class="form-control">
                </div>

                <div class="campo-form">
                    <label for="tipo">Tipo</label>
                    <select id="tipo" name="tipo" class="form-control" required>
                        <option value="">Selecione o tipo</option>
                        <option value="INSS" <c:if test="${imposto.tipo == 'INSS'}">selected</c:if>>INSS</option>
                        <option value="IRRF" <c:if test="${imposto.tipo == 'IRRF'}">selected</c:if>>IRRF</option>
>>>>>>> Juntar_codigo
                    </select>
                </div>
            </div>

<<<<<<< HEAD
            <div class="botoes-form">
                <button type="submit" class="btn btn-success">
                    Gravar
                </button>
                <a href="listar_imposto.jsp" class="btn btn-warning">
                     Voltar
=======
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
>>>>>>> Juntar_codigo
                </a>
            </div>
        </form>
    </div>
</div>

<script>
<<<<<<< HEAD
    function toggleMenu(){
=======
    function toggleMenu() {
>>>>>>> Juntar_codigo
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
