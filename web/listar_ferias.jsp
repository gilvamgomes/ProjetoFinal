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
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Lista de Férias</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Lista de Férias</h2>
        <a href="form_ferias.jsp" class="btn btn-primary">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display" id="listarFerias">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Data Início</th>
                    <th>Data Fim</th>
                    <th>Status</th>
                    <th>ID Funcionário</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Data Início</th>
                    <th>Data Fim</th>
                    <th>Status</th>
                    <th>ID Funcionário</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.FeriasDAO" id="fDAO"/>
            <tbody>
                <c:forEach var="f" items="${fDAO.lista}">
                    <tr>
                        <td>${f.idFerias}</td>
                        <td><fmt:formatDate value="${f.dataInicio}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${f.dataFim}" pattern="dd/MM/yyyy"/></td>
                        <td>${f.status}</td>
                        <td>${f.funcionario_idFfuncionario}</td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarFerias?acao=editar&idFerias=${f.idFerias}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${f.idFerias})">
                                <i class="glyphicon glyphicon-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="datatables/jquery.js"></script>
    <script src="datatables/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function(){
            $("#listarFerias").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idFerias) {
            if (confirm('Deseja realmente excluir esse registro de férias?')) {
                location.href = 'GerenciarFerias?acao=excluir&idFerias=' + idFerias;
            }
        }
    </script>

</body>
</html>
