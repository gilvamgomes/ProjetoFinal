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
    <title>Menu</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Menu</h2>
        <form action="GerenciarMenu" method="POST">
            <legend>Formulário de Menu</legend>
            
            <input type="hidden" id="idMenu" name="idMenu" value="${m.idMenu}"/>
            
            <label for="nome" class="control-label">Nome do Menu</label>
            <input type="text" class="form-control" id="nome" name="nome" required value="${m.nome}">
            
            <label for="link" class="control-label">Link</label>
            <input type="text" class="form-control" id="link" name="link" required value="${m.link}">
            
            <label for="icone" class="control-label">Ícone</label>
            <input type="text" class="form-control" id="icone" name="icone" required value="${m.icone}">
            
            <label for="exibir" class="control-label">Exibir</label>
            <select name="exibir" class="form-control">
                <c:if test="${m.exibir == null}">
                    <option value="0">Escolha uma opção</option>
                    <option value="1">Sim</option>
                    <option value="2">Não</option>
                </c:if>
                <c:if test="${m.exibir == 1}">
                    <option value="1" selected>Sim</option>
                    <option value="2">Não</option>
                </c:if>
                <c:if test="${m.exibir == 2}">
                    <option value="1">Sim</option>
                    <option value="2" selected>Não</option>
                </c:if>
            </select>

            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_menu.jsp" class="btn btn-warning">Voltar</a>
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