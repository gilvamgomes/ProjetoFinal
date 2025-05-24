<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Login - Sistema Ótica</title>
    </head>
    <body>

        <div class="content">
            <% 
                String mensagem = (String) request.getSession().getAttribute("mensagem");
                if (mensagem != null) {
            %>
                <div class="alert alert-info"><%= mensagem %></div>
            <%
                    request.getSession().removeAttribute("mensagem");
                }
            %>

            <form action="GerenciarLogin" method="POST">
                <legend>Formulário de Login</legend>

                <label for="login" class="control-label">Login</label>
                <input type="text" class="form-control" id="login" name="login" required>

                <label for="senha" class="control-label">Senha</label>
                <input type="password" class="form-control" name="senha" id="senha" required>
                
                <br>
                <button class="btn btn-success">Acessar</button>
            </form>    
        </div>

    </body>
</html>