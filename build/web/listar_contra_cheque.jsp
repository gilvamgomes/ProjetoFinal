<%@page import="model.Usuario" %>
<%@page import="controller.GerenciarLogin" %>

<%
    Usuario ulogado = GerenciarLogin.verificarAcesso(request, response);
    request.setAttribute("ulogado", ulogado);

    String[] meses = {
        "", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    };
    request.setAttribute("meses", meses);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean class="model.FuncionarioDAO" id="fDAO" />
<%
    request.setAttribute("funcionarios", fDAO.getLista());
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/estilo.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="datatables/jquery.dataTables.min.css">
    <title>Lista de Contra-Cheques</title>
</head>
<body>

    <div class="banner">
        <%@include file="banner.jsp" %>
    </div>

    <%@include file="menu.jsp" %>

    <div class="content">
        <h2>Lista de Contra-Cheques</h2>

        <!-- ALERTA DE MENSAGEM COM JSTL -->
        <c:if test="${not empty sessionScope.mensagem}">
            <script>
                alert('${sessionScope.mensagem}');
            </script>
            <c:remove var="mensagem" scope="session" />
        </c:if>

        <a href="form_contra_cheque.jsp" class="btn btn-primary">Novo Cadastro Manual</a>

        <!-- FORMULÁRIO PARA GERAR CONTRA-CHEQUE AUTOMÁTICO -->
        <form method="get" action="GerenciarContraCheque" class="form-inline" style="margin-top: 20px;">
            <input type="hidden" name="acao" value="gerar">
            <div class="form-group">
                <label for="idFuncionario">Funcionário:</label>
                <select name="idFuncionario" class="form-control" required>
                    <option value="">-- Selecione --</option>
                    <c:forEach var="f" items="${funcionarios}">
                        <option value="${f.idFuncionario}">${f.nome}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="mes">Mês:</label>
                <select name="mes" class="form-control" required>
                    <option value="">-- Mês --</option>
                    <c:forEach var="i" begin="1" end="12">
                        <option value="${i}">${meses[i]}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="ano">Ano:</label>
                <input type="number" name="ano" value="2025" required class="form-control">
            </div>
            <button type="submit" class="btn btn-success">Gerar Contra-Cheque</button>
        </form>

        <!-- TABELA DE LISTAGEM -->
        <table class="table table-hover table-striped table-bordered display" id="listarContraCheque" style="margin-top: 20px;">
            <thead>
                <tr>
                    <th>Mês</th>
                    <th>Ano</th>
                    <th>Valor Bruto</th>
                    <th>Descontos</th>
                    <th>Valor Líquido</th>
                    <th>Funcionário</th>
                    <th>Opções</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th>Mês</th>
                    <th>Ano</th>
                    <th>Valor Bruto</th>
                    <th>Descontos</th>
                    <th>Valor Líquido</th>
                    <th>Funcionário</th>
                    <th>Opções</th>
                </tr>
            </tfoot>

            <jsp:useBean class="model.ContraChequeDAO" id="cDAO"/>
            <tbody>
                <c:forEach var="c" items="${cDAO.lista}">
                    <tr>
                        <td>${meses[c.mes]}</td>
                        <td>${c.ano}</td>
                        <td>${c.valorBruto}</td>
                        <td>${c.descontos}</td>
                        <td>${c.valorLiquido}</td>
                        <td>${c.nomeFuncionario}</td>
                        <td>
                            <a class="btn btn-primary" href="GerenciarContraCheque?acao=alterar&idContraCheque=${c.idContraCheque}">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                            <button class="btn btn-danger" onclick="confirmarExclusao(${c.idContraCheque})">
                                <i class="glyphicon glyphicon-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script type="text/javascript" src="datatables/jquery.js"></script>
    <script type="text/javascript" src="datatables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#listarContraCheque").DataTable({
                "language": {
                    "url": "datatables/portugues.json"
                }
            });
        });

        function confirmarExclusao(idContraCheque) {
            if (confirm('Deseja realmente excluir o contra-cheque ID ' + idContraCheque + ' ?')) {
                location.href = 'GerenciarContraCheque?acao=excluir&idContraCheque=' + idContraCheque;
            }
        }

        function toggleMenu(){
            var menu = document.getElementById("nav-links");
            menu.classList.toggle("show");
        }
    </script>

</body>
</html>
