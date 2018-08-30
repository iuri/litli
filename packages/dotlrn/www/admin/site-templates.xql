<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Victor Guerra (guerra@galileo.edu) -->
<!-- @creation-date 2005-05-19 -->
<!-- @arch-tag: 8d17b70f-91ef-41c1-bc52-f837f8d652c2 -->
<!-- @cvs-id $Id: site-templates.xql,v 1.2 2006/08/08 21:26:28 donb Exp $ -->

<queryset>
  <fullquery name="select_site_templates">
    <querytext>
      select dst.site_template_id, dst.pretty_name, 
      pet.name || ' ( ' || pet.description || ' )' as portal_theme
      from dotlrn_site_templates dst, portal_element_themes pet
      where dst.portal_theme_id = pet.theme_id 
    </querytext>
  </fullquery>
</queryset>