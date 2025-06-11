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
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Cadastro de Férias</title>
</head>
<body>

    <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
    <%@ include file="menu_mobile.jsp" %>

    <div class="formulario-funcionario">
        <div class="form-funcionario">
            <h2>Cadastrar Férias</h2>
            <form action="GerenciarFerias" method="POST">
                <input type="hidden" id="idFerias" name="idFerias" value="${ferias.idFerias}"/>

                <div class="grupo-campos">
                    <div class="campo-form">
                        <label for="dataInicio">Data Início</label>
                        <input type="date" id="dataInicio" name="dataInicio" required
                            value="<fmt:formatDate value='${ferias.dataInicio}' pattern='yyyy-MM-dd'/>" />
                    </div>

                    <div class="campo-form">
                        <label for="dataFim">Data Fim</label>
                        <input type="date" id="dataFim" name="dataFim" required
                            value="<fmt:formatDate value='${ferias.dataFim}' pattern='yyyy-MM-dd'/>" />
                    </div>

                    <c:choose>
                        <c:when test="${ulogado.perfil.nome != 'Funcionario'}">
                            <div class="campo-form">
                                <label for="status">Status</label>
                                <select id="status" name="status" required>
                                    <option value="Em analise" <c:if test="${ferias.status == 'Em analise'}">selected</c:if>>Em análise</option>
                                    <option value="Aprovado" <c:if test="${ferias.status == 'Aprovado'}">selected</c:if>>Aprovado</option>
                                    <option value="Recusado" <c:if test="${ferias.status == 'Recusado'}">selected</c:if>>Recusado</option>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" id="status" name="status" value="${empty ferias.status ? 'Em analise' : ferias.status}"/>
                        </c:otherwise>
                    </c:choose>
                </div>

                <input type="hidden" name="funcionario_idFfuncionario" value="${ulogado.funcionario.idFuncionario}">

                <div class="botoes-form">
                    <button class="btn btn-success">Gravar</button>
                    <a href="listar_ferias.jsp" class="btn btn-warning">Voltar</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
