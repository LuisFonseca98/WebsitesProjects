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
	sql1 = "select ccPessoa, NomeUtilizador, Bloquear from utilizador where ccPessoa != 1111111 and ccPessoa != 9999999;";
	
	ResultSet result = manipula.getResultado(sql1);
	
	int counter=0;
	
	ArrayList<String[]> arrayBloquear = new ArrayList<String[]>();
	
	while(result.next()){
		String[] arrayNormal = new String[3];
		
		arrayNormal[0] = result.getString("NomeUtilizador");
		arrayNormal[1] = result.getString("ccPessoa");
		arrayNormal[2] = result.getString("Bloquear");
	
		arrayBloquear.add(counter, arrayNormal);
		counter++;
		
	}
	
	if(request.getParameterValues("letsgo") != null){
		for(int i = 0; i < request.getParameterValues("letsgo").length; i++){
			int valor = Integer.parseInt(request.getParameterValues("letsgo")[i]);
			String sqlAltera = "";
			if(arrayBloquear.get(valor)[2].equals("0")){
				sqlAltera = "UPDATE utilizador SET Bloquear=1 WHERE utilizador.NomeUtilizador= '"+arrayBloquear.get(valor)[0]+"';";
			}else if(arrayBloquear.get(valor)[2].equals("1")){
				sqlAltera = "UPDATE utilizador SET Bloquear=0 WHERE utilizador.NomeUtilizador= '"+arrayBloquear.get(valor)[0]+"';";
			}
			
			if(!manipula.xDirectiva(sqlAltera)){
				System.out.println("Erro1");
			}
		}
		
		
		ResultSet resultRefresh = manipula.getResultado(sql1);
		
		int counterRefresh=0;
		
		arrayBloquear.clear();
		
		while(resultRefresh.next()){
			String[] arrayNormal = new String[3];
			
			arrayNormal[0] = resultRefresh.getString("NomeUtilizador");
			arrayNormal[1] = resultRefresh.getString("ccPessoa");
			arrayNormal[2] = resultRefresh.getString("Bloquear");
			
			arrayBloquear.add(counterRefresh, arrayNormal);
			counterRefresh++;
			
		}
		
		
	}
	
%>

<h1>Gerir Utilizadores</h1>

	<hr>

	<table style="width: 100%">
		<tr id="title">
			<th>CC Pessoa</th>
			<th>Nome Utilizador</th>
			<th>Bloquear</th>
			<th>Desbloquear</th>
		</tr>
		
			<%for(int i=0; i < arrayBloquear.size(); i++){ 
			%>
					<tr>
						<td><%=arrayBloquear.get(i)[1] %></td>
						<td><%=arrayBloquear.get(i)[0] %></td>
						<% if(arrayBloquear.get(i)[2].equals("0")){ %>
						
							<td><input id="check" name="check" type="checkbox" value="<%=i%>"></td>
							<td></td>
						<%}else{ %>
							<td></td>
							<td><input id="check" name="check" type="checkbox" value="<%=i%>"></td>	
						<%} %>
					</tr>
			<%}
			%>
		
		
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
	var checkado = false;
	var fields = document.getElementsByName("check");
	for(var i = 0; i < fields.length; i++) {
	    values.push(fields[i].checked);
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
