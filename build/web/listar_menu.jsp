<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
    <title>Menus</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <br>
            <!-- TOPO -->
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
                            placeholder="Buscar menu..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>

                    <!-- Botão Novo -->
                    <a href="form_menu.jsp" class="btn btn-primary" style="height: 38px;">
                        <i class="fa fa-plus"></i> Novo Cadastro
                    </a>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-list"></i> Menus</h2>
                </div>
            </div>
                            <br>
            <jsp:useBean class="model.MenuDAO" id="mDAO"/>
            <c:set var="lista" value="${empty param.busca ? mDAO.lista : mDAO.buscarPorTermo(param.busca)}"/>

            <div class="row">
                <c:forEach var="m" items="${lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-bars"></i> ${m.nome}</h4>
                            <p><strong>ID:</strong> ${m.idMenu}</p>
                            <p><strong>Link:</strong> ${m.link}</p>
                            <p><strong>Ícone:</strong> ${m.icone}</p>
                            <p><strong>Exibir:</strong> 
                                <span class="label ${m.exibir == 1 ? 'label-success' : 'label-default'}">
                                    ${m.exibir == 1 ? 'Sim' : 'Não'}
                                </span>
                            </p>

                            <a class="btn btn-primary btn-sm" href="GerenciarMenu?acao=alterar&idMenu=${m.idMenu}" title="Editar">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${m.idMenu}, '${m.nome}')" title="Excluir">
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
    function confirmarExclusao(idMenu, nome) {
        if (confirm('Deseja realmente desativar o menu ' + nome + '?')) {
            location.href = 'GerenciarMenu?acao=excluir&idMenu=' + idMenu;
        }
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
