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
    <title>Formulário de Imposto</title>
</head>
<body>

   
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Imposto</h2>
        <form action="GerenciarImposto" method="POST">
            <legend>Formulário de Imposto</legend>
            
            <input type="hidden" id="idImposto" name="idImposto" value="${imposto.idImposto}"/>
            
            <label for="nome" class="control-label">Nome do Imposto</label>
            <input type="text" class="form-control" id="nome" name="nome" required value="${imposto.nome}">
            
            <label for="percentual" class="control-label">Percentual (%)</label>
            <input type="number" step="0.01" class="form-control" id="percentual" name="percentual" required value="${imposto.percentual}">
            
            <label for="status" class="control-label">Status</label>
            <select name="status" class="form-control">
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
            </select>

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
