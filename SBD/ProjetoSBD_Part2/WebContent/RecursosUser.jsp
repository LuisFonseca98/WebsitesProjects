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
<h2>Pagina de gestao de recursos do utilizador: <%=utilizador %></h2>
<hr>

			<% 
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "SELECT recurso.Titulo, recurso.Tipo, recurso.NumeroRecurso, recurso.Ilustracao from recurso where recurso.NomeUtilizador ='"+utilizador+"';";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			
			int counter = 0;
			
			
			ArrayList<String[]> arrayFinal = new ArrayList<String[]>(); 

			while(result.next()){
				String[] arrayNormal = new String[4];
				
				arrayNormal[0] = result.getString("Titulo");
				arrayNormal[1] = result.getString("Tipo");
				arrayNormal[2] = result.getString("NumeroRecurso");
				arrayNormal[3] = result.getString("Ilustracao");
				
				arrayFinal.add(counter, arrayNormal);
				counter++;
			}
			
			
			
			
			
			System.out.println(Arrays.toString(request.getParameterValues("letsgo")));
			if(request.getParameterValues("letsgo") != null){
				String sqlComent = "SELECT comentario.NumeroRecurso from comentario;";
				
				System.out.println(sqlComent);
				
				ResultSet resultComent = manipula.getResultado(sqlComent);
				
				
				int counterComent = 0;
				
				
				ArrayList<String> arrayComent = new ArrayList<String>(); 

				while(resultComent.next()){
					arrayComent.add(counterComent, resultComent.getString("NumeroRecurso"));
					counterComent++;
				}
				
				String sqlClass = "SELECT classificacao.NumeroRecurso from classificacao;";
				
				System.out.println(sqlClass);
				
				ResultSet resultClass = manipula.getResultado(sqlClass);
				
				
				int counterClass = 0;
				
				
				ArrayList<String> arrayClass = new ArrayList<String>(); 

				while(resultClass.next()){
					arrayClass.add(counterClass, resultClass.getString("NumeroRecurso"));
					counterClass++;
				}
				
				for(int i = 0; i < request.getParameterValues("letsgo").length; i++){
					int valor = Integer.parseInt(request.getParameterValues("letsgo")[i]);
					
					
						
					String sqlElimina3 = "delete from comentario where comentario.NumeroRecurso = "+arrayFinal.get(valor)[2]+";";
					
					if(!manipula.xDirectiva(sqlElimina3)){
						System.out.println("Erro1");
					}
					
					String sqlElimina4 = "delete from classificacao where classificacao.NumeroRecurso = "+arrayFinal.get(valor)[2]+";";
					
					if(!manipula.xDirectiva(sqlElimina4)){
						System.out.println("Erro2");
					}
						
					
					String sqlElimina1 = "delete from "+arrayFinal.get(valor)[1].toLowerCase()+" where "+arrayFinal.get(valor)[1].toLowerCase()+".NumeroRecurso = "+arrayFinal.get(valor)[2]+";";
		
					if(!manipula.xDirectiva(sqlElimina1)){
						System.out.println("Erro3");
					}
					
					String sqlElimina2 = "delete from recurso where recurso.NumeroRecurso = "+arrayFinal.get(valor)[2]+";";
					
					if(!manipula.xDirectiva(sqlElimina2)){
						System.out.println("Erro4");
					}
				}
				
				String sqlReformulado;
				sqlReformulado = "SELECT recurso.Titulo, recurso.Tipo, recurso.NumeroRecurso, recurso.Ilustracao from recurso where recurso.NomeUtilizador ='"+utilizador+"';";
			
				System.out.println(sqlReformulado);
				
				ResultSet resultReformulado = manipula.getResultado(sqlReformulado);
				
				
				int counterReformulado = 0;
				arrayFinal.clear();
				
				while(resultReformulado.next()){
					String[] arrayNormal = new String[4];
					
					arrayNormal[0] = resultReformulado.getString("Titulo");
					arrayNormal[1] = resultReformulado.getString("Tipo");
					arrayNormal[2] = resultReformulado.getString("NumeroRecurso");
					arrayNormal[3] = resultReformulado.getString("Ilustracao");
					
					arrayFinal.add(counterReformulado, arrayNormal);
					counterReformulado++;
				}
				
			}
			
			
			
			%>

<table style="width: 100%">
		<tr id="title">
			<th>Título</th>
			<th>Tipo</th>
			<th>Download</th>
			<th>Upload</th>
			<th>Remover</th>
		</tr>
		
		<%for(int i = 0; i < arrayFinal.size(); i++){%>
		<tr>
			<td><a href="recursos.jsp?recursotitulo=<%= arrayFinal.get(i)[0] %>&util=<%= utilizador %>&tipo=<%=tipo%>"><%= arrayFinal.get(i)[0]  %> </a></td>
			<td><%= arrayFinal.get(i)[1]  %></td>
			<td>
				<form action="downloadServlet">
					<input type="hidden" id="recursoID" name="recursoID" value="<%=arrayFinal.get(i)[2]%>"> 
					<input type="hidden" id="tipo" name="tipo" value="<%=arrayFinal.get(i)[1]%>"> 
					<input type="hidden" id="titulo" name="titulo" value="<%=arrayFinal.get(i)[0]%>"> 
					<input type="hidden" id="utilizador" name="utilizador" value="<%=utilizador%>"> 
					<input type="hidden" id="tipoUser" name="tipoUser" value="<%=tipo%>"> 
					<input onclick="sucesso();" type="submit" value="Download">
				</form>
			</td>
			<%if(arrayFinal.get(i)[3].length() == 0){ %>
				<td>
					<form action="uploadServlet" method="post" enctype="multipart/form-data">
						<input type="hidden" id="recursoID" name="recursoID" value="<%=arrayFinal.get(i)[2]%>"> 
						<input type="hidden" id="tipo" name="tipo" value="<%=arrayFinal.get(i)[1]%>"> 
						<input type="hidden" id="titulo" name="titulo" value="<%=arrayFinal.get(i)[0]%>"> 
						<input type="hidden" id="utilizador" name="utilizador" value="<%=utilizador%>"> 
						<input type="hidden" id="tipoUser" name="tipoUser" value="<%=tipo%>"> 
						<input type="file" id="file" name="file"> 
						<input onclick="sucesso2();" type="submit" value="Upload">
					</form>
				</td>
			<%}else{
				%>
				<td>
					Ja possui recurso
				</td>
			<%
			}%>
			
			<td id="checkboxes">
			
				<input type="checkbox" id="eliminar" name="eliminar" value="<%=i%>">
				
			</td>
			
		</tr>
		<%}%>
			
</table>
<br>
<div>
	
	<form style="float: left;" id="formCriar" method = "POST" onsubmit="return criarRecurso()">
    	<input type="submit" value="Criar Recurso" />
	</form>
	<form style="float: right;" id="formCriar2" method = "POST" onsubmit="return selecione();">
    	<input type="submit" value="Eliminar Recurso(s)" />
	</form>
</div>



<script type="text/javascript">
function sucesso(){
	alert("Download concluido com sucesso para a pasta 'Transferencias'!");
}

function sucesso2(){
	alert("Upload concluido com sucesso!");
}

function selecione(){
	var theForm = document.getElementById("formCriar2");
	var checkado = false;
	var values = [];
	var fields = document.getElementsByName("eliminar");
	for(var i = 0; i < fields.length; i++) {
	    values.push(fields[i].checked);
	}
	console.log(values);
	
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

function criarRecurso(){
	var user = '<%=utilizador%>';
	var tipo = '<%=tipo%>';
	document.getElementById('formCriar').action = "CriarRecursos.jsp?util="+user+"&tipo="+tipo; 
	return true;
}

</script>


<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>