<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Meus Contra-Cheques</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <h2 style="text-align:center; margin:20px 0;"><i class="fa fa-file-text-o"></i> Meus Contra-Cheques</h2>

            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
            <c:set var="minhaLista" value="${cDAO.lista}" />

            <c:choose>
                <c:when test="${empty minhaLista}">
                    <div class="alert alert-warning text-center">
                        ⚠ Nenhum contra-cheque encontrado.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach var="c" items="${minhaLista}">
                            <c:if test="${c.funcionarioId == ulogado.funcionario.idFuncionario}">
                                <div class="col-sm-6 col-xs-12">
                                    <div class="card-funcionario">
                                        <h4><i class="fa fa-calendar"></i> ${c.mes} / ${c.ano}</h4>
                                        <p><strong>Valor Bruto:</strong> R$ ${c.valorBruto}</p>
                                        <p><strong>Descontos:</strong> R$ ${c.descontos}</p>
                                        <p><strong>Valor Líquido:</strong> R$ ${c.valorLiquido}</p>
                                        <div class="btn-group">
                                            <a class="btn btn-info btn-sm" target="_blank" href="GerarPDF?idContraCheque=${c.idContraCheque}">
                                                <i class="fa fa-print"></i> PDF
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script type="text/javascript" src="datatables/jquery.js"></script>
<script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("#minhaTabela").DataTable({
            "language": {
                "url": "datatables/portugues.json"
            }
        });
    });

    function toggleMenu(){
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
