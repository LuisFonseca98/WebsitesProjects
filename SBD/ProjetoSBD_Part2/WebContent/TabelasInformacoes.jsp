<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>

<% 
String utilizador = request.getParameter("util"); 
String tipo = request.getParameter("tipo");
%>


<jsp:include page="Header.jsp?util=<%= utilizador %>" flush="true">
    <jsp:param name="util" value="<%= utilizador %>"/>
</jsp:include>



<body>


	<h1>Listar os N recursos mais recentes ordenados pela classificação</h1>
	<hr>
	<br>

	<table style="width: 100%">
		<tr id="title">
			<th>Título</th>
			<th>Tipo</th>
			<th>Data</th>
			<th>Classificacao</th>
			<th>Bloqueado</th>
		</tr>
			<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "select Tipo, Titulo, DataHoraCarr, round(avg(distinct classificacao.NotaClass), 1) as mediaClass, Bloquear from recurso, classificacao where recurso.NumeroRecurso = classificacao.NumeroRecurso group by Titulo order by DataHoraCarr desc;";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			
			int counter = 0;
			
			
			ArrayList<String[]> arrayFinal = new ArrayList<String[]>(); 

			while(result.next()){
				String[] arrayNormal = new String[5];
				String bloqueio = "";
				if(Integer.parseInt(result.getString("Bloquear"))== 0){
					bloqueio = "Nao esta";
				}else{
					bloqueio = "Esta";
				}
				
				arrayNormal[0] = result.getString("Titulo");
				arrayNormal[1] = result.getString("Tipo");
				arrayNormal[2] = result.getString("DataHoraCarr");
				arrayNormal[3] = result.getString("mediaClass");
				arrayNormal[4] = bloqueio;
				
				arrayFinal.add(counter, arrayNormal);
				
			
				
				
				counter++;
			}
			
			%>
			<form method="POST">
			  
			  <label for="quantity">Escolha o numero dos recursos a apresentar, por ordem cronologica:</label>
			  <input type="number" id="quantity" name="quantity" min="1" max="<%= counter%>"><br><br>
			
			  <input type="submit" value="Procurar">
			</form>
			<br>
			<hr>
		     
		     
			<% 
			
			System.out.println(request.getParameter("quantity"));
			
			String parametro = request.getParameter("quantity");
			
			if(parametro == null || parametro == ""){
				%>
				<h1>Escolha o numero de recursos</h1>
				<% 
			}else{
				arrayFinal.subList(Integer.parseInt(parametro), arrayFinal.size()).clear();
				Collections.sort(arrayFinal, new Comparator<String[]>() {
				    public int compare(String[] a, String[] b) {
				        return (a[a.length-2]).compareTo(b[b.length-2]);
				    }
				});
				
				for(int i = 0; i < Integer.parseInt(parametro); i++){
					
					%>
						<tr>
							<td><a href="recursos.jsp?recursotitulo=<%=arrayFinal.get(i)[0]%>&util=<%= utilizador %>&tipo=<%=tipo%>"><%= arrayFinal.get(i)[0] %></a></td>
							<td><%= arrayFinal.get(i)[1]  %></td>
							<td><%= arrayFinal.get(i)[2]  %></td>
							<td><%= arrayFinal.get(i)[3]  %></td>
							<td><%= arrayFinal.get(i)[4]  %></td>
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
<br>
<br>

<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>