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
    <title>Dashboard</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="dashboard-milano">
    <div class="dashboard-cards">
        <div class="card-dashboard"><div class="titulo-card">Funcionários</div><div class="valor-card">12</div></div>
        <div class="card-dashboard"><div class="titulo-card">Férias Agendadas</div><div class="valor-card">5</div></div>
        <div class="card-dashboard"><div class="titulo-card">Registros Semanais</div><div class="valor-card">47</div></div>
        <div class="card-dashboard"><div class="titulo-card">Benefícios Pagos</div><div class="valor-card">R$ 7.300</div></div>
        <div class="card-dashboard"><div class="titulo-card">Contra-Cheques Emitidos</div><div class="valor-card">22</div></div>
    </div>

    <div class="dashboard-graficos">
        <div class="grafico-box">
            <h3 class="titulo-grafico">Distribuição de Benefícios</h3>
            <canvas id="graficoPizza" width="300" height="300"></canvas>
        </div>
        <div class="grafico-box">
            <h3 class="titulo-grafico">Registros de Ponto por Dia</h3>
            <canvas id="graficoBarra" width="300" height="300"></canvas>
        </div>
        <div class="grafico-box">
            <h3 class="titulo-grafico">Status de Férias</h3>
            <canvas id="graficoDonut" width="300" height="300"></canvas>
        </div>
    </div>

    <div class="blocos-lista">
        <div class="bloco-recentes">
            <h4>Últimos Funcionários</h4>
            <ul>
                <li>Maria - Atendente - 10/06/2025</li>
                <li>João - Vendedor - 09/06/2025</li>
                <li>Luciana - Gerente - 07/06/2025</li>
            </ul>
        </div>
        <div class="bloco-recentes">
            <h4>Últimos Registros de Ponto</h4>
            <ul>
                <li>Maria - 10/06 08:00</li>
                <li>João - 09/06 07:58</li>
                <li>Luciana - 08/06 08:05</li>
            </ul>
        </div>
        <div class="bloco-recentes">
            <h4>Últimos Pagamentos</h4>
            <ul>
                <li>Maria - R$ 2.500 - 05/06</li>
                <li>João - R$ 3.100 - 04/06</li>
                <li>Luciana - R$ 4.200 - 03/06</li>
            </ul>
        </div>
    </div>
</div>

<script src="bootstrap/js/Chart.min.js"></script>
<script>
const ctx1 = document.getElementById("graficoPizza").getContext("2d");
new Chart(ctx1, {
    type: "pie",
    data: {
        labels: ["VT", "VA", "Bônus"],
        datasets: [{
            data: [5, 3, 2],
            backgroundColor: ["#4caf50", "#ff9800", "#2196f3"]
        }]
    }
});

const ctx2 = document.getElementById("graficoBarra").getContext("2d");
new Chart(ctx2, {
    type: "bar",
    data: {
        labels: ["Seg", "Ter", "Qua", "Qui", "Sex"],
        datasets: [{
            label: "Registros de Ponto",
            data: [8, 10, 9, 7, 12],
            backgroundColor: ["#4caf50", "#ff9800", "#2196f3", "#f44336", "#9c27b0"]
        }]
    },
    options: {
        scales: {
            yAxes: [{ ticks: { beginAtZero: true } }]
        }
    }
});

const ctx3 = document.getElementById("graficoDonut").getContext("2d");
new Chart(ctx3, {
    type: "doughnut",
    data: {
        labels: ["Aprovadas", "Em Análise", "Recusadas"],
        datasets: [{
            data: [4, 2, 1],
            backgroundColor: ["#4caf50", "#ffc107", "#f44336"]
        }]
    }
});
</script>

<script>
function toggleMenu() {
    var menu = document.getElementById("nav-links");
    menu.classList.toggle("show");
}
</script>

</body>
</html>
