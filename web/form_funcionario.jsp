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
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Funcionário</title>
</head>
<body>


   <%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
 <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

<div class="content">
    <h2>Cadastrar Funcionário</h2>
    <form action="GerenciarFuncionario" method="POST">
        <legend>Formulário de Funcionário</legend>

        <input type="hidden" id="idFuncionario" name="idFuncionario" value="${f.idFuncionario}"/>

        <label for="nome" class="control-label">Nome</label>
        <input type="text" class="form-control" id="nome" name="nome" required value="${f.nome}"/>

        <label for="dataNasc" class="control-label">Data de Nascimento</label>
        <input type="date" class="form-control" id="dataNasc" name="dataNasc" required value="${f.dataNasc}"/>

        <label for="cpf" class="control-label">CPF</label>
        <input type="text" class="form-control" id="cpf" name="cpf" required value="${f.cpf}"/>

        <label for="cargo" class="control-label">Cargo</label>
        <input type="text" class="form-control" id="cargo" name="cargo" required value="${f.cargo}"/>

        <label for="status" class="control-label">Status</label>
        <select name="status" class="form-control">
            <c:if test="${f.status == null}">
                <option value="0">Escolha uma opção</option>
                <option value="1">Ativo</option>
                <option value="2">Inativo</option>
            </c:if>
            <c:if test="${f.status == 1}">
                <option value="1" selected>Ativo</option>
                <option value="2">Inativo</option>
            </c:if>
            <c:if test="${f.status == 2}">
                <option value="1">Ativo</option>
                <option value="2" selected>Inativo</option>
            </c:if>
        </select>

        <label for="idUsuario" class="control-label">Usuário</label>
        <select name="idUsuario" id="idUsuario" required class="form-control">
            <option value="">Selecione o Usuário</option>
            <jsp:useBean class="model.UsuarioDAO" id="usuario"/>
            <c:forEach var="u" items="${usuario.lista}">
                <option value="${u.idUsuario}"
                        <c:if test="${u.idUsuario == f.usuario.idUsuario}">
                            selected
                        </c:if>
                >${u.nome}</option>
            </c:forEach>
        </select>

        <br>
        <button class="btn btn-success">Gravar</button>
        <a href="listar_funcionario.jsp" class="btn btn-warning">Voltar</a>
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