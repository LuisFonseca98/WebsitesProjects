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

<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql1;
			sql1 = "SELECT associacao.NumeroRecursoA1, recurso.Tipo as Tipo1, recurso.Titulo as Titulo1 from associacao, recurso where associacao.NumeroRecursoA1 = recurso.NumeroRecurso;";
	
			ResultSet result1 = manipula.getResultado(sql1);
			
			int counter1=0;
			
			ArrayList<String[]> arrayA1 = new ArrayList<String[]>();
			
			while(result1.next()){
				String[] arrayNormal = new String[3];
				
				arrayNormal[0] = result1.getString("NumeroRecursoA1");
				arrayNormal[1] = result1.getString("Tipo1");
				arrayNormal[2] = result1.getString("Titulo1");
				
				arrayA1.add(counter1, arrayNormal);
				counter1++;
				
			}
			
			String sql2;
			sql2 = "SELECT associacao.NumeroRecursoA2, recurso.Tipo as Tipo2, recurso.Titulo as Titulo2 from associacao, recurso where associacao.NumeroRecursoA2 = recurso.NumeroRecurso;";
	
			ResultSet result2 = manipula.getResultado(sql2);
			

			int counter2=0;
			
			ArrayList<String[]> arrayA2 = new ArrayList<String[]>();
			
			while(result2.next()){
				String[] arrayNormal = new String[3];
				
				arrayNormal[0] = result2.getString("NumeroRecursoA2");
				arrayNormal[1] = result2.getString("Tipo2");
				arrayNormal[2] = result2.getString("Titulo2");
				
				arrayA2.add(counter2, arrayNormal);
				counter2++;
				
			}
			
			String sql3;
			sql3 = "SELECT Titulo, NumeroRecurso from recurso order by Titulo;";
	
			ResultSet result3 = manipula.getResultado(sql3);
			

			int counter3=0;
			
			ArrayList<String[]> arrayTit = new ArrayList<String[]>();
			
			while(result3.next()){
				String[] arrayNormal = new String[2];
				
				arrayNormal[0] = result3.getString("Titulo");
				arrayNormal[1] = result3.getString("NumeroRecurso");
				
				arrayTit.add(counter3, arrayNormal);
				
				counter3++;
				
			}
			
			
			String associar1 = request.getParameter("assoc1");
			String associar2 = request.getParameter("assoc2");
			System.out.println(associar1);
			System.out.println(associar2);
			
			if(associar1 != null && associar2 != null){
				String slqAssociar = "insert into associacao values("+arrayTit.get(Integer.parseInt(associar1))[1]+","+arrayTit.get(Integer.parseInt(associar2))[1]+");";
				if(!manipula.xDirectiva(slqAssociar)){
					System.out.println("Erro1");
				}
				
				ResultSet resultA1Refresh = manipula.getResultado(sql1);
				
				int counterA1Refresh=0;
				
				arrayA1.clear();
				
				while(resultA1Refresh.next()){
					String[] arrayNormal = new String[3];
					
					arrayNormal[0] = resultA1Refresh.getString("NumeroRecursoA1");
					arrayNormal[1] = resultA1Refresh.getString("Tipo1");
					arrayNormal[2] = resultA1Refresh.getString("Titulo1");
					
					arrayA1.add(counterA1Refresh, arrayNormal);
					counterA1Refresh++;
					
				}
				
				ResultSet resultA2Refresh = manipula.getResultado(sql2);
				

				int counterA2Refresh=0;
				
				arrayA2.clear();
				
				while(resultA2Refresh.next()){
					String[] arrayNormal = new String[3];
					
					arrayNormal[0] = resultA2Refresh.getString("NumeroRecursoA2");
					arrayNormal[1] = resultA2Refresh.getString("Tipo2");
					arrayNormal[2] = resultA2Refresh.getString("Titulo2");
					
					arrayA2.add(counterA2Refresh, arrayNormal);
					counterA2Refresh++;
					
				}
			}
				
			
%>

<h1>Associar Recursos</h1>

	<hr>

	<table style="width: 100%">
		<tr id="title">
			<th>Tipo</th>
			<th>Titulo</th>
			<th>Associado a</th>
			<th>Tipo</th>
			<th>Titulo</th>
		</tr>
		
			<%for(int i=0; i < arrayA1.size(); i++){ %>
				<tr>
					<td><%=arrayA1.get(i)[1] %></td>
					<td><a href="recursos.jsp?recursotitulo=<%=arrayA1.get(i)[2]%>&util=<%= utilizador %>&tipo=<%=tipo%>"><%=arrayA1.get(i)[2] %></a></td>
					<td style="text-align: center;">&#8594;</td>
					<td><%=arrayA2.get(i)[1] %></td>
					<td><a href="recursos.jsp?recursotitulo=<%=arrayA2.get(i)[2]%>&util=<%= utilizador %>&tipo=<%=tipo%>"><%=arrayA2.get(i)[2] %></a></td>
				</tr>
			<%} %>
		
		
	</table>
	
	
<form id="formAssoc" method="POST" onsubmit="return associar()">
	<p>Indique o primeiro recurso que deseja associar:</p>
	<select id="assoc1" name="assoc1" size="10">
	<%for(int i=0; i < arrayTit.size(); i++){ %>
		<option value ="<%=i%>"><%=arrayTit.get(i)[0] %></option>
	<%} %>
	</select> 
	<br>
	<br>
	<p>Indique o segundo recurso que deseja associar:</p>
	<select id="assoc2" name="assoc2" size="10">
	<%for(int i=0; i < arrayTit.size(); i++){ %>
		<option value ="<%=i%>"><%=arrayTit.get(i)[0] %></option>
	<%} %>
	</select> 
	<br>
	<br>
	<p><input type="submit" value="Associar"></p>
</form>
<br>
<br>
<br>
<br>
<br>
<br>

<script type="text/javascript">
function associar(){
	var assoc1 = document.getElementById("assoc1").value;
	var assoc2 = document.getElementById("assoc2").value;
	console.log(assoc1);
	console.log(assoc2);
	if(assoc1 != assoc2){
		
		alert("Realizou a associacao com sucesso!");
		return true;
	}else{
		alert("Nao pode associar recursos iguais!");
		return false;
	}
}

</script>

<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>
