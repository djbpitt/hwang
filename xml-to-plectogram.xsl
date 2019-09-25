<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:svg="http://www.w3.org/2000/svg" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="rectHeight" as="xs:integer" select="20"/>
    <xsl:variable name="rectWidth" as="xs:integer" select="500"/>
    <xsl:function name="djb:processYear" as="element()">
        <xsl:param name="year"/>
        <xsl:variable name="precedingYear" select="$year/preceding-sibling::year[1]"/>
        <svg:g id="{concat('y', $year/@n)}"
            transform="translate({$year/count(preceding-sibling::year) * 1000}, 0)">
            <xsl:for-each select="$year/monument">
                <xsl:variable name="yPos" as="xs:integer" select="(position() - 1) * $rectHeight"/>
                <svg:rect x="0" y="{$yPos}" width="{$rectWidth}" height="{$rectHeight}"
                    stroke="black" stroke-width="2" fill="none"/>
                <svg:text x="2" y="{$yPos + 16}">
                    <xsl:value-of select="."/>
                </svg:text>
                <xsl:if test="$precedingYear">
                    <xsl:if test="$precedingYear/monument = current()">
                        <xsl:variable name="yPosPreceding" as="xs:integer"
                            select="($rectHeight div 2) + $rectHeight * (count($precedingYear/monument[. = current()]/preceding-sibling::monument))"/>
                        <svg:line x1="{$rectWidth - 1000}" y1="{$yPosPreceding}" x2="0"
                            y2="{$yPos + ($rectHeight div 2)}" stroke="black" stroke-width="1"/>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </svg:g>
    </xsl:function>
    <xsl:template match="/">
        <html>
            <head>
                <title>Monuments</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"
                />
            </head>
            <body>
                <h1>Monuments</h1>
                <svg:svg width="100%" height="{max(//year/count(monument)) * $rectHeight}">
                    <svg:g id="wrapper">
                        <xsl:for-each select="//year">
                            <xsl:sequence select="djb:processYear(.)"/>
                        </xsl:for-each>
                    </svg:g>
                </svg:svg>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
