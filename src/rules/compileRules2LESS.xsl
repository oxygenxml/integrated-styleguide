<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	<!-- Apply this on a library of abstract patterns to get the list of rules and their descriptions -->
	
	<xsl:output method="text"/>
	
	<xsl:variable name="q">&quot;</xsl:variable>
	<xsl:variable name="a">&apos;</xsl:variable>
	<xsl:variable name="ea">\\&apos;</xsl:variable>
	
	<xsl:template match="/">
		<xsl:text>@rules:'</xsl:text>
		<xsl:value-of select="string-join((//*:pattern[@abstract]/@id), ', ')"/>
		<xsl:text>';
</xsl:text>
		<xsl:text>@descriptions:'</xsl:text>
		<xsl:value-of select="string-join((//*:pattern[@abstract]/*:title/normalize-space()), ', ')"/>
		<xsl:text>';
</xsl:text>
		<xsl:text>@staticParams:'</xsl:text>
		<xsl:text>&lt;xsl:stylesheet xmlns:xsl=&quot;http://www.w3.org/1999/XSL/Transform&quot; xmlns:saxon=&quot;http://saxon.sf.net/&quot; xmlns:xs=&quot;http://www.w3.org/2001/XMLSchema&quot; exclude-result-prefixes=&quot;xs saxon&quot; version=&quot;2.0&quot;&gt; &lt;xsl:param name=&quot;currentElementLocation&quot;/&gt; </xsl:text>
		<xsl:text>&lt;xsl:variable name=&quot;lib&quot;&gt; &lt;rules xmlns=&quot;http://oxygenxml.com/ns/schematron/params&quot;&gt; </xsl:text>
		<xsl:for-each select="(//*:pattern[@abstract][@id])">
			<xsl:text>&lt;pattern id=&quot;</xsl:text>
			<xsl:value-of select="@id"/>
			<xsl:text>&quot;&gt; &lt;parameters&gt; </xsl:text>
			<xsl:for-each select="*:parameters/*:parameter">
				<xsl:text>&lt;parameter&gt; </xsl:text>
				<xsl:text>&lt;name&gt;</xsl:text>
				<xsl:value-of select="replace(normalize-space(*:name),$a, $ea)"/>
				<xsl:text>&lt;/name&gt; </xsl:text>
				<xsl:text>&lt;desc&gt;</xsl:text>
				<xsl:value-of select="replace(normalize-space(*:desc), $a, $ea)"/>
				<xsl:text>&lt;/desc&gt;</xsl:text>
				<xsl:text>&lt;/parameter&gt;</xsl:text> 
			</xsl:for-each>
			<xsl:text> &lt;/parameters&gt; &lt;/pattern&gt;</xsl:text>				
		</xsl:for-each>
		<xsl:text>&lt;/rules&gt; &lt;/xsl:variable&gt;</xsl:text>
		<xsl:text>&lt;xsl:template match=&quot;/&quot;&gt; &lt;xsl:apply-templates select=&quot;node()&quot;/&gt; &lt;/xsl:template&gt; &lt;xsl:template match=&quot;@class&quot;/&gt; &lt;xsl:template match=&quot;dl&quot;&gt; &lt;xsl:variable name=&quot;pattern&quot; select=&quot;normalize-space(dlhead/ddhd)&quot; as=&quot;xs:string&quot;/&gt; &lt;xsl:copy&gt; &lt;xsl:apply-templates select=&quot;dlhead | @*&quot;/&gt; &lt;xsl:apply-templates select=&quot;$lib//*:pattern[@id=$pattern]/*:parameters/*&quot; mode=&quot;sch&quot;&gt; &lt;xsl:with-param name=&quot;rule&quot; select=&quot;.&quot;/&gt; &lt;/xsl:apply-templates&gt; &lt;/xsl:copy&gt; &lt;/xsl:template&gt; &lt;xsl:template match=&quot;node() | @*&quot;&gt; &lt;xsl:copy&gt; &lt;xsl:apply-templates select=&quot;node() | @*&quot;/&gt; &lt;/xsl:copy&gt; &lt;/xsl:template&gt; &lt;xsl:template match=&quot;*:parameter&quot; mode=&quot;sch&quot;&gt; &lt;xsl:param name=&quot;rule&quot;/&gt; &lt;xsl:variable name=&quot;name&quot; select=&quot;*:name&quot;/&gt; &lt;xsl:variable name=&quot;q&quot;&gt;&quot;&lt;/xsl:variable&gt; &lt;xsl:variable name=&quot;a&quot;&gt;\&apos;&lt;/xsl:variable&gt; &lt;xsl:variable name=&quot;empty&quot;/&gt; &lt;dlentry&gt; &lt;dt&gt;&lt;xsl:value-of select=&quot;$name&quot;/&gt;&lt;/dt&gt; &lt;dd&gt; &lt;xsl:variable name=&quot;value&quot; select=&quot;$rule/dlentry/dt[.=$name]/following-sibling::dd/node()[not(self::processing-instruction())]&quot;/&gt; &lt;xsl:choose&gt; &lt;xsl:when test=&quot;$value!=$empty&quot;&gt; &lt;xsl:copy-of select=&quot;$value&quot;/&gt; &lt;/xsl:when&gt; &lt;xsl:otherwise&gt; &lt;xsl:processing-instruction name=&quot;oxy-placeholder&quot;&gt; &lt;xsl:text&gt;content=&quot;&lt;/xsl:text&gt; &lt;xsl:value-of select=&quot;replace(normalize-space(*:desc), $q, $a)&quot;/&gt; &lt;xsl:text&gt;&quot;&lt;/xsl:text&gt;&lt;/xsl:processing-instruction&gt; &lt;/xsl:otherwise&gt; &lt;/xsl:choose&gt; &lt;/dd&gt; &lt;/dlentry&gt; &lt;/xsl:template&gt; &lt;/xsl:stylesheet&gt;</xsl:text>
		<xsl:text>';</xsl:text>		
	</xsl:template>
	
	
	
	
</xsl:stylesheet>