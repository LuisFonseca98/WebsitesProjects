package util;

import java.io.*;
import java.math.BigDecimal;
/*
 * Implementa funcionalidades de acesso á consola
 */
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.jsp.*;

/**
 * Encapsula o acesso á consola Java
 * 
 * @author Engº Porfírio Filipe
 */
final public class Consola {

	private static BufferedReader br = null;

	final static private String inFormat = "dd/MM/yyyy";

	static private SimpleDateFormat inFormatar = new SimpleDateFormat(inFormat);

	final static private String outFormat = "EEE dd MMM yyyy";

	private static String file = null; // ficheiro de esrita por omissão

	static private SimpleDateFormat outFormatar = new SimpleDateFormat(outFormat);
	static {
		try {
			br = new BufferedReader(new InputStreamReader(System.in));
		} catch (Exception exp) {
			System.err.println("Erro no acesso ao Standard Input");
		}
	}

	/**
	 * Converte um Calendário para String no formato do ecrã
	 * 
	 * @param data Calendário
	 * @return String no formato de data do ecrã
	 */
	static public String CalendarToString(Calendar data) {
		return outFormatar.format(data);
	}

	/**
	 * Formata a nota do aluno
	 * 
	 * @param nota nota do aluno
	 * @return a nota formatada com dois digitos inteiros e dois decimais,
	 *         completando eventuais zeros às esquerda
	 */
	static public String NotaToString(BigDecimal nota) {
		NumberFormat formatter = new DecimalFormat("00.00");
		return formatter.format(nota);
	}

	/**
	 * Converte uma Data SQL para String no formato do ecrã
	 * 
	 * @param data Data SQL
	 * @return String no formato do ecrã
	 */
	static public String DateToString(java.sql.Date data) {
		return outFormatar.format(data);
	}

	/**
	 * Retorna uma String com a dimensão 'dim' obtido por concatenação de espaços na
	 * String 'str'
	 * 
	 * @param str String original
	 * @param dim Dimensão final
	 * @param ch  Character tipicamente ' '
	 * @return String com espaços
	 */
	public static String fill(String str, int dim, String ch) {
		if (str != null)
			while (dim > str.length())
				str = str + ch;
		return str;
	}

	/**
	 * Muda o path do ficheiro por omissão
	 * 
	 * @param str Linha a escrever no ficheiro
	 */
	public static void setFile(String str) {
		file = str;
	}

	/**
	 * Escreve no ficheiro indicado por omissão o String str
	 * 
	 * @param str Linha a escrever no ficheiro
	 */
	public static void escFile(String str) {
		if (file == null || file.length() == 0)
			return;
		PrintWriter bulksavwriter = null;
		try {
			bulksavwriter = new PrintWriter(new BufferedWriter(new FileWriter(file, true)));
		} catch (IOException e) {
			e.printStackTrace();
		}
		bulksavwriter.println(str);
		bulksavwriter.close();
	}

	/**
	 * Pergunta ao utilizador o ano de funcionamento da disciplina
	 * 
	 * @return o ano de funcionamento da disciplina indicado pelo utilizador
	 */
	@SuppressWarnings("deprecation")
	public static Integer getCAnoDis() {
		String a = null;
		Integer ano = null;
		do {
			Consola.writeLine("Indique o ano de funcionamento da disciplina:");
			a = Consola.readLine();
			a = a.trim();
			try {
				ano = new Integer(a);
			} catch (NumberFormatException e) {
				continue;
			}
		} while (a.length() > 4 || a.length() == 0 || ano == null);
		return ano;
	}

	/**
	 * Pergunta ao utilizador o código da disciplina
	 * 
	 * @return código da disciplina indicada pelo utilizador
	 */
	public static String getCCodDis() {
		String codigo = null;
		do {
			Consola.writeLine("Indique o código da disciplina (max. 4 caracteres):");
			codigo = Consola.readLine();
			codigo = codigo.trim();
		} while (codigo.length() > 4 || codigo.length() == 0);
		return codigo;
	}

	/**
	 * Pergunta ao utilizador a designação da disciplina
	 * 
	 * @return a designação da disciplina indicada pelo utilizador
	 */
	public static String getCDsgDis() {
		String designacao = null;
		do {
			Consola.writeLine("Indique a nova designação (max. 60 caracteres):");
			designacao = Consola.readLine();
			designacao = designacao.trim();
		} while (designacao.length() > 60 || designacao.length() == 0);
		return designacao;
	}

	/**
	 * Pergunta ao utilizador o nome do aluno
	 * 
	 * @return o nome do aluno indicado pelo utilizador
	 */
	public static String getCNome() {
		String nome = null;
		do {
			Consola.writeLine("Indique o novo nome (max. 100 caracteres):");
			nome = Consola.readLine();
			nome = nome.trim();
		} while (nome.length() > 100 || nome.length() == 0);
		return nome;
	}

	/**
	 * Pergunta ao utilizador a nota do aluno.
	 * 
	 * @return a nota do aluno indicada pelo utilizador
	 */
	public static BigDecimal getCNotaDis() {
		String nt = null;
		BigDecimal nota = null;
		do {
			Consola.writeLine("Indique a nota [0.0...20.0]:");
			nt = Consola.readLine();
			nt = nt.trim();
			try {
				nota = new BigDecimal(nt);
			} catch (NumberFormatException e) {
				continue;
			}
		} while (nt.length() > 4 || nt.length() == 0 || nota == null || nota.floatValue() > 20.0
				|| nota.floatValue() < 0.0);
		return nota;
	}

	/**
	 * Pergunta ao utilizador o número do aluno
	 * 
	 * @return Número do aluno indicado pelo utilizador
	 */
	@SuppressWarnings("deprecation")
	public static Integer getCNumAl() {
		String num = null;
		Integer numero = null;
		do {
			Consola.writeLine("Indique o número do aluno (max. 5 caracteres):");
			num = Consola.readLine();
			num = num.trim();
			try {
				numero = new Integer(num);
			} catch (NumberFormatException e) {
				continue;
			}
		} while (num.length() > 5 || num.length() == 0 || numero == null);
		return numero;
	}

	/**
	 * Pergunta ao utilizador o género do aluno
	 * 
	 * @return género do aluno indicado pelo utilizador
	 */

	public static String getCGenAl() {
		String genero = null;
		do {
			Consola.writeLine("Indique o género do aluno (M/F):");
			genero = Consola.readLine();
			if (genero != null && genero.length() == 1)
				genero = genero.substring(0, 1).toUpperCase();
		} while (genero.compareTo("M") != 0 && genero.compareTo("F") != 0);
		return genero;
	}

	/**
	 * Pergunta ao utilizador a data de nascimento do aluno
	 * 
	 * @return data de nascimento do aluno indicada pelo utilizador
	 */

	public static java.sql.Date getCNascAl() {
		String nascido = null;
		java.sql.Date parsed = null;
		do {
			Consola.writeLine("Indique a data de nascimento do aluno (" + Consola.getInFormato() + "):");
			nascido = Consola.readLine();
			try {
				parsed = Consola.StringToDate(nascido);
				break;
			} catch (ParseException e) {
				Consola.writeLine("O formato da data '" + nascido + "' é inválido (" + Consola.getInFormato() + ")");
			}
		} while (true);
		return parsed;
	}

	/**
	 * Retorna o formato de escrita da data fornecida pelo utilizador
	 * 
	 * @return Formato de escrita da data fornecida pelo utilizador
	 */
	static public String getInFormato() {
		return inFormat;
	}

	/**
	 * Retorna o formato de escrita da data no ecrã
	 * 
	 * @return Formato de escrita da data no ecrã
	 */
	static public String getOutFormato() {
		return outFormat;
	}

	/**
	 * Lê um caracter do Standard Input convertendo-o para minuscula. Se a linha for
	 * vazia devolve o caracter espaço.
	 * 
	 * @return Caracter lido
	 */
	public static char readChar() {
		String str = Consola.readLine().toLowerCase();
		if (str.length() > 0)
			return str.charAt(0);
		return ' ';
	}

	/**
	 * Lê uma linha do Standard Input
	 * 
	 * @return linha lida
	 */
	public static String readLine() {
		String line = "";
		try {
			line = br.readLine();
		} catch (Exception exp) {
			System.err.println("Erro na leitura de uma linha do Standard Input");
		}
		return line;
	}

	/**
	 * Converte uma String fornecida pelo utilizador para Calendário
	 * 
	 * @param data Data no formado fornecido pelo utilizador
	 * @return Calendário
	 * @throws ParseException Ocorreu um erro na análise da String data
	 */
	static public Calendar StringToCalendar(String data) throws ParseException {
		Calendar d = Calendar.getInstance();
		d.setTime(inFormatar.parse(data));
		return d;
	}

	/**
	 * Converte uma String fornecida pelo utilizador para Data SQL
	 * 
	 * @param data String fornecida pelo utilizador
	 * @return Data SQL
	 * @throws ParseException Ocorreu um erro na análise da String data
	 */
	static public java.sql.Date StringToDate(String data) throws ParseException {
		return new java.sql.Date(inFormatar.parse(data).getTime());
	}

	/**
	 * Escreve uma linha do Standard Output
	 * 
	 * @param line linha a ser escrita
	 */
	public static void writeLine(String line) {
		writeLine(line, null);
	}

	/**
	 * Escreve uma linha no Stream do Browser
	 * 
	 * @param line linha a ser escrita
	 */
	public static void writeLine(String line, JspWriter out) {
		if (line != null)
			if (out == null)
				System.out.println(line);
			else
				try {
					out.print(line + "<br>");
				} catch (IOException e) {
					e.printStackTrace();
				}
	}

	public static String ValorD(String valor, String delimitador) {
		if (valor == null || valor.compareTo("null") == 0)
			return "NULL";
		else
			return delimitador + valor + delimitador;
	}

	public static String ValorS(String valor) {
		return ValorD(valor, "'");
	}

	public static String Valor(String valor) {
		return ValorD(valor, "");
	}

	public static String IgualS(String atributo, String valor) {
		if (valor == null || valor.compareTo("null") == 0)
			return " " + atributo + " IS NULL";
		else
			return " " + atributo + " = '" + valor + "'";
	}

	public static String Like(String atributo, String valor) {
		if (valor == null || valor.compareTo("null") == 0)
			return " " + atributo + " IS NULL";
		else
			return " " + atributo + " like '%" + valor + "%'";
	}

	public static String IgualV(String atributo, String valor) {
		if (valor == null || valor.compareTo("null") == 0 || valor.compareTo("") == 0)
			return " " + atributo + " IS NULL";
		else
			return " " + atributo + " = " + valor;
	}

	String designacao = Consola.getCDsgDis();
}
