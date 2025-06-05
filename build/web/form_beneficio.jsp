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
    <title>Benefício</title>
</head>
<body>

      <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Cadastrar Benefício</h2>
        <form action="GerenciarBeneficio" method="POST">
            <legend>Formulário de Benefício</legend>
            
            <input type="hidden" id="idBeneficio" name="idBeneficio" value="${b.idBeneficio}"/>
            
            <label for="nome" class="control-label">Nome do Benefício</label>
            <input type="text" class="form-control" id="nome" name="nome" required value="${b.nome}">
            
            <label for="descricao" class="control-label">Descrição</label>
            <input type="text" class="form-control" id="descricao" name="descricao" required value="${b.descricao}">
            
            <label for="status" class="control-label">Status</label>
            <select name="status" class="form-control">
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

            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_beneficio.jsp" class="btn btn-warning">Voltar</a>
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