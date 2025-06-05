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
    <title>Sistema da �tica - P�gina Inicial</title>
</head>
<body>

    
    <%@include file="banner.jsp" %>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h1>Bem-vindo ao Sistema da �tica!</h1>
        
        <p>Ol�, <strong><c:out value="${ulogado.nome}"/></strong>! Seja bem-vindo(a).</p>

        <p>Escolha uma das op��es no menu acima para continuar.</p>

       
    </div>

    <script>
        function toggleMenu() {
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>