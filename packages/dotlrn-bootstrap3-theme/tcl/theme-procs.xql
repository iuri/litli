<?xml version="1.0"?>

<queryset>

  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.get_site_template_name">
    <querytext>
       select name
       from subsite_themes
       where key = :new_theme
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.select_st_id">
    <querytext>
       select site_template_id
       from dotlrn_site_templates
       where pretty_name = :site_template_name
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.get_theme">
    <querytext>
      select theme_id
      from portal_element_themes
      where name = :site_template_name
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.update_theme">
    <querytext>
      update portals
      set theme_id = :theme_id
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.get_old">
    <querytext>
      select layout_id as old_id
      from portal_layouts
      where name = :old
    </querytext>
  </fullquery>

  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.get_new">
    <querytext>
      select layout_id as new_id
      from portal_layouts
      where name = :new
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::portal_page_parameter_update.update_layouts">
    <querytext>
      update portal_pages
      set layout_id = :new_id
      where layout_id = :old_id
    </querytext>
  </fullquery>
  
</queryset>
