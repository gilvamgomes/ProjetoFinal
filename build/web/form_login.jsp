<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Login - Ótica Milano</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body class="login-body">

    <!-- Loader universal -->
    <div id="loader-wrapper" style="display: none;">
        <div class="loader"></div>
    </div>

    <div class="login-overlay">
        <div class="login-card">

            <!-- Alerta de erro -->
            <c:if test="${not empty erro}">
                <div class="alert alert-danger" style="text-align: center;">
                    ${erro}
                </div>
            </c:if>

            <form action="GerenciarLogin" method="POST" style="width: 100%;">
                <div class="campo-form">
                    <input type="text" name="login" placeholder="Login" class="login-input" required>
                </div>

                <div class="campo-form">
                    <input type="password" name="senha" placeholder="Senha" class="login-input" required>
                </div>

                <button type="submit" class="botao-login">Acessar</button>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const form = document.querySelector("form");
            form.addEventListener("submit", function () {
                document.getElementById("loader-wrapper").style.display = "flex";
            });

            // Garante que o loader não fique travado se houver erro
            const erro = document.querySelector(".alert-danger");
            if (erro) {
                document.getElementById("loader-wrapper").style.display = "none";
            }
        });
    </script>

</body>
</html>
