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
<br>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">

            <!-- TOPO: barra de busca alinhada à esquerda -->
            <div class="clearfix" style="margin-bottom: 10px;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                    
                    <!-- Barra de busca -->
                    <form method="get" id="formBusca" style="margin: 0;">
                        <input 
                            type="text" 
                            name="busca" 
                            id="campoBusca"
                            value="${param.busca}" 
                            class="form-control" 
                            placeholder="Buscar mês, ano, valor..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-file-text-o"></i> Meus Contra-Cheques</h2>
                </div>
                <br>
            </div>

            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
            <c:set var="minhaLista" value="${empty param.busca ? cDAO.lista : cDAO.buscarPorTermo(param.busca)}" />

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
                                        <h4><i class="fa fa-calendar"></i> <fmt:formatNumber value="${c.mes}" pattern="00"/>/${c.ano}</h4>
                                        <p><strong>Valor Bruto:</strong> R$ ${c.valorBruto}</p>
                                        <p><strong>Descontos:</strong> R$ ${c.descontos}</p>
                                        <p><strong>Valor Líquido:</strong> R$ ${c.valorLiquido}</p>

                                        <!-- Botões com alinhamento e espaçamento -->
                                        <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px;">
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

<!-- Loader Universal -->
<div id="loader-wrapper" style="display:none;">
    <div class="loader"></div>
</div>

<script type="text/javascript" src="datatables/jquery.js"></script>
<script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
<script>
    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }

    let timeout = null;
    const campo = document.getElementById("campoBusca");

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
</script>

</body>
</html>
