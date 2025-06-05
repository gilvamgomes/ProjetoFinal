<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- MENU MOBILE FIXO NO RODAPÉ -->
<div class="menu-mobile">
    <c:if test="${ulogado != null && ulogado.perfil != null}">
        <c:forEach var="menu" items="${ulogado.perfil.menus}">
            <c:if test="${menu.exibir == 1}">
                <c:choose>
                    <c:when test="${menu.nome eq 'Dashbord'}">
                        <a href="${menu.link}" class="menu-item">
                            <i class="fa fa-home"></i>
                            <span>Início</span>
                        </a>
                    </c:when>
                    <c:when test="${menu.nome eq 'Registro de Ponto'}">
                        <a href="${menu.link}" class="menu-item">
                            <i class="fa fa-clock"></i>
                            <span>Ponto</span>
                        </a>
                    </c:when>
                    <c:when test="${menu.nome eq 'Férias'}">
                        <a href="${menu.link}" class="menu-item">
                            <i class="fa fa-suitcase"></i>
                            <span>Férias</span>
                        </a>
                    </c:when>
                    <c:when test="${menu.nome eq 'Contra-cheques'}">
                        <a href="${menu.link}" class="menu-item">
                            <i class="fa fa-money"></i>
                            <span>Contra</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- Os outros menus vão pro modal do botão Mais -->
                    </c:otherwise>
                </c:choose>
            </c:if>
        </c:forEach>

        <!-- Botão MAIS -->
        <div class="menu-item" onclick="abrirMenuMais()">
            <i class="fa fa-bars"></i>
            <span>Mais</span>
        </div>
    </c:if>
</div>

<!-- MODAL EXPANDIDO DO MAIS -->
<div class="menu-modal" id="menuMais">
    <c:forEach var="menu" items="${ulogado.perfil.menus}">
        <c:if test="${menu.exibir == 1 
                    && menu.nome != 'Dashbord' 
                    && menu.nome != 'Registro de Ponto' 
                    && menu.nome != 'Férias' 
                    && menu.nome != 'Contra-cheques'}">
            <a href="${menu.link}">${menu.nome}</a>
        </c:if>
    </c:forEach>

    <!-- BOTÃO SAIR -->
    <a href="GerenciarLogin" class="botao-sair-mobile">Sair</a>
</div>


<script>
function abrirMenuMais() {
  document.getElementById("menuMais").classList.toggle("ativo");
}
</script>
