package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Properties;
import java.util.Random;
import java.util.stream.Collectors;


	

	/*
	 * Java Program to to connect to MySQL database and
	 * fix java.sql.SQLException: No suitable driver found for jdbc:mysql://localhost:3306
	 * error which occur if JAR is missing or you fail to register driver.
	 */

public class teste {

  public static void ordenador(ArrayList<String[]> array) {
	  String[] valor = new String[5];
	  System.out.println("ORDENA ESTA PORRA");
	  ArrayList<String[]> arrayFinal = new ArrayList<String[]>();
	  for (int i = 0; i <5; i++) { 
		  int aux = 0;
          for (int j = i+1; j <5; j++) {  
        	  if(Integer.parseInt(array.get(i)[4]) > Integer.parseInt(array.get(j)[4])) {
        		  aux++;
        	  }
          }    
          System.out.println(aux);
          valor = array.get(aux);
          
//          arrayFinal.get(aux)[0] = array.get(i)[0];
//          arrayFinal.get(aux)[1] = array.get(i)[1];
//          arrayFinal.get(aux)[2] = array.get(i)[2];
//          arrayFinal.get(aux)[3] = array.get(i)[3];
//          arrayFinal.get(aux)[4] = array.get(i)[4];
          
      }
	
	  
  }

  public static void main(String[] args) throws ClassNotFoundException {

	  SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	  SimpleDateFormat formatter2= new SimpleDateFormat("yyyy");
	  Date date = new Date(System.currentTimeMillis());
	  System.out.println(formatter2.format(date));
	  
	  
	     Random rand = new Random(); 
	  
		int counter = 0;
		int number = 5;
		
		
		ArrayList<String[]> arrayFinal = new ArrayList<String[]>(); 
		String bloqueio = "7";
		while(counter < number){
			String[] arrayNormal = new String[5];
			
			
			arrayNormal[0] = String.valueOf(rand.nextInt(6));
			arrayNormal[1] = String.valueOf(rand.nextInt(6));
			arrayNormal[2] = String.valueOf(rand.nextInt(6));
			arrayNormal[3] = String.valueOf(rand.nextInt(6));
			arrayNormal[4] = String.valueOf(rand.nextInt(6));
			
			arrayFinal.add(counter, arrayNormal);
			bloqueio = "5";
			
			
			
			counter++;
			
			
		}
		
		for(int i = 0; i < 5; i++) {
			
			System.out.println(Arrays.toString(arrayFinal.get(i)));
		}
		
		System.out.println("#########################################################");
		

		
		Collections.sort(arrayFinal, new Comparator<String[]>() {
		    public int compare(String[] a, String[] b) {
		        return (a[a.length-1]).compareTo(b[b.length-1]);
		    }
		});
	
		for(int i = 0; i < 5; i++) {
			
			System.out.println(Arrays.toString(arrayFinal.get(i)));
		}
	
		

  }
}

////function insertComent(){
//<%
//String utilizador = request.getParameter("util");
//String Comentario = request.getParameter("comment");
//
//System.out.println(Comentario);
//
//if(Comentario != null){
//	String sqlComentario = "INSERT INTO comentario values ("+recursoID+", '"+utilizador+"', '"+Comentario+"');";
//	if(!manipula.xDirectiva(sqlComentario)){
//		System.out.println("Erro");
//	}
//}else{
//	System.out.println("Esta a null");
//}
//
//%>
//}

