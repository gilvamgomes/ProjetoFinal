<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Usuários</title>
</head>
<body>

   
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Lista de Usuários</h2>
        <a href="form_usuario.jsp" class="btn btn-primary">Novo Cadastro</a>
        
        <table class="table table-hover table-striped table-bordered display" id="listarUsuario">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Login</th>
                    
                    <th>Status</th>
                    <th>Perfil</th>
                    <th>Opções</th>
                </tr>
            </thead>  
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Login</th>
         
                    <th>Status</th>
                    <th>Perfil</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.UsuarioDAO" id="uDAO"/>
            <tbody>
                <c:forEach var="u" items="${uDAO.lista}">
                    <tr>
                        <td>${u.idUsuario}</td>
                        <td>${u.nome}</td>
                        <td>${u.login}</td>
                        
                        <td>
                            <c:if test="${u.status == 1}">Ativo</c:if>
                            <c:if test="${u.status == 2}">Inativo</c:if>
                        </td>
                        <td>${u.perfil.nome}</td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarUsuario?acao=alterar&idUsuario=${u.idUsuario}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${u.idUsuario}, '${u.nome}')">
                                <i class="glyphicon glyphicon-trash"></i>
                            </button>    
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
            $("#listarUsuario").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idUsuario, nome) {
            if (confirm('Deseja realmente desativar o usuário ' + nome + ' ?')) {
                location.href = 'GerenciarUsuario?acao=excluir&idUsuario=' + idUsuario;
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