form_funcionario_beneficio.jsp
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
    <title>Gerenciar Benefícios</title>
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

   <%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
 <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

<div class="container">
    <h2 class="text-center">Gerenciar Benefícios do Funcionário</h2>

    <form action="GerenciarFuncionarioBeneficio" method="post" class="form-horizontal">
        <input type="hidden" name="idFuncionario" value="${idFuncionario}" />

        <table class="table table-striped table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th class="text-center">Selecionar</th>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Valor</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="beneficio" items="${listaBeneficios}">
                    <tr>
                        <td class="text-center">
                            <input type="checkbox" name="beneficioSelecionado" value="${beneficio.idBeneficio}"
                                <c:if test="${beneficio.ativoParaFuncionario}">checked</c:if> />
                        </td>
                        <td>${beneficio.nome}</td>
                        <td>${beneficio.descricao}</td>
                        <td>
                            <input type="text" name="valor_${beneficio.idBeneficio}" value="${beneficio.valorTemporario}" class="form-control" />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="form-group text-center">
            <button type="submit" class="btn btn-success">Salvar</button>
            <a href="listar_funcionario.jsp" class="btn btn-secondary">Voltar</a>
        </div>
    </form>

    <c:if test="${param.status == 'sucesso'}">
        <div class="alert alert-success text-center">Benefícios atualizados com sucesso!</div>
    </c:if>
</div>

</body>
</html>
