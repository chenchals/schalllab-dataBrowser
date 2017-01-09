<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fx="http://exslt.org/functions"
    extension-element-prefixes="fx" exclude-result-prefixes="xs" version="1.0">
    
    <xsl:output method="text" indent="no"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//h2/following-sibling::*[1]/li/a">
            <xsl:call-template name="pubs"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="pubs">
        <xsl:variable name="cat">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:variable>
        <xsl:for-each select="//h3[node() = $cat]/following-sibling::*[1]/li"> 
            <xsl:call-template name="pub">
                <xsl:with-param name="cat" select="$cat"/></xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="pub">
        <xsl:param name="cat"/>
        <xsl:variable name="authorsYearTitle">
            <xsl:value-of select="normalize-space(text()[1])"/>
        </xsl:variable>
        <xsl:variable name="journal">
            <xsl:value-of select="normalize-space(concat(span[@class='journal'],text()[2]))"/>
        </xsl:variable>
        <xsl:variable name="pdf">
            <xsl:value-of select="normalize-space(a[position()=1 and contains(@href, 'pdf')]/@href)"/>
        </xsl:variable>
        <xsl:value-of
            select="
            concat(
            $cat
            , '|'
            , $authorsYearTitle
            , '|'
            , $journal
            , '|'
            , $pdf
            , '&#xA;'
            )"
        />
    </xsl:template>
    
    
</xsl:stylesheet>
