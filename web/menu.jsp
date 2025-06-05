<div class="barra-menu">
    <div class="menu-topo">
        <div class="menu-toggle" onclick="toggleMenu()">&#9776;</div>

        <!-- Menu links visíveis no desktop e responsivos no mobile -->
        <ul class="menu-links" id="menuLinks">
            <c:if test="${ulogado != null && ulogado.perfil != null}">
                <c:forEach var="menu" items="${ulogado.perfil.menus}">
                    <c:if test="${menu.exibir == 1}">
                        <li><a href="${menu.link}">${menu.nome}</a></li>
                    </c:if>
                </c:forEach>
            </c:if>
        </ul>
    </div>

    <div class="menu-lado-direito">
        <a href="GerenciarLogin" class="botao-sair">Sair</a>
    </div>
</div>
<script>
function toggleMenu() {
  var links = document.getElementById("menuLinks");
  links.classList.toggle("mostrar");
}
</script>
