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
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Formulário de Registro de Ponto</title>
    <link rel="stylesheet" href="css/estilo.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" />
</head>
<body>

<div class="banner">
    <%@include file="banner.jsp" %>
</div>

<%@include file="menu.jsp" %>

<div class="content">
    <h2>Cadastro / Edição de Registro de Ponto</h2>

    <form action="GerenciarRegistroPonto" method="POST">
        <input type="hidden" name="acao" value="${registroPonto.idRegistro_ponto == 0 ? 'gravar' : 'alterar'}" />
        <input type="hidden" name="idRegistro_ponto" value="${registroPonto.idRegistro_ponto}" />

        <label for="data">Data</label>
        <input type="date" id="data" name="data" class="form-control" required value="${registroPonto.data}" />

        <label for="horaEntrada">Hora de Entrada</label>
        <input type="time" id="horaEntrada" name="horaEntrada" class="form-control" required value="${registroPonto.horaEntrada}" />

        <label for="horaAlmocoSaida">Saída para Almoço</label>
        <input type="time" id="horaAlmocoSaida" name="horaAlmocoSaida" class="form-control" value="${registroPonto.horaAlmocoSaida}" />

        <label for="horaAlmocoVolta">Volta do Almoço</label>
        <input type="time" id="horaAlmocoVolta" name="horaAlmocoVolta" class="form-control" value="${registroPonto.horaAlmocoVolta}" />

        <label for="horaSaida">Saída Final</label>
        <input type="time" id="horaSaida" name="horaSaida" class="form-control" value="${registroPonto.horaSaida}" />

        <label for="funcionario_idFfuncionario">Funcionário</label>
        <select id="funcionario_idFfuncionario" name="funcionario_idFfuncionario" class="form-control" required>
            <option value="">-- Selecione --</option>
            <c:forEach var="func" items="${listaFuncionarios}">
                <option value="${func.idFuncionario}" 
                    <c:if test="${func.idFuncionario == registroPonto.funcionario_idFfuncionario}">selected</c:if>>
                    ${func.nome}
                </option>
            </c:forEach>
        </select>

        <br/>
        <button type="submit" class="btn btn-success">Gravar</button>
        <a href="GerenciarRegistroPonto?acao=listar" class="btn btn-warning">Voltar</a>
    </form>

    <c:if test="${not empty listaRegistrosFuncionario}">
        <hr/>
        <h3>Histórico do Funcionário</h3>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Data</th>
                    <th>Hora Entrada</th>
                    <th>Saída Almoço</th>
                    <th>Volta Almoço</th>
                    <th>Saída Final</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${listaRegistrosFuncionario}">
                    <tr>
                        <td>${r.data}</td>
                        <td>${r.horaEntrada}</td>
                        <td>${r.horaAlmocoSaida}</td>
                        <td>${r.horaAlmocoVolta}</td>
                        <td>${r.horaSaida}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

</body>
</html>
