package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
 
@WebServlet("/uploadServlet")
@MultipartConfig(maxFileSize = 20971520)    // upload file's size up to 20MB
public class FileUploadServlet extends HttpServlet {
     
	private static final long serialVersionUID = 1L;
	
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
    	
    	String recursoid = request.getParameter("recursoID");
        String tipoRecurso = request.getParameter("tipoRecurso");
		String utilizador = request.getParameter("utilizador");
		String tipoUser = request.getParameter("tipoUser");
		
        InputStream inputStream = null; // input stream of the upload file
    	Configura cfgaux = new Configura();
        
        System.out.println("UploadServlet: Vou começar.");
        
        Part filePart = request.getPart("file");
        if (filePart != null) {
            // prints out some information for debugging
            System.out.println(filePart.getName());
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());
             
            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }
         
        Connection conn = null; // connection to the database
         
        try {
        	conn = cfgaux.getConnection();
            String sql="UPDATE recurso SET Ilustracao=? WHERE recurso.NumeroRecurso= " + recursoid+";";
        	
        	
            System.out.println("Query: " + sql );

            PreparedStatement statement = conn.prepareStatement(sql);
         
            if (inputStream != null)
                statement.setBlob(1, inputStream);
            statement.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace();
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
