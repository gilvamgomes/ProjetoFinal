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
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="css/estilo.css">
    <title>Cadastro de Funcionário</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="formulario-funcionario">
    <div class="form-funcionario">
        <h2>Cadastrar Funcionário</h2>

        <form action="GerenciarFuncionario" method="POST">
            <input type="hidden" name="idFuncionario" value="${f.idFuncionario}" />

            <!-- Grupo 1 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="nome">Nome</label>
                    <input type="text" id="nome" name="nome" class="form-control" required value="${f.nome}" />
                </div>
                <div class="campo-form">
                    <label for="dataNasc">Data de Nascimento</label>
                    <input type="date" id="dataNasc" name="dataNasc" class="form-control" required value="${f.dataNasc}" />
                </div>
            </div>

            <!-- Grupo 2 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="cpf">CPF</label>
                    <input type="text" id="cpf" name="cpf" class="form-control" required value="${f.cpf}" />
                </div>
                <div class="campo-form">
                    <label for="cargo">Cargo</label>
                    <input type="text" id="cargo" name="cargo" class="form-control" required value="${f.cargo}" />
                </div>
            </div>

            <!-- Grupo 3 -->
            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="status">Status</label>
                    <select name="status" id="status" class="form-control" required>
                        <c:if test="${f.status == null}">
                            <option value="0">Escolha uma opção</option>
                        </c:if>
                        <option value="1" ${f.status == 1 ? 'selected' : ''}>Ativo</option>
                        <option value="2" ${f.status == 2 ? 'selected' : ''}>Inativo</option>
                    </select>
                </div>
                <div class="campo-form">
                    <label for="idUsuario">Usuário</label>
                    <select name="idUsuario" id="idUsuario" class="form-control" required>
                        <option value="">Selecione o Usuário</option>
                        <jsp:useBean class="model.UsuarioDAO" id="usuario" />
                        <c:forEach var="u" items="${usuario.lista}">
                            <option value="${u.idUsuario}" <c:if test="${u.idUsuario == f.usuario.idUsuario}">selected</c:if>>
                                ${u.nome}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Botões -->
            <div class="botoes-form">
                <button type="submit" class="btn btn-success">Gravar</button>
                <a href="listar_funcionario.jsp" class="btn btn-warning">Voltar</a>
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
