<%@page import="model.Usuario" %>
<%
    Usuario ulogado = (Usuario) session.getAttribute("ulogado");
    if (ulogado == null) {
        response.sendRedirect("form_login.jsp");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="css/estilo.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css" />
    <title>Lista de Registro de Ponto</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Registro de Ponto</h2>

        <c:if test="${ulogado.perfil.nome == 'Funcionario' || ulogado.perfil.nome == 'Gerente' || ulogado.perfil.nome == 'Administrador'}">
            <form action="GerenciarRegistroPonto" method="post" style="display:inline-block;">
                <input type="hidden" name="acao" value="registrarPonto" />
                <button type="submit" class="btn btn-primary">Bater Ponto</button>
            </form>
        </c:if>

        <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
            <a href="GerenciarRegistroPonto?acao=novo" class="btn btn-success" style="margin-left: 20px;">Novo Registro</a>
        </c:if>

        <br/><br/>

        <c:if test="${not empty mensagem}">
            <div class="alert alert-info">${mensagem}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty lista}">
                <div class="alert alert-info">Nenhum registro encontrado.</div>
            </c:when>
            <c:otherwise>
                <table class="table table-hover table-striped table-bordered display" id="listarRegistroPonto">
                    <thead>
                        <tr>
                            <th>Data</th>
                            <th>Entrada</th>
                            <th>Saída Almoço</th>
                            <th>Volta Almoço</th>
                            <th>Saída Final</th>
                            <th>Horas Trabalhadas</th>

                            <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                <th>Funcionário</th>
                                <th>Opções</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${lista}">
                            <tr>
                                <td>${r.data}</td>
                                <td><c:out value="${r.horaEntrada != null ? r.horaEntrada : '-'}" /></td>
                                <td><c:out value="${r.horaAlmocoSaida != null ? r.horaAlmocoSaida : '-'}" /></td>
                                <td><c:out value="${r.horaAlmocoVolta != null ? r.horaAlmocoVolta : '-'}" /></td>
                                <td><c:out value="${r.horaSaida != null ? r.horaSaida : '-'}" /></td>
                                <td><c:out value="${r.horasTrabalhadas} h" /></td>

                                <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                    <td><c:out value="${r.funcionario.nome}" /></td>
                                    <td>
                                        <a class="btn btn-primary" href="GerenciarRegistroPonto?acao=editar&idRegistro=${r.idRegistro_ponto}">
                                            <i class="glyphicon glyphicon-pencil"></i> Editar
                                        </a>
                                        <button class="btn btn-danger" onclick="confirmarExclusao(${r.idRegistro_ponto}, '${r.data}')">
                                            <i class="glyphicon glyphicon-trash"></i> Excluir
                                        </button>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <script type="text/javascript" src="datatables/jquery.js"></script>
    <script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#listarRegistroPonto").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idRegistro, data) {
            if (confirm('Deseja realmente excluir o registro do dia ' + data + '?')) {
                location.href = 'GerenciarRegistroPonto?acao=excluir&idRegistro=' + idRegistro;
            }
        }

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>
</body>
</html>
