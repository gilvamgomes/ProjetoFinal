<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);

    if (request.getAttribute("lista") == null) {
        response.sendRedirect("GerenciarImposto?acao=listar");
        return;
    }
%>

<fmt:setLocale value="pt_BR"/>

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
    <title>Lista de Impostos</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <br>

            <div class="clearfix" style="margin-bottom: 10px;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                    <form method="get" id="formBusca" style="margin: 0;">
                        <input type="text" id="filtroBusca" class="form-control" placeholder="Buscar imposto..."
                               style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;">
                    </form>
                    
                     <!-- Botão Novo Cadastro -->
                    <a href="form_imposto.jsp" class="btn btn-primary" style="height: 38px;">
                        <i class="fa fa-plus"></i> Novo
                    </a>
                   
                </div>

                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-percent"></i> Lista de Impostos</h2>
                </div>
            </div>

            <c:if test="${empty lista}">
                <div class="alert alert-warning text-center">
                    ⚠ Nenhum imposto encontrado.
                </div>
            </c:if>

            <div class="row" id="registrosContainer">
                <c:forEach var="i" items="${lista}">
                    <div class="col-sm-6 col-xs-12 registro-card">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-file-text-o"></i> ${i.descricao}</h4>
                            <p><strong>Tipo:</strong> ${i.tipo}</p>
                            <p><strong>Faixa Início:</strong> <fmt:formatNumber value="${i.faixaInicio}" type="currency"/></p>
                            <p><strong>Faixa Fim:</strong>
                                <c:choose>
                                    <c:when test="${i.faixaFim != null}">
                                        <fmt:formatNumber value="${i.faixaFim}" type="currency"/>
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Alíquota:</strong> <fmt:formatNumber value="${i.aliquota}" minFractionDigits="2" maxFractionDigits="2"/>%</p>
                            <p><strong>Parcela a Deduzir:</strong> <fmt:formatNumber value="${i.parcelaDeduzir}" type="currency"/></p>

                            <div class="grupo-botoes-card">
                                <a class="btn btn-primary btn-sm" href="GerenciarImposto?acao=editar&idImposto=${i.idImposto}">
                                    <i class="fa fa-edit"></i> Editar
                                </a>
                                <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${i.idImposto}, '${i.descricao}')">
                                    <i class="fa fa-trash"></i> Excluir
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>
</div>

<script src="datatables/jquery.js"></script>
<script src="datatables/jquery.dataTables.min.js"></script>
<script>
    document.getElementById("filtroBusca").addEventListener("input", function() {
        let termo = this.value.toLowerCase();
        let cards = document.querySelectorAll(".registro-card");

        cards.forEach(card => {
            let texto = card.innerText.toLowerCase();
            card.style.display = texto.includes(termo) ? "block" : "none";
        });
    });

    function confirmarExclusao(id, descricao) {
        if (confirm('Deseja realmente excluir o imposto "' + descricao + '"?')) {
            window.location.href = 'GerenciarImposto?acao=excluir&idImposto=' + id;
        }
    }

    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
