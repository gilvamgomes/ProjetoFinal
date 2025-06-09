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

    FuncionarioDAO fdao = new FuncionarioDAO();
    Funcionario funcionarioLogado = fdao.getFuncionarioPorUsuario(ulogado.getIdUsuario());

    java.util.List lista = "Funcionario".equals(ulogado.getPerfil().getNome())
        ? rdao.listarPorFuncionario(funcionarioLogado.getIdFuncionario())
        : rdao.listarTodos();

    request.setAttribute("lista", lista);
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
            <div class="clearfix" style="margin-bottom: 20px;">
                <h2 class="pull-left"><i class="fa fa-clock-o"></i> Registro de Ponto</h2>
                <div class="pull-right">
                    <c:if test="${ulogado.perfil.nome == 'Funcionario' || ulogado.perfil.nome == 'Gerente' || ulogado.perfil.nome == 'Administrador'}">
                        <form action="GerenciarRegistroPonto" method="post" style="display:inline-block;">
                            <input type="hidden" name="acao" value="registrarPonto" />
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-sign-in"></i> Bater Ponto
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                        <a href="form_registro_ponto.jsp" class="btn btn-success">
                            <i class="fa fa-plus"></i> Novo Registro
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="form-group">
                <input type="text" id="filtroBusca" class="form-control" placeholder="Buscar registro...">
            </div>

            <c:choose>
                <c:when test="${empty lista}">
                    <div class="alert alert-info">Nenhum registro encontrado.</div>
                </c:when>
                <c:otherwise>
                    <div class="row" id="registrosContainer">
                        <c:forEach var="r" items="${lista}">
                            <div class="col-sm-6 col-xs-12 registro-card">
                                <div class="card-funcionario">
                                    <h4><i class="fa fa-calendar"></i> ${r.data}</h4>
                                    <p><strong>Entrada:</strong> ${r.horaEntrada != null ? r.horaEntrada : '-'}</p>
                                    <p><strong>Saída Almoço:</strong> ${r.horaAlmocoSaida != null ? r.horaAlmocoSaida : '-'}</p>
                                    <p><strong>Volta Almoço:</strong> ${r.horaAlmocoVolta != null ? r.horaAlmocoVolta : '-'}</p>
                                    <p><strong>Saída Final:</strong> ${r.horaSaida != null ? r.horaSaida : '-'}</p>
                                    <p><strong>Horas Trabalhadas:</strong> ${r.horasTrabalhadas} h</p>
                                    <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                        <p><strong>Funcionário:</strong> ${r.funcionario.nome}</p>
                                        <div class="btn-group">
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

    document.getElementById("filtroBusca").addEventListener("input", function() {
        let termo = this.value.toLowerCase();
        let cards = document.querySelectorAll(".registro-card");

        cards.forEach(card => {
            let texto = card.innerText.toLowerCase();
            card.style.display = texto.includes(termo) ? "block" : "none";
        });
    });

    function toggleMenu(){
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
