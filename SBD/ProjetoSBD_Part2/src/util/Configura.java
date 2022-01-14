package util;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.DriverPropertyInfo;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * Define a configuração usada para acesso à base de dados
 * 
 * @author Engº Porfírio Filipe
 * 
 */

public class Configura {

	/**
	 * Tipo enumerado usado para carecterizar os Sistemas de Gestão de Bases de
	 * Dados
	 * 
	 * @author Engº Porfírio Filipe
	 *
	 */

	public enum SGBD {
		MSSqlServer, MySQL, ODBC
	}

	static boolean bRun = false;

	String recurso = "configura"; // configura.properties

	/*
	 * Ativação do modo de autenticação misto no SQLServer ALTER LOGIN sa ENABLE; GO
	 * ALTER LOGIN sa WITH PASSWORD = '<enterStrongPasswordHere>' ; GO
	 */
	/*
	 * Configuração para o SQLServer com JDBC tipo 4 private String database = "BD";
	 * private String usr = "root"; private String pwd = "root"; private String
	 * serverName = "localhost";
	 * 
	 * private String drv = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	 * 
	 * private String url =
	 * "jdbc:sqlserver://"+serverName+":1433;databaseName="+database+
	 * ";selectMethod=cursor;"; private SGBD sgbd = SGBD.MSSqlServer;
	 */

	/*
	 * O modo windows autentication não funciona sem a dll: sqljdbc_auth in
	 * java.library.path
	 */

	/* Configuração para o mySQL com JDBC tipo 4 private */
	/*
	 * 
	 * String database = "SBD"; private String usr = "root"; private String pwd =
	 * "root"; String serverName = "localhost";
	 * 
	 * String drv = "com.mysql.jdbc.Driver"; private String url =
	 * "jdbc:mysql://"+serverName+"/"+database+""; SGBD sgbd = SGBD.MySQL;
	 */

	/* Configuração para o MySQL8 com JDBC tipo 4 */

	private String database = "sbd_tp1";
	private String usr = "root";
	private String pwd = "3323";
	private String serverName = "localhost:3306";

	private String drv = "com.mysql.cj.jdbc.Driver";
	// private String url =
	// "jdbc:mysql://"+serverName+"/"+database+"?useTimezone=true&serverTimezone=UTC";
	private String url = "jdbc:mysql://" + serverName + "/" + database + "?useLegacyDatetimeCode=false&serverTimezone=Europe/Lisbon";
	
	private SGBD sgbd = SGBD.MySQL;

	/*
	 * Configuração com JDBC tipo 1 JDBC-ODBC descontinuado a partir do Java 8
	 * 
	 * private String drv = "sun.jdbc.odbc.JdbcOdbcDriver";
	 * 
	 * private String url = "jdbc:odbc:BD";
	 * 
	 * private SGBD sgbd = SGBD.ODBC;
	 * 
	 * private String usr = "userbd";
	 * 
	 * private String pwd = "passbd";
	 */

	/**
	 * Chama a lista de propriedades do driver
	 * 
	 * @param args nenhum
	 */
	public static void main(String[] args) {
		Configura cfg = new Configura();
		cfg.driverProperties();
	}

	/**
	 * Construtor, tenta ler do ficheiro indicado em 'recurso' a configuração do
	 * acesso à base de dados
	 */
	public Configura() {
		if (!bRun) {
			try {
				final ResourceBundle rb = ResourceBundle.getBundle(recurso);
				drv = rb.getString("drv");
				url = rb.getString("url");
				usr = rb.getString("usr");
				pwd = rb.getString("pwd");
			} catch (final MissingResourceException e) {
				// System.err.println(e.getMessage());
				// if no resource bundle for the specified base name can be
				// found
				// System.err.println("O ficheiro de configuração '" + recurso+
				// "'
				// não foi encontrado...");
			}
			bRun = true;
		}
	}

	/**
	 * Apresenta as propriedades do driver corrente
	 */
	public void driverProperties() {
		// String URL = "jdbc:odbc:"; //"jdbc:odbc:local//GESTAL:1433";
		try {
			System.err.println("Vai carregar o driver (" + drv + ")...");
			Class.forName(drv);

			System.err.println("Vai obter uma instancia do driver...");
			Driver driver = DriverManager.getDriver(url);

			System.err.println("Vai ler as propriedades do driver...");
			DriverPropertyInfo[] info = driver.getPropertyInfo(url, null);
			System.err.println("Vai listar as propriedades do driver...");
			for (int i = 0; i < info.length; i++) {
				// Get name of property
				String name = info[i].name;

				// Is property value required?
				boolean isRequired = info[i].required;

				// Get current value
				String value = info[i].value;

				// Get description of property
				String desc = info[i].description;

				// Get possible choices for property; if null, value can be any string
				String[] choices = info[i].choices;
				System.out.println(name + " (" + ((isRequired) ? "Obrigatório" : "Opcional") + ") " + ": " + value
						+ ", " + desc + ", " + choices);
			}
		} catch (ClassNotFoundException e) {
			// Could not find the database driver
		} catch (SQLException e) {
			System.err.println("SQLException" + e.getMessage());
		}
	}

	/**
	 * Formata numa String uma Data SQL
	 * 
	 * @param dia dia do mês
	 * @param mes mes 1..12
	 * @param ano ano com quatro digitos
	 * @return Data no formato SQL
	 */
	public String fmt(int dia, int mes, int ano) {
		Calendar Cl = Calendar.getInstance();
		Cl.set(ano, mes - 1, dia);
		java.sql.Date d = new java.sql.Date(Cl.getTime().getTime());
		return formatar(d);
	}

	/**
	 * Formata numa String uma Data SQL
	 * 
	 * @param data Data SQL
	 * @return String formatada para ser usada na clausula 'WHERE'
	 */
	public String formatar(final java.sql.Date data) {
		Calendar C = Calendar.getInstance();
		C.setTime(data);
		SimpleDateFormat formatar = new SimpleDateFormat("MM/dd/yyyy");
		switch (sgbd) {
		case MySQL:
		case MSSqlServer:
			formatar = new SimpleDateFormat("yyyy-MM-dd");
			return "'" + formatar.format(data) + "'";
		default:
			return "'" + data.toString() + "'"; // yyyy-MM-dd
		}
		/*
		 * -- Exemplo de inserção de datas no SQL Server 2000
		 * 
		 * DROP TABLE X GO SET NOCOUNT ON CREATE TABLE X(D DATETIME)
		 * 
		 * INSERT INTO X VALUES ('19561030') INSERT INTO X VALUES ('561030') INSERT INTO
		 * X VALUES ('10/30/1956') INSERT INTO X VALUES ('10/30/56') INSERT INTO X
		 * VALUES ('30 OCT 1956') INSERT INTO X VALUES ('30 OCT 56') INSERT INTO X
		 * VALUES ('OCT 30 1956') INSERT INTO X VALUES ('OCT 30, 1956') INSERT INTO X
		 * VALUES ('OCT 30, 56') INSERT INTO X VALUES ('OCTOBER 10, 1956') SELECT * FROM
		 * X
		 */
	}

	/**
	 * Deveolve true se o argumento for um código de um tipo SQL associado a uma
	 * data ou data/hora
	 * 
	 * @param tipo
	 * @return true se o tipo for uma data ou data/hora
	 */
	public boolean isTime(int tipo) {
		/*
		 * TIME | java.sql.Time | getTime( ) | 92 TIMESTAMP | java.sql.Timestamp |
		 * getTimestamp( ) | 93
		 */
		return tipo == 92 || tipo == 93;
	}

	/**
	 * Deveolve true se a coluna tiver a configuração com a indicação de 'Update'
	 * 
	 * @param Colunas
	 * 
	 * @param tipo
	 * @return true se o padrão "_u" for encontrado
	 */
	public boolean isEditable(String Colunas) {
		return Colunas.startsWith("_u");
	}

	/**
	 * Deveolve true se a coluna da chave primária tiver a configuração com a
	 * indicação de 'Insert'
	 * 
	 * @param Colunas
	 * 
	 * @param Tabela
	 * @return true se o padrão "_i" ou "_a" for encontrado
	 */
	public boolean isInsertable(String Colunas) {
		return Colunas.startsWith("_i") || Colunas.startsWith("_a");
	}

	/**
	 * Deveolve true se a coluna da chave primária tiver a configuração com a
	 * indicação de 'Delete'
	 * 
	 * @param Colunas
	 * 
	 * @param Tabela
	 * @return true se o padrão "_d" ou "_a" for encontrado
	 */
	public boolean isDeletable(String Colunas) {
		return Colunas.startsWith("_d") || Colunas.startsWith("_a");
	}

	/**
	 * Deveolve true se a coluna tiver a configuração com a indicação de 'Primary
	 * Key' se tiver '_p' indica que a coluna pertence simplesmente á chave primária
	 * se tiver '_a' indica que pertence à chave e que a tabela suporta deletes e
	 * inserts se tiver '_i' indica que pertence à chave e que a tabela suporta
	 * inserts se tiver '_d' indica que pertence à chave e que a tabela suporta
	 * deletes
	 * 
	 * @param Colunas
	 * 
	 * @param tipo
	 * @return true se o padrão "_p" for encontrado
	 */
	public boolean isPrimaryKey(String Colunas) {
		return Colunas.startsWith("_p") || Colunas.startsWith("_a") || Colunas.startsWith("_i")
				|| Colunas.startsWith("_d");
	}

	/**
	 * Deveolve true se o argumento for um número
	 * 
	 * @param tipo
	 * @return true se o tipo for um número
	 */
	public boolean isNumero(int tipo) {
		/*
		 * NUMERIC | java.math.BigDecimal | getBigDecimal( ) | 2 DECIMAL |
		 * java.math.BigDecimal | getBigDecimal( ) | 3 BIT | Boolean (boolean) |
		 * getBoolean( ) | -7 TINYINT | Integer (byte) | getByte( ) | -6 SMALLINT |
		 * Integer (short) | getShort( ) | 5 INTEGER | Integer (int) | getInt( ) | 4
		 * BIGINT | Long (long) | getLong( ) | -5 REAL | Float (float) | getFloat( ) | 7
		 * FLOAT | Double (double) | getDouble( ) | 6 DOUBLE | Double (double) |
		 * getDouble( ) | 8
		 */
		return tipo == 2 || tipo == 3 || tipo == -7 || tipo == -6 || tipo == 5 || tipo == 4 || tipo == -5 || tipo == 7
				|| tipo == 6 || tipo == 8;
	}

	/**
	 * Deveolve true se o argumento for um código de um tipo SQL associado a Strings
	 * 
	 * @param tipo
	 * @return true se o tipo for String
	 */
	public boolean isChar(int tipo) {
		/*
		 * SQL Data Type | Java Type | getXXX( ) Method | Numeric Code CHAR | String |
		 * getString( ) | 1 VARCHAR | String | getString( ) | 12 LONGVARCHAR | String |
		 * getString( ) | -1
		 */
		return tipo == 1 || tipo == 12 || tipo == -1;
	}

	/**
	 * @param valor dado a ser formatado
	 * @param tipo  tipo de dados SQL
	 * @param tnome mome do tipo de dados SQL
	 * @return um String formatado para ser escrito na base de dados
	 */
	public String fmTipo(Object valor, int tipo, String tnome) {

		/*
		 * http://www.oreilly.com/catalog/jentnut2/chapter/ch02.html SQL Data Type |
		 * Java Type | getXXX( ) Method | Numeric Code CHAR | String | getString( ) | 1
		 * VARCHAR | String | getString( ) | 12 LONGVARCHAR | String | getString( ) | -1
		 * NUMERIC | java.math.BigDecimal | getBigDecimal( ) | 2 DECIMAL |
		 * java.math.BigDecimal | getBigDecimal( ) | 3 BIT | Boolean (boolean) |
		 * getBoolean( ) | -7 TINYINT | Integer (byte) | getByte( ) | -6 SMALLINT |
		 * Integer (short) | getShort( ) | 5 INTEGER | Integer (int) | getInt( ) | 4
		 * BIGINT | Long (long) | getLong( ) | -5 REAL | Float (float) | getFloat( ) | 7
		 * FLOAT | Double (double) | getDouble( ) | 6 DOUBLE | Double (double) |
		 * getDouble( ) | 8 BINARY | byte[] | getBytes( ) | -2 VARBINARY | byte[] |
		 * getBytes( ) | -3 LONGVARBINARY | byte[] | getBytes( ) | -4 DATE |
		 * java.sql.Date | getDate( ) | 91 TIME | java.sql.Time | getTime( ) | 92
		 * TIMESTAMP | java.sql.Timestamp | getTimestamp( ) | 93 BLOB | java.sql.Blob |
		 * getBlob( ) | CLOB | java.sql.Clob | getClob( ) |
		 * 
		 */

		// System.out.println("->"+valor.getClass()+" SQL:"+tipo+" - "+tnome);
		if (valor == null || valor.toString().length() == 0)
			return "NULL";
		if (isTime(tipo)) { // Horas
			java.sql.Timestamp t = (java.sql.Timestamp) valor;
			return formatar(new java.sql.Date(t.getTime()));
		}
		if (tipo == 91) // Data
			return formatar((java.sql.Date) valor);
		if (isChar(tipo))
			return "'" + valor.toString() + "'";
		return valor.toString();
	}

	/**
	 * Retorna o nome do driver JDBC
	 * 
	 * @return nome do driver JDBC
	 */
	public String getDRV() {
		return drv;
	}

	/**
	 * Retorna a palavra passe do utilizador da base de dados
	 * 
	 * @return palavra passe do utilizador da base de dados
	 */
	public String getPWD() {
		return pwd;
	}

	/**
	 * Retorna o identificador do tipo de gestor de base de dados
	 * 
	 * @return identificador do tipo de gestor de base de dados
	 */
	public SGBD getSGBD() {
		return sgbd;
	}

	/**
	 * Retorn o URL que permite aceder à base de dados
	 * 
	 * @return URL para acesso á base de dados
	 */
	public String getURL() {
		return url;
	}

	/**
	 * Retorna o nome do utilizador da base de dados
	 * 
	 * @return Nome do utilizador da base de dados
	 */
	public String getUSR() {
		return usr;
	}

	/**
	 * Altera o nome do driver JDBC
	 * 
	 * @param str Novo driver JDBDC
	 */
	public void setDRV(final String str) {
		if (str != null)
			drv = str;
	}

	/**
	 * Altera a palavra passe do utilizador da base de dados
	 * 
	 * @param str Palavra passe do utilzador da base de dados
	 */
	public void setPWD(final String str) {
		if (str != null)
			pwd = str;
	}

	/**
	 * Altera o tipo de sistema de base de dados
	 * 
	 * @param aSGBD Tipo de sistema de base de dados
	 */
	public void setSGBD(final SGBD aSGBD) {
		sgbd = aSGBD;
	}

	/**
	 * Altera o URL que permite aceder á base de dados
	 * 
	 * @param str Novo URL JDBC
	 */
	public void setURL(final String str) {
		if (str != null)
			url = str;
	}

	/**
	 * Altera o nome do utilizador da base de dados
	 * 
	 * @param str Nome do utilizador da base de dados
	 */
	public void setUSR(final String str) {
		if (str != null)
			usr = str;
	}

	public Connection getConnection() {
		Connection con = null;
		try {
			Class.forName(drv);
			con = DriverManager.getConnection(url, usr, pwd);
			// por omissão já devia estar assim
			// con.setAutoCommit(true);
			// con.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
		} catch (ClassNotFoundException cnfe) {
			System.out.println("Não é possível carregar o Driver JDBC " + drv + ",");
			System.out.println("Verifique a propriedade classpath");
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println(e.toString());
		} catch (Exception e) {
			System.err.println(e.toString());
			System.err.println("Não é possivel estabelecer a ligação com a base de dados.");
			System.err.println("Verifique o Host/ IP e a autenticação\r\n");
			System.out.println("Veja as mensagens seguintes com uma descrição completa do erro.");
			e.printStackTrace();
		}
		return con;
	}
}
