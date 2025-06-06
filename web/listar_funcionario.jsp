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
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Funcionários</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container mt-5 lista-funcionario">
    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
        <h2><i class="fas fa-users"></i> Funcionários</h2>
        <a href="form_funcionario.jsp" class="btn btn-success">
            <i class="fas fa-user-plus"></i> Novo Cadastro
        </a>
    </div>

    <c:if test="${param.status == 'beneficio_sucesso'}">
        <div class="alert alert-success text-center">
            Benefícios atualizados com sucesso!
        </div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-hover table-striped table-bordered display" id="listarFuncionario">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Data de Nascimento</th>
                    <th>CPF</th>
                    <th>Cargo</th>
                    <th>Status</th>
                    <th>Usuário</th>
                    <th class="text-center">Opções</th>
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
                    <th class="text-center">Opções</th>
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
                            <span class="badge ${f.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                <c:out value="${f.status == 1 ? 'Ativo' : 'Inativo'}"/>
                            </span>
                        </td>
                        <td>${f.usuario.nome}</td>
                        <td class="text-center">
                            <a class="btn btn-sm btn-primary" href="GerenciarFuncionario?acao=alterar&idFuncionario=${f.idFuncionario}" title="Editar">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a class="btn btn-sm btn-warning text-dark" href="CarregarFuncionarioBeneficio?id=${f.idFuncionario}" title="Benefícios">
                                <i class="fas fa-gift"></i>
                            </a>
                            <button class="btn btn-sm btn-danger" onclick="confirmarExclusao(${f.idFuncionario}, '${f.nome}')" title="Excluir">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="datatables/jquery.js"></script>
<script src="datatables/jquery.dataTables.min.js"></script>
<script>
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

</body>
</html>
