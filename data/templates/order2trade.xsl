<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="order">
    <xsl:text>&#xa;</xsl:text>
    <trade>
      <xsl:text>&#xa;</xsl:text>
      <xsl:copy-of select="client"/>
      <xsl:text>&#xa;</xsl:text>
      <xsl:copy-of select="symbol"/>      
      <xsl:text>&#xa;</xsl:text>
      <xsl:copy-of select="country"/>   
      <xsl:text>&#xa;</xsl:text>
      <xsl:copy-of select="quantity"/>
      <xsl:text>&#xa;</xsl:text>
      <xsl:if test = "symbol='AMZN'">
          <price>2000</price>
      </xsl:if>
      <xsl:if test = "symbol='AC'">
          <price>40</price>
      </xsl:if>      
      <xsl:text>&#xa;</xsl:text>
    </trade>
  </xsl:template>
</xsl:stylesheet>
