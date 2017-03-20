<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Fetch content from the "md:mods/md:relatedItem[@type='event']" mods field
  and displays it HTML style
-->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:md="http://www.loc.gov/mods/v3"
               xmlns="http://www.w3.org/1999/xhtml"
               version="1.0">

  <xsl:template name="event_renderer">
    <xsl:if test="node()">
      <xsl:element name="dt">
        <strong xml:lang="en">Event</strong>
        <strong xml:lang="da">Begivenhed</strong>
        <br/>
      </xsl:element>
      <xsl:element name="dd">
        <xsl:if test="md:titleInfo/md:title">
          <xsl:for-each select="md:titleInfo">
            <xsl:for-each select="md:title">
              <xsl:apply-templates/>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>

        <xsl:for-each select="md:typeOfResource">
          <xsl:if test="position()=1">
            <br/>
          </xsl:if>
          <xsl:apply-templates/>
          <xsl:if test="position()&lt;last()">
            <xsl:text>;</xsl:text>
          </xsl:if>
          <xsl:text>
          </xsl:text>
        </xsl:for-each>

        <xsl:for-each select="md:originInfo">
          <xsl:for-each select="md:place">
            <xsl:for-each select="md:placeTerm">
              <xsl:apply-templates/>
            </xsl:for-each>
          </xsl:for-each>
          <xsl:text>;
          </xsl:text>
          <xsl:for-each select="md:dateIssued">
            <xsl:apply-templates/>
          </xsl:for-each>
          <xsl:text>;
          </xsl:text>
        </xsl:for-each>

        <xsl:for-each select="md:note">
          <xsl:if test="position()=1">
            <br/>
          </xsl:if>
          <xsl:apply-templates/>
          <xsl:text>
          </xsl:text>
        </xsl:for-each>

        <xsl:for-each select="md:name">
          <xsl:if test="position()=1">
            <br/>
          </xsl:if>
          <xsl:for-each select="md:namePart">
            <xsl:apply-templates/>
            <xsl:if test="position()&lt;last()">
              <xsl:text></xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:if test="position()&lt;last()">
            <xsl:text>;</xsl:text>
          </xsl:if>
        </xsl:for-each>
    </xsl:element>
  </xsl:if>
</xsl:template>

        <!--
        $Id: render_event.xsl,v 1.2 2011-03-31 12:18:25 slu Exp $

        $Log: not supported by cvs2svn $
        Revision 1.1  2010/11/03 12:28:56  slu
        OK, these are needed as well

        Revision 1.2  2010/09/23 10:47:27  slu
        OK, I'll will not make the head/title bold

        Revision 1.1  2010/09/23 08:06:28  slu
        Initial adding of the event_rendering xsl script

        -->

        </xsl:transform>
