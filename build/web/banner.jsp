<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="banner-topo">
    <div class="banner-esquerda">
        <a href="index.jsp" class="marca-banner">ÓTICA MILANO</a>
    </div>
    <div class="banner-direita">
        <img src="imagens/avatar_padrao.png" class="foto-perfil" alt="Perfil">
        <span class="nome-usuario"><c:out value="${ulogado.nome}" /></span>
    </div>
</div>
