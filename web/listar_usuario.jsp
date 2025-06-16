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
    <title>Usuários</title>
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <br>
            <!-- TOPO: busca à esquerda, botão à direita -->
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
                            placeholder="Buscar usuário..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>

                    <!-- Botão Novo Cadastro -->
                    <a href="form_usuario.jsp" class="btn btn-primary" style="height: 38px;">
                        <i class="fa fa-plus"></i> Novo
                    </a>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-user"></i> Usuários</h2>
                </div>
            </div>
                     <br>
            <jsp:useBean class="model.UsuarioDAO" id="uDAO"/>
            <c:set var="lista" value="${empty param.busca ? uDAO.lista : uDAO.buscarPorTermo(param.busca)}"/>

            <div class="row">
                <c:forEach var="u" items="${lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-user-circle"></i> ${u.nome}</h4>
                            <p><strong>ID:</strong> ${u.idUsuario}</p>
                            <p><strong>Login:</strong> ${u.login}</p>
                            <p><strong>Perfil:</strong> ${u.perfil.nome}</p>
                            <p><strong>Status:</strong>
                                <span class="label ${u.status == 1 ? 'label-success' : 'label-default'}">
                                    <c:out value="${u.status == 1 ? 'Ativo' : 'Inativo'}"/>
                                </span>
                            </p>
                            <a class="btn btn-primary btn-sm" href="GerenciarUsuario?acao=alterar&idUsuario=${u.idUsuario}">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${u.idUsuario}, '${u.nome}')">
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
    function confirmarExclusao(idUsuario, nome) {
        if (confirm('Deseja realmente desativar o usuário ' + nome + '?')) {
            location.href = 'GerenciarUsuario?acao=excluir&idUsuario=' + idUsuario;
        }
    }

    // Delay de busca automática com persistência do cursor
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
