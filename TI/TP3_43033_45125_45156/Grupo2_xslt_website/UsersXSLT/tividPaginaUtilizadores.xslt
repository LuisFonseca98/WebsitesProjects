<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
<xsl:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--<link rel="stylesheet" href="css/styling2.css" type="text/css"/>-->
<style type="text/css">
body {background: linear-gradient(to bottom, #000000 19%, #1c1d20 65%);}
a	 {color: white;font-size:2.5vw;}
p1   {color: rgb(199, 199, 199);font-size:2vw;}
p2   {color: red;font-size:2.5vw;}

.footer {color: rgb(187, 53, 53);font-size:2vw;}
.c2{font-size:1vw;}

.navbar ul { 
text-align: right; 
background-color: #000; 
text-decoration:none;
} 

.navbar ul li {  
display: inline; 
} 

.navbar ul li a { 
text-decoration: none; 
padding: .2em; 
color: #fff; 
background-color: #000; 
} 

.navbar ul li a:hover { 
color: #000; 
background-color: #fff; 
} 

.info{
color: white;
}
</style>
	<body>
	<h2>Utilizadores</h2>
	<div class="navbar"> 
<ul> 
<li><a href = "../home/Home">Home </a></li>
<li><a href = "../UsersXSLT/UsersGeral.xhtml">Utilizadores </a></li>
<li><a href = "../VideosXSLT/VideosGeral.xhtml">Vídeos</a></li>
<li><a href = "../PlayLitsXSLT/PlaylistsGeral.xhtml">Playlists</a></li>
</ul>
</div>
	<p1> Neste website encontra-se 4 utilizadores, em baixo encontra informacao acerca de cada utilizador, se pretende saber mais sobre os nossos utilizadores, carregue no link em baixo</p1>
	<br/>
	<br/>
	<hr/>
<div class = "info">
    <xsl:for-each select="//Tivid/utilizadores/utilizador[@id = 'U01']">
		<p2><xsl:value-of select="@username"/></p2> 
    <br/>
    <hr/>
    </xsl:for-each>
	<xsl:for-each select="//Tivid/utilizadores/utilizador[@id = 'U02']">
		<p2><xsl:value-of select="@username"/> </p2>
    <br/>
    <hr/>
    </xsl:for-each>
    <xsl:for-each select="//Tivid/utilizadores/utilizador[@id = 'U03']"> 
		<p2><xsl:value-of select="@username"/></p2> 
	<br/>
    <hr/>
    </xsl:for-each>
    <xsl:for-each select="//Tivid/utilizadores/utilizador[@id = 'U04']">
		<p2><xsl:value-of select="@username"/></p2>
	<br/>
	<hr/>
    </xsl:for-each>
    </div>
    <a href="/UsersDetail.xhtml">Pressione neste link se deseja saber mais informacoes sobre os nossos utilizadores</a> 
</body>
</html>
</xsl:template>
</xsl:stylesheet>
