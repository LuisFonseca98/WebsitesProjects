<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>

<% 
String utilizador = request.getParameter("nomeUtil"); 
String tipo = request.getParameter("tipo");
%>


<jsp:include page="Header.jsp?util=<%= utilizador %>" flush="true">
    <jsp:param name="util" value="<%= utilizador %>"/>
</jsp:include>


<body>


	<h1>Atributos dos Utilizadores</h1>
	<hr>

	<table style="width: 100%">
		<tr id="title">
			<th>CC Pessoa</th>
			<th>Pessoa</th>
			<th>Nome Utilizador</th>
			<th>dataNasc</th>
			<th>Nacionalidade</th>
			<th>Reputacao </th>
			<th>Quantidade Recursos </th>
			<th>Bloqueado </th>
		</tr>
			<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "select NomeUtilizador from utilizador;";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			
			int counter = 0;
			
			
			ArrayList<String> arrayUtilizadores = new ArrayList<String>(); 

			while(result.next()){
				
				arrayUtilizadores.add(counter, result.getString("NomeUtilizador"));
				counter++;
			}
			
			String sqlFinal = "";
			
			for(int i=0; i<arrayUtilizadores.size(); i++){
				if(i == 0){
					sqlFinal = "(select pessoa.ccPessoa, pessoa.nome, utilizador.NomeUtilizador, pessoa.dataNasc, pessoa.Nacionalidade, round(avg(recurso.Pontos),1) as MediaPontos, count(recurso.NomeUtilizador) as QuantidadeRecursos, utilizador.Bloquear from recurso, utilizador, pessoa where recurso.NomeUtilizador = '"+arrayUtilizadores.get(i)+"' and recurso.NomeUtilizador = utilizador.NomeUtilizador and utilizador.ccPessoa = pessoa.ccPessoa)";					
				}else{
					sqlFinal += "UNION (select pessoa.ccPessoa, pessoa.nome, utilizador.NomeUtilizador, pessoa.dataNasc, pessoa.Nacionalidade, round(avg(recurso.Pontos),1) as MediaPontos, count(recurso.NomeUtilizador) as QuantidadeRecursos, utilizador.Bloquear from recurso, utilizador, pessoa where recurso.NomeUtilizador = '"+arrayUtilizadores.get(i)+"' and recurso.NomeUtilizador = utilizador.NomeUtilizador and utilizador.ccPessoa = pessoa.ccPessoa)";
				}
			
			}
			sqlFinal += "order by MediaPontos;";
			
			ResultSet resultFinal = manipula.getResultado(sqlFinal);
			
			
			int counterFinal = 0;
			
			
			ArrayList<String[]> arrayFinal = new ArrayList<String[]>(); 

			while(resultFinal.next()){
				String[] arrayNormal = new String[8];
				
				arrayNormal[0] = resultFinal.getString("ccPessoa");
				arrayNormal[1] = resultFinal.getString("nome");
				arrayNormal[2] = resultFinal.getString("NomeUtilizador");
				arrayNormal[3] = resultFinal.getString("dataNasc");
				arrayNormal[4] = resultFinal.getString("Nacionalidade");
				arrayNormal[5] = resultFinal.getString("MediaPontos");
				arrayNormal[6] = resultFinal.getString("QuantidadeRecursos");
				arrayNormal[7] = resultFinal.getString("Bloquear");
				
				arrayFinal.add(counterFinal, arrayNormal);
				counterFinal++;
			}
			
			%>
			
		     
		     
			<% 
			
				
			for(int i = 0; i < arrayFinal.size(); i++){
				if(arrayFinal.get(i)[0] != null){
					%>
						<tr>
							<td><%= arrayFinal.get(i)[0]  %></td>
							<td><%= arrayFinal.get(i)[1]  %></td>
							<td><%= arrayFinal.get(i)[2]  %></td>
							<td><%= arrayFinal.get(i)[3]  %></td>
							<td><%= arrayFinal.get(i)[4]  %></td>
							<td><%= arrayFinal.get(i)[5]  %></td>
							<td><%= arrayFinal.get(i)[6]  %></td>
							<%if(arrayFinal.get(i)[7].equals("0")){ %>
								<td> Esta Desbloqueado </td>
							<%}else { %>
								<td> Esta Bloqueado </td>
							<%} %>
						</tr>
						
					<% 
						
				}
			}
			
			
			
		%>	
	</table>

<br>
<br>
<br>
<br>
<br>

<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>