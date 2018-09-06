<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs saxon" version="2.0">
	
	<xsl:param name="currentElementLocation"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="node()"/>
		<!-- 
          sourceLocation parameter was set to /* to have a larger context.
          We can pinpoint the element that contained the caret 
          using $currentElementLocation
      -->
		<!--<xsl:apply-templates select="saxon:eval(saxon:expression($currentElementLocation))"/>--> 
	</xsl:template>
	
	<xsl:template match="@class"/>
	
	<xsl:template match="dl">
		<xsl:variable name="pattern" select="normalize-space(dlhead/ddhd)" as="xs:string"/>
		<xsl:copy>
			<xsl:apply-templates select="dlhead | @*"/>
			<xsl:apply-templates select="document('http://www.oxygenxml.com/styleguide/rules/library.sch')//*:pattern[@id=$pattern]/*:parameters/*" mode="sch">
				<xsl:with-param name="rule" select="."/>								
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*:parameter" mode="sch">
		<xsl:param name="rule"/>
		<xsl:variable name="name" select="*:name"/>
		<xsl:variable name="q">"</xsl:variable>
		<xsl:variable name="a">'</xsl:variable>
		<dlentry>
			<dt><xsl:value-of select="$name"/></dt>
			<dd>
				<xsl:variable name="value" select="$rule/dlentry/dt[.=$name]/following-sibling::dd/node()[not(self::processing-instruction())]"/>
				<xsl:choose>
					<xsl:when test="$value!=''">
						<xsl:copy-of select="$value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:processing-instruction name="oxy-placeholder"> 
							<xsl:text>content="</xsl:text>
							<xsl:value-of select="replace(normalize-space(*:desc), $q, $a)"/>
							<xsl:text>"</xsl:text></xsl:processing-instruction>
					</xsl:otherwise>
				</xsl:choose>
			</dd>
		</dlentry>
	</xsl:template>

	
</xsl:stylesheet>