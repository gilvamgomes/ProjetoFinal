<%@page import="model.RegistroPontoDAO, model.FuncionarioDAO, model.Funcionario, model.Usuario" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean class="model.RegistroPontoDAO" id="rdao" />
<%
    Usuario ulogado = (Usuario) session.getAttribute("ulogado");
    if (ulogado == null) {
        response.sendRedirect("form_login.jsp");
        return;
    }

    request.setAttribute("ulogado", ulogado);
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Registro de Ponto</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <br>

            <!-- TOPO: barra de busca à esquerda, botões à direita -->
            <div class="clearfix" style="margin-bottom: 10px;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                    
                    <!-- Barra de busca -->
                    <form method="get" id="formBusca" action="listar_registro_ponto.jsp" style="margin: 0;">
                        <input 
                            type="text" 
                            name="busca" 
                            value="${param.busca}" 
                            class="form-control" 
                            placeholder="Buscar registro..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                        >
                    </form>

                    <!-- Botões -->
                    <div style="display: flex; gap: 10px;">
                        <c:if test="${ulogado.perfil.nome == 'Funcionario' || ulogado.perfil.nome == 'Gerente'}">
                            <form action="GerenciarRegistroPonto" method="post" style="margin: 0;">
                                <input type="hidden" name="acao" value="registrarPonto" />
                                <button type="submit" class="btn btn-primary" style="height: 38px;">
                                    <i class="fa fa-sign-in"></i> Bater Ponto
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                            <a href="form_registro_ponto.jsp" class="btn btn-primary" style="height: 38px;">
                                <i class="fa fa-plus"></i> Novo
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-clock-o"></i> Registro de Ponto</h2>
                </div>
            </div>

            <!-- MENSAGEM DE FEEDBACK -->
            <c:if test="${not empty sessionScope.mensagem}">
                <div class="alert alert-info text-center">${sessionScope.mensagem}</div>
                <c:remove var="mensagem" scope="session"/>
            </c:if>

            <br>

            <!-- LISTA -->
            <c:set var="lista" value="${empty param.busca ? rdao.listarTodos() : rdao.buscarPorTermo(param.busca)}"/>

            <c:choose>
                <c:when test="${empty lista}">
                    <div class="alert alert-info">Nenhum registro encontrado.</div>
                </c:when>
                <c:otherwise>
                    <div class="row" id="registrosContainer">
                        <c:forEach var="r" items="${lista}">
                            <div class="col-sm-6 col-xs-12 registro-card">
                                <div class="card-funcionario">
                                    <h4><i class="fa fa-calendar"></i> ${r.dataFormatada}</h4>
                                    <p><strong>Entrada:</strong> ${r.horaEntrada != null ? r.horaEntrada : '-'}</p>
                                    <p><strong>Saída Almoço:</strong> ${r.horaAlmocoSaida != null ? r.horaAlmocoSaida : '-'}</p>
                                    <p><strong>Volta Almoço:</strong> ${r.horaAlmocoVolta != null ? r.horaAlmocoVolta : '-'}</p>
                                    <p><strong>Saída Final:</strong> ${r.horaSaida != null ? r.horaSaida : '-'}</p>
                                    <p><strong>Horas Trabalhadas:</strong> ${r.horasTrabalhadasFormatado}</p>
                                    <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                        <p><strong>Funcionário:</strong> ${r.funcionario.nome}</p>
                                        <div class="grupo-botoes-card">
                                            <a href="GerenciarRegistroPonto?acao=editar&idRegistro=${r.idRegistro_ponto}" class="btn btn-primary btn-sm">
                                                <i class="fa fa-edit"></i> Editar
                                            </a>
                                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${r.idRegistro_ponto}, '${r.data}')">
                                                <i class="fa fa-trash"></i> Excluir
                                            </button>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    function confirmarExclusao(id, data) {
        if (confirm('Deseja excluir o registro do dia ' + data + '?')) {
            window.location.href = 'GerenciarRegistroPonto?acao=excluir&idRegistro=' + id;
        }
    }

    let timeout = null;
    const campo = document.getElementsByName("busca")[0];

    if (localStorage.getItem("posCursor") !== null) {
        const pos = parseInt(localStorage.getItem("posCursor"));
        campo.focus();
        campo.setSelectionRange(pos, pos);
        localStorage.removeItem("posCursor");
    }

    campo.addEventListener("input", function () {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            localStorage.setItem("posCursor", campo.selectionStart);
            document.getElementById("formBusca").submit();
        }, 500);
    });

    function toggleMenu(){
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
