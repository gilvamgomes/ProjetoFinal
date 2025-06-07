<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome 4.7 compatível com Bootstrap 3 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <title>Contra-Cheques</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <div class="clearfix" style="margin-bottom: 20px;">
                <h2 class="pull-left"><i class="fa fa-file-text-o"></i> Contra-Cheques</h2>
                <a href="form_contra_cheque.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                    <i class="fa fa-plus"></i> Novo Cadastro
                </a>
            </div>

            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>

            <div class="row">
                <c:forEach var="c" items="${cDAO.lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-file-text"></i> Contra-Cheque ID ${c.idContraCheque}</h4>
                            <p><strong>Valor Bruto:</strong> R$ ${c.valorBruto}</p>
                            <p><strong>Descontos:</strong> R$ ${c.descontos}</p>
                            <p><strong>Valor Líquido:</strong> R$ ${c.valorLiquido}</p>
                            <p><strong>ID Funcionário:</strong> ${c.funcionarioId}</p>

                            <a class="btn btn-primary btn-sm" href="GerenciarContraCheque?acao=alterar&idContraCheque=${c.idContraCheque}" title="Editar">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${c.idContraCheque})" title="Excluir">
                                <i class="fa fa-trash"></i> Excluir
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmarExclusao(idContraCheque) {
        if (confirm('Deseja realmente excluir o contra-cheque ID ' + idContraCheque + ' ?')) {
            location.href = 'GerenciarContraCheque?acao=excluir&idContraCheque=' + idContraCheque;
        }
    }
</script>

</body>
</html>
