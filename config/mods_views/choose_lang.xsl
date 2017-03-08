<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns="http://www.w3.org/1999/xhtml"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
               xmlns:atom="http://www.w3.org/2005/Atom"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dcterms="http://purl.org/dc/terms/"
               xmlns:xalan="http://xml.apache.org/xslt"
               xmlns:string="xalan://java.lang.String"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:kb="http://www.kb.dk/insert/"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:md="http://www.loc.gov/mods/v3"
               exclude-result-prefixes="h xsl kb md string xlink dcterms dc atom opensearch xalan tei"
               version="1.0">

    <!--
        Script that implements language selection. It traverses a HTML
        page and supresses the printing of one language (Danish or English)
        Author: Sigfrid Lundberg (slu@kb.dk)
        $Revision: 1.11 $ last modified $Date: 2011-03-31 12:18:13 $ by $Author: slu $
        $Id: choose_lang.xsl,v 1.11 2011-03-31 12:18:13 slu Exp $
    -->


    <xsl:param name="path" select="''"/>

    <xsl:param name="query_string" select="''"/>
    <xsl:param name="myQuery">
        <xsl:if test="$query_string">
            <xsl:value-of select="concat('?',$query_string)"/>
        </xsl:if>
    </xsl:param>

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

    <xsl:template match="node()[@class = 'language']">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="string-length(substring-after($path,concat('/',$lang))) = 0">
                        <xsl:value-of select="concat(substring-before($path,concat('/',$lang)),
				  '/',$suppress_lang,'/',
				  $myQuery)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(substring-before($path,concat('/',$lang,'/')),
				  '/',$suppress_lang,'/',
				  substring-after($path,concat('/',$lang,'/')),
				  $myQuery)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="class">language</xsl:attribute>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="$suppress_lang"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$lang = 'da'">English</xsl:when>
                <xsl:otherwise>Dansk</xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="form">
        <xsl:element name="form">
            <xsl:attribute name="method">get</xsl:attribute>
            <xsl:attribute name="action"></xsl:attribute>
            <xsl:attribute name="accept-charset">UTF-8</xsl:attribute>
            <xsl:attribute name="id">search-form</xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="node()[@xml:lang = $suppress_lang]">
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:choose>
            <xsl:when test="name(.)='form'">
                <xsl:call-template name="form"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:transform>


        <!--
            $Log: not supported by cvs2svn $
            Revision 1.10  2009/06/26 11:50:26  slu
            implemented workaround for searching

            Revision 1.9  2009/06/04 07:36:32  slu
            Added an extensive exclude-result-prefixes

            Revision 1.8  2009/04/14 10:38:17  slu
            Now with proper metadata and RCS tags

            Revision 1.7  2009/04/14 10:36:53  slu
            no comments

            Revision 1.6  2009/04/14 10:36:32  slu
            No correctly handling URIs with a trailing language tag (da or en)
            without a trailing slash.
        -->
