<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);

    // Redireciona se acessar direto
    if (request.getAttribute("lista") == null) {
        response.sendRedirect("GerenciarImposto?acao=listar");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Lista de Impostos</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Lista de Impostos</h2>
        <a href="form_imposto.jsp" class="btn btn-primary">Novo Cadastro</a>

        <c:if test="${empty lista}">
            <div class="alert alert-warning text-center">
                ⚠ Nenhum imposto encontrado.
            </div>
        </c:if>

        <table class="table table-hover table-striped table-bordered display" id="listarImposto">
            <thead>
                <tr>
                    <th>Descrição</th>
                    <th>Tipo</th>
                    <th>Faixa Início</th>
                    <th>Faixa Fim</th>
                    <th>Alíquota (%)</th>
                    <th>Parcela a Deduzir</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>Descrição</th>
                    <th>Tipo</th>
                    <th>Faixa Início</th>
                    <th>Faixa Fim</th>
                    <th>Alíquota (%)</th>
                    <th>Parcela a Deduzir</th>
                    <th>Opções</th>
                </tr>
            </tfoot>
            <tbody>
                <c:forEach var="i" items="${lista}">
                    <tr>
                        <td>${i.descricao}</td>
                        <td>${i.tipo}</td>
                        <td><fmt:formatNumber value="${i.faixaInicio}" type="currency" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${i.faixaFim != null}">
                                    <fmt:formatNumber value="${i.faixaFim}" type="currency" />
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatNumber value="${i.aliquota}" minFractionDigits="2" maxFractionDigits="2" />%</td>
                        <td><fmt:formatNumber value="${i.parcelaDeduzir}" type="currency" /></td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarImposto?acao=editar&idImposto=${i.idImposto}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${i.idImposto}, '${i.descricao}')">
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
            $("#listarImposto").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idImposto, descricao) {
            if (confirm('Deseja realmente excluir o imposto "' + descricao + '"?')) {
                location.href = 'GerenciarImposto?acao=excluir&idImposto=' + idImposto;
            }
        }

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
