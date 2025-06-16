<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Gerenciar Menus do Perfil</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">

    <!-- Bloco Formulário -->
    <div class="form-funcionario">
        <h2>Gerenciar Menus do Perfil</h2>

        <form action="GerenciarMenuPerfil" method="POST">
            <input type="hidden" id="idPerfil" name="idPerfil" value="${perfilv.idPerfil}">

            <div class="grupo-campos">
                <div class="campo-form">
                    <label>Perfil:</label>
                    <input type="text" class="form-control" readonly value="${perfilv.nome}">
                </div>

                <div class="campo-form">
                    <label>Menu:</label>
                    <select name="idMenu" id="idMenu" class="form-control" required>
                        <option value="">Selecione o Menu</option>
                        <c:forEach var="m" items="${perfilv.naoMenus}">
                            <option value="${m.idMenu}">${m.nome}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="botoes-form">
                <button type="submit" class="btn btn-success">
                   Vincular
                </button>
                <a href="listar_perfil.jsp" class="btn btn-warning">
                   Voltar
                </a>
            </div>
        </form>
    </div>
                <br>
    <div style="margin-top: 10px;">
        <h3 class="text-center"><i class="fa fa-list-alt"></i> Menus vinculados ao perfil de ${perfilv.nome}</h3>
    </div> <br>        

    
    <!-- Bloco Cards - Agora sem filtro na JSP, pois o filtro já vem do DAO -->
    <div class="row">
        <c:forEach var="m" items="${perfilv.menus}">
            <div class="col-sm-6 col-xs-12">
                <div class="card-funcionario">
                    <h4><i class="fa fa-cog"></i> ${m.nome}</h4>
                    <p><strong>ID:</strong> ${m.idMenu}</p>
                    <p><strong>Link:</strong> ${m.link}</p>
                    <div class="btn-group">
                        <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${perfilv.idPerfil}, '${m.nome}', ${m.idMenu})">
                            <i class="fa fa-trash"></i> Excluir
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</div>

<script src="datatables/jquery.js"></script>
<script src="datatables/jquery.dataTables.min.js"></script>
<script>
    function confirmarExclusao(idPerfil, nome, idMenu) {
        if (confirm('Deseja realmente desvincular o menu "' + nome + '"?')) {
            location.href = 'GerenciarMenuPerfil?acao=desvincular&idPerfil=' + idPerfil + '&idMenu=' + idMenu;
        }
    }

    let timeout = null;
    const campo = document.getElementById("campoBusca");

    // Recupera posição do cursor ao recarregar
    if (localStorage.getItem("posCursorPerfilMenu") !== null) {
        const pos = parseInt(localStorage.getItem("posCursorPerfilMenu"));
        campo.focus();
        campo.setSelectionRange(pos, pos);
        localStorage.removeItem("posCursorPerfilMenu");
    }

    // Salva posição do cursor antes de submeter
    campo.addEventListener("input", function () {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            localStorage.setItem("posCursorPerfilMenu", campo.selectionStart);
            document.getElementById("formBusca").submit();
        }, 500);
    });

    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
