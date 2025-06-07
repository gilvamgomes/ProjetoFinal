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
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="css/estilo.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Cadastro de Menu</title>
</head>
<body>

    <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
    <%@include file="menu_mobile.jsp" %>

    <div class="formulario-funcionario">
        <form class="form-funcionario" action="GerenciarMenu" method="POST">
            <h2><i class="fa fa-bars"></i> Cadastro de Menu</h2>

            <div class="grupo-campos">
                <input type="hidden" id="idMenu" name="idMenu" value="${m.idMenu}"/>

                <div class="campo-form">
                    <label for="nome">Nome do Menu</label>
                    <input type="text" id="nome" name="nome" required value="${m.nome}">
                </div>

                <div class="campo-form">
                    <label for="link">Link</label>
                    <input type="text" id="link" name="link" required value="${m.link}">
                </div>

                <div class="campo-form">
                    <label for="icone">Ícone</label>
                    <input type="text" id="icone" name="icone" required value="${m.icone}">
                </div>

                <div class="campo-form">
                    <label for="exibir">Exibir</label>
                    <select name="exibir" id="exibir">
                        <c:choose>
                            <c:when test="${m.exibir == 1}">
                                <option value="1" selected>Sim</option>
                                <option value="2">Não</option>
                            </c:when>
                            <c:when test="${m.exibir == 2}">
                                <option value="1">Sim</option>
                                <option value="2" selected>Não</option>
                            </c:when>
                            <c:otherwise>
                                <option value="0" selected>Escolha uma opção</option>
                                <option value="1">Sim</option>
                                <option value="2">Não</option>
                            </c:otherwise>
                        </c:choose>
                    </select>
                </div>
            </div>

            <div class="botoes-form">
                <button class="btn btn-success" type="submit">Gravar</button>
                <a href="listar_menu.jsp" class="btn btn-warning">Voltar</a>
            </div>
        </form>
    </div>

    <script>
        function toggleMenu() {
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
