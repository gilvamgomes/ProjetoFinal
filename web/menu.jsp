<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="barra-menu">
    
    <!-- ÁREA SCROLL DOS MENUS NO DESKTOP -->
    <div class="menu-scroll">
        <ul class="menu-links">
            <c:if test="${ulogado != null && ulogado.perfil != null}">
                <c:forEach var="menu" items="${ulogado.perfil.menus}">
                    <c:if test="${menu.exibir == 1}">
                        <li><a href="${menu.link}">${menu.nome}</a></li>
                    </c:if>
                </c:forEach>
            </c:if>
        </ul>
    </div>

    <!-- BOTÃO DE SAIR NO CANTO DIREITO -->
    <div class="menu-lado-direito">
        <a href="GerenciarLogin" class="botao-sair">Sair</a>
    </div>
</div>
