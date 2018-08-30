
<?xml version="1.0"?>

<queryset>

  <fullquery name="dotlrn_bootstrap3_theme::apm::after_install.insert_theme_to_dotlrn_site_templates">
    <querytext>
      insert into dotlrn_site_templates
        (site_template_id, pretty_name, site_master, portal_theme_id ) 
      values 
        (:site_template_id, '#dotlrn-bootstrap3-theme.bootstrap3-theme#', '/packages/dotlrn-bootstrap3-theme/resources/masters/dotlrn-master',
         :theme_id)
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_layouts1">
    <querytext>
        DELETE from portal_layouts WHERE name='#dotlrn-bootstrap3-theme.bootstrap-1column#';
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_layouts2">
    <querytext>
        DELETE from portal_layouts WHERE name='#dotlrn-bootstrap3-theme.bootstrap-2column#';
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_layouts3">
    <querytext>
        DELETE from portal_layouts WHERE name='#dotlrn-bootstrap3-theme.bootstrap-3column#'
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_supported_regions1">
    <querytext>
        DELETE 
        FROM portal_supported_regions AS psr
        USING portal_layouts AS pl
        where (pl.layout_id = psr.layout_id) AND pl.filename='../../dotlrn-bootstrap3-theme/lib/layouts/bootstrap-1column'
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_supported_regions2">
    <querytext>
        DELETE 
        FROM portal_supported_regions AS psr
        USING portal_layouts AS pl
        where (pl.layout_id = psr.layout_id) AND pl.filename='../../dotlrn-bootstrap3-theme/lib/layouts/bootstrap-2column'
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_supported_regions3">
    <querytext>
        DELETE 
        FROM portal_supported_regions AS psr
        USING portal_layouts AS pl
        where (pl.layout_id = psr.layout_id) AND pl.filename='../../dotlrn-bootstrap3-theme/lib/layouts/bootstrap-3column'
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_dotlrn_site_templates">
    <querytext>
        DELETE from dotlrn_site_templates WHERE pretty_name='#dotlrn-bootstrap3-theme.bootstrap3-theme#'
    </querytext>
  </fullquery>
  
  <fullquery name="dotlrn_bootstrap3_theme::apm::before_uninstall.delete_theme_from_portal_element_themes">
    <querytext>
        DELETE from portal_element_themes WHERE name='#dotlrn-bootstrap3-theme.bootstrap3-theme#'
    </querytext>
  </fullquery>
    
</queryset>
