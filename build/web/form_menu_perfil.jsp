<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <title>Gerenciar Acessos</title>
</head>
<body>

   
   <%@include file="banner.jsp" %>
    <%@include file="menu.jsp" %>
     <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->

    <div class="content">
        <h2>Gerenciar Acessos</h2>

        <form action="GerenciarMenuPerfil" method="POST">
            <legend>Menus Não Vinculados ao Perfil</legend>
            <label>Perfil: ${perfilv.nome}</label>
            <input type="hidden" id="idPerfil" name="idPerfil" value="${perfilv.idPerfil}">
            <br>
            <label for="idMenu">Menu</label>
            <select name="idMenu" id="idMenu" required>
                <option value="">Selecione o Menu</option>
                <c:forEach var="m" items="${perfilv.naoMenus}">
                    <option value="${m.idMenu}">${m.nome}</option>
                </c:forEach>
            </select>
            <br><br>
            <button class="btn btn-success">Vincular</button>
            <a href="listar_perfil.jsp" class="btn btn-warning">Voltar</a>
        </form>

        <h4>Menus Vinculados ao Perfil: ${perfilv.nome}</h4>

        <table class="table table-hover table-striped table-bordered display" id="listarMenu">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Link</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Link</th>
                    <th>Opções</th>
                </tr>
            </tfoot>
            <tbody>
                <c:forEach var="m" items="${perfilv.menus}">
                    <tr>
                        <td>${m.idMenu}</td>
                        <td>${m.nome}</td>
                        <td>${m.link}</td>
                        <td>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${perfilv.idPerfil}, '${m.nome}', ${m.idMenu})">
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
            $("#listarMenu").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idPerfil, nome, idMenu) {
            if (confirm('Deseja realmente desvincular o menu ' + nome + '?')) {
                location.href = 'GerenciarMenuPerfil?acao=desvincular&idPerfil=' + idPerfil + '&idMenu=' + idMenu;
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