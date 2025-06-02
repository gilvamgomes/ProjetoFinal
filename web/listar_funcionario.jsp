<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Funcionários</title>
</head>
<body>

<div class="banner">
    <%@include file="banner.jsp" %>
</div>

<%@include file="menu.jsp" %>

<div class="content">
    <h2>Lista de Funcionários</h2>
    <c:if test="${param.status == 'beneficio_sucesso'}">
        <div class="alert alert-success text-center">
            Benefícios atualizados com sucesso!
        </div>
    </c:if>

    <a href="form_funcionario.jsp" class="btn btn-primary">Novo Cadastro</a>

    <table class="table table-hover table-striped table-bordered display" id="listarFuncionario">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Data de Nascimento</th>
                <th>CPF</th>
                <th>Cargo</th>
                <th>Status</th>
                <th>Usuário</th>
                <th>Opções</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Data de Nascimento</th>
                <th>CPF</th>
                <th>Cargo</th>
                <th>Status</th>
                <th>Usuário</th>
                <th>Opções</th>
            </tr>
        </tfoot>

        <jsp:useBean class="model.FuncionarioDAO" id="fDAO"/>
        <tbody>
            <c:forEach var="f" items="${fDAO.lista}">
                <tr>
                    <td>${f.idFuncionario}</td>
                    <td>${f.nome}</td>
                    <td><fmt:formatDate pattern="dd/MM/yyyy" value="${f.dataNasc}"/></td>
                    <td>${f.cpf}</td>
                    <td>${f.cargo}</td>
                    <td>
                        <c:if test="${f.status == 1}">Ativo</c:if>
                        <c:if test="${f.status != 1}">Inativo</c:if>
                    </td>
                    <td>${f.usuario.nome}</td>
                    <td>
                        <a class="btn btn-primary" href="GerenciarFuncionario?acao=alterar&idFuncionario=${f.idFuncionario}">
                            <i class="glyphicon glyphicon-pencil"></i>
                        </a>

                        <a class="btn btn-info" href="CarregarFuncionarioBeneficio?id=${f.idFuncionario}">
                            <i class="glyphicon glyphicon-gift"></i> 
                        </a>

                        <button class="btn btn-danger" onclick="confirmarExclusao(${f.idFuncionario}, '${f.nome}')">
                            <i class="glyphicon glyphicon-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script type="text/javascript" src="datatables/jquery.js"></script>
<script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("#listarFuncionario").DataTable({
            "language": {
                "url": "datatables/portugues.json"
            }
        });
    });

    function confirmarExclusao(idFuncionario, nome) {
        if (confirm('Deseja realmente desativar o funcionário ' + nome + ' ?')) {
            location.href = 'GerenciarFuncionario?acao=excluir&idFuncionario=' + idFuncionario;
        }
    }
</script>

<script>
    function toggleMenu(){
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
