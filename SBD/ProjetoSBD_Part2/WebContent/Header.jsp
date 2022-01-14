<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Configura" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Language" content="pt">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<title>SBD tp2</title>

</head>
<style>


* {
  box-sizing: border-box;
}

body {
  font: 16px Arial;  
}

/*the container must be positioned relative:*/
.autocomplete {
  position: relative;
  display: inline-block;
}

input {
  border: 1px solid transparent;
  background-color: #f1f1f1;
  padding: 10px;
  font-size: 16px;
}

input[type=text] {
  background-color: #f1f1f1;
  width: 100%;
}

input[type=submit] {
  background-color: green;
  color: #fff;
  cursor: pointer;
}

.autocomplete-items {
  position: absolute;
  border: 1px solid #d4d4d4;
  border-bottom: none;
  border-top: none;
  z-index: 99;
  top: 100%;
  left: 0;
  right: 0;
}

.autocomplete-items div {
  padding: 10px;
  cursor: pointer;
  background-color: #fff; 
  border-bottom: 1px solid #d4d4d4; 
}


.autocomplete-items div:hover {
  background-color: #e9e9e9; 
}


.autocomplete-active {
  background-color: DodgerBlue !important; 
  color: #ffffff; 
}

table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
}

th, td {
	padding: 5px;
	text-align: center;
}


#title {
	background-color: green;
	color: white;
	padding: 40px;
	text-align: center;
}
body {
  font-family: Arial, Helvetica, sans-serif;
}

.navbar {
  overflow: hidden;
  background-color: #333;
}

.navbar a {
  float: left;
  font-size: 16px;
  color: white;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
}

.dropdown {
  float: left;
  overflow: hidden;
}

.dropdown .dropbtn {
  font-size: 16px;  
  border: none;
  outline: none;
  color: white;
  padding: 14px 16px;
  background-color: #333;
  font-family: inherit;
  margin: 0;
}

.navbar a:hover, .dropdown:hover .dropbtn {
  background-color: #c9c9c9;
  color: black;
}

.dropdown-content {
  display: none;
  position: absolute;
  background-color: #f9f9f9;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
}

.dropdown-content a {
  float: none;
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
  text-align: left;
}

.dropdown-content a:hover {
  background-color: #ddd;
}

.dropdown:hover .dropdown-content {
  display: block;
}

#first {
	background-color: green;
	color: white;
}

.secondnav {
	width: 100%;
	height: 45px;
	padding: 0 50px;
	background: #333;
	
}

.secondnav ul {
	width: 100%;
	height: 45px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	list-style-type: none;
}

.secondnav ul li a{
	text-transform: uppercase;
	letter-spacing: 2px;
	text-decoration:none;
	color: white;
}

.secondnav ul li:hover a{
	background: #c9c9c9;
	color: black;
}




</style>
<% 
String utilizador = request.getParameter("util"); 
String tipo = request.getParameter("tipo"); 


%>

<div class="navbar">

  
  <%
  if(utilizador == null){
	  %>
	  <a id="first" href="login.jsp">Login</a>
	  
	  <% 
  }else{
	  %>
	  <a id="first" href="index.jsp?nomeUtil=<%=utilizador %>&tipo=<%=tipo%>">Inicio</a>
	  <div class="dropdown">
	    <button class="dropbtn">Recursos 
	      <i class="fa fa-caret-down"></i>
	    </button>
	    <div class="dropdown-content">
	      <a href="TabelasInformacoes.jsp?util=<%=utilizador %>&tipo=<%=tipo%>">N Recursos</a>
	      <a href="AutoresFilmesAssociados.jsp?nomeUtil=<%=utilizador %>&tipo=<%=tipo%>">Listagem Autor</a>
	      <a href="index.jsp?nomeUtil=<%=utilizador %>&tipo=<%=tipo%>">Faixa Etaria/Palavra</a>
	    </div>
	  </div> 
	  <%if(!tipo.equals("1")){
		  %>
		 	 <a href="RecursosUser.jsp?nomeUtil=<%=utilizador%>&tipo=<%=tipo%>">Gestao</a>
		  <% 
	  }
	  if(!tipo.equals("1") && !tipo.equals("2")){
		  %>
		 	
		 	 <div class="dropdown">
			    <button class="dropbtn">Admnistracao 
			      <i class="fa fa-caret-down"></i>
			    </button>
			    <div class="dropdown-content">
			      <a href="AssociarRecursos.jsp?util=<%=utilizador %>&tipo=<%=tipo%>">Associar</a>
			      <a href="GerirRecursos.jsp?nomeUtil=<%=utilizador%>&tipo=<%=tipo%>">Gerir Recursos</a>
			      <a href="GerirUsers.jsp?nomeUtil=<%=utilizador%>&tipo=<%=tipo%>">Gerir Utilizadores</a>
			      <a href="ListarUsers.jsp?nomeUtil=<%=utilizador%>&tipo=<%=tipo%>">Listar Utilizadores</a>
			      <a href="ListarPessoas.jsp?nomeUtil=<%=utilizador%>&tipo=<%=tipo%>">Listar Pessoas</a>
			      <a href="AssumirPapel.jsp?nomeUtil=<%=utilizador%>&tipo=<%=tipo%>">Assumir Utilizadores</a>
			    </div>
			  </div>
		  <% 
	  }
  }
  
 if(utilizador == null){%>
		<a style="float:right;">Iniciar Sessao</a>
		<% 
  }else{
	  if(tipo.equals("3") && !utilizador.equals("admin")){
		  %>
		 	<a id="first" href="AssumirPapel.jsp?nomeUtil=admin&tipo=3" style="float:right;">Voltar Admin</a>
			<a style="float:right;"><%= utilizador %> (admin)</a>
			
			<% 
	  }else {
		  
		  
			%>
		 	<a id="first" href="login.jsp" style="float:right;">Logout</a>
			<a style="float:right;"><%= utilizador %></a>
			
			<% 
			
	  }
  }
   %>
</div>
