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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Perfis</title>
</head>
<body>

  
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Lista de Perfis</h2>
        <a href="form_perfil.jsp" class="btn btn-primary">Novo Cadastro</a>

        <table class="table table-hover table-striped table-bordered display" id="listarPerfil">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome do Perfil</th>
                    <th>Status</th>
                    <th>Opções</th>
                </tr>
            </thead>  
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Nome do Perfil</th>
                    <th>Status</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.PerfilDAO" id="pDAO"/>
            <tbody>
                <c:forEach var="p" items="${pDAO.lista}">
                    <tr>
                        <td>${p.idPerfil}</td>
                        <td>${p.nome}</td>
                        <td>
                            <c:if test="${p.status == 1}">Ativo</c:if>
                            <c:if test="${p.status == 2}">Inativo</c:if>
                        </td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarPerfil?acao=alterar&idPerfil=${p.idPerfil}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>    
                            <button class="btn btn-danger" onclick="confirmarExclusao(${p.idPerfil}, '${p.nome}')">
                                <i class="glyphicon glyphicon-trash"></i>
                            </button>
                            <a class="btn btn-default" href="GerenciarMenuPerfil?acao=gerenciar&idPerfil=${p.idPerfil}">
                                <i class="glyphicon">Acessos</i>
                            </a>         
                        </td>
                    </tr>
                </c:forEach>
            </tbody>    
        </table>    
    </div>

    <script type="text/javascript" src="datatables/jquery.js"></script>
    <script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#listarPerfil").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idPerfil, nome) {
            if (confirm('Deseja realmente desativar o perfil ' + nome + ' ?')) {
                location.href = 'GerenciarPerfil?acao=excluir&idPerfil=' + idPerfil;
            }
        }
    </script>

    <script>
        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>