<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.Configura"%>
<%@ page import="util.*, java.sql.ResultSetMetaData, java.sql.ResultSet, java.sql.SQLException"%>
<%@ page import="java.util.ArrayList,java.util.Arrays"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>
<%@ page import="java.io.InputStream, java.io.OutputStream, java.io.ByteArrayOutputStream, java.sql.Blob, java.awt.image.BufferedImage, javax.imageio.ImageIO"%>




<body>
	<%
			Configura cfg = new Configura();
			util.Manipula manipula = new util.Manipula(cfg);
			String recursoID = request.getParameter("recursoID");
			
			
			if(request.getParameter("comment") != null){
				if(request.getParameter("comment") != ""){
					String utilizador = request.getParameter("util");
					String Comentario = request.getParameter("comment");
					
					System.out.println(Comentario);
					
					
					String sqlComentario = "INSERT INTO comentario values ("+recursoID+", '"+utilizador+"', '"+Comentario+"');";
					if(!manipula.xDirectiva(sqlComentario)){
						System.out.println("Erro");
					}
				}
			}else{
				System.out.println("Esta a null");
			}
			
			if(request.getParameter("class") != null){
				String utilizador = request.getParameter("util");
				String Nota = request.getParameter("class");
				
				System.out.println(Nota);
				
				
				String sqlNota = "INSERT INTO classificacao values ("+recursoID+", '"+utilizador+"', "+Nota+");";
				if(!manipula.xDirectiva(sqlNota)){
					System.out.println("Erro");
				}
			}else{
				System.out.println("Esta a null");
			}

			String sql;
			sql = "select recurso.NumeroRecurso, NomeUtilizador, idAdmin, Tipo, Titulo, Resumo, DataHoraCarr, Bloquear, FaixaEtar, Ilustracao, poema.tipoAut, pessoa.Nome from recurso, poema, pessoa where recurso.NumeroRecurso = poema.NumeroRecurso and poema.ccPessoa = pessoa.ccPessoa order by Titulo;";
	
			ResultSet result = manipula.getResultado(sql);

			int counter = 0;

			
			
			ArrayList<String[]> arrayFinal = new ArrayList<String[]>(); 

			while(result.next()){
				String[] arrayNormal = new String[12];
				
				arrayNormal[0] = result.getString("NumeroRecurso");
				arrayNormal[1] = result.getString("NomeUtilizador");
				arrayNormal[2] = result.getString("idAdmin");
				arrayNormal[3] = result.getString("Tipo");
				arrayNormal[4] = result.getString("Titulo");
				arrayNormal[5] = result.getString("Resumo");
				arrayNormal[6] = result.getString("DataHoraCarr");
				arrayNormal[7] = result.getString("Bloquear");
				arrayNormal[8] = result.getString("FaixaEtar");
				arrayNormal[9] = result.getString("tipoAut");
				arrayNormal[10] = result.getString("Nome");
				arrayNormal[11] = result.getString("Ilustracao");
				
				arrayFinal.add(counter, arrayNormal);
				
				counter++;
			}
			
			int CounterRep = 0;
			int ValorCerto = 0;
			
			for(int i = 0; i < counter; i++){
				
				
				if(arrayFinal.get(i)[0].equals(recursoID)){
					if(arrayFinal.get(i)[7].equals("1")){
						ValorCerto = i;
						%>
						<h1> O Conteudo encontra-se bloqueado </h1>
						<% 
						break;
					}else{
						CounterRep++;
						if(CounterRep > 1){
							ValorCerto = i;
							%>
								<div id ="autorRecurso">
									<p><strong>Autores: </strong><%=arrayFinal.get(i)[10]%>-<%=arrayFinal.get(i)[9]%></p>
								</div>
							<% 
						}else{
							%>
							<h1><%=arrayFinal.get(i)[4]%> (<%=arrayFinal.get(i)[3]%>)</h1>
							<div id="divPoema">
							
								<textarea rows="8" cols="40" readonly><%=arrayFinal.get(i)[11].toString() %></textarea>
							</div>
							<br>
							<hr>
							<h4>Publicado por: <%=arrayFinal.get(i)[1]%> às <%=arrayFinal.get(i)[6]%></h4>
							<p><strong>Faixa Etaria: </strong><%=arrayFinal.get(i)[8]%></p>			
							<h4>Descrição: <br></h4>
							<div id = "descricaoMargem">
								<%=arrayFinal.get(i)[5]%>
								<p><strong>Autores: </strong><%=arrayFinal.get(i)[10]%>-<%=arrayFinal.get(i)[9]%></p>
								
							</div>
							
							
							<% 
						}
						
					}
					
					
				}
			}
			if(arrayFinal.get(ValorCerto)[7].equals("1")){
				
			}else{
				String sqlComent;
				sqlComent = "select recurso.NumeroRecurso, recurso.Titulo, comentario.ConteudoCom, comentario.NomeUtilizador as Comentador from comentario, recurso where recurso.NumeroRecurso = comentario.NumeroRecurso;";
		
				ResultSet resultComent = manipula.getResultado(sqlComent);
				
				ArrayList<String[]> arrayComent = new ArrayList<String[]>();
				int counterComent= 0;
				
				while(resultComent.next()){
					String[] arrayNormal = new String[4];
					arrayNormal[0] = resultComent.getString("NumeroRecurso");
					arrayNormal[1] = resultComent.getString("Titulo");
					arrayNormal[2] = resultComent.getString("ConteudoCom");
					arrayNormal[3] = resultComent.getString("Comentador");
					
					arrayComent.add(counterComent, arrayNormal);
					counterComent++;
				}
				
				String sqlNota;
				sqlNota = "select recurso.NumeroRecurso, recurso.Titulo, classificacao.NotaClass, classificacao.NomeUtilizador as Classificador from classificacao, recurso where recurso.NumeroRecurso = classificacao.NumeroRecurso;";
		
				ResultSet resultNota = manipula.getResultado(sqlNota);
				
				ArrayList<String[]> arrayNota = new ArrayList<String[]>();
				int counterNota= 0;
				
				while(resultNota.next()){
					String[] arrayNormal = new String[4];
					arrayNormal[0] = resultNota.getString("NumeroRecurso");
					arrayNormal[1] = resultNota.getString("Titulo");
					arrayNormal[2] = resultNota.getString("NotaClass");
					arrayNormal[3] = resultNota.getString("Classificador");
					
					arrayNota.add(counterNota, arrayNormal);
					counterNota++;
				}
				%>
				
				
				<hr>
				
				<h3>Comentarios:</h3>
				
				<%
				boolean existe = false;
				for(int i = 0; i < arrayComent.size(); i++){
					if(arrayComent.get(i)[0].equals(recursoID)){
						existe = true;
						%>
						<h3><%= arrayComent.get(i)[3] %></h3>
						<p><%= arrayComent.get(i)[2] %></p>
						<br>
						<% 
					}
					
				}
				
				if(!existe){
					%>
					<h3>Nao existem comentarios neste poema</h3>
					<% 
				}
				
				%>
				<hr>
				
				<h3>Classificacoes:</h3>
				
				<%
				boolean existeCla = false;
				for(int i = 0; i < arrayNota.size(); i++){
					if(arrayNota.get(i)[0].equals(recursoID)){
						existeCla = true;
						%>
						<h3><%= arrayNota.get(i)[3] %>:  <span style="font-weigth:italic"><%= arrayNota.get(i)[2] %></span></h3>
						<br>
						<% 
					}
					
				}
				
				if(!existeCla){
					%>
					<h3>Nao existem classificacoes neste poema</h3>
					<% 
				}
				
			}
			
			if(arrayFinal.get(ValorCerto)[7].equals("1")){
				
			}else{
				%>
				<hr>
			
			<div>
			   <h3>Inserir um Classificacao:</h3>
			   <form id="form2" method = "POST" onsubmit="return insertClass();">
				   <select name="class" id="class">
				   		<option id="class" value="null">N/A</option>
						<option id="class" value="1">1</option>
						<option id="class" value="2">2</option>
						<option id="class" value="3">3</option>
						<option id="class" value="4">4</option>
						<option id="class" value="5">5</option>
					</select>
					<input type="submit" value="Classificar">
				</form>
				
			</div>
			<hr>
			<div >
			   <h3>Inserir um comentario:</h3>
			   	
				<!-- <button type="button" onclick="insertComent();" >Comentar</button>  -->
				<form id="form2" method = "POST" onsubmit="return insertComent();">
						<textarea id="comment" name="comment" rows="4" cols="40"></textarea>
						<input type="submit" value="Comentar">
						
				</form>
			</div>
		
			<hr>
				<% 
			}
			%>
			
			
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			
			

