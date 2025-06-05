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
    <!-- Link do Font Awesome no head da página principal para puxar os icones -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <title>Sistema da Ótica - Página Inicial</title>
</head>
<body>

    
    <%@include file="banner.jsp" %>

    <%@include file="menu.jsp" %>

    <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->
    
    <div class="content">
        <h1>Bem-vindo ao Sistema da Ótica!</h1>
        
        <p>Olá, <strong><c:out value="${ulogado.nome}"/></strong>! Seja bem-vindo(a).</p>

        <p>Escolha uma das opções no menu acima para continuar.</p>

       
    </div>

    <script>
        function toggleMenu() {
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>