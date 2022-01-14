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

if(request.getParameter("assumir") != null){
	System.out.println(request.getParameter("assumir"));
	utilizador = request.getParameter("assumir");
}
%>


<jsp:include page="Header.jsp?util=<%= utilizador %>" flush="true">
    <jsp:param name="util" value="<%= utilizador %>"/>
</jsp:include>

<body>


	<h1>Assumir papel de um Utilizador registado</h1>

	<hr>
		<h3>Selecione o Utilizador que deseja assumir:</h3>	
		<br>
			<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "select NomeUtilizador from utilizador where NomeUtilizador != 'convidado' and NomeUtilizador != 'admin';";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			ArrayList<String> arrayUtilizadores = new ArrayList<String>();
			int counter = 0;
			while(result.next()){
				
				arrayUtilizadores.add(counter, result.getString("NomeUtilizador"));
				counter++;
			}
			
			
			
		%>	
		
		
	<form id="formAssum" method="POST" >	
		<select id="assumir" name="assumir" size="9">
			<%for(int i=0; i < arrayUtilizadores.size(); i++){ %>
				<option value ="<%=arrayUtilizadores.get(i) %>"><%=arrayUtilizadores.get(i) %></option>
			<%} %>
		</select> 
		<br>
		<br>
		
		<input type="submit" value="Assumir">
	</form>
	<hr>
<br>
<br>
<br>
<br>
<br>
<br>
<script type="text/javascript">

</script>

<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>