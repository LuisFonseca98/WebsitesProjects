package util;


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ViewBinary
 */
@WebServlet("/ViewBlob")
public class ViewBlobServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewBlobServlet() {
        super();
    }

    
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		final int BUFFER_LENGTH=16*1024*1024;
		String dsg = request.getParameter("dsg");
		if(dsg==null) 
			dsg="aldeia.jpg"; //"sample.mp4";
		try {
			System.out.println("\nAccessing '" + dsg + "' Example!");
			Connection con = null;
			con = DriverManager.getConnection(UpDownBlobApp.jdbcUrl, UpDownBlobApp.username, UpDownBlobApp.password);
		
			PreparedStatement st = con.prepareStatement("SELECT distinct Tipo, Ilustracao from recurso, filme where recurso.NumeroRecurso = "+dsg+" and length(Ilustracao)>0 order by recurso.NumeroRecurso;");
			
		
			
			ResultSet rs = st.executeQuery();
	
			System.out.println("\nRetrieving '" + dsg + "' Example!");
			if (rs.next()) { // só vai ler um registo
				OutputStream o = response.getOutputStream();
				byte[] bytearray = new byte[BUFFER_LENGTH];
				int size = 0;
				String type = rs.getString("Tipo");
				System.out.println(type);
				Blob rec = rs.getBlob("Ilustracao");
				InputStream sImage = rec.getBinaryStream(); // rs.getBinaryStream("content"); // tem de ser a ultima
				
				
				// coluna!!!
				response.reset();
				response.setBufferSize(BUFFER_LENGTH);
				response.setContentType(type); // "image/jpeg" "video/mp4"
			
				// Content-Disposition: attachment
				// Content-Disposition: inline; filename="filename.jpg"

				response.setHeader("Connection", "Keep-Alive");
				response.setHeader("Keep-Alive", "timeout=90, max=1000");

				/*
				 * timeout: indicando a quantidade mínima de tempo que uma conexão deve ser
				 * mantida aberta (em segundos). Observe que os tempos limite maiores que o
				 * tempo limite do TCP podem ser ignorados se nenhuma mensagem TCP keep-alive
				 * estiver definida na camada de transporte. max: indicando o número máximo de
				 * pedidos que podem ser enviados nesta conexão antes de fechá-lo.
				 */

				/*
				 * mudar o timeout no ficheiro server.xml: <Connector port="8080"
				 * protocol="HTTP/1.1" connectionTimeout="90000" redirectPort="8443" />
				 */

				response.setHeader("Content-Length", rec.length() + "");
				response.setHeader("Content-Disposition", "inline; filename=" + dsg);

				System.out.println(type + " > (" + sImage.available() + ")/" + rec.length());
				int conta = 0;
				while ((size = sImage.read(bytearray)) != -1)
					try {
						o.write(bytearray, 0, size);
						o.flush();
						conta++;
						switch (conta % 4) {
						case 0:
							System.out.print("|");
							break;
						case 1:
							System.out.print("/");
							break;
						case 2:
							System.out.print("-");
							break;
						case 3:
							System.out.print("\\");
							break;
						default:
						}
					} catch (Exception e) {
						System.out.println("\nErro na escrita '" + dsg + "': " + e.getMessage());
						break;
					}
				o.flush();
				o.close();
				sImage.close();
			} else
				System.out.println("Recurso '" + dsg + "' não encontrado!");
			rs.close();
			st.close();
			con.close();
		} catch (Exception e) {
			System.out.println("Terminou: " + e.getMessage());
			// e.printStackTrace();

		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
