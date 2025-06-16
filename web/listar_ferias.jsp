<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Férias</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <br>
            <!-- TOPO: busca à esquerda, botão à direita -->
            <div class="clearfix" style="margin-bottom: 10px;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                    
                    <!-- Barra de busca funcional -->
                    <form method="get" id="formBusca" style="margin: 0;">
                        <input 
                            type="text" 
                            name="busca" 
                            id="campoBusca"
                            value="${param.busca}" 
                            class="form-control" 
                            placeholder="Buscar férias..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>

                    <!-- Botão Novo Cadastro -->
                    <a href="form_ferias.jsp" class="btn btn-primary" style="height: 38px;">
<<<<<<< HEAD
                        <i class="fa fa-plus"></i> Novo Cadastro
=======
                        <i class="fa fa-plus"></i> Novo
>>>>>>> Juntar_codigo
                    </a>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-calendar"></i> Férias</h2>
                </div>
            </div>
                  <br>
            <jsp:useBean class="model.FeriasDAO" id="fDAO"/>
            <c:set var="lista" value="${empty param.busca ? fDAO.lista : fDAO.buscarPorTermo(param.busca)}"/>

            <div class="row">
                <c:forEach var="f" items="${lista}">
                    <c:if test="${ulogado.perfil.nome == 'Administrador' || ulogado.perfil.nome == 'Gerente' || f.funcionario.idFuncionario == ulogado.funcionario.idFuncionario}">
                        <div class="col-sm-6 col-xs-12">
                            <div class="card-funcionario">
                                <h4><i class="fa fa-plane"></i> Férias</h4>
                                <p><strong>Data Início:</strong> <fmt:formatDate value="${f.dataInicio}" pattern="dd/MM/yyyy"/></p>
                                <p><strong>Data Fim:</strong> <fmt:formatDate value="${f.dataFim}" pattern="dd/MM/yyyy"/></p>
                                <p><strong>Status:</strong> ${f.status}</p>

                                <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                    <p><strong>Funcionário:</strong> ${f.funcionario.nome}</p>
                                </c:if>

                                <a href="GerenciarFerias?acao=alterar&idFerias=${f.idFerias}" class="btn btn-primary btn-sm">
                                    <i class="fa fa-edit"></i> Editar
                                </a>
                                <c:if test="${ulogado.perfil.nome != 'Funcionario'}">
                                    <a href="GerenciarFerias?acao=excluir&idFerias=${f.idFerias}" class="btn btn-danger btn-sm" onclick="return confirm('Deseja excluir?');">
                                        <i class="fa fa-trash"></i> Excluir
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    let timeout = null;
    const campo = document.getElementById("campoBusca");

    if (localStorage.getItem("posCursor") !== null) {
        const pos = parseInt(localStorage.getItem("posCursor"));
        campo.focus();
        campo.setSelectionRange(pos, pos);
        localStorage.removeItem("posCursor");
    }

    campo.addEventListener("input", function () {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            localStorage.setItem("posCursor", campo.selectionStart);
            document.getElementById("formBusca").submit();
        }, 500);
    });
</script>

</body>
</html>
