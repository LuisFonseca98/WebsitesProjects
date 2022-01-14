package util;
import static java.nio.file.StandardOpenOption.READ;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.channels.SeekableByteChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpDownBlobApp {	
//	static String path = "c:\\recursos\\"; // "WebContent\\";
//	static String pathVideos=path+"videos\\";
//	static String pathFotos=path+"fotos\\";
//	static String pathMusicas=path+"musicas\\";
	static String path = "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads"; // "WebContent\\";
	static String pathVideos="C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads";
	static String pathFotos="C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads";
	static String pathMusicas="C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads";
	static String host="localhost";
	static String bd="sbd_tp1";
	
	public static String drv = "com.mysql.cj.jdbc.Driver";
	public static String jdbcUrl = "jdbc:mysql://" + host + "/" + bd
			+ "?xdevapi.connect-timeout=0&allowMultiQueries=true&useLegacyDatetimeCode=false&serverTimezone=Europe/Lisbon";;
	public static String username =  "root";
	public static String password = "3323";
		
	public enum SGBD {MSSqlServer, MySQL, ODBC }
	// max blob sqlServer 2 Gigas
	// max blob mySQL     1 Giga - limitação do max_allowedpacket
	
	public final static SGBD sgbd = SGBD.MySQL; //  definir o valor da constante para ligação à base de dados
	private static boolean bLoad=false;
	
	public static Connection getConnection() throws SQLException {
		if(!bLoad) {
			Server();
			try {
				Class.forName(UpDownBlobApp.drv);
				bLoad=true;
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
		// Class.forName("com.mysql.cj.jdbc.Driver");  // tipicamente não é preciso!
		return DriverManager.getConnection(jdbcUrl, username, password);
		//tentativa: integratedSecurity=true
		//return DriverManager.getConnection("jdbc:sqlserver://"+host+":1433;databaseName="+bd+";selectMethod=cursor; integratedSecurity=true;domain=myDomain");
	}

	private static void Server() {
		if(sgbd==SGBD.MySQL) {
			drv = "com.mysql.cj.jdbc.Driver";
			jdbcUrl = "jdbc:mysql://" + host + "/" + bd
			+ "?xdevapi.connect-timeout=0&allowMultiQueries=true&useLegacyDatetimeCode=false&serverTimezone=Europe/Lisbon";
			username =  "root";
			password = "3323";
			return;
		}
		if(sgbd==SGBD.MSSqlServer) {
			/* https://www.codejava.net/java-se/jdbc/connect-to-microsoft-sql-server-via-jdbc */
			drv = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
			jdbcUrl = "jdbc:sqlserver://"+host+":1433;databaseName="+bd+";selectMethod=cursor;";
			username =  "root";
			password = "root"; 	
			return;
		}		
		System.out.println("Falta definir o valor da constante 'sgbd' para ligação à base de dados");
	}

	
	public static void create() {
		Connection conn = null;
		Statement stmt = null;
		try {
			Server();
			Class.forName(drv);
			// ligação sem especificar a base de dados;
			if(sgbd == SGBD.MySQL)
				conn = DriverManager.getConnection("jdbc:mysql://" + host+"?serverTimezone=Europe/Lisbon", username, password);
			else if(sgbd == SGBD.MSSqlServer)
					conn = DriverManager.getConnection("jdbc:sqlserver://"+host+":1433;", username, password);
				else {
					System.out.println("Usar mySQL() ou MSSQLServer() para definir a ligação à base de dados");
					return;
				}
			stmt = conn.createStatement();   // sem definir a bd
			// cria a base de dados
			try {
				stmt.execute("DROP DATABASE IF EXISTS "+bd);
				System.out.println("Creating '"+bd+"' database...");
				// stmt.execute("CREATE DATABASE IF NOT EXISTS "+bd);
				stmt.execute("CREATE DATABASE  "+bd);
			    System.out.println("Database '"+bd+"' created!");
			}
			 catch (SQLException e) {
					System.out.println("Erro na criação da base de dados '"+bd+"' ...");
					e.printStackTrace();
					return;
				}
			
			stmt.execute("USE "+bd);
			stmt.execute("DROP TABLE IF EXISTS blobs");
			
			if(sgbd == SGBD.MySQL) 
			stmt.execute("CREATE TABLE IF NOT EXISTS blobs ("
					+ "  ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,"
					+ "  NAME VARCHAR(255) NOT NULL UNIQUE,"
					+ "  TYPE VARCHAR(25) NULL,"
					+ "  CONTENT LONGBLOB NULL)"); 
			else 
				if(sgbd == SGBD.MSSqlServer)
					stmt.execute("CREATE TABLE blobs ("
							+ "  ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,"
							+ "  NAME VARCHAR(255) NOT NULL UNIQUE,"
							+ "  TYPE VARCHAR(25) NULL,"
							+ "  CONTENT varbinary(max) NULL)");
			System.out.println("Table 'blobs' created!");

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		} finally {
			try {
				if (stmt != null) // Close statement
					stmt.close();
				if (conn != null) // Close connection
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	// vai enviar o video (existente num ficheiro) indicado em parametro
	public static void processRequestFile(final HttpServletRequest request, final HttpServletResponse response)
			throws IOException {
		final int BUFFER_LENGTH = 1024 * 16;
		final long EXPIRE_TIME = 1000 * 60 * 60 * 24;
		final Pattern RANGE_PATTERN = Pattern.compile("bytes=(?<start>\\d*)-(?<end>\\d*)");

		String dsg = request.getParameter("dsg");
		if(dsg==null) 
			dsg="sample.mp4";

		Path video = Paths.get(pathVideos, dsg);

		long length = Files.size(video);
		long start = 0;
		long end = length - 1;

		String range = request.getHeader("Range");
		if (range != null) {
			Matcher matcher = RANGE_PATTERN.matcher(range);

			if (matcher.matches()) {
				String startGroup = matcher.group("start");
				//System.out.println(startGroup);
				start = startGroup.isEmpty() ? start : Long.parseLong(startGroup);
				start = start < 0 ? 0 : start;

				String endGroup = matcher.group("end");
				end = endGroup.isEmpty() ? end : Integer.valueOf(endGroup);
				end = end > length - 1 ? length - 1 : end;
			}
		}
		else
			System.out.println("\nAccessing '"+dsg+"' Example!");

		long contentLength = end - start + 1;

		System.out.println("Get "+contentLength/1024/1024+" MB!");
		response.reset();
		response.setBufferSize(BUFFER_LENGTH);
		response.setHeader("Content-Disposition", String.format("inline;filename=\"%s\"", dsg));
		response.setHeader("Accept-Ranges", "bytes");
		response.setDateHeader("Last-Modified", Files.getLastModifiedTime(video).toMillis());
		response.setDateHeader("Expires", System.currentTimeMillis() + EXPIRE_TIME);
		response.setContentType(Files.probeContentType(video));
		response.setHeader("Content-Range", String.format("bytes %s-%s/%s", start, end, length));
		response.setHeader("Content-Length", String.format("%s", contentLength));
		response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);

		int bytesRead;
		long bytesLeft = contentLength;
		ByteBuffer buffer = ByteBuffer.allocate(BUFFER_LENGTH);

		try (SeekableByteChannel input = Files.newByteChannel(video, READ);
				OutputStream output = response.getOutputStream()) {

			System.out.println("\nRetrieving '"+dsg+"' "+contentLength/1024/1024+" MB from ("+start+") to ("+end+") bytes");
			input.position(start);
			int conta=0;
			while ((bytesRead = input.read(buffer)) != -1 && bytesLeft > 0) {
				buffer.clear();
				output.write(buffer.array(), 0, (int) (bytesLeft < bytesRead ? bytesLeft : bytesRead));
				bytesLeft -= bytesRead;
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
			}
		}
	}

	// vai enviar o video (existente num blob) indicado em parametro
	public static void processRequestBlob(final HttpServletRequest request, final HttpServletResponse response) throws IOException {
		final int BUFFER_LENGTH = 1024 * 16;
		final long EXPIRE_TIME = 1000 * 60 * 60 * 24;
		final Pattern RANGE_PATTERN = Pattern.compile("bytes=(?<start>\\d*)-(?<end>\\d*)");
		String dsg = request.getParameter("dsg");
		if(dsg==null) 
			dsg="sample.mp4";
		try {
			Connection con = getConnection();
			PreparedStatement st = con.prepareStatement("SELECT distinct Ilustracao from recurso, filme where recurso.NumeroRecurso = 77 and length(Ilustracao)>0 order by recurso.NumeroRecurso;");
			st.setString(1, dsg);
			ResultSet rs = st.executeQuery();
			if (rs.next()) { // só vai ler um registo
				//String type = rs.getString("type");
				Blob rec = rs.getBlob("Ilustracao");
				InputStream input = rec.getBinaryStream();
				OutputStream output = response.getOutputStream();

				long length = rec.length();
				long start = 0;
				long end = length - 1;

				String range = request.getHeader("Range");
				if (range != null) {
					Matcher matcher = RANGE_PATTERN.matcher(range);

					if (matcher.matches()) {
						String startGroup = matcher.group("start");
						start = startGroup.isEmpty() ? start : Long.parseLong(startGroup);
						start = start < 0 ? 0 : start;

						String endGroup = matcher.group("end");
						end = endGroup.isEmpty() ? end : Integer.valueOf(endGroup);
						end = end > length - 1 ? length - 1 : end;
					}
				}
				else
				  System.out.println("\nAccessing '"+dsg+"' Example!");

				long contentLength = end - start + 1;

				response.reset();
				response.setContentType("video/mp4"); // "image/jpeg" "video/mp4"
				response.setBufferSize(BUFFER_LENGTH);
				response.setHeader("Content-Disposition", String.format("inline;filename=\"%s\"", dsg));
				response.setHeader("Accept-Ranges", "bytes");
				response.setDateHeader("Expires", System.currentTimeMillis() + EXPIRE_TIME);
				response.setHeader("Content-Range", String.format("bytes %s-%s/%s", start, end, length));
				response.setHeader("Content-Length", String.format("%s", contentLength));
				response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);

				int bytesRead;
				long bytesLeft = contentLength;
				byte[] buffer = new byte[BUFFER_LENGTH];

				//input.skipNBytes(start);
				System.out.println("\nRetrieving '"+dsg+" "+contentLength/1024/1024+" MB from ("+start+") to ("+end+")");
				input.skip(start);
				int conta=0;
				while ((bytesRead = input.read(buffer)) != -1 && bytesLeft > 0) {
						output.write(buffer, 0, (int)(bytesLeft < bytesRead ? bytesLeft : bytesRead));
						bytesLeft -= bytesRead;
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
				}
			    output.close();
			    input.close();
			    rs.close();
			    con.close();
			}
		} catch (SQLException e1) {
			System.out.println(e1.getMessage());
			e1.printStackTrace();
		}
  }
	
	public static void upload(URL pathContent) {
		// upload from URL
		FileName aux = new FileName(pathContent.getFile(), '/', '.');
		String type = aux.mimeType();
		String name = aux.filename() + "." + aux.extension();
		InputStream input = null;
		;
		try {
			input = pathContent.openStream();
			System.out.println("Reading file from " + pathContent);
			upload(input, name, type);
			input.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void upload(String pathContent) {
		// upload from file or folder
		File[] listOfFiles = null;
		File filefolder = new File(pathContent);
		if (!filefolder.exists())
			return;
		if (filefolder.isDirectory())
			listOfFiles = filefolder.listFiles();
		if (filefolder.isFile()) {
			listOfFiles = new File[1];
			listOfFiles[0] = filefolder;
		}
		if (listOfFiles == null)
			return;
		for (int i = 0; i < listOfFiles.length; i++) {
			File file = listOfFiles[i];
			if (file.isFile()) {
				FileName aux = new FileName(file.getAbsolutePath(), '\\', '.');
				String type = aux.mimeType();
				String name = aux.filename() + "." + aux.extension();
				// read the file  -- aqui podiam-se filtrar as estensões
				try {
					FileInputStream input = new FileInputStream(file);
					System.out.println("Reading file from " + file.getAbsolutePath());
					upload(input, name, type);
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
					return;
				}
			}
			else
				System.out.println("Cannot read from " + file.getAbsolutePath());
		}
	}
	
	public static boolean bdExist(String name) {
		try (Connection conn = getConnection(); 
			 PreparedStatement st = conn.prepareStatement("SELECT distinct recurso.Titulo from recurso, filme where recurso.NumeroRecurso = 77;");) {
			 st.setString(1, name);
			return st.executeQuery().next();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} 
	}
	
	public static void upload(InputStream input, String name, String type) {
		// upload stream

		try (Connection conn = getConnection();) {
			if (bdExist(name)) {
				System.out.println("Nothing to do with '"+name+"'!");
				return;
			}
			PreparedStatement pstmt = conn
					.prepareStatement("INSERT INTO blobs(NAME, TYPE, CONTENT) VALUES (?,?,?)"); 
			// set parameters
//			pstmt.setString(1, name);
//			pstmt.setString(2, type);
//			pstmt.setBinaryStream(3, input);
			// store the file in database
			int count=0;
			try {
				count = pstmt.executeUpdate();
			  } catch (OutOfMemoryError e) {
			    throw new IOException("Data too long to read into memory!");
			  } catch (NegativeArraySizeException e) {
			    throw new IOException("Cannot read negative length!");
			  }
			if (count == 1)
				System.out.println("File stored in the database!");
			input.close();
		} catch (SQLException | IOException e) {
			System.err.println("Upload: "+e.getMessage());
		} // não precisa de fechar
	}
	
	public static void download(String pathContent) {
		// download file

		try (Connection conn = getConnection();
			 PreparedStatement pstmt = conn.prepareStatement("SELECT CONTENT FROM blobs WHERE NAME = ?");
			) {
			
			FileName aux = new FileName(pathContent, '\\', '.');
			// set parameter;
			pstmt.setString(1, aux.filename()+"."+aux.extension());
			ResultSet rs = pstmt.executeQuery();

			// write binary stream into file
			File file = new File(aux.path()+"\\"+aux.filename()+".bk."+aux.extension());
			FileOutputStream output = new FileOutputStream(file);

			System.out.println("Writing to file '"+ aux.path()+"\\"+aux.filename()+".bk."+aux.extension()+"'");
			// writing the movie file in file
			while (rs.next()) {
				InputStream input = rs.getBinaryStream("CONTENT");
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
		} // não precisa de fechar
	}

	public static String readDataList(String name) {
		Connection conn = null;
		Statement stmt = null;
		String buffer = "<datalist>";
		try {
			conn = getConnection();
			stmt = conn.createStatement();
			String where="where Name LIKE '" + name + "%'";
			if(name==null || name.length()==0)
				where="";
			ResultSet rs = stmt.executeQuery(
					"Select Name from blobs "+where+" order by Name");
			while (rs.next()) {
				buffer = buffer + "<option value='" + rs.getString("name") + "'>";
				// System.out.println(rs.getString("ShortName"));
			}
		} catch (SQLException e) {
			System.err.println("SQL Exception!");
			e.printStackTrace();
			System.out.println(e.getMessage());
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				System.err.println("Cannot close!");
				System.out.println(e.getMessage());
			}
		}
		return buffer + "</datalist>";
	}

	public static String readSelect() {  // lê os nomes da bd e dos ficheiros que existirem com tamanhos grandes

		ArrayList<String> list = new ArrayList<String>();  

		try (Connection conn = UpDownBlobApp.getConnection();
			Statement stmt = conn.createStatement();
				) {		
				ResultSet rs = stmt.executeQuery("SELECT NAME FROM blobs ORDER BY NAME");
				while (rs.next()) {
					list.add("<option>"+rs.getString("NAME")+"</option>\n");
				}
				rs.close();
			} catch (SQLException e) {
				System.out.println(e.getMessage());
			} // não precisa de fechar
		
		// acrescenta a lista com os titulos existentes em ficheiro na diretoria videos
		File[] listOfFiles = null;
		File filefolder = new File(pathVideos);
		listOfFiles = filefolder.listFiles();
		for (int i = 0; i < listOfFiles.length; i++) {
			File file = listOfFiles[i];
			if (file.isFile()) {
				FileName aux = new FileName(file.getAbsolutePath(), '\\', '.');
				if(!list.contains("<option>"+aux.filename() + "." + aux.extension()+ "</option>\n")) 
					list.add("<option>"+aux.filename() + "." + aux.extension()+ "</option>\n");
			}
		}
		Collections.sort(list, String.CASE_INSENSITIVE_ORDER);   // sem parametro ordena pela ordem natural
		StringBuilder out = new StringBuilder();
		for (String s : list)
		{
		  out.append(s);
		  //out.append("\t");
		}
		return out.toString().replaceAll(" ", "&nbsp;");
	}
	
	
	
    /**
     * @param args the command line arguments
     * @throws Exception 
     */
    public static void main(String[] args) {

    	//create();  // apaga a base de dados se existir
    	
    	//upload(pathFotos);
    	//upload(pathMusicas);
    	//upload(pathVideos);
    	
    	//upload(pathVideos+"Hino Nacional de Portugal A Portuguesa_480p.mp4");
        
        //upload(new URL("https://www.w3schools.com/tags/movie.mp4"));
        
        //download(pathVideos+"sample.mp4");
    	//download(pathFotos+"telhaPedra.jpg");
    	
    	//System.out.println(readList("s"));
    	//System.out.println(readList(""));
	}

}
