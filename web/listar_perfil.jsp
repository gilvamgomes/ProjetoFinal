<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="css/estilo.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Perfis</title>
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
                            placeholder="Buscar perfil..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>

                    <!-- Botão Novo Cadastro -->
                    <a href="form_perfil.jsp" class="btn btn-primary" style="height: 38px;">
<<<<<<< HEAD
                        <i class="fa fa-plus"></i> Novo Cadastro
                    </a>
                </div>
=======
                        <i class="fa fa-plus"></i> Novo
                    </a>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-id-badge"></i> Perfis</h2>
                </div>
            </div>
            <br>
>>>>>>> Juntar_codigo

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-id-badge"></i> Perfis</h2>
                </div>
            </div>
                  <br>
            <jsp:useBean class="model.PerfilDAO" id="pDAO"/>
            <c:set var="lista" value="${empty param.busca ? pDAO.lista : pDAO.buscarPorTermo(param.busca)}"/>

            <div class="row">
                <c:forEach var="p" items="${lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-user-shield"></i> ${p.nome}</h4>
                            <p><strong>ID:</strong> ${p.idPerfil}</p>
                            <p><strong>Status:</strong> 
                                <span class="label ${p.status == 1 ? 'label-success' : 'label-default'}">
                                    <c:out value="${p.status == 1 ? 'Ativo' : 'Inativo'}"/>
                                </span>
                            </p>
<<<<<<< HEAD
                            <div class="btn-group">
=======

                            <div class="btn-group" style="display: flex; flex-wrap: wrap; gap: 5px;">
>>>>>>> Juntar_codigo
                                <a class="btn btn-primary btn-sm" href="GerenciarPerfil?acao=alterar&idPerfil=${p.idPerfil}">
                                    <i class="fa fa-edit"></i> Editar
                                </a>
                                <a class="btn btn-default btn-sm" href="GerenciarMenuPerfil?acao=gerenciar&idPerfil=${p.idPerfil}">
                                    <i class="fa fa-lock"></i> Acessos
                                </a>
                                <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${p.idPerfil}, '${p.nome}')">
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

<script>
    function confirmarExclusao(idPerfil, nome) {
        if (confirm('Deseja realmente desativar o perfil ' + nome + '?')) {
            location.href = 'GerenciarPerfil?acao=excluir&idPerfil=' + idPerfil;
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
