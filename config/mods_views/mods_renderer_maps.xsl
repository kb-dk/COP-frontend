<?xml version="1.0" encoding="UTF-8"?>
<!-- XSLT traverdes all metadata of the mods document, and render them
in the metadatasection of a landing page -->
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:md="http://www.loc.gov/mods/v3"
               version="1.0">

  <xsl:param name="resource_type_config" select="document('./resource-type.xml')"/>
  <xsl:param name="cataloging_language" select="'da'"/>
  <xsl:param name="isoplaces" select="document('./iso3166.xml')"/>
  <xsl:include href="./render_event.xsl"/>
  <xsl:output encoding="UTF-8" omit-xml-declaration="yes"  indent="yes" method="xml"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="md:mods">
	<xsl:call-template name="mods_renderer"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="md:modsCollection">
    <xsl:call-template name="mods_renderer"/>
  </xsl:template>

  <xsl:template name="mods_renderer">
    <xsl:element name="div">
      <xsl:attribute name="class">rightGrid</xsl:attribute>
      <section id="metaData">
	<ul>
	  <!-- START METADATAELEMENTS -->
	  <!--  START TITLE ELEMENTS -->
	  <!-- START TITLE -->
	  <xsl:if test="md:mods/md:titleInfo[not(@type) and not(md:subTitle)]">
	    <xsl:element name="li">
	      <xsl:for-each select="md:mods/md:titleInfo[not(@type) and not(md:subTitle)]">
		<xsl:if test="md:title">
		  <strong xml:lang="da">Titel:</strong>
		  <strong xml:lang="en">Title:</strong>
		  <xsl:element name="span">
		    <xsl:attribute name="dir">ltr</xsl:attribute>
		    <xsl:element name="span">
		      <xsl:attribute name="lang">
			<xsl:call-template name="get_language">
			  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
			</xsl:call-template>
		      </xsl:attribute>
		      <xsl:apply-templates select="(md:nonSort|md:title)[not(@transliteration='rex')]"/>
		    </xsl:element>
		    <xsl:element name="span">
		      <xsl:attribute name="lang">
			<xsl:call-template name="get_language">
			  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
			</xsl:call-template>
		      </xsl:attribute>
		      <xsl:if test="position()&lt;last() and last()&gt;1">
			<xsl:text>; </xsl:text>
		      </xsl:if>
		    </xsl:element>
		  </xsl:element>
		</xsl:if>
		<xsl:text>
		</xsl:text>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:if>
	  <!-- END TITLE -->

	  <!-- START SUBTITLE -->
	  <xsl:if test="md:mods/md:titleInfo[md:subTitle]">
	    <xsl:element name="li">
	      <xsl:attribute name="class">even</xsl:attribute>
	      <xsl:for-each select="md:mods/md:titleInfo[md:subTitle]">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Subtitle:</strong>
		  <strong xml:lang="da">Undertitel:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="(md:nonSort|md:subTitle)[not(@transliteration='rex')]"/>
		  <xsl:if test="position()&lt;last() and last()&gt;1">
		    <xsl:text>; </xsl:text>
		  </xsl:if>
		</xsl:element>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:if>
	  <!-- END SUBTITLE -->

	  <!-- START ALTERNATIVE TITLE -->
	  <xsl:if test="md:mods/md:titleInfo[@type='alternative']">
	    <xsl:element name="li">
	      <xsl:for-each select="md:mods/md:titleInfo[@type='alternative']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Alternative title:</strong>
		  <strong xml:lang="da">Varianttitel:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="(md:nonSort|md:title|md:subTitle)[not(@transliteration='rex')]"/>
		  <xsl:if test="position()&lt;last() and last()&gt;1">
		    <xsl:text>; </xsl:text>
		  </xsl:if>
		</xsl:element>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:if>
	  <!-- END ALTERNATIVE TITLE -->

	  <!-- START TRANSCRIBED TITLE -->
	  <xsl:if test="md:mods/md:titleInfo[@type='transcribed']">
	    <xsl:element name="li">
	      <xsl:for-each select="md:mods/md:titleInfo[@type='transcribed']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Transcribed title:</strong>
		  <strong xml:lang="da">Transkriberet titel:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="(md:nonSort|md:title|md:subTitle)[not(@transliteration='rex')]"/>
		  <xsl:if test="position()&lt;last() and last()&gt;1">
		    <xsl:text>; </xsl:text>
		  </xsl:if>
		</xsl:element>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:if>
	  <!-- END TRANSCRIBED TITLE -->

	  <!--  END TITLE ELEMETS -->

	  <!-- BEGIN CARTOONS ELEMENTS -->

	  <xsl:if test="md:mods/md:note[@displayLabel='Situation']">
	    <li>
	      <xsl:for-each select="md:mods/md:note[@displayLabel='Situation']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Situation:</strong>
		  <strong xml:lang="da">Situation:</strong>
		</xsl:if>
		<span>
		  <xsl:apply-templates select="."/>
		</span>

	      </xsl:for-each>
	    </li>
	  </xsl:if>

	  <xsl:if test="md:mods/md:note[@displayLabel='Caption']">
	    <li>
	      <xsl:for-each select="md:mods/md:note[@displayLabel='Caption']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Caption:</strong>
		  <strong xml:lang="da">Undertekst:</strong>
		</xsl:if>
		<span>
		  <xsl:apply-templates select="."/>
		</span>
	      </xsl:for-each>
	    </li>
	  </xsl:if>

	  <xsl:if test="md:mods/md:note[@displayLabel='Dialog']">
	    <li>
	      <xsl:for-each select="md:mods/md:note[@displayLabel='Dialog']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Dialogue:</strong>
		  <strong xml:lang="da">Dialog:</strong>
		</xsl:if>
		<span>
		  <xsl:apply-templates select="."/>
		</span>
	      </xsl:for-each>
	    </li>
	  </xsl:if>

	  <!-- END CARTOONS ELEMENTS -->

	  <!-- START EVENT -->
	  <xsl:for-each select="md:mods/md:relatedItem[@type='event']">
	    <xsl:call-template name="event_renderer"/>
	  </xsl:for-each>
	  <!-- END EVENT -->


	  <!-- START NAME ELEMENTS -->

	  <xsl:if test="md:mods/md:name">
	    <xsl:element name="li">
	      <xsl:for-each select="md:mods/
				    md:name[md:role/md:roleTerm[@type='code']='aut']">
		<xsl:if test="position()=1">
		  <xsl:choose>
		    <xsl:when test="@displayLabel='Sender'">
		      <xsl:choose>
			<xsl:when test="@type='personal'">
			  <strong xml:lang="en">Sender:</strong>
			  <strong xml:lang="da">Afsender:</strong>
			</xsl:when>
			<xsl:otherwise>
			  <strong xml:lang="en">Corporate sender:</strong>
			  <strong xml:lang="da">Ophavsorganisation:</strong>
			</xsl:otherwise>
		      </xsl:choose>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:choose>
			<xsl:when test="@type='personal'">
			  <strong xml:lang="en">Author:</strong>
			  <strong xml:lang="da">Forfatter:</strong>
			</xsl:when>
			<xsl:otherwise>
			  <strong xml:lang="en">Corporate author:</strong>
			  <strong xml:lang="da">Ophavsorganisation:</strong>
			</xsl:otherwise>
		      </xsl:choose>
		    </xsl:otherwise>
		  </xsl:choose>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		</xsl:element>
		<xsl:call-template name="render_residence"/>
		<xsl:call-template name="break_semicolon"/>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:name[md:role/md:roleTerm[@type='text']='creator']">
		<xsl:if test="position()=1">
		  <xsl:choose>
		    <xsl:when test="@type = 'corporate'">
		      <strong xml:lang="en">Corporate creator:</strong>
		      <strong xml:lang="da">Ophavsorganisation:</strong>
		    </xsl:when>
		    <xsl:otherwise>
		      <strong xml:lang="en">Creator:</strong>
		      <strong xml:lang="da">Ophav:</strong>
		    </xsl:otherwise>
		  </xsl:choose>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		  <xsl:if test="position()!=last()">
		    <xsl:element name="br"> </xsl:element>
		  </xsl:if>
		</xsl:element>
		<xsl:call-template name="break_semicolon"/>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/
				    md:name[@type='personal'][md:role/md:roleTerm[@type='code']='prt']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Printer:</strong>
		  <strong xml:lang="da">Trykker:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/
				    md:name[@type='personal'][md:role/md:roleTerm[@type='code']='ctb']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Contributor:</strong>
		  <strong xml:lang="da">Anden bidragsyder:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:name[md:role/md:roleTerm[@type='code']='src']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Scribe:</strong>
		  <strong xml:lang="da">Skriver:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:name[md:role/md:roleTerm[@type='code']='pat']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Patron:</strong>
		  <strong xml:lang="da">Protektor:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:name[md:role/md:roleTerm[@type='code']='rcp']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Recipient:</strong>
		  <strong xml:lang="da">Modtager:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		<xsl:call-template name="render_residence"/>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>


	    </xsl:element>
	  </xsl:if>
	  <!-- END NAME ELEMENTS -->
	  <!-- START NOTE -->
	  <xsl:for-each select="md:mods/md:note[@type='content'and not(@transliteration='rex')]">
	    <xsl:element name="li">
	      <xsl:if test="position()=1">
		<strong xml:lang="en">Note:</strong>
		<strong xml:lang="da">Note:</strong>
	      </xsl:if>
	      <xsl:attribute name="lang">
		<xsl:call-template name="get_language">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:attribute>
	      <xsl:value-of select="."/>
	      <br/>
	    </xsl:element>
	  </xsl:for-each>
	  <!-- END NOTE -->

	  <!-- START Physcal description part 1 -->
	  <xsl:if test="md:mods/md:typeOfResource">
	    <xsl:element name="li">
	      <xsl:if test="position() = 1">
		<strong xml:lang="en">Resource type:</strong>
		<strong xml:lang="da">Ressourcetype:</strong>
	      </xsl:if>
	      <xsl:value-of select="md:mods/md:typeOfResource"/>
	    </xsl:element>
	  </xsl:if>
	  <!-- END Physcal description part 1 -->


	  <!-- START NOTE -->
	  <xsl:if test="md:mods/md:genre">
	    <xsl:element name="li">
	      <xsl:choose>
		<xsl:when test="count(md:mods/md:genre)&gt;1">
		  <strong xml:lang="en">Genres:</strong>
		  <strong xml:lang="da">Genre:</strong>
		</xsl:when>
		<xsl:otherwise>
		  <strong xml:lang="en">Genre:</strong>
		  <strong xml:lang="da">Genre:</strong>
		</xsl:otherwise>
	      </xsl:choose>
	      <xsl:for-each select="md:mods/md:genre">
		<xsl:element name="span">

		  <xsl:attribute name="xml:lang">
		    <xsl:value-of select="@xml:lang"/>
		  </xsl:attribute>
		  <xsl:value-of select="."/>
		  <xsl:if test="position()!=last()">
		    <xsl:element name="br"></xsl:element>
		  </xsl:if>

		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>

	      </xsl:for-each>
	    </xsl:element>
	  </xsl:if>
	  <!-- END NOTE -->


	  <!-- Physical Description -->
	  <xsl:if test="md:mods/md:physicalDescription[@displayLabel='Medium']|
			md:mods/md:physicalDescription[@displayLabel='Extent']|
			md:mods/md:physicalDescription[md:note[@type='technique']]">
	    <xsl:element name="li">
	      <xsl:for-each select="md:mods/md:physicalDescription[@displayLabel='Medium']">
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Medium:</strong>
		  <strong xml:lang="da">Materiale:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:note"/>
		<xsl:if test="position() = last()">
		  <br/>
		</xsl:if>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:physicalDescription[md:note[@type='technique']]">
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Technique:</strong>
		  <strong xml:lang="da">Teknik:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:note"/>
		<xsl:choose>
		  <xsl:when test="position() = last()">
		    <br/>
		  </xsl:when>
		  <xsl:otherwise><xsl:text>
		  </xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:physicalDescription[@displayLabel='Extent']">
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Extent:</strong>
		  <strong xml:lang="da">Omfang:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:extent"/>
		<xsl:if test="position() = last()">
		  <br/>
		</xsl:if>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:if>


	  <!-- START SCALE-->
	  <xsl:if test="md:mods/md:subject/md:cartographics/md:scale | md:mods/md:physicalDescription[@displayLabel='Size']">
	    <xsl:element name="li">
	      <xsl:if test="md:mods/md:subject/md:cartographics/md:scale">
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Scale:</strong>
		  <strong xml:lang="da">Målestok:</strong>
		</xsl:if>
		<xsl:value-of select="md:mods/md:subject/md:cartographics/md:scale"/>
		<xsl:if test="position() = last()">
		  <br/>
		</xsl:if>
	      </xsl:if>

	      <!-- END SCALE part 1 -->

	      <xsl:for-each select="md:mods/md:physicalDescription[@displayLabel='Size']">

		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Size:</strong>
		  <strong xml:lang="da">Størrelse:</strong>
		</xsl:if>
		<xsl:apply-templates select="md:extent"/>
		<xsl:if test="position() = last()">
		  <br/>
		</xsl:if>

	      </xsl:for-each>
	    </xsl:element>

	  </xsl:if>


	  <xsl:if test="md:mods/md:note[@displayLabel='Script']">
	    <xsl:for-each select="md:mods/md:note[@displayLabel='Script']">
	      <xsl:if test="position()=1">
		<strong xml:lang="en">Script:</strong>
		<strong xml:lang="da">Skriftsystem:</strong>
	      </xsl:if>
	      <xsl:apply-templates/>
	      <xsl:if test="position() = last()">
		<br/>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:if>

	  <xsl:if test="md:mods/md:note[@displayLabel='Script: detail']">
	    <xsl:for-each select="md:mods/md:note[@displayLabel='Script: detail']">
	      <xsl:if test="position()=1">
		<strong xml:lang="en">Script (detailed):</strong>
		<strong xml:lang="da">Skriftsystem (detaljeret):</strong>
	      </xsl:if>
	      <xsl:apply-templates/>
	      <xsl:if test="position() = last()">
		<br/>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:if>


	  <!-- START originInfo -->

	  <xsl:if test="md:mods/md:originInfo">
	    <xsl:element name="li">

	      <xsl:for-each select="md:mods/md:originInfo/md:place/md:placeTerm[@type='text']">

		<xsl:if test="position()=1">
		  <strong xml:lang="en">Country and Place of origin:</strong>
		  <strong xml:lang="da">Udgivelsesland og sted:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:if test="not(@transliteration)">
		    <xsl:apply-templates/>
		    <xsl:if test="position()!=last()">
		      <xsl:text>, </xsl:text>
		    </xsl:if>

		  </xsl:if>
		  <xsl:call-template name="break_semicolon">
		    <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		  </xsl:call-template>

		</xsl:element>
	      </xsl:for-each>

	      <xsl:if test="md:mods/md:language">
		<xsl:for-each select="md:mods/md:language/md:languageTerm">
		  <xsl:if test="position()=1">
		    <strong xml:lang="en">Languages:</strong>
		    <strong xml:lang="da">Udgivelsessprog:</strong>
		  </xsl:if>
		  <xsl:element name="span">

		    <xsl:apply-templates/>
		    <xsl:text>
		    </xsl:text>
		    <xsl:if test="position() = last()">
		      <br/>
		    </xsl:if>
		  </xsl:element>

		</xsl:for-each>
	      </xsl:if>


	      <xsl:for-each select="md:mods/md:originInfo/md:place/md:placeTerm[@type='code']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Country of origin:</strong>
		  <strong xml:lang="da">Udgivelsesland:</strong>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="position() = last()">
		  <br/>
		</xsl:if>
	      </xsl:for-each>

	      <xsl:for-each select="md:mods/md:originInfo/md:dateCreated[@encoding='w3cdtf']">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Date created:</strong>
		  <strong xml:lang="da">Udgivelsesdato:</strong>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:text>
		</xsl:text>
	      </xsl:for-each>

	      <xsl:if test="md:mods/md:originInfo/md:dateCreated[@xml:lang]">
		<xsl:if test="not(@encoding='w3cdtf')">
		  <xsl:if test="position()=1">
		    <strong xml:lang="en">Date created:</strong>
		    <strong xml:lang="da">Udgivelsesdato:</strong>
		  </xsl:if>
		</xsl:if>
		<span dir="ltr">
		  <xsl:for-each select="md:mods/md:originInfo/md:dateCreated[@xml:lang]">
		    <xsl:element name="span">
		      <xsl:attribute name="lang">
			<xsl:value-of select="@xml:lang"/>
		      </xsl:attribute>
		      <xsl:apply-templates/>
		    </xsl:element>
		  </xsl:for-each>
		</span>
	      </xsl:if>

	      <xsl:if test="not(md:mods/md:originInfo/md:dateCreated[@xml:lang])">
		<br/>
	      </xsl:if>

	      <xsl:if test="md:mods/md:relatedItem[@displayLabel='Publication']">

		<xsl:for-each select="md:mods/
				      md:relatedItem[@displayLabel='Publication']/
				      md:titleInfo/
				      md:title">
		  <xsl:if test="position()=1">
		    <strong xml:lang="en">Publication:</strong>
		    <strong xml:lang="da">Publikation:</strong>
		  </xsl:if>
		  <xsl:apply-templates/>
		</xsl:for-each>

	      </xsl:if>


	      <!-- START PUBLISHER -->
	      <xsl:for-each select="md:mods/md:originInfo/md:publisher">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Publisher:</strong>
		  <strong xml:lang="da">Forlag:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates/>
		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>

	    </xsl:element>
	  </xsl:if>

	  <!-- END PUBLISHER -->
	  <!-- START SUBJECT ELEMENTS -->

	  <xsl:if test="md:mods/md:subject[not(md:topic/@xlink:href)]">
	    <xsl:element name="li">
	      <xsl:for-each select="md:mods/md:subject/md:topic[not(@xlink:href)]">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Topic</strong>
		  <strong xml:lang="da">
		    <xsl:choose>
		      <xsl:when test="../@displayLabel='Motiv'">Motiv:</xsl:when>
		      <xsl:otherwise>Emne:</xsl:otherwise>
		    </xsl:choose>
		  </strong>
		</xsl:if>

		<!-- START Topic -->
		<xsl:element name="span">
		  <xsl:attribute name="xml:lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates/>
		  <xsl:if test="position()!=last()">
		    <xsl:element name="br"></xsl:element>
		  </xsl:if>
		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>
	    </xsl:element>


	    <!-- END Topic -->

	    <xsl:element name="li">

	      <xsl:for-each select="md:mods/md:subject/md:geographic">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Place:</strong>
		  <strong xml:lang="da">Lokalitet:</strong>
		</xsl:if>
		<!-- START Topic -->
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates/>
		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>
	    </xsl:element>

	    <!-- END Topic -->

	    <!-- START PERSON -->
	    <xsl:for-each select="md:mods/md:subject/md:name">
	      <xsl:if test="position()=1">
		<strong xml:lang="en">Person:</strong>
		<strong xml:lang="da">Person:</strong>
	      </xsl:if>
	      <xsl:element name="span">
		<xsl:attribute name="lang">
		  <xsl:call-template name="get_language">
		    <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		  </xsl:call-template>
		</xsl:attribute>
		<xsl:apply-templates select="md:namePart[not(@transliteration='rex')]"/>
		<xsl:if test="position()!=last()">
		  <xsl:element name="br"></xsl:element>
		</xsl:if>
	      </xsl:element>
	      <xsl:call-template name="break_semicolon">
		<xsl:with-param name="cataloging_language" select="$cataloging_language"/>
	      </xsl:call-template>
	    </xsl:for-each>

	    <!-- END PERSON -->


	    <!-- START ÅRSTAL -->
	    <xsl:if test="md:mods/md:subject/md:temporal[not(@transliteration='rex')]">
	      <xsl:for-each select="md:temporal">
		<xsl:if test="position()=1">
		  <strong xml:lang="en">Time:</strong>
		  <strong xml:lang="da">Tid:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:attribute name="lang">
		    <xsl:call-template name="get_language">
		      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		    </xsl:call-template>
		  </xsl:attribute>
		  <xsl:apply-templates select="md:temporal"/>
		</xsl:element>
		<xsl:call-template name="break_semicolon">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:for-each>
	    </xsl:if>
	    <!-- END ÅRSTAL -->

	  </xsl:if>
	  <!-- END SUBJECT ELMENTS -->

	  <xsl:if
	      test="md:mods/md:identifier[@type='accession number']|md:mods/md:identifier[@type='local']">
	    <li>
	      <xsl:for-each select="md:mods/md:identifier[@type='local']">
		<xsl:if test="position() = 1">
		  <strong>Id:</strong>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="position() = last()">
		  <br/>
		</xsl:if>
	      </xsl:for-each>
	      <!--
		  <xsl:for-each select="md:mods/md:identifier[@type='accession number']">
		  <xsl:if test="position() = 1">
		  <strong xml:lang="en">Accession number:</strong>
		  <strong xml:lang="da">Accessionsnummer:</strong>
		  </xsl:if>
		  <xsl:apply-templates/>
		  <xsl:if test="position() = last()">
		  <br/>
		  </xsl:if>
		  </xsl:for-each>
	      -->
	    </li>
	  </xsl:if>


	  <!-- Shelf mark    -->
	  <xsl:if test="md:mods/md:location/md:physicalLocation[not(@transliteration)]">
	    <li>
	      <xsl:for-each select="md:mods/md:location/md:physicalLocation[not(@transliteration)]">
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Shelf mark:</strong>
		  <strong xml:lang="da">Opstilling:</strong>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="position() = last()"><br/></xsl:if>
	      </xsl:for-each>
	    </li>
	  </xsl:if>


	  <!-- Collection -->
	  <xsl:if test="md:mods/md:relatedItem[@displayLabel='Collection']">
	    <li>
	      <xsl:for-each select="md:mods/md:relatedItem[@displayLabel='Collection']">
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Collection:</strong>
		  <strong xml:lang="da">Samling:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:if test="@xml:lang">
		    <xsl:attribute name="lang">
		      <xsl:call-template name="get_language">
			<xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		      </xsl:call-template>
		    </xsl:attribute>
		  </xsl:if>
		  <xsl:apply-templates select="md:titleInfo"/>
		</xsl:element>
	      </xsl:for-each>
	    </li>
	  </xsl:if>

	  <!-- References -->
	  <xsl:if test="md:mods/md:note[@type='citation/reference']">
	    <xsl:for-each select="md:mods/md:note[@type='citation/reference']">
	      <li>
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Selected references:</strong>
		  <strong xml:lang="da">Referencer til materialet:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:if test="@xml:lang">
		    <xsl:attribute name="lang">
		      <xsl:call-template name="get_language">
			<xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		      </xsl:call-template>
		    </xsl:attribute>
		  </xsl:if>
		  <xsl:apply-templates/>
		</xsl:element>
	      </li>
	    </xsl:for-each>
	  </xsl:if>

	  <!-- a nude note without any decorations whatsoever -->
	  <xsl:if test="md:mods/md:note[not(@type)]">
	    <xsl:for-each select="md:mods/md:note[not(@type)]">
	      <li>
		<xsl:if test="position() = 1">
		  <strong xml:lang="en">Comment:</strong>
		  <strong xml:lang="da">Kommentar:</strong>
		</xsl:if>
		<xsl:element name="span">
		  <xsl:if test="@xml:lang">
		    <xsl:attribute name="lang">
		      <xsl:call-template name="get_language">
			<xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		      </xsl:call-template>
		    </xsl:attribute>
		  </xsl:if>
		  <xsl:apply-templates/>
		</xsl:element>
	      </li>
	    </xsl:for-each>
	  </xsl:if>

	  <!-- CUSTOM URL  / RELEATED MATERIAL -->
	  <xsl:if test="md:mods/md:relatedItem[@xlink]">
	    <xsl:for-each select="md:mods/md:relatedItem[@xlink]">
	      <li>
		<strong xml:lang="en">Related:</strong>
		<strong xml:lang="da">Relateret:</strong>
		<xsl:element name="span">
		  <xsl:if test="@xml:lang">
		    <xsl:attribute name="lang">
		      <xsl:call-template name="get_language">
			<xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		      </xsl:call-template>
		    </xsl:attribute>
		  </xsl:if>
		  <xsl:element name="a">
		    <xsl:attribute name="href">
		      <xsl:value-of select="@xlink"/>
		    </xsl:attribute>
		    <xsl:choose>
		      <xsl:when test="text()">
			<xsl:value-of select="text()"/>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="@xlink"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:element>
		</xsl:element>
	      </li>
	    </xsl:for-each>
	  </xsl:if>
	  <!-- Copyright -->
	  <xsl:if test="md:mods/md:accessCondition/node()">
	    <li>
	      <strong xml:lang="en">Copyright:</strong>
	      <strong xml:lang="da">Ophavsret:</strong>
	      <xsl:for-each select="md:mods/md:accessCondition">
		<xsl:choose>
		  <xsl:when test="text()!='CC BY-NC-ND'">
		    <xsl:element name="span">
		      <xsl:attribute name="xml:lang">
			<xsl:value-of select="@xml:lang"/>
		      </xsl:attribute>
		      <br/>
		      <xsl:apply-templates/>
		    </xsl:element>
		  </xsl:when>
		</xsl:choose>
		<xsl:choose>
		  <xsl:when test="text()='CC BY-NC-ND'">
		    <span xml:lang="da">
		      <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/">
			<img alt="Creative Commons licens" style="border-width:0"
			     src="http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png"/>
		      </a>
		      <br/>Dette værk er licenseret under en<a rel="license"
		      href="http://creativecommons.org/licenses/by-nc-nd/3.0/">
		      Creative Commons Navngivelse-IkkeKommerciel-IngenBearbejdelse 3.0 Unported Licens</a>.
		    </span>
		    <span xml:lang="en">
		      <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/">
			<img alt="Creative Commons License" style="border-width:0"
			     src="http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png"/>
		      </a>
		      <br/>This work is licensed under a<a rel="license"
		      href="http://creativecommons.org/licenses/by-nc-nd/3.0/">
		      Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License</a>.
		    </span>
		  </xsl:when>
		</xsl:choose>
	      </xsl:for-each>
	    </li>
	  </xsl:if>
	</ul>
      </section>
    </xsl:element>

  </xsl:template>


  <xsl:template match="h:a">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:if test="@xml:lang">
	<xsl:attribute name="xml:lang">
	  <xsl:value-of select="@xml:lang"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="md:nonSort|md:title|md:subTitle">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="md:namePart">
    <xsl:param name="cataloging_language" select="'da'"/>
    <xsl:element name="span">
      <xsl:attribute name="lang">
	<xsl:call-template name="get_language">
	  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="break_semicolon">
    <xsl:param name="cataloging_language" select="'da'"/>
    <xsl:param name="preserve_lang" select="'no'"/>
    <xsl:choose>
      <xsl:when test="not(position() = last())">
	<xsl:element name="span">
	  <xsl:choose>
	    <xsl:when test="$preserve_lang = 'yes'">
	      <xsl:attribute name="xml:lang">
		<xsl:value-of select="@xml:lang"/>
	      </xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:attribute name="lang">
		<xsl:call-template name="get_language">
		  <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
		</xsl:call-template>
	      </xsl:attribute>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get_language">
    <xsl:param name="cataloging_language" select="'da'"/>
    <xsl:choose>
      <xsl:when test="@xml:lang">
	<xsl:value-of select="@xml:lang"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$cataloging_language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="render_residence">
    <xsl:for-each select="tei:residence">
      <xsl:variable name="country" select="tei:country"/>
      <xsl:if test="position()=1"><xsl:text>
	(</xsl:text>
      </xsl:if>
      <xsl:for-each select="tei:settlement">
	<xsl:element name="span">
	  <xsl:attribute name="lang">
	    <xsl:value-of select="@xml:lang"/>
	  </xsl:attribute>
	  <xsl:value-of select="."/>
	</xsl:element>
	<xsl:choose>
	  <xsl:when test="position()&lt;last()">
	    <xsl:text>; </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="$isoplaces//country[@code=$country]"/>)
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:comment>
	  <xsl:value-of select="$country"/>
	  <xsl:value-of select="$isoplaces//country[@code=$country]"/>
	</xsl:comment>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>


</xsl:transform>