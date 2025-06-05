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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Lista de Férias</title>
</head>
<body>

  
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Lista de Férias</h2>
        <a href="form_ferias.jsp" class="btn btn-primary">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display" id="listarFerias">
            <thead>
                <tr>
                    <th>Data Início</th>
                    <th>Data Fim</th>
                    <th>Status</th>
                    <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                        <th>Funcionário</th>
                    </c:if>
                    <th>Opções</th>
                </tr>
            </thead>

            <jsp:useBean class="model.FeriasDAO" id="fDAO"/>
            <tbody>
                <c:forEach var="f" items="${fDAO.lista}">
                    <c:if test="${ulogado.perfil.nome == 'Administrador' || ulogado.perfil.nome == 'Gerente' || f.funcionario.idFuncionario == ulogado.funcionario.idFuncionario}">
                        <tr>
                            <td><fmt:formatDate value="${f.dataInicio}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${f.dataFim}" pattern="dd/MM/yyyy"/></td>
                            <td>${f.status}</td>
                            <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                <td>${f.funcionario.nome}</td>
                            </c:if>
                            <td>
                                <c:choose>
                                    <c:when test="${ulogado.perfil.nome == 'Funcionario' && f.status == 'Em analise'}">
                                        <a href="GerenciarFerias?acao=alterar&idFerias=${f.idFerias}" class="btn btn-primary">
                                            <i class="glyphicon glyphicon-pencil"></i>
                                        </a>
                                    </c:when>
                                    <c:when test="${ulogado.perfil.nome != 'Funcionario'}">
                                        <a href="GerenciarFerias?acao=alterar&idFerias=${f.idFerias}" class="btn btn-primary">
                                            <i class="glyphicon glyphicon-pencil"></i>
                                        </a>
                                        <a href="GerenciarFerias?acao=excluir&idFerias=${f.idFerias}" class="btn btn-danger" onclick="return confirm('Deseja excluir?');">
                                            <i class="glyphicon glyphicon-trash"></i>
                                        </a>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
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
    </script>

</body>
</html>
