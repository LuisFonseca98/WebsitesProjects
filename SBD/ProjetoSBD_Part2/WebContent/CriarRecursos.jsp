<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Configura" %>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>
<%@ page import="java.text.SimpleDateFormat"%>

<% 
String utilizador = request.getParameter("util");
String tipo = request.getParameter("tipo");
String tipoRecurso = request.getParameter("tipoRecurso");

Configura cfg = new Configura();
util.Manipula manipula = new util.Manipula(cfg);
HttpSession sessions = request.getSession(true);
SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat formatter2= new SimpleDateFormat("yyyy");
Date date = new Date(System.currentTimeMillis());


String sql;
sql = "select recurso.NumeroRecurso from recurso order by recurso.NumeroRecurso desc;";

System.out.println(sql);

ResultSet result = manipula.getResultado(sql);

ArrayList<String> arrayNuRecurso = new ArrayList<String>();
int counter2 = 0;
while(result.next()){

	arrayNuRecurso.add(counter2, result.getString("NumeroRecurso"));
	counter2++;
}


int firstValue = Integer.parseInt(arrayNuRecurso.get(0));
String dataAtual = formatter.format(date);
String dataAtualAno = formatter2.format(date);

System.out.println(tipoRecurso);

String sql2 = "";
if(tipoRecurso != null){
	if(tipoRecurso.equals("Filme")){
		sql2 = "select pessoa.Nome, tipoAut, pessoa.ccPessoa from pessoa, autor where (tipoAut='realizador' or tipoAut='ator') and autor.ccPessoa = pessoa.ccPessoa order by pessoa.Nome;";
	}else if(tipoRecurso.equals("Musica")){
		sql2 = "select pessoa.Nome, tipoAut, pessoa.ccPessoa from pessoa, autor where (tipoAut='musico' or tipoAut='letrista') and autor.ccPessoa = pessoa.ccPessoa order by pessoa.Nome;";
	}else if(tipoRecurso.equals("Poema")){
		sql2 = "select pessoa.Nome, tipoAut, pessoa.ccPessoa from pessoa, autor where (tipoAut='poeta') and autor.ccPessoa = pessoa.ccPessoa order by pessoa.Nome;";
	}else if(tipoRecurso.equals("Fotografia")){
		sql2 = "select pessoa.Nome, tipoAut, pessoa.ccPessoa from pessoa, autor where (tipoAut='fotografo') and autor.ccPessoa = pessoa.ccPessoa order by pessoa.Nome;";
	}
}

ArrayList<String[]> arrayAutores = new ArrayList<String[]>();
if(tipoRecurso != null){
	ResultSet result2 = manipula.getResultado(sql2);
	
	int counter = 0;
	while(result2.next()){
		String[] arrayAutores2 = new String[3];
	
		
		arrayAutores2[0] = result2.getString("Nome");
		arrayAutores2[1] = result2.getString("tipoAut");
		arrayAutores2[2] = result2.getString("ccPessoa");
		
		
		arrayAutores.add(counter, arrayAutores2);
		
		counter++;
	}
}


if(request.getParameter("nomeRecurso") != null && request.getParameter("descricao") != null && request.getParameter("autores") != null){
	if(!request.getParameter("nomeRecurso").equals("") &&  !request.getParameter("descricao").equals("")){
		String nomeRecurso = request.getParameter("nomeRecurso");
		String descricao = request.getParameter("descricao");
		String faixa = request.getParameter("faixa");
		String[] autores = request.getParameterValues("autores");
		ArrayList<String> arrayAutor = new ArrayList<String>();
		ArrayList<String> arrayTipoAutor = new ArrayList<String>();
		for(int x = 0; x < autores.length; x++){
			arrayAutor.add(x, arrayAutores.get(Integer.parseInt(autores[x]))[0]);
			arrayTipoAutor.add(x, arrayAutores.get(Integer.parseInt(autores[x]))[1]);
		}
		
		ArrayList<String> arrayCCPessoa = new ArrayList<String>();
		for(int z = 0; z < autores.length; z++){
			for(int b = 0; b < arrayAutores.size(); b++){
				if(arrayAutores.get(b)[0].equals(arrayAutor.get(z))){
					arrayCCPessoa.add(z, arrayAutores.get(b)[2]);
				}
			}
		}
			
		
		String sqlrecurso = "INSERT INTO recurso (NumeroRecurso, NomeUtilizador, idAdmin, Ilustracao, Tipo, Titulo, Resumo, DataHoraCarr, Pontos, Bloquear, FaixaEtar) values ("+(firstValue+1)+",'"+utilizador+
				"',"+1+", '','"+tipoRecurso+"','"+nomeRecurso+"','"+descricao+"','"+dataAtual+"',"+2+","+0+","+faixa+");";
		if(!manipula.xDirectiva(sqlrecurso)){
			System.out.println("Erro");
		}
		for(int i = 0; i < autores.length; i++){
			if(tipoRecurso.equals("Filme")){
				String sqlAutores = "INSERT INTO "+tipoRecurso+" (NumeroRecurso, ccPessoa, tipoAut, AnoLanc) values ("+(firstValue+1)+","+arrayCCPessoa.get(i)+",'"+arrayTipoAutor.get(i)+"',"+dataAtualAno+");";
				if(!manipula.xDirectiva(sqlAutores)){
					System.out.println("Erro");
				}
			}else{
				String sqlAutores = "INSERT INTO "+tipoRecurso+" (NumeroRecurso, ccPessoa, tipoAut) values ("+(firstValue+1)+","+arrayCCPessoa.get(i)+",'"+arrayTipoAutor.get(i)+"');";
				if(!manipula.xDirectiva(sqlAutores)){
					System.out.println("Erro");
				}
			}
			
		}
		
		
	}
}


%>
<jsp:include page="Header.jsp?util=<%= utilizador %>" flush="true">
    <jsp:param name="util" value="<%= utilizador %>"/>
</jsp:include>
<nav class="secondnav" id="nav1">
      <ul>
        <li><a href="CriarRecursos.jsp?util=<%=utilizador%>&tipo=<%=tipo%>&tipoRecurso=Filme">Filme</a></li>
        <li><a href="CriarRecursos.jsp?util=<%=utilizador%>&tipo=<%=tipo%>&tipoRecurso=Poema">Poema</a></li>
        <li><a href="CriarRecursos.jsp?util=<%=utilizador%>&tipo=<%=tipo%>&tipoRecurso=Musica">Musica</a></li>
        <li><a href="CriarRecursos.jsp?util=<%=utilizador%>&tipo=<%=tipo%>&tipoRecurso=Fotografia">Fotografia</a></li>
      </ul>
    </nav>

<body>
<%
if(tipoRecurso == null){
	%>
	<h1>Indique o tipo de recurso que quer carregar!</h1>
	<% 
}else {
	%>
	<form id="form2" method = "POST" onsubmit="return verifica()">
		<h1>Nome do recurso</h1>
		<textarea id="nomeRecurso" name="nomeRecurso" rows="2" cols="30"></textarea>
		<h1>Descricao do recurso</h1>
		<textarea id="descricao" name="descricao" rows="4" cols="30"></textarea>
		<h1>Insira a faixa etaria do recurso</h1>
	   <select name="faixa" id="faixa">
			<option id="faixa" value="6">6</option>
			<option id="faixa" value="12">12</option>
			<option id="faixa" value="16">16</option>
			<option id="faixa" value="18">18</option>
		</select>
		
		<h1>Escolha um ou mais autores</h1>
		<%
		for(int i = 0; i < arrayAutores.size(); i++){
		%>
		 <input type="checkbox" id="autores" name="autores" value="<%=i%>">
		 
		  <label for="autores"><%=arrayAutores.get(i)[0] %>-<%=arrayAutores.get(i)[1]%> </label>
		  
		  <%
		}
	%>	
		<hr>
		<input type="submit" value="Criar Recurso">
	</form>
	<%
}
%>

<script type="text/javascript">
        
        
    function verifica(){
        var titulo = document.getElementById("nomeRecurso").value;
        var descript = document.getElementById("descricao").value;
        var patt = new RegExp('[\\\\/:"*?<>|]+');
        
        console.log(titulo);
        console.log(descript);
        
        if(patt.test(titulo)) {
            alert('Titulo invalido, por favor introduza apenas caracteres de A-z e numeros');
            return false;
        }
        else if(patt.test(descript)) {
            alert('Descricao invalida, por favor introduza apenas caracteres de A-z e numeros');
            return false;
        }
        
        return true;
    }
</script>