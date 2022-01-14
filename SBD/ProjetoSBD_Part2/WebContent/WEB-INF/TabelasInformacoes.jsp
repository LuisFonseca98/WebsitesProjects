<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Tabela HTML</title>
</head>

<style>
table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
}

th, td {
	padding: 5px;
}

th {
	text-align: left;
}

#title {
	background-color: lightblue;
	color: black;
	padding: 40px;
	text-align: center;
}
</style>

<body>

	<h1>Informa��es de um recurso</h1>

	<p>Poss�vel tabela com as informa��es de um recurso</p>

	<table style="width: 100%">
		<tr id="title">
			<th>T�tulo</th>
			<th>Tipo</th>
			<th>Data</th>
			<th>Pontos</th>
		</tr>
		<tr>
			<td>Jill</td>
			<td>Smith</td>
			<td>50</td>
			<td>50</td>
		</tr>
		<tr>
			<td>Eve</td>
			<td>Jackson</td>
			<td>94</td>
			<td>50</td>
		</tr>
		<tr>
			<td>John</td>
			<td>Doe</td>
			<td>80</td>
			<td>50</td>
		</tr>
	</table>
</body>
</html>