<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${ulogado != null && ulogado.perfil != null}">
    <c:set var="menuPrincipalCount" value="0" />
    <c:set var="paginaAtual" value="${pageContext.request.requestURI}" />

    <div class="menu-mobile">
        <c:forEach var="menu" items="${ulogado.perfil.menus}" varStatus="loop">
            <c:if test="${menu.exibir == 1 && menuPrincipalCount lt 4}">
                <c:set var="menuPrincipalCount" value="${menuPrincipalCount + 1}" />
                <a href="${menu.link}" class="menu-item <c:if test='${fn:contains(paginaAtual, menu.link)}'>ativo</c:if>">
                    <i class="fa
                        <c:choose>
<<<<<<< HEAD
                            <c:when test="${menu.nome eq 'Dashbord'}"> fa-home</c:when>
                            <c:when test="${menu.nome eq 'Registro de Ponto'}"> fa-clock-o</c:when>
                            <c:when test="${menu.nome eq 'Férias'}"> fa-plane</c:when>
                            <c:when test="${menu.nome eq 'Contra-cheques'}"> fa-file-text</c:when>
=======
                            <c:when test="${menu.nome eq 'Dashboard'}"> fa-home</c:when>
                            <c:when test="${menu.nome eq 'Registro de Ponto'}"> fa-clock-o</c:when>
                            <c:when test="${menu.nome eq 'Férias'}"> fa-plane</c:when>
                            <c:when test="${menu.nome eq 'Contracheque'}"> fa-file-text</c:when>
                            <c:when test="${menu.nome eq 'Contra-Cheque'}"> fa-file-text-o</c:when>
>>>>>>> Juntar_codigo
                            <c:when test="${menu.nome eq 'Funcionários'}"> fa-users</c:when>
                            <c:when test="${menu.nome eq 'Benefícios'}"> fa-briefcase</c:when>
                            <c:when test="${menu.nome eq 'Usuário'}"> fa-user</c:when>
                            <c:when test="${menu.nome eq 'Perfil'}"> fa-id-badge</c:when>
                            <c:when test="${menu.nome eq 'Impostos'}"> fa-money</c:when>
                            <c:when test="${menu.nome eq 'Pagamento'}"> fa-credit-card</c:when>
                            <c:when test="${menu.nome eq 'Menu'}"> fa-list</c:when>
                            <c:otherwise> fa-circle</c:otherwise>
                        </c:choose>"></i>
                    <span>
                        <c:choose>
                            <c:when test="${menu.nome eq 'Dashbord'}">Início</c:when>
                            <c:when test="${menu.nome eq 'Registro de Ponto'}">Ponto</c:when>
                            <c:otherwise>${menu.nome}</c:otherwise>
                        </c:choose>
                    </span>
                </a>
            </c:if>
        </c:forEach>

        <!-- Botão "Mais" sempre visível -->
        <div class="menu-item" onclick="abrirMenuMais()">
            <i class="fa fa-bars"></i>
            <span>Mais</span>
        </div>
    </div>

    <div class="menu-modal" id="menuMais">
        <c:forEach var="menu" items="${ulogado.perfil.menus}" varStatus="loop">
            <c:if test="${menu.exibir == 1 && loop.index >= 4}">
                <a href="${menu.link}" class="<c:if test='${fn:contains(paginaAtual, menu.link)}'>ativo</c:if>">
                    <i class="fa
                        <c:choose>
<<<<<<< HEAD
                            <c:when test="${menu.nome eq 'Dashbord'}"> fa-home</c:when>
                            <c:when test="${menu.nome eq 'Registro de Ponto'}"> fa-clock-o</c:when>
                            <c:when test="${menu.nome eq 'Férias'}"> fa-plane</c:when>
                            <c:when test="${menu.nome eq 'Contra-cheques'}"> fa-file-text</c:when>
=======
                            <c:when test="${menu.nome eq 'Dashboard'}"> fa-home</c:when>
                            <c:when test="${menu.nome eq 'Registro de Ponto'}"> fa-clock-o</c:when>
                            <c:when test="${menu.nome eq 'Férias'}"> fa-plane</c:when>
                            <c:when test="${menu.nome eq 'Contracheque'}"> fa-file-text</c:when>
                            <c:when test="${menu.nome eq 'Contra-Cheque'}"> fa-file-text-o</c:when>
>>>>>>> Juntar_codigo
                            <c:when test="${menu.nome eq 'Funcionários'}"> fa-users</c:when>
                            <c:when test="${menu.nome eq 'Benefícios'}"> fa-briefcase</c:when>
                            <c:when test="${menu.nome eq 'Usuário'}"> fa-user</c:when>
                            <c:when test="${menu.nome eq 'Perfil'}"> fa-id-badge</c:when>
                            <c:when test="${menu.nome eq 'Impostos'}"> fa-money</c:when>
                            <c:when test="${menu.nome eq 'Pagamento'}"> fa-credit-card</c:when>
                            <c:when test="${menu.nome eq 'Menu'}"> fa-list</c:when>
                            <c:otherwise> fa-circle</c:otherwise>
                        </c:choose>"></i>
                    ${menu.nome}
                </a>
            </c:if>
        </c:forEach>
        <a href="GerenciarLogin" class="botao-sair-mobile">Sair</a>
    </div>
</c:if>

<script>
function abrirMenuMais() {
  document.getElementById("menuMais").classList.toggle("ativo");
}
</script>
