<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:output method="text" indent="no"/>
    
    <xsl:template match="ul">
        <xsl:apply-templates select="li"/>
    </xsl:template>
    
    <xsl:template match="li">
           <xsl:if test="count(./ul/li) &gt; 0">
            <xsl:call-template name="pub">
                <xsl:with-param name="cat" select="'not-yet'"/>
            </xsl:call-template>      
           </xsl:if>
    </xsl:template>
    
    <xsl:template name="pub">
        <xsl:param name="cat"/>
        <xsl:variable name="ref">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:variable>
        <xsl:variable name="pdf">
            <xsl:value-of select="normalize-space(a[position()=1 and contains(node(), 'pdf')]/@href)"/>
        </xsl:variable>
        <xsl:value-of
            select="
            concat(
            $cat
            , '|'
            , $ref
            , '|'
            , $pdf
            , '&#xA;'
            )"
        />
    </xsl:template>
    <xsl:template match="@*|node()">
        <!--
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
        -->
    </xsl:template>
    
</xsl:stylesheet>