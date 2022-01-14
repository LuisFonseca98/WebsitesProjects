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

<%
	Configura cfg = new Configura();
	util.Manipula manipula = new util.Manipula(cfg);
	
	
	
	String sql1;
	sql1 = "select recurso.Tipo, recurso.Titulo, utilizador.NomeUtilizador, recurso.Bloquear, recurso.NumeroRecurso, recurso.Pontos from recurso, utilizador where recurso.NomeUtilizador = utilizador.NomeUtilizador order by recurso.Titulo;";
	
	ResultSet result = manipula.getResultado(sql1);
	
	int counter=0;
	
	ArrayList<String[]> arrayBloquear = new ArrayList<String[]>();
	
	while(result.next()){
		String[] arrayNormal = new String[6];
		
		arrayNormal[0] = result.getString("Tipo");
		arrayNormal[1] = result.getString("Titulo");
		arrayNormal[2] = result.getString("NomeUtilizador");
		arrayNormal[3] = result.getString("Bloquear");
		arrayNormal[4] = result.getString("NumeroRecurso");
		arrayNormal[5] = result.getString("Pontos");
		
		arrayBloquear.add(counter, arrayNormal);
		counter++;
		
	}
	
	
	
	
	if(request.getParameterValues("letsgo") != null || request.getParameterValues("pontos") != null){
		if(request.getParameterValues("letsgo") != null){
			for(int i = 0; i < request.getParameterValues("letsgo").length; i++){
				int valor = Integer.parseInt(request.getParameterValues("letsgo")[i]);
				String sqlAltera = "";
				if(arrayBloquear.get(valor)[3].equals("0")){
					sqlAltera = "UPDATE recurso SET Bloquear=1 WHERE recurso.NumeroRecurso= "+arrayBloquear.get(valor)[4]+";";
				}else if(arrayBloquear.get(valor)[3].equals("1")){
					sqlAltera = "UPDATE recurso SET Bloquear=0 WHERE recurso.NumeroRecurso= "+arrayBloquear.get(valor)[4]+";";
				}
				
				if(!manipula.xDirectiva(sqlAltera)){
					System.out.println("Erro1");
				}
			}
		}
		
		
		
		if(request.getParameterValues("pontos") != null){
			for(int i = 0; i < request.getParameterValues("pontos").length; i++){
				if(!request.getParameterValues("pontos")[i].equals("null")){
					int valor = Integer.parseInt(request.getParameterValues("pontos")[i]);
					int indice = Integer.parseInt(request.getParameterValues("indice")[i]);
					
					
					String sqlAltera = "UPDATE recurso SET Pontos="+valor+" WHERE recurso.NumeroRecurso= "+arrayBloquear.get(indice)[4]+";";
					System.out.println("Controlo: "+valor+" Array:"+arrayBloquear.get(indice)[4]+" Titulo: "+arrayBloquear.get(indice)[1]);
					
					if(!manipula.xDirectiva(sqlAltera)){
						System.out.println("Erro1");
					}
				}
			}
		}
		
		
		
		ResultSet resultRefresh = manipula.getResultado(sql1);
		
		int counterRefresh=0;
		
		arrayBloquear.clear();
		
		while(resultRefresh.next()){
			String[] arrayNormal = new String[6];
			
			arrayNormal[0] = resultRefresh.getString("Tipo");
			arrayNormal[1] = resultRefresh.getString("Titulo");
			arrayNormal[2] = resultRefresh.getString("NomeUtilizador");
			arrayNormal[3] = resultRefresh.getString("Bloquear");
			arrayNormal[4] = resultRefresh.getString("NumeroRecurso");
			arrayNormal[5] = resultRefresh.getString("Pontos");
			
			arrayBloquear.add(counterRefresh, arrayNormal);
			counterRefresh++;
			
		}
		
		
	}
	
%>

<h1>Gerir Recursos</h1>

	<hr>

	<table style="width: 100%">
		<tr id="title">
			<th>Tipo</th>
			<th>Titulo</th>
			<th>Utilizador</th>
			<th>Bloquear</th>
			<th>Desbloquear</th>
			<th>Reputacao do Utilizador</th>
		</tr>
		
			<%for(int i=0; i < arrayBloquear.size(); i++){ %>
				<tr>
					<td><%=arrayBloquear.get(i)[0] %></td>
					<td><a href="recursos.jsp?recursotitulo=<%=arrayBloquear.get(i)[1] %>&util=<%= utilizador %>&tipo=<%=tipo%>"><%=arrayBloquear.get(i)[1] %></a></td>
					<td><%=arrayBloquear.get(i)[2] %></td>
					<% if(arrayBloquear.get(i)[3].equals("0")){ %>
						<td><input id="check" name="check" type="checkbox" value="<%=i%>"></td>
						<td></td>
					<%}else{ %>
						<td></td>
						<td><input id="check" name="check" type="checkbox" value="<%=i%>"></td>	
					<%} %>
					<td>
						<%=arrayBloquear.get(i)[5] %>
						<select class="drop" name="dropName">
					   		<option id="class1" value="null">N/A</option>
							<option id="class2" value="1">1</option>
							<option id="class3" value="2">2</option>
							<option id="class4" value="3">3</option>
							<option id="class5" value="4">4</option>
							<option id="class6" value="5">5</option>
						</select>
					</td>
				</tr>
			<%} %>
		
		
	</table>
	
	<form style="float:right;" id="formsubmeter" method="POST" onsubmit="return submeter();">
		<p><input type="submit" value="Submeter"></p>
	</form>
<br>
<br>
<br>
<br>
<br>
<br>
<script type="text/javascript">
function submeter(){
	var theForm = document.getElementById("formsubmeter");
	var values = [];
	var valuesPontos = [];
	var checkado = false;
	var fields = document.getElementsByName("check");
	var fieldsPontos = document.getElementsByClassName("drop");
	
	
	for(var i = 0; i < fields.length; i++) {
	    values.push(fields[i].checked);
	}
	
	for(var i = 0; i < fieldsPontos.length; i++) {
		valuesPontos.push(fieldsPontos[i].value);
	}

	for(var i = 0; i < values.length; i++) {
		if(values[i] === true){
			checkado = true;
			var x = document.createElement("INPUT");
		    x.setAttribute("type", "hidden");
		    x.setAttribute("name", "letsgo");
		    x.setAttribute("value", i);
		    theForm.appendChild(x);
		}
	}
	
	for(var i = 0; i < valuesPontos.length; i++) {
		if(valuesPontos[i] !== "null"){
			checkado = true;
			var x = document.createElement("INPUT");
		    x.setAttribute("type", "hidden");
		    x.setAttribute("name", "pontos");
		    x.setAttribute("value", valuesPontos[i]);
		    theForm.appendChild(x);
		    var z = document.createElement("INPUT");
		    z.setAttribute("type", "hidden");
		    z.setAttribute("name", "indice");
		    z.setAttribute("value", i);
		    theForm.appendChild(z);
		    
		}
	}
	
	
	if(checkado){
		return true;
	}else{
		return false;
	}
	
}
</script>



<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>
