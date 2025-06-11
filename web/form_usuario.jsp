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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Usuário</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container formulario-funcionario">
    <div class="form-funcionario">
        <h2><i class="fas fa-user-plus"></i> Cadastrar Usuário</h2>

        <form action="GerenciarUsuario" method="POST">
            <input type="hidden" id="idUsuario" name="idUsuario" value="${u.idUsuario}"/>

            <!-- Grupo 1 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="nome">Nome</label>
                    <input type="text" class="form-control" id="nome" name="nome" required value="${u.nome}">
                </div>
                <div class="campo-form">
                    <label for="login">Login</label>
                    <input type="text" class="form-control" id="login" name="login" required value="${u.login}">
                </div>
            </div>

            <!-- Grupo 2 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="senha">Senha</label>
                    <input type="password" class="form-control" id="senha" name="senha" required value="${u.senha}">
                </div>
                <div class="campo-form">
                    <label for="idPerfil">Perfil</label>
                    <select name="idPerfil" id="idPerfil" class="form-control" required>
                        <option value="">Selecione o Perfil</option>
                        <jsp:useBean class="model.PerfilDAO" id="perfil" />
                        <c:forEach var="p" items="${perfil.lista}">
                            <option value="${p.idPerfil}" <c:if test="${p.idPerfil == u.perfil.idPerfil}">selected</c:if>>
                                ${p.nome}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Grupo 3 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="status">Status</label>
                    <select name="status" id="status" class="form-control" required>
                        <option value="0" ${u.status == null ? 'selected' : ''}>Escolha uma opção</option>
                        <option value="1" ${u.status == 1 ? 'selected' : ''}>Ativo</option>
                        <option value="2" ${u.status == 2 ? 'selected' : ''}>Inativo</option>
                    </select>
                </div>
            </div>

            <!-- Botões -->
            <div class="mt-4 botoes-form">
                <button class="btn btn-success">
                    <i class="fas fa-save"></i> Gravar
                </button>
                <a href="listar_usuario.jsp" class="btn btn-warning text-dark">
                    <i class="fas fa-arrow-left"></i> Voltar
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
