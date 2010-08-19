<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
    xmlns:ooo="http://openoffice.org/2004/office"
    xmlns:ooow="http://openoffice.org/2004/writer"
    xmlns:oooc="http://openoffice.org/2004/calc"
    xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:rpt="http://openoffice.org/2005/report"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:grddl="http://www.w3.org/2003/g/data-view#"
    xmlns:tableooo="http://openoffice.org/2009/table"
    xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0"
    xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0"    
    xmlns:css3t="http://www.w3.org/TR/css3-text/"
    xmlns:saxon="http://icl.com/saxon"
    extension-element-prefixes="saxon">

  <xsl:output indent="yes" 
	      method="xml" 
	      encoding="UTF-8" 
	      saxon:character-representation="native;decimal"/>

  <xsl:param name="collimit" select="100"/>

  <xsl:template match="*">
    <!-- Do Nothing -->
  </xsl:template>

  <xsl:template match="office:document">
    <document>
      <xsl:apply-templates />
    </document>
  </xsl:template>

  
  <xsl:template match="office:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="office:spreadsheet">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="table:table">
    <table>
      <xsl:attribute name="name">
	<xsl:value-of select="@table:name"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <xsl:template match="table:table-row">
    <row>
      <xsl:attribute name="rownum">
	<xsl:value-of select="count(preceding-sibling::table:table-row) + 1"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </row>
  </xsl:template>

  <xsl:template name="repeat-cells">
    <xsl:param name="index" select="0"/>
    <xsl:param name="cellnum" select="1"/>
    <xsl:if test="$collimit >= $cellnum">
      <xsl:if test="$index > 0">
	<cell>
	  <xsl:attribute name="cellnum">
	    <xsl:value-of select="$cellnum"/>
	  </xsl:attribute>
	</cell>
	<xsl:call-template name="repeat-cells">
	  <xsl:with-param name="index" select="$index - 1"/>
	  <xsl:with-param name="cellnum" select="$cellnum + 1"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="table:table-cell">
    <xsl:variable name="repeats" 
		  select="sum(preceding-sibling::table:table-cell/@table:number-columns-repeated) -
			  count(preceding-sibling::table:table-cell[@table:number-columns-repeated > 0])"/>
    <xsl:variable name="cellnum" select="count(preceding-sibling::table:table-cell) + $repeats + 1"/>
    <xsl:if test="$collimit >= $cellnum">  
      <cell>
	<xsl:attribute name="cellnum">
	  <xsl:value-of select="$cellnum"/>
	</xsl:attribute>
	<xsl:apply-templates />
      </cell>
      <xsl:if test="@table:number-columns-repeated > 0">
	<xsl:call-template name="repeat-cells">
	  <xsl:with-param name="index" select="@table:number-columns-repeated -1"/>
	  <xsl:with-param name="cellnum" select="$cellnum + 1"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text:p">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>
		
</xsl:stylesheet>