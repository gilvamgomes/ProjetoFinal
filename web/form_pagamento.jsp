<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%@page import="model.FuncionarioDAO" %>
<%@page import="model.Funcionario" %>
<%@page import="java.util.List" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);

    // Carrega lista de funcionários
    FuncionarioDAO fdao = new FuncionarioDAO();
    List<Funcionario> listaFuncionarios = fdao.listar();
    request.setAttribute("listaFuncionarios", listaFuncionarios);
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Cadastro de Pagamento</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container formulario-funcionario">
    <div class="form-funcionario">
        <h2><i class="fas fa-money-check-alt"></i> Cadastrar Pagamento</h2>

        <form action="GerenciarPagamento" method="POST">
            <input type="hidden" name="idPagamento" value="${pagamento.idPagamento}" />

            <!-- Grupo 1 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="tipoPagamento">Tipo de Pagamento</label>
                    <input type="text" id="tipoPagamento" name="tipoPagamento" class="form-control" required value="${pagamento.tipoPagamento}" />
                </div>
                <div class="campo-form">
                    <label for="valor">Valor</label>
                    <input type="number" step="0.01" id="valor" name="valor" class="form-control" required value="${pagamento.valor}" />
                </div>
            </div>

            <!-- Grupo 2 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="dataPagamento">Data do Pagamento</label>
                    <input type="date" id="dataPagamento" name="dataPagamento" class="form-control" required
                           value="<fmt:formatDate value='${pagamento.dataPagamento}' pattern='yyyy-MM-dd'/>" />
                </div>

                <!-- Campo Funcionário como SELECT -->
                <div class="campo-form">
                    <label for="funcionario_idFfuncionario">Funcionário</label>
                    <select id="funcionario_idFfuncionario" name="funcionario_idFfuncionario" class="form-control" required>
                        <option value="">-- Selecione o Funcionário --</option>
                        <c:forEach var="f" items="${listaFuncionarios}">
                            <option value="${f.idFuncionario}" <c:if test="${pagamento.funcionario_idFfuncionario == f.idFuncionario}">selected</c:if>>
                                ${f.nome}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Botões -->
            <div class="mt-4 botoes-form">
                <button type="submit" class="btn btn-success">
                   Gravar
                </button>
                <a href="listar_pagamento.jsp" class="btn btn-warning text-dark">
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
