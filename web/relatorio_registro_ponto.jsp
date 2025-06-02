<%@page import="model.RegistroPonto"%>
<%@page import="model.Funcionario"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Funcionario funcionario = (Funcionario) request.getAttribute("funcionario");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Relatório de Ponto - <%= funcionario.getNome() %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
</head>
<body>

<div class="container">
    <h2 class="text-center">Relatório de Ponto</h2>
    <h4>Funcionário: <strong><%= funcionario.getNome() %></strong></h4>

    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Data</th>
                <th>Entrada</th>
                <th>Saída Almoço</th>
                <th>Volta Almoço</th>
                <th>Saída Final</th>
                <th>Horas Trabalhadas</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="r" items="${registros}">
                <tr>
                    <td><fmt:formatDate value="${r.data}" pattern="dd/MM/yyyy"/></td>
                    <td>${r.horaEntrada}</td>
                    <td>${r.horaAlmocoSaida}</td>
                    <td>${r.horaAlmocoVolta}</td>
                    <td>${r.horaSaidaFinal}</td>
                    <td><fmt:formatNumber value="${r.horasTrabalhadas}" pattern="#0.00"/>h</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="alert alert-info">
        Total trabalhado no mês: <strong><fmt:formatNumber value="${totalHoras}" pattern="#0.00"/>h</strong><br/>
        Saldo:
        <c:choose>
            <c:when test="${saldo > 0}">
                <span style="color: green;"><strong>+<fmt:formatNumber value="${saldo}" pattern="#0.00"/>h (extra)</strong></span>
            </c:when>
            <c:when test="${saldo < 0}">
                <span style="color: red;"><strong><fmt:formatNumber value="${saldo}" pattern="#0.00"/>h (déficit)</strong></span>
            </c:when>
            <c:otherwise>
                <span style="color: gray;"><strong>0.00h (neutro)</strong></span>
            </c:otherwise>
        </c:choose>
    </div>

    <a href="listar_registro_ponto.jsp" class="btn btn-default">Voltar</a>
</div>

</body>
</html>
