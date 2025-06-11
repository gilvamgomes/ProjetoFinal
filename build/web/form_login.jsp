<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

    <div class="login-overlay">
        <div class="login-card">

            <!-- Logo vem do CSS via ::before -->

            

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

</body>
</html>
