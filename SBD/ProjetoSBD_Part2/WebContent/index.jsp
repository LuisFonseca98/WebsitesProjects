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
			HttpSession sessions = request.getSession(true);
			
			String sql;
			sql = "select recurso.Titulo, recurso.FaixaEtar, recurso.Tipo from recurso order by recurso.FaixaEtar;";
		
			System.out.println(sql);
			
			ResultSet result = manipula.getResultado(sql);
			
			ArrayList<String> arrayFaixa = new ArrayList<String>();
	 	 	ArrayList<String[]> arrayGeral = new ArrayList<String[]>();
	 	 	int counter = 0;
	 	 	
			while(result.next()){
				String[] arrayFaixaEtar = new String[3];
				String faixaEtar = result.getString("FaixaEtar");
				
				arrayFaixaEtar[0] = faixaEtar;
				arrayFaixaEtar[1] = result.getString("Titulo");
				arrayFaixaEtar[2] = result.getString("Tipo");
				
				arrayFaixa.add(counter, faixaEtar);
				
				arrayGeral.add(counter, arrayFaixaEtar);
				
				counter++;
			}
			
		
			
	%>

	<h1>SBD - Tp2</h1>
	<hr/>
	<h2>Indique: uma palavra com relevancia e/ou faixa etaria</h2>
	<form autocomplete="off" method="POST">
	  <label for="fname">Indique uma palavra relevante para procurar:</label>
	  
	  <div class="autocomplete" style="width:300px;">
	  
       <input id="myInput" type="text" name="myCountry" placeholder="Recurso">
      </div>
 	  
	  <br/>
	  <br/>
	  <label for="idades">Escolha a faixa etária:</label>
	  <select name="idades" id="idades">
	  
	  <% 

			Set<String> listWithoutDuplicates = new LinkedHashSet<String>(arrayFaixa);
	 	 	arrayFaixa.clear();

	  		arrayFaixa.addAll(listWithoutDuplicates);
			
			for(int i = 0; i < arrayFaixa.size(); i++){
				
				%>
				<option type="number" id="faixaEtar" value="<%= arrayFaixa.get(i) %>"><%= arrayFaixa.get(i) %></option>

				<%
			}
			
		%>	
		
		
	  </select>
	   <br/>
	    <br/>
	  <div style="padding-left:10px">
	 	 <input   type="submit" value="Procurar">
	 </div>
	</form>
	
	
	
	<hr/>
	
	
	
	<table style="width: 100%">
		<tr id="title">
			<th>Tipo do Recurso</th>
			<th>Titulo</th>
			<th>Faixa Etaria</th>
		</tr>

	<%
		boolean encontrar = false;
		String passar = "";
	
		for(int i = 0; i < arrayGeral.size(); i++){
			if(request.getParameter("myCountry") != null){
				if(arrayGeral.get(i)[1].equals(request.getParameter("myCountry"))){
					if(arrayGeral.get(i)[0].equals(request.getParameter("idades"))){
						passar = arrayGeral.get(i)[1];
						%>
						
							
							<tr>
								<td><%= arrayGeral.get(i)[2]  %></td>
								<td ><a href="recursos.jsp?recursotitulo=<%=passar%>&util=<%= utilizador %>&tipo=<%=tipo%>"><%= passar  %> </a></td>
								<td><%= arrayGeral.get(i)[0] %></td>
		
							</tr>
							
						
						<%
						
						encontrar = true;
					}
					
				}else if(request.getParameter("myCountry").equals("")){
					if(arrayGeral.get(i)[0].equals(request.getParameter("idades"))){
						passar = arrayGeral.get(i)[1];
						%>
						
						
						<tr>
							<td><%= arrayGeral.get(i)[2]  %></td>
							<td><a href="recursos.jsp?recursotitulo=<%=passar%>&util=<%= utilizador %>&tipo=<%=tipo%>"><%= passar %> </a></td>
							<td><%= arrayGeral.get(i)[0] %></td>
		
						</tr>
						
					
						<%
						
						encontrar = true;
					}
					
				}
				
			}else{
				encontrar = true;
			}
		}
		
		if(!encontrar){
			String txt = "Nao foi encontrado nenhum recurso com o nome "+request.getParameter("myCountry")+" e com a faixa etaria "+request.getParameter("idades");
			%>
			<h3><%= txt %></h3>
			<%
		}
		
		
		
		
	%>
	</table>
	


<script>




function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
          b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
              closeAllLists();
          });
          a.appendChild(b);
        }
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }
  /*execute a function when someone clicks in the document:*/
  document.addEventListener("click", function (e) {
      closeAllLists(e.target);
  });
}

/*An array containing all the country names in the world:*/
 



var recursos = [];

<%for(int i = 0; i < arrayGeral.size(); i++){%>
	recursos[<%=i%>] = "<%=arrayGeral.get(i)[1]%>";
<%}%>

/*initiate the autocomplete function on the "myInput" element, and pass along the countries array as possible autocomplete values:*/
autocomplete(document.getElementById("myInput"), recursos);
</script>
<br>
<br>
<br>
<br>
<br>
<jsp:include page="Footer.jsp" flush="true">
    <jsp:param name="pageTitle" value="pageValue"/>
</jsp:include>