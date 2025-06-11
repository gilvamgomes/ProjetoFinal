<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%@page import="model.FuncionarioDAO" %>
<%@page import="model.Funcionario" %>
<%@page import="java.util.List" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);

    if (request.getAttribute("listaFuncionarios") == null) {
        FuncionarioDAO fdaoDireto = new FuncionarioDAO();
        List<Funcionario> funcionariosDireto = fdaoDireto.listar();
        request.setAttribute("listaFuncionarios", funcionariosDireto);
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
     <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="formulario-funcionario">
    <div class="form-funcionario">
        <h2><i class="fa fa-clock-o"></i> Registro de Ponto</h2>

        <form action="GerenciarRegistroPonto" method="POST">
            <input type="hidden" name="acao" value="${registroPonto.idRegistro_ponto == 0 ? 'gravar' : 'alterar'}" />
            <input type="hidden" name="idRegistro_ponto" value="${registroPonto.idRegistro_ponto}" />

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="data">Data</label>
                    <input type="date" id="data" name="data" class="form-control" required value="${registroPonto.data}" />
                </div>
                <div class="campo-form">
                    <label for="horaEntrada">Hora de Entrada</label>
                    <input type="time" id="horaEntrada" name="horaEntrada" class="form-control" required value="${registroPonto.horaEntrada}" />
                </div>
            </div>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="horaAlmocoSaida">Saída para Almoço</label>
                    <input type="time" id="horaAlmocoSaida" name="horaAlmocoSaida" class="form-control" value="${registroPonto.horaAlmocoSaida}" />
                </div>
                <div class="campo-form">
                    <label for="horaAlmocoVolta">Volta do Almoço</label>
                    <input type="time" id="horaAlmocoVolta" name="horaAlmocoVolta" class="form-control" value="${registroPonto.horaAlmocoVolta}" />
                </div>
            </div>

            <div class="grupo-campos">
                <div class="campo-form">
                    <label for="horaSaida">Saída Final</label>
                    <input type="time" id="horaSaida" name="horaSaida" class="form-control" value="${registroPonto.horaSaida}" />
                </div>

                <div class="campo-form">
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
                </div>
            </div>

            <div class="mt-4 botoes-form">
                <button type="submit" class="btn btn-success">
                     Gravar
                </button>
                <a href="listar_registro_ponto.jsp" class="btn btn-warning text-dark">
                     Voltar
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
