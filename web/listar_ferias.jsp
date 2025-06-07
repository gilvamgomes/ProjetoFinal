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
    <title>Férias - Ótica Milano</title>
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
            <div class="clearfix" style="margin-bottom: 20px;">
                <h2 class="pull-left"><i class="fa fa-calendar"></i> Férias</h2>
                <a href="form_ferias.jsp" class="btn btn-primary pull-right" style="margin-top: 10px;">
                    <i class="fa fa-plus"></i> Novo Cadastro
                </a>
            </div>

            <jsp:useBean class="model.FeriasDAO" id="fDAO"/>
            <div class="row">
                <c:forEach var="f" items="${fDAO.lista}">
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

<script src="datatables/jquery.js"></script>
<script src="datatables/jquery.dataTables.min.js"></script>
<script>
    $(document).ready(function(){
        $("#listarFerias").DataTable({
            "language": {
                "url": "datatables/portugues.json"
            }
        });
    });
</script>

</body>
</html>
