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


	<h1>Apresentacao atributos pessoas</h1>

	<hr>

	<table style="width: 100%">
		<tr id="title">
			<th>CC Pessoa</th>
			<th>Nome Utilizador</th>
			<th>Data Nascimento</th>
			<th>Nacionalidade</th>
			<th>Tipo Autor</th>
			<th>Quantidade Recursos</th>
		</tr>
			<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "select distinct ccPessoa from autor;";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			ArrayList<String> arrayPessoa = new ArrayList<String>();
			int counter = 0;
			while(result.next()){
				arrayPessoa.add(counter, result.getString("ccPessoa"));
				counter++;
			}
			
			String sqlNova ="";
			for(int i = 0; i < arrayPessoa.size(); i++){
				if(i == 0){
					sqlNova = "(select pessoa.ccPessoa, pessoa.nome, pessoa.dataNasc, pessoa.Nacionalidade, filme.tipoAut, count(distinct recurso.Titulo) as quantidade from pessoa, filme, recurso where pessoa.ccPessoa = "+arrayPessoa.get(i)+" and filme.ccPessoa = pessoa.ccPessoa and filme.NumeroRecurso = recurso.NumeroRecurso group by tipoAut)";
				}else{
					sqlNova += "UNION (select pessoa.ccPessoa, pessoa.nome, pessoa.dataNasc, pessoa.Nacionalidade, filme.tipoAut, count(distinct recurso.Titulo) as quantidade from pessoa, filme, recurso where pessoa.ccPessoa = "+arrayPessoa.get(i)+" and filme.ccPessoa = pessoa.ccPessoa and filme.NumeroRecurso = recurso.NumeroRecurso group by tipoAut)";
						
				}
				sqlNova += "UNION (select pessoa.ccPessoa, pessoa.nome, pessoa.dataNasc, pessoa.Nacionalidade, musica.tipoAut,  count(distinct recurso.Titulo) as quantidade from pessoa, musica, recurso where pessoa.ccPessoa = "+arrayPessoa.get(i)+" and musica.ccPessoa = pessoa.ccPessoa and musica.NumeroRecurso = recurso.NumeroRecurso group by tipoAut)";
				sqlNova += "UNION (select pessoa.ccPessoa, pessoa.nome, pessoa.dataNasc, pessoa.Nacionalidade, fotografia.tipoAut,  count(distinct recurso.Titulo) as quantidade from pessoa, fotografia, recurso where pessoa.ccPessoa = "+arrayPessoa.get(i)+" and fotografia.ccPessoa = pessoa.ccPessoa and fotografia.NumeroRecurso = recurso.NumeroRecurso group by tipoAut)";
				sqlNova += "UNION (select pessoa.ccPessoa, pessoa.nome, pessoa.dataNasc, pessoa.Nacionalidade, poema.tipoAut,  count(distinct recurso.Titulo) as quantidade from pessoa, poema, recurso where pessoa.ccPessoa = "+arrayPessoa.get(i)+" and poema.ccPessoa = pessoa.ccPessoa and poema.NumeroRecurso = recurso.NumeroRecurso group by tipoAut)";
				
				
			}
			
			sqlNova += "order by ccPessoa;";
			System.out.println(sqlNova);
			ResultSet resultNova = manipula.getResultado(sqlNova);
			
			ArrayList<String[]> arrayNovo = new ArrayList<String[]>();
			int counterNovo = 0;
			while(resultNova.next()){
				String[] arrayNormal = new String[6];
				
				arrayNormal[0] = resultNova.getString("ccPessoa");
				arrayNormal[1] = resultNova.getString("nome");
				arrayNormal[2] = resultNova.getString("dataNasc");
				arrayNormal[3] = resultNova.getString("Nacionalidade");
				arrayNormal[4] = resultNova.getString("tipoAut");
				arrayNormal[5] = resultNova.getString("quantidade");
				
				arrayNovo.add(counterNovo, arrayNormal);
				counterNovo++;
			}
			
			
		%>	
		
		<%for(int x = 0; x < arrayNovo.size(); x++){ %>
			<tr>
				<td><%=arrayNovo.get(x)[0] %></td>
				<td><%=arrayNovo.get(x)[1] %></td>
				<td><%=arrayNovo.get(x)[2] %></td>
				<td><%=arrayNovo.get(x)[3] %></td>
				<td><%=arrayNovo.get(x)[4] %></td>
				<td><%=arrayNovo.get(x)[5] %></td>
			</tr>
		<%} %>
		
	</table>

</body>
</html>