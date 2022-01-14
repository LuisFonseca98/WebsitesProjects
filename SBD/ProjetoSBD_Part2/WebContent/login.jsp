<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Configura" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>



<jsp:include page="Header.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>


<body>


<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			
		
			
			String sql;
			sql = "select NomeUtilizador, Bloquear from utilizador;";
	
			ResultSet result = manipula.getResultado(sql);
			
			
			int counter = 0;
			
	
			ArrayList<String[]> arrayNome = new ArrayList<String[]>();
			

			while(result.next()){
				String[] arrayNormal = new String[2];
				
				arrayNormal[0] = result.getString("NomeUtilizador");
				arrayNormal[1] = result.getString("Bloquear");
				
				arrayNome.add(counter, arrayNormal);
				counter++;
			}
			
	%>

 			<div >
                <h1 >
                  	Efectuar Login
                </h1>
                <p >Insira as suas credenciais e efectue login</p>
                	
                	<form id="form1" method = "POST" onsubmit="return valida_login()">
						
						 <label>
						 Nome de Utilizador: <input id="nome" type="text" size="30" name="nome"><br><br>
						 </label>
						 <br>
						 <br>
						<input type="submit" value="Submeter">
						
					</form>
                
            </div>

<script type="text/javascript">

  
 function valida_login() {
	 
	 var users = [<% for (int i = 0; i < arrayNome.size(); i++) { %>"<%= arrayNome.get(i)[0] %>"<%= i + 1 < arrayNome.size() ? ",":"" %><% } %>]; 
	 var tipo = "";
	 var bloquear = [<% for (int i = 0; i < arrayNome.size(); i++) { %>"<%= arrayNome.get(i)[1] %>"<%= i + 1 < arrayNome.size() ? ",":"" %><% } %>]; 
	 
	 
	 
	 let nome = document.getElementById("nome").value;
	 let nomeTrim = nome.trim();
	 let nomeFinish = nomeTrim.split(' ').join('');
	 if(nomeFinish !== nome){
		 alert("O nome nao pode ter espaços");
		 return false;
	 }
	 if ( nome === null || nome === "" ) {
		 
		tipo = "1";
		nome = "convidado";
	 }
	 
	 for(i = 0; i < users.length; i++){
		 
		 if(nome === users[i]){
			 if(bloquear[i] === "0"){
				 
				 if(users[i] === "convidado"){
					 tipo = "1";
				 }else if(users[i] === "admin"){
					 tipo = "3";
				 }else{
					 tipo = "2";
				 }
				 document.getElementById('form1').action = "index.jsp?nomeUtil="+nome+"&tipo="+tipo+""; 
				 return true;
				 
			 }else{
				 alert("Este utilizador encontra-se bloqueado!");
				 return false;
			 }
		 }
	 }
	 
	 alert("O nome de utilizador inserido nao existe!");
	 return false;
 }
 

 
 </script> 

</body>

</html>