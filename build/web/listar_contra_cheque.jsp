<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>
<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);

<<<<<<< HEAD
=======
    String[] meses = {
        "", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    };
    request.setAttribute("meses", meses);
%>

>>>>>>> Juntar_codigo
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width ,initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Contracheques</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>

<div class="container lista-funcionario">
    <div class="row">
        <div class="col-xs-12">
            <br>
<<<<<<< HEAD
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
                            placeholder="Buscar contra-cheque..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                            autofocus
                        >
                    </form>

                    <!-- Botão Novo Cadastro -->
                    <a href="form_contra_cheque.jsp" class="btn btn-primary" style="height: 38px;">
                        <i class="fa fa-plus"></i> Novo Cadastro
                    </a>
                </div>

                <!-- Título centralizado -->
                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-file-text-o"></i> Contra-Cheques</h2>
                </div>
            </div>
                <br>
            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
            <c:set var="lista" value="${empty param.busca ? cDAO.lista : cDAO.buscarPorTermo(param.busca)}"/>

            <div class="row">
                <c:forEach var="c" items="${lista}">
                    <div class="col-sm-6 col-xs-12">
                        <div class="card-funcionario">
                            <h4><i class="fa fa-file-text"></i> Contra-Cheque ID ${c.idContraCheque}</h4>
                            <p><strong>Valor Bruto:</strong> R$ ${c.valorBruto}</p>
                            <p><strong>Descontos:</strong> R$ ${c.descontos}</p>
                            <p><strong>Valor Líquido:</strong> R$ ${c.valorLiquido}</p>
                            <p><strong>ID Funcionário:</strong> ${c.funcionarioId}</p>

                            <a class="btn btn-primary btn-sm" href="GerenciarContraCheque?acao=alterar&idContraCheque=${c.idContraCheque}" title="Editar">
                                <i class="fa fa-edit"></i> Editar
                            </a>
                            <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${c.idContraCheque})" title="Excluir">
                                <i class="fa fa-trash"></i> Excluir
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
=======

            <div class="clearfix" style="margin-bottom: 10px;">
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                    <form method="get" id="formBusca" style="margin: 0;">
                        <input 
                            type="text" 
                            name="busca" 
                            id="campoBusca"
                            value="${param.busca}" 
                            class="form-control" 
                            placeholder="Buscar contracheque..." 
                            style="min-width: 220px; border-radius: 20px; padding: 6px 14px; height: 38px;"
                        >
                    </form>

                   
                </div>

                <!-- FORMULÁRIO DE GERAÇÃO AUTOMÁTICA -->
                <jsp:useBean class="model.FuncionarioDAO" id="fDAO" />
                <%
                    request.setAttribute("funcionarios", fDAO.getLista());
                %>

                <form method="get" action="GerenciarContraCheque" class="form-gerar-contracheque" onsubmit="exibirLoader()">
                    <input type="hidden" name="acao" value="gerar">

                    <div class="form-group">
                        <label>Funcionário:</label>
                        <select name="idFuncionario" class="form-control" required>
                            <option value="">-- Selecione --</option>
                            <c:forEach var="f" items="${funcionarios}">
                                <option value="${f.idFuncionario}">${f.nome}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Mês:</label>
                        <select name="mes" class="form-control" required>
                            <option value="">-- Mês --</option>
                            <c:forEach var="i" begin="1" end="12">
                                <option value="${i}">${meses[i]}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Ano:</label>
                        <input type="number" name="ano" value="2025" required class="form-control">
                    </div>

                    <button type="submit" class="btn btn-success">
                        <i class="fa fa-cogs"></i> Gerar
                    </button>
                </form>

                <div style="text-align: center; margin-top: 20px;">
                    <h2 style="margin: 0;"><i class="fa fa-file-text-o"></i> ContraCheques</h2>
                </div><br>
            </div>

            <c:if test="${not empty sessionScope.mensagem}">
                <div class="alert alert-info text-center">${sessionScope.mensagem}</div>
                <c:remove var="mensagem" scope="session"/>
            </c:if>

            <!-- LISTAGEM EM CARDS -->
            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
            <c:set var="lista" value="${empty param.busca ? cDAO.lista : cDAO.buscarPorTermo(param.busca)}"/>

            <c:choose>
                <c:when test="${empty lista}">
                    <div class="alert alert-warning text-center">⚠ Nenhum contracheque encontrado.</div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach var="c" items="${lista}">
                            <div class="col-sm-6 col-xs-12">
                                <div class="card-funcionario">
                                    <h4><i class="fa fa-calendar"></i> <fmt:formatNumber value="${c.mes}" pattern="00"/>/${c.ano}</h4>
                                    <p><strong>Valor Bruto:</strong> R$ ${c.valorBruto}</p>
                                    <p><strong>Descontos:</strong> R$ ${c.descontos}</p>
                                    <p><strong>Valor Líquido:</strong> R$ ${c.valorLiquido}</p>
                                    <p><strong>Funcionário:</strong> ${c.nomeFuncionario}</p>
                                    
                                    <!-- Botões com espaçamento e layout responsivo -->
                                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px;">
                                        <a class="btn btn-primary btn-sm" href="GerenciarContraCheque?acao=alterar&idContraCheque=${c.idContraCheque}">
                                            <i class="fa fa-edit"></i> Editar
                                        </a>
                                        <button class="btn btn-danger btn-sm" onclick="confirmarExclusao(${c.idContraCheque})">
                                            <i class="fa fa-trash"></i> Excluir
                                        </button>
                                        <a class="btn btn-info btn-sm" target="_blank" href="GerarPDF?idContraCheque=${c.idContraCheque}">
                                            <i class="fa fa-print"></i> PDF
                                        </a>
                                    </div>

                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
>>>>>>> Juntar_codigo
        </div>
    </div>
</div>

<<<<<<< HEAD
<script>
    function confirmarExclusao(id) {
        if (confirm('Deseja realmente excluir o contra-cheque ID ' + id + '?')) {
            location.href = 'GerenciarContraCheque?acao=excluir&idContraCheque=' + id;
=======
<!-- Loader Universal -->
<div id="loader-wrapper" style="display:none;">
    <div class="loader"></div>
</div>

<script>
    function exibirLoader() {
        document.getElementById('loader-wrapper').style.display = 'flex';
    }

    function confirmarExclusao(idContraCheque) {
        if (confirm('Deseja realmente excluir o contracheque ID ' + idContraCheque + '?')) {
            location.href = 'GerenciarContraCheque?acao=excluir&idContraCheque=' + idContraCheque;
>>>>>>> Juntar_codigo
        }
    }

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
<<<<<<< HEAD
=======

    function toggleMenu(){
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
>>>>>>> Juntar_codigo
</script>

</body>
</html>
