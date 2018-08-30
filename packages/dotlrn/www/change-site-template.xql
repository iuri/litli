<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Victor Guerra (guerra@galileo.edu) -->
<!-- @creation-date 2005-05-25 -->
<!-- @arch-tag: d023d173-cfd8-40dc-a928-c05dfe394d93 -->
<!-- @cvs-id $Id: change-site-template.xql,v 1.2 2006/08/08 21:26:23 donb Exp $ -->

<queryset>
  <fullquery name="select_site_templates">
    <querytext>
      select pretty_name, site_template_id
      from dotlrn_site_templates
    </querytext>
  </fullquery>
</queryset>