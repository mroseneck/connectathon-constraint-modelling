<xsl:stylesheet version="3.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:odm="http://www.cdisc.org/ns/odm/v1.3" exclude-result-prefixes="map">
  <xsl:output method="xml" indent="yes" encoding="UTF-8" />
  <xsl:template match="odm:ODM">
    <xs:schema xmlns="http://www.cdisc.org/ns/odm/v1.3" xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="http://www.cdisc.org/ns/odm/v1.3" elementFormDefault="qualified">
      
      <xs:element name="ODM">
        <xs:complexType>
          <xs:sequence>
            <xs:element ref="ClinicalData" />
          </xs:sequence>
          <xs:attributeGroup ref="OdmAttributes" />
        </xs:complexType>
      </xs:element>
      
      <!-- valid oids per element -->      
      <xsl:element name="xs:simpleType">
        <xsl:attribute name="name">
          <xsl:value-of select="'oids.event'" />
        </xsl:attribute>
        <xsl:element name="xs:restriction">
          <xsl:attribute name="base">
            <xsl:value-of select="'xs:string'" />
          </xsl:attribute>
          <xsl:for-each select="//odm:StudyEventRef">
            <xsl:element name="xs:enumeration">
              <xsl:attribute name="value">
                <xsl:value-of select="./@StudyEventOID" />
              </xsl:attribute>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
      
      <xsl:for-each select="//odm:StudyEventDef">
        <xsl:element name="xs:simpleType">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('oids.',./@OID)" />
          </xsl:attribute>
          <xsl:element name="xs:restriction">
            <xsl:attribute name="base">
              <xsl:value-of select="'xs:string'" />
            </xsl:attribute>
            <xsl:for-each select="./odm:FormRef">
              <xsl:element name="xs:enumeration">
                <xsl:attribute name="value">
                  <xsl:value-of select="./@FormOID" />
                </xsl:attribute>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      
      <xsl:for-each select="//odm:FormDef">
        <xsl:element name="xs:simpleType">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('oids.',./@OID)" />
          </xsl:attribute>
          <xsl:element name="xs:restriction">
            <xsl:attribute name="base">
              <xsl:value-of select="'xs:string'" />
            </xsl:attribute>
            <xsl:for-each select="./odm:ItemGroupRef">
              <xsl:element name="xs:enumeration">
                <xsl:attribute name="value">
                  <xsl:value-of select="./@ItemGroupOID" />
                </xsl:attribute>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      
      <xsl:for-each select="//odm:ItemGroupDef">
        <xsl:element name="xs:simpleType">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('oids.',./@OID)" />
          </xsl:attribute>
          <xsl:element name="xs:restriction">
            <xsl:attribute name="base">
              <xsl:value-of select="'xs:string'" />
            </xsl:attribute>
            <xsl:for-each select="./odm:ItemRef">
              <xsl:element name="xs:enumeration">
                <xsl:attribute name="value">
                  <xsl:value-of select="./@ItemOID" />
                </xsl:attribute>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      
      <!-- structure -->      
      <xs:element name="ClinicalData">
        <xs:complexType>
          <xs:sequence>
            <xs:element ref="SubjectData" />
          </xs:sequence>
          <xs:attributeGroup ref="ClinicalDataAttributes" />
        </xs:complexType>
      </xs:element>
      
      <xs:element name="SubjectData">
        <xs:complexType>
          <xs:all>
            <xs:element ref="SiteRef" minOccurs="1" />
            <xsl:apply-templates select="//odm:StudyEventRef" />
          </xs:all>
          <xs:attributeGroup ref="SubjectDataAttributes" />
        </xs:complexType>
      </xs:element>
      
      <xsl:for-each select="//odm:StudyEventDef">
        <xsl:element name="xs:element">
          <xsl:attribute name="name" select="'StudyEventData'"/>
          <xsl:element name="xs:attribute">
            <xsl:attribute name="name" select="'StudyEventOID'"/>
            <xsl:attribute name="type" select="./@OID"/>
          </xsl:element>
          <xs:complexType>
            <xs:all>
              <!-- <xsl:for-each select="./odm:FormRef">
              </xsl:for-each> -->
            </xs:all>
          </xs:complexType>
        </xsl:element>  
      </xsl:for-each>
      
      <xsl:for-each select="//odm:FormDef">
        <xsl:element name="xs:element">
          <xsl:attribute name="name" select="'FormData'"/>
          <xsl:element name="xs:attribute">
            <xsl:attribute name="name" select="'FormOID'"/>
            <xsl:attribute name="type" select="./@OID"/>
          </xsl:element>
        </xsl:element>  
      </xsl:for-each>
      
      <xs:element name="SiteRef">
        <xs:complexType>
          <xs:attribute name="LocationOID" />
        </xs:complexType>
      </xs:element>
      
      <xs:attributeGroup name="OdmAttributes">
        <xs:attribute name="FileType" type="xs:string" use="required" />
        <xs:attribute name="Granularity" type="xs:string" use="required" />
        <xs:attribute name="FileOID" type="xs:string" use="required" />
        <xs:attribute name="CreationDateTime" type="xs:string" use="required" />
        <xs:attribute name="ODMVersion" type="xs:string" use="required" />
      </xs:attributeGroup>
      
      <xs:attributeGroup name="ClinicalDataAttributes">
        <xs:attribute name="StudyOID" type="xs:string" use="required" />
        <xs:attribute name="MetaDataVersionOID" type="xs:string" use="required" />
      </xs:attributeGroup>
      <xs:attributeGroup name="SubjectDataAttributes">
        <xs:attribute name="SubjectKey" type="xs:string" use="required" />
      </xs:attributeGroup>
      
    </xs:schema>
  </xsl:template>
  
  <xsl:template match="odm:StudyEventRef">
    <xsl:variable name="current" select="."/>
    <xsl:element name="xs:element">
      <xsl:attribute name="name" select="'StudyEventData'"/>
      <xsl:choose>
        <xsl:when test="./@Mandatory='Yes'">
          <xsl:attribute name="minOccurs" select="'1'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="minOccurs" select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xs:complexType>
        <xs:all>
          <xsl:apply-templates select="//odm:StudyEventDef[@OID=$current/@StudyEventOID]/odm:FormRef" />
        </xs:all>
        <xsl:element name="xs:attribute">
          <xsl:attribute name="name">StudyEventOID</xsl:attribute>
          <xsl:attribute name="type">
            <xsl:value-of select="'oid.event'" />
          </xsl:attribute>
        </xsl:element>
      </xs:complexType>
    </xsl:element>
  </xsl:template>  
  
  <xsl:template match="odm:FormRef">
    <xsl:variable name="current" select="."/>
    <xsl:element name="xs:element">
      <xsl:attribute name="name" select="'FormData'"/>
      <xsl:choose>
        <xsl:when test="./@Mandatory='Yes'">
          <xsl:attribute name="minOccurs" select="'1'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="minOccurs" select="'0'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xs:complexType>
        <xs:all>
          <xsl:apply-templates select="//odm:FormDef[@OID=$current/@OID]/odm:ItemGroupRef" />
        </xs:all>
        <xsl:element name="xs:attribute">
          <xsl:attribute name="name">FormOID</xsl:attribute>
          <xsl:attribute name="type">
            <xsl:value-of select="concat('oids.',./@OID)" />
          </xsl:attribute>
        </xsl:element>
      </xs:complexType>
    </xsl:element>
  </xsl:template>  
  
  <xsl:template match="odm:ItemGroupRef">
    <xs:element name="ItemGroupData">
      <xs:complexType>
        <xs:sequence>
          <xsl:apply-templates select="//odm:ItemGroupDef/odm:ItemRef" />
        </xs:sequence>
        <xsl:element name="xs:attribute">
          <xsl:attribute name="name">ItemGroupOID</xsl:attribute>
        </xsl:element>
      </xs:complexType>
    </xs:element>
  </xsl:template>
  
  <xsl:template match="odm:ItemRef">
    <xs:element name="ItemData">
      <xs:complexType>
        <xsl:element name="xs:attribute">
          <xsl:attribute name="name">ItemOID</xsl:attribute>
        </xsl:element>
        <xsl:element name="xs:attribute">
          <xsl:attribute name="name">Value</xsl:attribute>
        </xsl:element>
      </xs:complexType>
    </xs:element>
  </xsl:template>
  
</xsl:stylesheet>