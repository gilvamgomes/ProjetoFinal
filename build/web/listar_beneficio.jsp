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
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Benefícios</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <div class="clearfix" style="margin-bottom: 20px;">
                <h2 class="pull-left"><i class="fa fa-gift"></i> Benefícios</h2>
                <a href="form_beneficio.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                    <i class="fa fa-plus"></i> Novo Cadastro
                </a>
            </div>

            <jsp:useBean class="model.BeneficioDAO" id="bDAO"/>

            <div class="row">
                <c:forEach var="b" items="${bDAO.todos}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-gift"></i> ${b.nome}</h4>
                            <p><strong>ID:</strong> ${b.idBeneficio}</p>
                            <p><strong>Descrição:</strong> ${b.descricao}</p>
                            <p><strong>Status:</strong>
                                <span class="label ${b.status == 1 ? 'label-success' : 'label-default'}">
                                    <c:out value="${b.status == 1 ? 'Ativo' : 'Inativo'}"/>
                                </span>
                            </p>

                            <a class="btn btn-primary btn-sm" href="GerenciarBeneficio?acao=alterar&idBeneficio=${b.idBeneficio}" title="Editar">
                                <i class="fa fa-pencil"></i> Editar
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${b.idBeneficio}, '${b.nome}')" title="Excluir">
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
    function confirmarExclusao(idBeneficio, nome) {
        if (confirm('Deseja realmente desativar o benefício ' + nome + '?')) {
            location.href = 'GerenciarBeneficio?acao=excluir&idBeneficio=' + idBeneficio;
        }
    }
</script>

</body>
</html>
