<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<nav>
    <div class="menu-icon" onclick="toggleMenu()">&#9776;</div>
    <ul id="nav-links">
        <c:if test="${ulogado != null && ulogado.perfil != null}">
            <c:forEach var="menu" items="${ulogado.perfil.menus}">
                <c:if test="${menu.exibir == 1}">
                    <li><a href="${menu.link}">${menu.nome}</a></li>
                </c:if>
            </c:forEach>
        </c:if>
    </ul>
</nav>

<p>Bem-vindo, <c:if test="${ulogado != null}">${ulogado.nome}</c:if></p>
<a href="GerenciarLogin">Sair</a>