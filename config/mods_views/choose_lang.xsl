<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="1.0">

    <xsl:param name="lang" select="'en'"/>
    <xsl:param name="suppress_lang">
        <xsl:choose>
            <xsl:when test="$lang = 'en'">da</xsl:when>
            <xsl:otherwise>en</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:output
            doctype-public=""
            encoding="UTF-8"
            indent="yes"
            method="html"
            omit-xml-declaration="yes"
            />

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@*|node()">
      <xsl:if test="not(@xml:lang=$suppress_lang)">
	<xsl:copy>
	  <xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
      </xsl:if>
    </xsl:template>

</xsl:transform>
