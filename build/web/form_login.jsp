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
        <div class="login-card text-center">
          
          

            <h4>Sistema de RH - <span class="marca">Ótica Milano</span></h4>

            <form action="GerenciarLogin" method="POST">
                <input type="text" name="login" placeholder="Login" class="form-control login-input" required>
                <input type="password" name="senha" placeholder="Senha" class="form-control login-input" required>
                <button type="submit" class="btn botao-login">Acessar</button>
            </form>
        </div>
    </div>

</body>
</html>
