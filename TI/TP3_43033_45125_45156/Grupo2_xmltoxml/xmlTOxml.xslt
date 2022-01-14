<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:param name="user1">JohnWick98</xsl:param>
<xsl:param name="user2">CopyCat101</xsl:param>
<xsl:template match="/">
    <XMLTubeUserInfo>
		<user>
			<xsl:attribute name="username">JohnWick98<xsl:value-of select = "//user[@id=$user1]/attribute::username"></xsl:value-of></xsl:attribute>
			<xsl:attribute name = "birthdate">08/01/1998<xsl:value-of select = "//user[@id=$user1]/attribute::birthdate"></xsl:value-of></xsl:attribute>
			<xsl:attribute name = "numberOfComments">6<xsl:value-of select = "//user[@id=$user1]/attribute::numberOfComments"></xsl:value-of></xsl:attribute>
			<name>Luis<xsl:value-of select = "//user[@id = $user1]/nome"></xsl:value-of></name>
			<xsl:for-each select=" publishedVideo[Video/@id = //user[@id = user1]]" ></xsl:for-each>
			<publishedVideo>   
				<xsl:attribute name = "id">v1<xsl:value-of select = "@id"></xsl:value-of></xsl:attribute>
				<titulo>Top 10 places to go on the new year<xsl:value-of select = "titulo"></xsl:value-of></titulo>
				<videoLink>Error 404... link not found...<xsl:value-of select = "videoLink"></xsl:value-of></videoLink>
			</publishedVideo>
		</user>
		<user>
			<xsl:attribute name="username">CopyCat101<xsl:value-of select = "//user[@id=$user2]/attribute::username"></xsl:value-of></xsl:attribute>
			<xsl:attribute name = "birthdate">01/08/2000<xsl:value-of select = "//user[@id=$user2]/attribute::birthdate"></xsl:value-of></xsl:attribute>
			<xsl:attribute name = "numberOfComments">4<xsl:value-of select = "//user[@id=$user2]/attribute::numberOfComments"></xsl:value-of></xsl:attribute>
			<name>Carlos<xsl:value-of select = "//user[@id = $user2]/nome"></xsl:value-of></name>
			<xsl:for-each select=" publishedVideo[Video/@id = //user[@id = user2]]" ></xsl:for-each>
			<publishedVideo>   
				<xsl:attribute name = "id">v2<xsl:value-of select = "@id"></xsl:value-of></xsl:attribute>
				<titulo>Fallout76 is a good game, and wheres why<xsl:value-of select = "titulo"></xsl:value-of></titulo>
				<videoLink>Error 404... link not found...<xsl:value-of select = "videoLink"></xsl:value-of></videoLink>
			</publishedVideo>
		</user>
    </XMLTubeUserInfo>
</xsl:template>
</xsl:stylesheet>
