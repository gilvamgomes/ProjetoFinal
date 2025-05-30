<%@page import="model.Usuario" %>

<%
    Usuario ulogado = (Usuario) session.getAttribute("ulogado");
    if (ulogado == null) {
        response.sendRedirect("login.jsp");
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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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

        <form action="GerenciarRegistroPonto" method="post" style="display:inline-block; margin-right:10px;">
            <input type="hidden" name="acao" value="registrarEntrada" />
            <button type="submit" class="btn btn-success">Registrar Entrada</button>
        </form>

        <form action="GerenciarRegistroPonto" method="post" style="display:inline-block;">
            <input type="hidden" name="acao" value="registrarSaida" />
            <button type="submit" class="btn btn-warning">Registrar Saída</button>
        </form>

        <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
            <a href="GerenciarRegistroPonto?acao=novo" class="btn btn-primary" style="margin-left: 20px;">Novo Registro</a>
        </c:if>

        <br/><br/>

        <c:choose>
            <c:when test="${empty lista}">
                <div class="alert alert-info">Nenhum registro encontrado.</div>
            </c:when>
            <c:otherwise>
                <table class="table table-hover table-striped table-bordered display" id="listarRegistroPonto">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Data</th>
                            <th>Hora Entrada</th>
                            <th>Hora Saída</th>
                            <th>Funcionário</th>
                            <th>Opções</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>ID</th>
                            <th>Data</th>
                            <th>Hora Entrada</th>
                            <th>Hora Saída</th>
                            <th>Funcionário</th>
                            <th>Opções</th>
                        </tr>
                    </tfoot>

                    <tbody>
                        <c:forEach var="r" items="${lista}">
                            <tr>
                                <td>${r.idRegistro_ponto}</td>
                                <td>${r.data}</td>
                                <td>${r.horaEntrada}</td>
                                <td>${r.horaSaida}</td>
                                <td>${r.funcionario.nome}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ulogado.perfil.nome == 'Funcionario'}">
                                            -
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-primary" href="GerenciarRegistroPonto?acao=editar&idRegistro=${r.idRegistro_ponto}">
                                                <i class="glyphicon glyphicon-pencil"></i> Editar
                                            </a>
                                            <button class="btn btn-danger" onclick="confirmarExclusao(${r.idRegistro_ponto}, '${r.data}')">
                                                <i class="glyphicon glyphicon-trash"></i> Excluir
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
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