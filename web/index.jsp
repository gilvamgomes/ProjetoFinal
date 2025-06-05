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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <title>Sistema da Ótica - Página Inicial</title>
</head>
<body>



    <%@include file="menu.jsp" %>

    <div class="content painel-usuario text-center">
        <h1 class="titulo-usuario">Bem-vindo(a) ao Sistema da Ótica!</h1>
        
        <p>Olá, <strong><c:out value="${ulogado.nome}"/></strong>! Que bom ter você por aqui.</p>

        <p>Use o menu acima para navegar pelo sistema.</p>

        <a href="GerenciarLogin?acao=logout" class="btn btn-danger btn-lg">Sair</a>
    </div>

    <script>
        function toggleMenu() {
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
