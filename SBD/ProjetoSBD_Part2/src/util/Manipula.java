package util;

import java.math.BigDecimal;
import java.sql.BatchUpdateException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

/**
 * @author Engº Porfírio Filipe
 */
public class Manipula {
	private Connection con = null;

	private boolean done = false;

	private String drv = null;

	private int linhasAfectadas = -1;

	private String pwd = null;

	private ResultSet res = null;

	private Statement stm = null;

	private String url = null;

	private String usr = null;

	/**
	 * Construtor para estabelecer a configuração de acesso á base de dados a partir
	 * de um objecto da classe Configura
	 * 
	 * @param cfg Objecto com a configuração
	 */
	public Manipula(Configura cfg) {
		setDRV(cfg.getDRV());
		setURL(cfg.getURL());
		setUSR(cfg.getUSR());
		setPWD(cfg.getPWD());
		Register();
	}

	/**
	 * Construtor para estabelecer a configuração de acesso á base de dados
	 * 
	 * @param dvr Driver JDC
	 * @param url URL para acesso á base de dados
	 * @param usr Utilizador da base de dados
	 * @param pwd Palavra pass do utilizador da base de dados
	 */
	public Manipula(final String dvr, final String url, final String usr, final String pwd) {
		setDRV(drv);
		setURL(url);
		setUSR(usr);
		setPWD(pwd);
		Register();
	}

	/**
	 * Fecha a conexão e a directiva associada á classe. Deve fazer-se sempre que
	 * termine o acesso aos dados.
	 * 
	 * @return true se correu tudo bem
	 */
	public boolean desligar() {
		linhasAfectadas = -1;
		try {
			if (res != null) {
				res.close();
				res = null;
			}
			if (stm != null) {
				stm.close();
				stm = null;
			}
			if (con != null && !con.isClosed()) {
				/*
				 * if(!con.getAutoCommit()) con.commit();
				 */
				con.close();
				con = null;
			}
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println(e.toString());
			return false;
		}
	}

	/**
	 * Tenta excutar em 'Batch' um conjunto de directivas SQL, caso não sejam
	 * suportados 'Batch' executa as directivas separadamente. As directivas são
	 * enviadas em bloco para o sistema de gestão de base de dados, o que melhora a
	 * performance.
	 * 
	 * @param directivas Conjunto de directivas SQL (não pode ter SELECT)
	 * @return true se tudo correr bem
	 */
	public boolean executaBatch(String directivas[]) {
		DatabaseMetaData dbmd;
		boolean ok = false;
		Statement stmt = getDirectiva();
		try {
			dbmd = getLigacao().getMetaData();
			ok = dbmd.supportsBatchUpdates();
			if (ok)
				stmt.clearBatch();
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println("SQLException: " + e.getMessage());
			System.err.println("Falhou a consulta da metada e/ou não existe suporte para a execução de 'batch'.");
		}
		if (ok) {
			for (int i = 0; i < directivas.length; i++) {
				try {
					stmt.addBatch(directivas[i]);
				} catch (SQLException e) {
					e.printStackTrace();
					System.err.println("SQLException: " + e.getMessage());
					System.err.println("Falhou o add batch." + directivas[i]);
					return false;
				}
			}
			try {
				int[] numUpdates = stmt.executeBatch();
				for (int i = 0; i < numUpdates.length; i++) {
					if (numUpdates[i] == -2)
						Consola.writeLine("Directiva " + i + ": numero desconhecido de linhas actualizadas");
					else if (numUpdates[i] == 1)
						Consola.writeLine("Directiva " + i + " sucesso: 1 linha actualizada");
					else
						Consola.writeLine("Directiva " + i + " sucesso: " + numUpdates[i] + " linhas actualizadas");
				}
			} catch (BatchUpdateException e) {
				e.printStackTrace();
				System.err.println("BatchUpdateException: " + e.getMessage());
				System.err.println("Falhou a execução de uma das directivas.");
				return false;
			} catch (SQLException e) {
				e.printStackTrace();
				System.err.println("SQLException: " + e.getMessage());
				System.err.println("Erro de acesso à base de dados.");
				return false;
			}
		} else {
			System.err.print("O Driver não suporta a execução de directivas em 'batch'");
			System.err.println("O processamento vai ser feito executando directivas separadas");
			for (int i = 0; i < directivas.length; i++) {
				try {
					stmt.executeUpdate(directivas[i]);
				} catch (SQLException e) {
					e.printStackTrace();
					System.err.println("SQLException: " + e.getMessage());
					System.err.println("Falhou o executeUpdate." + directivas[i]);
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * Exporta o conteudo de uma tabela
	 * 
	 * @param tabela
	 * @return true se tudo correr bem
	 */
	public boolean exportar(String tabela) {
		try {
			ResultSet rs = getResultado("SELECT * FROM " + tabela);
			ResultSetMetaData rsmd = rs.getMetaData();
			int cols = rsmd.getColumnCount();
			int dimcols[] = new int[cols];
			int typecols[] = new int[cols];
			String typenames[] = new String[cols];
			String colNames = "";
			for (int i = 0; i < cols; i++) {
				String aux = rsmd.getColumnLabel(i + 1);
				dimcols[i] = rsmd.getColumnDisplaySize(i + 1);
				typecols[i] = rsmd.getColumnType(i + 1);
				typenames[i] = rsmd.getColumnTypeName(i + 1);
				colNames = colNames + aux + ", ";
			}
			colNames = colNames.substring(0, colNames.length() - 2);
			Configura cfg = new Configura();
			while (rs.next()) {
				String Insert = "INSERT INTO " + tabela + " (" + colNames + ") VALUES (";
				for (int i = 1; i <= cols; i++) {
					Insert = Insert + cfg.fmTipo(rs.getObject(i), typecols[i - 1], typenames[i - 1]) + ", ";
				}
				Insert = Insert.substring(0, Insert.length() - 2) + ");";
				System.out.println(Insert);
				Consola.escFile(Insert);
			}
			return true;
		} catch (SQLException e) {
			System.err.println("\r\nAn Occoreu um erro na execução da exportação..");
			System.err.println("Ver detalhes baixo:\r\n");
			e.printStackTrace();
			System.err.println("-----SQLException-----");
			System.err.println("SQLState:  " + e.getSQLState());
			System.err.println("Message:  " + e.getMessage());
			System.err.println("Vendor:  " + e.getErrorCode());
			return false;
		} catch (Exception e) {
			System.err.println("\r\nAn Occoreu um erro na execução da exportação..");
			System.err.println("Ver detalhes baixo:\r\n");
			e.printStackTrace();
			System.err.println("-----Exception-----");
			System.err.println("Message:  " + e.getMessage());
			return false;
		}
	}

	/**
	 * Lista as tabelas existentes na base de dados.
	 */
	public void getTabelas() {
		/*
		 * Retrieves a description of the tables available in the given catalog. Only
		 * table descriptions matching the catalog, schema, table name and type criteria
		 * are returned. They are ordered by TABLE_TYPE, TABLE_SCHEM and TABLE_NAME.
		 * Each table description has the following columns:
		 * 
		 * TABLE_CAT String => table catalog (may be null) TABLE_SCHEM String => table
		 * schema (may be null) TABLE_NAME String => table name TABLE_TYPE String =>
		 * table type. Typical types are "TABLE", "VIEW", "SYSTEM TABLE", "GLOBAL
		 * TEMPORARY", "LOCAL TEMPORARY", "ALIAS", "SYNONYM".
		 * 
		 * Note: Some databases may not return information for all tables.
		 */
		ResultSet rsTables;
		String catalog = null;
		String schema = "%";
		String table = "%";
		String[] types = new String[] { "TABLE" };
		try {
			DatabaseMetaData dmd = getLigacao().getMetaData();
			rsTables = dmd.getTables(catalog, schema, table, types);
			while (rsTables.next()) {
				String Linha = rsTables.getString("TABLE_NAME");
				String Comentario = rsTables.getString("REMARKS");
				if (Comentario != null)
					Linha = Linha + " - " + Comentario;
				Consola.writeLine(Linha);
			}
		} catch (SQLException e) {
			System.err.println("\r\nAn Occoreu um erro na execução..");
			System.err.println("Ver detalhes baixo:\r\n");
			e.printStackTrace();
			System.err.println("-----SQLException-----");
			System.err.println("SQLState:  " + e.getSQLState());
			System.err.println("Message:  " + e.getMessage());
			System.err.println("Vendor:  " + e.getErrorCode());
		}
	}

	/**
	 * Retorna uma mensagem relativa ao número de linhas afectadas na execução da
	 * ultima 'executeUpdate'
	 * 
	 * @return mensagem relativa ao número de linhas afectadas
	 */
	public String getAfectadas() {
		switch (linhasAfectadas) {
		case -1:
			return "Não foi afectada nenhuma linha.";
		case 0:
			return "Não foram afectadas linhas.";
		case 1:
			return "Foi afectada uma linha.";
		default:
			return "Foram afectadas " + linhasAfectadas + " linhas.";
		}
	}

	/**
	 * Devolve a instrução associada á conexão
	 * 
	 * @return instrução corrente
	 */
	public Statement getDirectiva() {
		try {
			if (stm == null) {
				if (con == null)
					getLigacao();
				stm = con.createStatement();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println(e.toString());
			desligar();
		}
		return stm;
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
	 * Devolve a conexão á base de dados
	 * 
	 * @return conexão corrente
	 */
	public Connection getLigacao() {
		Register();
		try {
			if (con == null || con.isClosed()) {
				con = DriverManager.getConnection(url, usr, pwd);
				// con.setAutoCommit(false);
				// con.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println(e.toString());
			desligar();
		}
		return con;
	}

	/**
	 * Desfaz a transacção
	 */
	public boolean roolback() {
		try {
			if (con == null || con.isClosed())
				return false;
			con.rollback();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Consolida a transacção
	 */
	public boolean commit() {
		try {
			if (con == null || con.isClosed())
				return false;
			con.rollback();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Altera o modo autommit
	 */
	public boolean setAutoCommit(boolean modo) {
		try {
			if (con == null || con.isClosed())
				return false;
			con.setAutoCommit(modo);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Retorna a palavra pass do utilizador da base de dados
	 * 
	 * @return palavra pass do utilizador da base de dados
	 */
	public String getPWD() {
		return pwd;
	}

	/**
	 * Retorna as linhas associadas ao resultado da execução da interrogação SQL
	 * 
	 * @param interroga directiva SQL SELECT
	 * @return linhas do resultado
	 */
	public ResultSet getResultado(String interroga) {
		try {
			if (res != null) {
				res.close();
				res = null;
			}
			if (getDirectiva() != null) {
				res = stm.executeQuery(interroga);
			}
		} catch (Exception e) {
			System.err.println("Exception: " + e.getMessage());
		}
		return res;
	}

	/**
	 * @param directiva
	 * @return O objecto java presente no resulset
	 * @throws SQLException
	 */
	public Object getVObject(String directiva) throws SQLException {
		getResultado(directiva);
		if (res.next())
			return res.getObject(1);
		return null;
	}

	/**
	 * @param directiva directiva SQL SELECT
	 * @return A String presente no resulset
	 * @throws SQLException
	 */
	public String getVString(String directiva) throws SQLException {
		getResultado(directiva);
		if (res.next())
			return res.getString(1);
		return null;
	}

	/**
	 * @param directiva directiva SQL SELECT
	 * @return A data SQL presente no resultset
	 * @throws SQLException
	 */
	public java.sql.Date getVDate(String directiva) throws SQLException {
		getResultado(directiva);
		if (res.next())
			return res.getDate(1);
		return null;
	}

	/**
	 * @param directiva directiva SQL SELECT
	 * @return O valor numério presente no resultset
	 * @throws SQLException
	 */
	public BigDecimal getBigVDecimal(String directiva) throws SQLException {
		getResultado(directiva);
		if (res.next())
			return res.getBigDecimal(1);
		return null;
	}

	/**
	 * @param directiva directiva SQL SELECT
	 * @return O Vector dos elementos presentes na linha do 'ResulSet'
	 * @throws SQLException
	 */
	public Vector<Object> getLVector(String directiva) throws SQLException {
		getResultado(directiva);
		ResultSetMetaData rsmd = res.getMetaData();
		int cols = rsmd.getColumnCount();
		Vector<Object> linha = new Vector<Object>(cols);
		if (res.next())
			for (int i = 1; i <= cols; i++) {
				linha.add(res.getObject(i));
			}
		return linha;
	}

	/**
	 * @param directiva directiva SQL SELECT
	 * @return O Vector dos elementos presentes na coluna 'ResulSet'
	 * @throws SQLException
	 */
	public Vector<Object> getCVector(String directiva) throws SQLException {
		getResultado(directiva);
		ResultSetMetaData rsmd = res.getMetaData();
		int cols = rsmd.getColumnCount();
		Vector<Object> coluna = new Vector<Object>(cols);
		while (res.next())
			coluna.add(res.getObject(1));
		return coluna;
	}

	/**
	 * Retorna o URL que permite aceder à base de dados
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
	 * Devolve true se na sequencia da execucao 'executeUpdate' alguma linha foi
	 * afectada. No caso da execução de isntruções SQL DDL (CREATE, ALTER, DROP) é
	 * sempre devolvido false
	 * 
	 * @return true se foi afectada alguma linha
	 */
	public boolean isUpdated() {
		return linhasAfectadas > 0;
	}

	/**
	 * Regista uma única vez o driver JDBC para efectuar o acesso á base de dados
	 */
	public void Register() {
		if (!done)
			try {
				Class.forName(drv);
				done = true;
			} catch (ClassNotFoundException cnfe) {
				System.out.println("Não é possível carregar o Driver JDBC '" + drv + ",");
				System.out.println("Verifique a propriedade classpath");
				con = null;
			} catch (Exception e) {
				System.err.println(e.toString());
				System.err.println("Não é possivel estabelecer a ligação com a base de dados.");
				System.err.println("Verifique o Host/ IP e a autenticação\r\n");
				System.out.println("Veja as mensagens seguintes com uma descrição completa do erro.");
				e.printStackTrace();
				desligar();
			}
	}

	/**
	 * Altera o nome do driver JDBC
	 * 
	 * @param str Novo driver JDBDC
	 */
	public void setDRV(String str) {
		if (str != null)
			drv = str;
	}

	/**
	 * Altera a palavra passe do utilizador da base de dados
	 * 
	 * @param str Palavra passe do utilzador da base de dados
	 */
	public void setPWD(String str) {
		if (str != null)
			pwd = str;
	}

	/**
	 * Altera o URL que permite aceder á base de dados
	 * 
	 * @param str Novo URL JDBC
	 */
	public void setURL(String str) {
		if (str != null)
			url = str;
	}

	/**
	 * Altera o nome do utilizador da base de dados
	 * 
	 * @param str Nome do utilizador da base de dados
	 */
	public void setUSR(String str) {
		if (str != null)
			usr = str;
	}

	/**
	 * Executa a directiva indicada em argumento usando a conexção e instrução
	 * corrente
	 * 
	 * @param directivaSQL Directiva SQL DML (INSERT, UPDATE, DELETE) SQL DDL
	 *                     (CREATE, ALTER, DROP)
	 * @return true se tudo correu bem
	 */
	public boolean xDirectiva(String directivaSQL) {
		return xDirectivaMsg(directivaSQL, null, null);
	}

	/**
	 * Executa a directiva indicada em argumento usando a conexção e instrução
	 * corrente
	 * 
	 * @param directivaSQL DirectivaSQL directiva SQL DML (INSERT, UPDATE, DELETE)
	 *                     SQL DDL (CREATE, ALTER, DROP)
	 * @param msgSucesso   Mensagem apresentada na consola se correr tudo bem
	 * @param msgInSucesso Mensagem apresentada na consola se ocorrer um erro
	 * @return true se correr tudo bem
	 */
	public boolean xDirectivaMsg(String directivaSQL, String msgSucesso, String msgInSucesso) {
		try {
			if (getDirectiva() != null) {
				if (res != null) {
					res.close();
					res = null;
				}
				// Consola.writeLine(directivaSQL);
				linhasAfectadas = stm.executeUpdate(directivaSQL);
				Consola.writeLine(msgSucesso);
				Consola.writeLine(getAfectadas());
				return true;
			}
			return false;
		} catch (Exception e) {
			System.err.println("SQLException: " + e.getMessage());
			if (msgInSucesso == null)
				Consola.writeLine(directivaSQL);
			else
				Consola.writeLine(msgInSucesso);
			return false;
		}
	}

}