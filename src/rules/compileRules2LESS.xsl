<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	<!-- Apply this on a library of abstract patterns to get the list of rules and their descriptions -->
	
	<xsl:output method="text"/>
	
	<xsl:template match="/">
		<xsl:text>@rules:'</xsl:text>
		<xsl:value-of select="string-join((//*:pattern[@abstract]/@id), ', ')"/>
		<xsl:text>';
</xsl:text>
		<xsl:text>@descriptions:'</xsl:text>
		<xsl:value-of select="string-join((//*:pattern[@abstract]/*:title/normalize-space()), ', ')"/>
		<xsl:text>';</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>