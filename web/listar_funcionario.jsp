<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Funcionários</title>
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
                    
                    <!-- Barra de busca -->
                    <form method="get" id="formBusca" style="margin: 0;">
                        <input 
                            type="text" 
                            name="busca" 
                            id="campoBusca"
                            value="${param.busca}" 
                            class="form-control" 
                            placeholder="Buscar funcionário..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>

                    <!-- Botão Novo Cadastro -->
                    <a href="form_funcionario.jsp" class="btn btn-primary" style="height: 38px;">
                         <i class="fa fa-plus"></i> Novo
                    </a>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-users"></i> Funcionários</h2>
                </div>
            </div>
<br>
            <c:if test="${param.status == 'beneficio_sucesso'}">
                <div class="alert alert-success text-center">
                    Benefícios atualizados com sucesso!
                </div>
            </c:if>

            <jsp:useBean class="model.FuncionarioDAO" id="fDAO"/>
            <c:set var="lista" value="${empty param.busca ? fDAO.lista : fDAO.buscarPorTermo(param.busca)}"/>

            <div class="row">
                <c:forEach var="f" items="${lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-id-card-o"></i> ${f.nome}</h4>
                            <p><strong>ID:</strong> ${f.idFuncionario}</p>
                            <p><strong>Data Nasc.:</strong> <fmt:formatDate pattern="dd/MM/yyyy" value="${f.dataNasc}"/></p>
                            <p><strong>CPF:</strong> ${f.cpf}</p>
                            <p><strong>Cargo:</strong> ${f.cargo}</p>
                            <p><strong>Status:</strong>
                                <span class="label ${f.status == 1 ? 'label-success' : 'label-default'}">
                                    ${f.status == 1 ? 'Ativo' : 'Inativo'}
                                </span>
                            </p>
                            <p><strong>Usuário:</strong> ${f.usuario.nome}</p>

                            <a class="btn btn-primary btn-sm" href="GerenciarFuncionario?acao=alterar&idFuncionario=${f.idFuncionario}" title="Editar">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <a class="btn btn-info btn-sm" href="CarregarFuncionarioBeneficio?id=${f.idFuncionario}" title="Benefícios">
                                <i class="fa fa-gift"></i> Benefícios
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${f.idFuncionario}, '${f.nome}')" title="Excluir">
                                <i class="fa fa-trash"></i> Excluir
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmarExclusao(idFuncionario, nome) {
        if (confirm('Deseja realmente desativar o funcionário ' + nome + '?')) {
            location.href = 'GerenciarFuncionario?acao=excluir&idFuncionario=' + idFuncionario;
        }
    }

    let timeout = null;
    const campo = document.getElementById("campoBusca");

    // Recupera a posição do cursor após reload
    if (localStorage.getItem("posCursor") !== null) {
        const pos = parseInt(localStorage.getItem("posCursor"));
        campo.focus();
        campo.setSelectionRange(pos, pos);
        localStorage.removeItem("posCursor");
    }

    // Envia com delay e salva posição do cursor
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
