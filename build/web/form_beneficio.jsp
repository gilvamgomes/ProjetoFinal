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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Cadastro de Benefício</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="formulario-funcionario">
    <div class="form-funcionario">
        <h2><i class="fa fa-gift"></i> Cadastrar Benefício</h2>
        <form action="GerenciarBeneficio" method="POST">
            <input type="hidden" id="idBeneficio" name="idBeneficio" value="${b.idBeneficio}"/>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="nome">Nome do Benefício</label>
                    <input type="text" id="nome" name="nome" required value="${b.nome}">
                </div>

                <div class="campo-form">
                    <label for="descricao">Descrição</label>
                    <input type="text" id="descricao" name="descricao" required value="${b.descricao}">
                </div>

                <div class="campo-form">
                    <label for="status">Status</label>
                    <select name="status" id="status" required>
                        <c:if test="${b.status == null}">
                            <option value="0">Escolha uma opção</option>
                            <option value="1">Ativo</option>
                            <option value="2">Inativo</option>
                        </c:if>
                        <c:if test="${b.status == 1}">
                            <option value="1" selected>Ativo</option>
                            <option value="2">Inativo</option>
                        </c:if>
                        <c:if test="${b.status == 2}">
                            <option value="1">Ativo</option>
                            <option value="2" selected>Inativo</option>
                        </c:if>
                    </select>
                </div>
            </div>

            <div class="botoes-form">
                <button class="btn btn-success" type="submit"><i class="fa fa-check"></i> Gravar</button>
                <a href="listar_beneficio.jsp" class="btn btn-warning"><i class="fa fa-arrow-left"></i> Voltar</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
