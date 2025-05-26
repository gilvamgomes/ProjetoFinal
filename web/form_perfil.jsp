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
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Perfil</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Perfil</h2>
        <form action="GerenciarPerfil" method="POST">
            <legend>Formulário de Perfil</legend>
            
            <input type="hidden" id="idPerfil" name="idPerfil" value="${p.idPerfil}"/>
            
            <label for="nome" class="control-label">Nome do Perfil</label>
            <input type="text" class="form-control" id="nome" name="nome" required value="${p.nome}">
            
            <label for="status" class="control-label">Status</label>
            <select name="status" class="form-control">
                <c:if test="${p.status == null}">
                    <option value="0">Escolha uma opção</option>
                    <option value="1">Ativo</option>
                    <option value="2">Inativo</option>
                </c:if>
                <c:if test="${p.status == 1}">
                    <option value="1" selected>Ativo</option>
                    <option value="2">Inativo</option>
                </c:if>
                <c:if test="${p.status == 2}">
                    <option value="1">Ativo</option>
                    <option value="2" selected>Inativo</option>
                </c:if>
            </select>
            
            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_perfil.jsp" class="btn btn-warning">Voltar</a>
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