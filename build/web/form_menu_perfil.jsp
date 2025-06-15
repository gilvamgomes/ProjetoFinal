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
        <h2 class="text-center"><i class="fa fa-list"></i> Gerenciar Menus do Perfil</h2>

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
                    <i class="fa fa-link"></i> Vincular
                </button>
                <a href="listar_perfil.jsp" class="btn btn-warning">
                    <i class="fa fa-arrow-left"></i> Voltar
                </a>
            </div>
        </form>
    </div>

           <div style="margin-top: 10px;">
        <h3 class="text-center"><i class="fa fa-list-alt"></i> Menus vinculados ao perfil: ${perfilv.nome}</h3>
</div>         
                
    <!-- Barra de Busca com estilo centralizado e pequeno -->
    <div class="text-center" style="margin: 20px 0;">
        <form method="get" id="formBusca" style="display: inline-block; max-width: 300px; width: 100%;">
            <input type="hidden" name="acao" value="gerenciar">
            <input type="hidden" name="idPerfil" value="${perfilv.idPerfil}">
            <input 
                type="text" 
                name="busca" 
                id="campoBusca"
                value="${param.busca}" 
                placeholder="Buscar menus vinculados..." 
                class="form-control"
                style="border-radius: 20px; padding: 6px 14px; height: 36px; width: 100%;"
                autofocus
            >
        </form>
    </div>

    <!-- Bloco Cards -->

        <div class="row">
            <c:forEach var="m" items="${perfilv.menus}">
                <c:if test="${empty param.busca || fn:containsIgnoreCase(m.nome, param.busca)}">
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
                </c:if>
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
