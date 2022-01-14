<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Configura" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>


<% 
String utilizador = request.getParameter("nomeUtil"); 
String tipo = request.getParameter("tipo");
%>


<jsp:include page="Header.jsp?util=<%= utilizador %>" flush="true">
    <jsp:param name="util" value="<%= utilizador %>"/>
</jsp:include>


<body>


	<h1>Listar os recursos agrupados por pessoa mostrando o tipo de recurso e o papel da pessoa</h1>

	<p>Possível tabela com as informações de um recurso</p>

	<table style="width: 100%">
		<tr id="title">
			<th>Autor</th>
			<th>Tipo de Autor</th>
			<th>Titulo do recurso</th>
			<th>Tipo de Recurso onde participa</th>
		</tr>
			<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "(select tipoAut, pessoa.nome, recurso.Tipo, recurso.Titulo from filme, pessoa, recurso where pessoa.ccPessoa = filme.ccPessoa and recurso.NumeroRecurso = filme.NumeroRecurso)"+
					"UNION (select tipoAut, pessoa.nome, recurso.Tipo, recurso.Titulo from poema, pessoa, recurso where pessoa.ccPessoa = poema.ccPessoa and recurso.NumeroRecurso = poema.NumeroRecurso)"+
					"UNION (select tipoAut, pessoa.nome, recurso.Tipo, recurso.Titulo from fotografia, pessoa, recurso where pessoa.ccPessoa = fotografia.ccPessoa and recurso.NumeroRecurso = fotografia.NumeroRecurso)"+
					"UNION (select tipoAut, pessoa.nome, recurso.Tipo, recurso.Titulo from musica, pessoa, recurso where pessoa.ccPessoa = musica.ccPessoa and recurso.NumeroRecurso = musica.NumeroRecurso);";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			
			
			while(result.next()){
				%>
				<tr>
					<td><%= result.getString("nome") %></td>
					<td><%= result.getString("tipoAut") %></td>
					<td><a href="recursos.jsp?recursotitulo=<%= result.getString("Titulo") %>&util=<%= utilizador %>&tipo=<%=tipo%>"><%= result.getString("Titulo") %> </a></td>
					<td><%= result.getString("Tipo") %></td>
				</tr>
				
				<% 
				
			}
		%>	
	</table>

<br>
<br>
<br>
<br>
<br>
<br>
<br>

<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>