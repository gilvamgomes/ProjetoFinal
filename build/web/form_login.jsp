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

    <style>
        /* Loader */
        #loader-wrapper {
            position: fixed;
            width: 100%;
            height: 100%;
            background: white;
            top: 0;
            left: 0;
            z-index: 9999;
            display: none;
            justify-content: center;
            align-items: center;
        }

        .loader {
            border: 8px solid #f3f3f3;
            border-top: 8px solid #008CBA;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body class="login-body">

    <!-- Loader visual -->
    <div id="loader-wrapper">
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

            // Garante que o loader some se houver erro de login
            const erroLogin = document.querySelector(".alert-danger");
            if (erroLogin) {
                document.getElementById("loader-wrapper").style.display = "none";
            }
        });
    </script>

</body>
</html>
