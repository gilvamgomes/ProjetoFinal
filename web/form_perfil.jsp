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
    <title>Cadastro de Perfil</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container mt-4 mb-4 formulario-funcionario">
    <div class="form-funcionario">
        <h2><i class="fa fa-user-shield"></i> Cadastrar Perfil</h2>
        <form action="GerenciarPerfil" method="POST">
            <input type="hidden" id="idPerfil" name="idPerfil" value="${p.idPerfil}"/>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="nome">Nome do Perfil</label>
                    <input type="text" class="form-control" id="nome" name="nome" required value="${p.nome}">
                </div>

                <div class="campo-form">
                    <label for="status">Status</label>
                    <select name="status" id="status" class="form-control">
                        <c:choose>
                            <c:when test="${p.status == 1}">
                                <option value="1" selected>Ativo</option>
                                <option value="2">Inativo</option>
                            </c:when>
                            <c:when test="${p.status == 2}">
                                <option value="1">Ativo</option>
                                <option value="2" selected>Inativo</option>
                            </c:when>
                            <c:otherwise>
                                <option value="0" selected>Escolha uma opção</option>
                                <option value="1">Ativo</option>
                                <option value="2">Inativo</option>
                            </c:otherwise>
                        </c:choose>
                    </select>
                </div>
            </div>

            <div class="botoes-form">
                <button type="submit" class="btn btn-success">
                     Gravar
                </button>
                <a href="listar_perfil.jsp" class="btn btn-warning">
                     Voltar
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
