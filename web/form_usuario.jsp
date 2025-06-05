<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Cadastro de Usuário</title>
</head>
<body>

    
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Cadastrar Usuário</h2>
        <form action="GerenciarUsuario" method="POST">
            <legend>Formulário de Usuário</legend>
            <input type="hidden" id="idUsuario" name="idUsuario" value="${u.idUsuario}"/>

            <label for="nome" class="control-label">Nome do Usuário</label>
            <input type="text" class="form-control" id="nome" name="nome" value="${u.nome}">

            <label for="login" class="control-label">Login do Usuário</label>
            <input type="text" class="form-control" id="login" name="login" value="${u.login}">

            <label for="senha" class="control-label">Senha do Usuário</label>
            <input type="password" class="form-control" id="senha" name="senha" value="${u.senha}">

            

            <label for="idPerfil" class="control-label">Perfil</label>
            <select name="idPerfil" id="idPerfil" required class="form-control">
                <option value="">Selecione o Perfil</option>
                <jsp:useBean class="model.PerfilDAO" id="perfil"/>
                <c:forEach var="p" items="${perfil.lista}">
                    <option value="${p.idPerfil}"
                        <c:if test="${p.idPerfil == u.perfil.idPerfil}">
                            selected
                        </c:if>
                    >${p.nome}</option>    
                </c:forEach>
            </select>    

            <label for="status" class="control-label">Status</label>
            <select name="status" class="form-control">
                <c:if test="${u.status == null}">
                    <option value="0">Escolha uma opção</option>
                    <option value="1">Ativo</option>
                    <option value="2">Inativo</option>
                </c:if>
                <c:if test="${u.status == 1}">
                    <option value="1" selected>Ativo</option>
                    <option value="2">Inativo</option>
                </c:if>  
                <c:if test="${u.status == 2}">
                    <option value="1">Ativo</option>
                    <option value="2" selected>Inativo</option>
                </c:if>   
            </select> 

            <br>
            <button class="btn btn-success">Gravar</button>
            <a href="listar_usuario.jsp" class="btn btn-warning">Voltar</a>
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