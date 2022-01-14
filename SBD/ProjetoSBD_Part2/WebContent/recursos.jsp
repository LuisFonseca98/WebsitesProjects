<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Configura" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>


<%
String utilizador = request.getParameter("util"); 
String tipo = request.getParameter("tipo");
String recursoTit = request.getParameter("recursotitulo");
%>

<jsp:include page="Header.jsp?util=<%= utilizador %>" flush="true">
    <jsp:param name="util" value="<%= utilizador %>"/>
</jsp:include>

<body>
		<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "select Tipo, NumeroRecurso from recurso where recurso.Titulo='"+recursoTit+"';";
	
			ResultSet result = manipula.getResultado(sql);
			
			

			
			
			
			String tipoRecurso = "";
			String recursoID = "";

			while(result.next()){
				
				
				tipoRecurso = result.getString("Tipo");
				recursoID = result.getString("NumeroRecurso");
				
				
				
			}
			
			
			
			if(tipoRecurso.equals("Poema")){
				
				%>
				<jsp:include page="poemas.jsp" flush="true">
			    	<jsp:param name="recursoID" value="<%= recursoID %>"/>
				</jsp:include>
				<%
			}else if(tipoRecurso.equals("Filme")){
				%>
				<jsp:include page="filmes.jsp" flush="true">
			    	<jsp:param name="recursoID" value="<%= recursoID %>"/>
				</jsp:include>
				<%
			}else if(tipoRecurso.equals("Fotografia")){
				%>
				<jsp:include page="fotografias.jsp" flush="true">
			    	<jsp:param name="recursoID" value="<%= recursoID %>"/>
				</jsp:include>
				<%
			}else if(tipoRecurso.equals("Musica")){
				%>
				<jsp:include page="musicas.jsp" flush="true">
			    	<jsp:param name="recursoID" value="<%= recursoID %>"/>
				</jsp:include>
				<%
			}
			
			%>






<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>