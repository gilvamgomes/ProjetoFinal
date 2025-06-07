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
    <!-- Font Awesome 4.7 compatível com Bootstrap 3 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <title>Funcionários</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <div class="clearfix" style="margin-bottom: 20px;">
                <h2 class="pull-left"><i class="fa fa-users"></i> Funcionários</h2>
                <a href="form_funcionario.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                    <i class="fa fa-user-plus"></i> Novo Cadastro
                </a>
            </div>

            <c:if test="${param.status == 'beneficio_sucesso'}">
                <div class="alert alert-success text-center">
                    Benefícios atualizados com sucesso!
                </div>
            </c:if>

            <jsp:useBean class="model.FuncionarioDAO" id="fDAO"/>

            <div class="row">
                <c:forEach var="f" items="${fDAO.lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-id-card-o"></i> ${f.nome}</h4>
                            <p><strong>ID:</strong> ${f.idFuncionario}</p>
                            <p><strong>Data Nasc.:</strong> <fmt:formatDate pattern="dd/MM/yyyy" value="${f.dataNasc}"/></p>
                            <p><strong>CPF:</strong> ${f.cpf}</p>
                            <p><strong>Cargo:</strong> ${f.cargo}</p>
                            <p><strong>Status:</strong>
                                <span class="label ${f.status == 1 ? 'label-success' : 'label-default'}">
                                    <c:out value="${f.status == 1 ? 'Ativo' : 'Inativo'}"/>
                                </span>
                            </p>
                            <p><strong>Usuário:</strong> ${f.usuario.nome}</p>

                            <a class="btn btn-primary btn-sm" href="GerenciarFuncionario?acao=alterar&idFuncionario=${f.idFuncionario}" title="Editar">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <a class="btn btn-info btn-sm" href="CarregarFuncionarioBeneficio?id=${f.idFuncionario}" title="Benefícios">
                                <i class="fa fa-gift"></i> Benefícios
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${f.idFuncionario}, '${f.nome}')" title="Excluir">
                                <i class="fa fa-trash"></i> Excluir
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmarExclusao(idFuncionario, nome) {
        if (confirm('Deseja realmente desativar o funcionário ' + nome + '?')) {
            location.href = 'GerenciarFuncionario?acao=excluir&idFuncionario=' + idFuncionario;
        }
    }
</script>

</body>
</html>
