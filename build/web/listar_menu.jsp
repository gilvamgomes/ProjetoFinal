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
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <title>Menus - Ótica Milano</title>
</head>
<body>

    <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
    <%@include file="menu_mobile.jsp" %>

    <div class="container lista-funcionario">
        <div class="row">
            <div class="col-xs-12">
                <div class="clearfix" style="margin-bottom: 20px;">
                    <h2 class="pull-left"><i class="fa fa-list"></i> Menus</h2>
                    <a href="form_menu.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                        <i class="fa fa-plus"></i> Novo Cadastro
                    </a>
                </div>

                <jsp:useBean class="model.MenuDAO" id="mDAO"/>

                <div class="row">
                    <c:forEach var="m" items="${mDAO.lista}">
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

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
