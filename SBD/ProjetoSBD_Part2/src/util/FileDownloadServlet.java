package util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/downloadServlet")
public class FileDownloadServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

        String recursoid = request.getParameter("recursoID");
        String tipoRecurso = request.getParameter("tipo");
		String tituloRecurso = request.getParameter("titulo");
		String utilizador = request.getParameter("utilizador");
		String tipoUser = request.getParameter("tipoUser");
        
        System.out.println("DownloadServlet: Vou começar.");
        System.out.println("recursoid= " + recursoid);
        System.out.println("tipoid= " + tipoRecurso);
        System.out.println("ficheiro= " + tituloRecurso);
        
    	Configura cfgaux = new Configura();
    	Connection conn = cfgaux.getConnection();
    	
    	String titulo ="";
    	
    	if (tipoRecurso.equals("Filme"))
    		titulo+= tituloRecurso+".mp4";
    	else if (tipoRecurso.equals("Musica"))
    		titulo+= tituloRecurso+".mp3";
    	else if (tipoRecurso.equals("Fotografia"))
    		titulo+= tituloRecurso+".jpg";
    	else if (tipoRecurso.equals("Poema"))
    		titulo+= tituloRecurso+".txt";
    	
		try {
	
	    	String sql = "select distinct recurso.Ilustracao from recurso where recurso.NumeroRecurso = "+recursoid+";";
	    	
	    	System.out.println("Query: " + sql );
	    	
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			String path= System.getProperty("user.home") + "\\Downloads\\";
			
			File file = new File(path + "\\" + titulo);
			FileOutputStream output = new FileOutputStream(file);
			
			System.out.println("Writing to file '"+ path + titulo +"'");
			if (rs.next()) {
				InputStream input=null;

				
				input = rs.getBinaryStream("Ilustracao");
				
				byte[] buffer = new byte[1024*1024];
				while (input.read(buffer) > 0) {
					output.write(buffer);
					System.out.println(".");
				}
				input.close();
			}
			rs.close();
			output.close();
		} catch (SQLException | IOException e) {
			System.out.println(e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
          
            response.sendRedirect(request.getContextPath()+"/RecursosUser.jsp?nomeUtil="+utilizador+"&tipo="+tipoUser+"");
        }
    	
	}
}
