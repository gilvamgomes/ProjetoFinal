<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
<<<<<<< HEAD
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

   <%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
 <%@ include file="menu_mobile.jsp" %>   <!-- Menu mobile -->
=======
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <title>Gerenciar Benefícios do Funcionário</title>
</head>
<body>

<%@include file="banner.jsp" %>
<%@include file="menu.jsp" %>
<%@include file="menu_mobile.jsp" %>
<br>
<div class="container lista-funcionario">
    <div class="form-funcionario">
        <h2 class="text-center"><i class="fa fa-briefcase"></i> Gerenciar Benefícios do Funcionário</h2>
>>>>>>> Juntar_codigo

        <form action="GerenciarFuncionarioBeneficio" method="POST">
            <input type="hidden" name="idFuncionario" value="${idFuncionario}" />

            <div class="table-responsive">
                <table class="table table-hover table-bordered" id="tabelaBeneficios">
                    <thead class="thead-dark">
                        <tr>
                            <th>Selecionar</th>
                            <th>Nome</th>
                            <th>Descrição</th>
                            <th>Valor (R$)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${listaBeneficios}">
                            <tr>
                                <td style="text-align: center;">
                                    <!-- Nome corrigido aqui: agora é "beneficioSelecionado" para bater com o Servlet -->
                                    <input type="checkbox" name="beneficioSelecionado" value="${b.idBeneficio}" 
                                           <c:if test="${b.ativoParaFuncionario}">checked</c:if> />
                                </td>
                                <td>${b.nome}</td>
                                <td>${b.descricao}</td>
                                <td>
                                    <input type="number" step="0.01" name="valor_${b.idBeneficio}" 
                                           value="${b.valorTemporario}" 
                                           class="form-control" 
                                           style="width: 100px; border-radius: 20px;" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="botoes-form text-center" style="margin-top: 15px;">
                <button type="submit" class="btn btn-success">
                   Salvar
                </button>
                <a href="listar_funcionario.jsp" class="btn btn-warning text-dark">
                     Voltar
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleMenu() {
        var menu = document.getElementById("nav-links");
        menu.classList.toggle("show");
    }
</script>

</body>
</html>
