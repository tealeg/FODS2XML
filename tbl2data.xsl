<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output indent="yes" 
	      method="xml" 
	      encoding="UTF-8" 
	      xmlns:saxon="http://icl.com/saxon"
	      saxon:character-representation="native;decimal"/>

  <xsl:template match="*">
    <!-- Do Nothing -->
  </xsl:template>

  <xsl:template match="document">
    <subjects>
      <xsl:apply-templates select="table/row[@rownum > 1]" />
    </subjects>
  </xsl:template>

  <xsl:template match="row">
    <record>
      <xsl:apply-templates />
    </record>
  </xsl:template>

  <xsl:template match="cell">
    <xsl:variable name="cellnum">
      <xsl:value-of select="@cellnum"/>
    </xsl:variable>
    <xsl:variable name="table">
      <xsl:value-of select="ancestor::table/@name"/>
    </xsl:variable>
    <xsl:variable name="cellname">
      <xsl:value-of select="/document/table[@name=$table]/row[@rownum=1]/cell[@cellnum=$cellnum]/p[1]"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($cellname) > 0">
	<xsl:element name="{$cellname}">
	  <xsl:apply-templates />
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="OOPS">
	  <xsl:apply-templates />
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="p">
    <xsl:value-of select="."/>
  </xsl:template>
  
</xsl:stylesheet>

