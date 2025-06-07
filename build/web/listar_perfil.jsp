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
                <div class="clearfix" style="margin-bottom: 20px;">
                    <h2 class="pull-left"><i class="fa fa-id-badge"></i> Perfis</h2>
                    <a href="form_perfil.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                        <i class="fa fa-plus"></i> Novo Cadastro
                    </a>
                </div>

                <jsp:useBean class="model.PerfilDAO" id="pDAO"/>
                <div class="row">
                    <c:forEach var="p" items="${pDAO.lista}">
                        <div class="col-sm-6 col-xs-12">
                            <div class="card-funcionario">
                                <h4><i class="fa fa-user-shield"></i> ${p.nome}</h4>
                                <p><strong>ID:</strong> ${p.idPerfil}</p>
                                <p><strong>Status:</strong> 
                                    <span class="label ${p.status == 1 ? 'label-success' : 'label-default'}">
                                        <c:out value="${p.status == 1 ? 'Ativo' : 'Inativo'}"/>
                                    </span>
                                </p>
                                <div class="btn-group">
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

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
