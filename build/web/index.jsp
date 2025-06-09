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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Dashboard - Sistema RH</title>
</head>
<body>

    <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
    <%@include file="menu_mobile.jsp" %>

    <div class="index-container" style="padding: 30px; background-color: #f0f2f5; min-height: 85vh;">

        <div class="row text-center">
            <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                <div class="col-md-3 col-sm-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading"><i class="fas fa-users"></i> Funcionários</div>
                        <div class="panel-body"><h3>${totalFuncionarios}</h3></div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="panel panel-success">
                        <div class="panel-heading"><i class="fas fa-gift"></i> Benefícios</div>
                        <div class="panel-body"><h3>${totalBeneficios}</h3></div>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="panel panel-info">
                        <div class="panel-heading"><i class="fas fa-money-bill-wave"></i> Pagamentos</div>
                        <div class="panel-body">
                            <h3>R$ ${totalPagamentos}</h3>
                            <small>mês atual ou último</small>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h4>Últimos registros de ponto</h4>
                <table class="table table-striped table-condensed">
                    <thead>
                        <tr>
                            <th>Funcionário</th>
                            <th>Data</th>
                            <th>Entrada</th>
                            <th>Almoço</th>
                            <th>Volta</th>
                            <th>Saída</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ponto" items="${ultimosPontos}">
                            <tr>
                                <td>${ponto.funcionario.nome}</td>
                                <td>${ponto.data}</td>
                                <td>${ponto.horaEntrada}</td>
                                <td>${ponto.horaAlmocoSaida}</td>
                                <td>${ponto.horaAlmocoVolta}</td>
                                <td>${ponto.horaSaida}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="col-md-6">
                <h4>Férias Solicitadas</h4>
                <table class="table table-bordered table-condensed">
                    <thead>
                        <tr>
                            <th>Funcionário</th>
                            <th>Início</th>
                            <th>Fim</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ferias" items="${feriasSolicitadas}">
                            <tr>
                                <td>${ferias.funcionario.nome}</td>
                                <td>${ferias.dataInicio}</td>
                                <td>${ferias.dataFim}</td>
                                <td><span class="label label-warning">${ferias.status}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>
