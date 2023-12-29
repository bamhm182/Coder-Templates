<!--
    This customizes a libvirt domain xml.
    From: https://github.com/rgl/terraform-libvirt-windows-example/blob/master/libvirt-domain.xsl
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
  <!-- Copy all -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <!-- Set main disk bus to sata -->
  <xsl:template match="/domain/devices/disk[@device='disk']/target/@bus">
    <xsl:attribute name="bus">
      <xsl:value-of select="'sata'"/>
    </xsl:attribute>
  </xsl:template>
  <!-- Delete wwn element from main disk -->
  <xsl:template match="/domain/devices/disk[@device='disk']/wwn">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- Set CDROM to SCSI instead of IDE -->
  <xsl:template match="/domain/devices/disk[@device='cdrom']/target/@bus">
    <xsl:attribute name="bus">
      <xsl:value-of select="'scsi'"/>
    </xsl:attribute>
  </xsl:template>
  <!-- Add a Spice video connection -->
  <xsl:template match="/domain/devices">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
      <channel type="spicevmc">
        <target type="virtio" name="com.redhat.spice.0"/>
        <address type="virtio-serial" controller="0" bus="0" port="2"/>
      </channel>
      <!--
      <input type="tablet" bus="usb">
        <address type="usb" bus="0" port="1"/>
      </input>
      -->
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

