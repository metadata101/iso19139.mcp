<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:gn="http://geonetwork-opensource.org"
		xmlns:gco="http://www.isotc211.org/2005/gco"
		xmlns:gmd="http://www.isotc211.org/2005/gmd"
		xmlns:gml="http://www.opengis.net/gml"
		xmlns:wfs="http://www.opengis.net/wfs"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"		
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- 
			 This xslt should transform output from the gboundaries WFS service 
			 available in the geoserver instance installed with geonetwork into fragments
			 that can be inserted into the template 'gboundaries fragments test template'
			 by the WFS fragment harvester in GeoNetwork to create metadata records 
			 for each country.
			 
			 Note: The WFS server in geoserver must be enabled before this service can be
			 accessed.
	 -->

	<xsl:template match="/">
		<records>
			<xsl:if test="boolean( ./@timeStamp )">
				<xsl:attribute name="timeStamp">
					<xsl:value-of select="./@timeStamp"></xsl:value-of>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="boolean( ./@lockId )">
				<xsl:attribute name="lockId">
					<xsl:value-of select="./@lockId"></xsl:value-of>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="*"/>
		</records>
	</xsl:template>

	<xsl:template match="gml:featureMembers">
		<xsl:apply-templates select="gn:gboundaries"/>
	</xsl:template>

	<xsl:template match="gn:gboundaries">
		<record>

			<!-- boundingPolygon -->

			<fragment id="geoservertest.boundingpolygon" uuid="{@gml:id}_boundingpolygon" title="{concat(gn:ADM0NAME,':',gn:ADM0_CODE,':boundingpoly')}">
				<gmd:geographicElement>
					<gmd:EX_BoundingPolygon>
						<gmd:polygon>
							<xsl:copy-of select="gn:the_geom/*"/>
						</gmd:polygon>
					</gmd:EX_BoundingPolygon>
				</gmd:geographicElement>
			</fragment>

			<!-- pointOfContact -->

			<fragment id="geoservertest.contactinfo" uuid="{@gml:id}_contactinfo" title="{concat(gn:ADM0NAME,':',gn:ADM0_CODE,':contactinfo')}">
				<gmd:CI_ResponsibleParty>
   				<gmd:individualName>
     				<gco:CharacterString>Dr Charlie Brown</gco:CharacterString>
   				</gmd:individualName>
   				<gmd:organisationName>
     				<gco:CharacterString>Silicon Graphics R4400 64bit Systems and Mapping Section</gco:CharacterString>
   				</gmd:organisationName>
    			<gmd:positionName>
       			<gco:CharacterString>Part-time Chief Cartographer</gco:CharacterString>
    			</gmd:positionName>
    			<gmd:role>
       			<gmd:CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact"/>
    			</gmd:role> 	
				</gmd:CI_ResponsibleParty>
			</fragment>

			<!-- keywords -->

			<fragment id="geoservertest.keywords" uuid="{@gml:id}_keywords" title="{concat(gn:ADM0NAME,':',gn:ADM0_CODE,':keywords')}">
				<gmd:descriptiveKeywords>
					<gmd:MD_Keywords>
						<gmd:keyword>
							<gco:CharacterString><xsl:value-of select="gn:CONTINENT_"/></gco:CharacterString>
						</gmd:keyword>
						<gmd:keyword>
							<gco:CharacterString><xsl:value-of select="gn:REGION_"/></gco:CharacterString>
						</gmd:keyword>
						<gmd:keyword>
							<gco:CharacterString>Country</gco:CharacterString>
						</gmd:keyword>
						<gmd:type>
							<gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme"/>
						</gmd:type>
					</gmd:MD_Keywords>
				</gmd:descriptiveKeywords>
			</fragment>

			<!-- citation -->

			<fragment id="geoservertest.citation" uuid="{@gml:id}_citation" title="{concat(gn:ADM0NAME,':',gn:ADM0_CODE,':citation')}">
				<gmd:CI_Citation>
					<gmd:title>
						<gco:CharacterString>Information about the geographic boundary for <xsl:value-of select="gn:ADM0NAME"/></gco:CharacterString>
					</gmd:title>
					<gmd:date>
						<gmd:CI_Date>
							<gmd:date>
								<gco:Date>
									<xsl:value-of select="gn:LAST_UPD"/>
								</gco:Date>
							</gmd:date>
							<gmd:dateType>
								<gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication"/>
							</gmd:dateType>
						</gmd:CI_Date>
					</gmd:date>
					<!-- xlink to contactinfo fragment defined above -->
					<gmd:citedResponsibleParty xlink:href="#{@fid}_contactinfo"/>
				</gmd:CI_Citation>
			</fragment>

			<!-- abstract -->

			<fragment id="geoservertest.abstract" uuid="{@gml:id}_abstract" title="{concat(gn:ADM0NAME,':',gn:ADM0_CODE,':abstract')}">
				<gmd:abstract>
					<gco:CharacterString>
						Metadata about the geographic boundary for <xsl:value-of select="gn:ADM0NAME"/>
						&#160;
						Continent: <xsl:value-of select="gn:CONTINENT_"/>
						&#160;
						Region: <xsl:value-of select="gn:REGION_"/>
					</gco:CharacterString>
				</gmd:abstract>
			</fragment>

			<!-- temporal extent = validity -->

			<fragment id="geoservertest.tempextent" uuid="{@gml:id}_tempextent" title="{concat(gn:ADM0NAME,':',gn:ADM0_CODE,':tempextent')}">
				<gmd:temporalElement>
					<gmd:EX_TemporalExtent>
						<gmd:extent>
							<gml:TimePeriod gml:id="{@gml:id}_timeperiod">
								<gml:beginPosition indeterminatePosition="unknown">unknown</gml:beginPosition>
								<gml:endPosition><xsl:value-of select="gn:LAST_UPD"/></gml:endPosition>
							</gml:TimePeriod>
						</gmd:extent>
					</gmd:EX_TemporalExtent>
				</gmd:temporalElement>
			</fragment>
			
		</record>
	</xsl:template>

</xsl:stylesheet>
