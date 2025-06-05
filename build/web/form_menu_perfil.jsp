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
    <title>Gerenciar Acessos</title>
</head>


    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    
        <h2 class="titulo-usuario">Gerenciar Acessos</h2>

<form action="GerenciarMenuPerfil" method="POST" class="painel-usuario">
    <legend>Menus Não Vinculados ao Perfil</legend>
    <label>Perfil: ${perfilv.nome}</label>
    <input type="hidden" id="idPerfil" name="idPerfil" value="${perfilv.idPerfil}">

    <label for="idMenu" class="control-label">Menu</label>
    <select name="idMenu" id="idMenu" required class="form-control">
        <option value="">Selecione o Menu</option>
        <c:forEach var="m" items="${perfilv.naoMenus}">
            <option value="${m.idMenu}">${m.nome}</option>
        </c:forEach>
    </select>

    <br>
    <button class="btn btn-usuario">Vincular</button>
    <a href="listar_perfil.jsp" class="btn btn-usuario">Voltar</a>
</form>


        <h4 class="titulo-usuario">Menus Vinculados ao Perfil: ${perfilv.nome}</h4>



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


</html>