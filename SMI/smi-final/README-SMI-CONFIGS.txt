Colocar ficheiro httpd-smi.conf na pasta ./apache/conf/extra/

Na diretoria ./apache/conf/ no ficheiro httpd.conf, 
na ultima linha adicionar o seguinte: 

	Include "conf/extra/httpd-smi.conf"
	
No netbeans botao direito por cima do projeto, Properties > Run Configuration
Em Project URL colocar o seguinte:
	
	http://localhost/examples-smi/nomeDoProjeto/
	
Em Index File, clicar em Browse e procurar por: 

	PaginaPrincipal/PaginaPrincipal.php	
	
Importar a base de dados para o PhpMyAdmin