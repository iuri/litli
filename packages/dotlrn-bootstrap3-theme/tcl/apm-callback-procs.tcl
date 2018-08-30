namespace eval dotlrn_bootstrap3_theme {}
namespace eval dotlrn_bootstrap3_theme::apm {}

ad_proc dotlrn_bootstrap3_theme::apm::after_install {} {
    Package after installation callback proc.  Add a theme for dotlrn.
    This Package depends on openacs-bootstrap3-theme
} {

    
    ### 1-COLUMN LAYOUT ###
    # Insert layout to portal_layouts
    set var_list [list \
        [list name "#dotlrn-bootstrap3-theme.bootstrap-1column#"] \
        [list description "#dotlrn-bootstrap3-theme.bootstrap-1column#"] \
        [list resource_dir /resources/dotlrn-bootstrap3-theme/css] \
        [list filename ../../dotlrn-bootstrap3-theme/lib/layouts/bootstrap-1column]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    
    # Insert regions to portal_supported_regions
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region

    ### 2-COLUMN LAYOUT ###
    # Insert layout to portal_layouts
    set var_list [list \
        [list name "#dotlrn-bootstrap3-theme.bootstrap-2column#"] \
        [list description "#dotlrn-bootstrap3-theme.bootstrap-2column#"] \
        [list resource_dir /resources/dotlrn-bootstrap3-theme/css] \
        [list filename ../../dotlrn-bootstrap3-theme/lib/layouts/bootstrap-2column]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    
    # Insert regions to portal_supported_regions
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    
    ### 3-COLUMN LAYOUT ###
    # Insert layout to portal_layouts
    set var_list [list \
        [list name "#dotlrn-bootstrap3-theme.bootstrap-3column#"] \
        [list description "#dotlrn-bootstrap3-theme.bootstrap-3column#"] \
        [list resource_dir /resources/dotlrn-bootstrap3-theme/css] \
        [list filename ../../dotlrn-bootstrap3-theme/lib/layouts/bootstrap-3column]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    
    # Insert regions to portal_supported_regions
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 2]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 3]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    
    
    # Insert these themes into portal_element_themes
    set var_list [list \
        [list name "#dotlrn-bootstrap3-theme.bootstrap3-theme#"] \
        [list description "#dotlrn-bootstrap3-theme.bootstrap3-theme#"] \
        [list filename ../../dotlrn-bootstrap3-theme/lib/themes/bootstrap3-theme] \
        [list resource_dir ../../dotlrn-bootstrap3-theme/lib/themes/bootstrap3-theme]
    ]
    set theme_id [package_instantiate_object -var_list $var_list portal_element_theme]
    
    # Insert these themes to dotlrn_site_templates
    set site_template_id [db_nextval acs_object_id_seq]
    db_dml insert_theme_to_dotlrn_site_templates {}
    
    # Insert this package's themes to site_templates
    db_transaction {
            
        subsite::new_subsite_theme \
            -key dotlrn_bootstrap3 \
            -name #dotlrn-bootstrap3-theme.bootstrap3-theme# \
            -template /packages/dotlrn-bootstrap3-theme/resources/masters/dotlrn-master \
            -css {
{-href /resources/acs-subsite/site-master.css -media all -order 0}
{-href //maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css -media all -order 1}
{-href /resources/openacs-bootstrap3-theme/css/main.css -media all -order 2}
{-href /resources/dotlrn-bootstrap3-theme/css/dotlrn.css -media all -order 3}
{-href /resources/dotlrn-bootstrap3-theme/css/color/green.css -media all -order 4}
{-href /resources/acs-templating/forms.css -media all -order 5}
{-href /resources/acs-templating/lists.css -media all -order 6}
            } \
            -js {
{-src "/resources/openacs-bootstrap3-theme/js/jquery-1.11.3.min.js" -order 1}
{-src "//maxcdn.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" -order 2}
            } \
            -form_template standard \
            -list_template table \
            -list_filter_template filters \
            -dimensional_template dimensional \
            -resource_dir /packages/openacs-bootstrap3-theme/resources \
            -streaming_head /packages/dotlrn-bootstrap3-theme/resources/masters/dotlrn-streaming-head \
    }
}

ad_proc -public dotlrn_bootstrap3_theme::apm::before_uninstantiate {
    {-package_id:required}
} {
    Uninstantiate the package. We set portal_pages to zen theme layout here, because parameter BootstrapToZenMap is not available anymore at before_uninstall.
} { 
    
    # switch to zen-theme, set zen-theme-specific parameters, update portal_pages to zen-theme
    if {[subsite::get_theme] in {dotlrn_bootstrap3}} {
        subsite::set_theme -theme dotlrn_zen
    }
    # set default parameters to zen-theme; set portal_pages to zen-theme layout
    dotlrn_bootstrap3_theme::portal_page_parameter_update -new_theme dotlrn_zen
    
}

ad_proc -public dotlrn_bootstrap3_theme::apm::before_uninstall {} {
    Uninstall the package
} {
    
    db_transaction {
        # delete dotlrn-bootstrap3 portal_layouts, portal_supported_regions, dotlrn_site_templates. portal_element_themes
        db_dml delete_theme_from_portal_layouts1 {}
        db_dml delete_theme_from_portal_layouts2 {}
        db_dml delete_theme_from_portal_layouts3 {}
        db_dml delete_theme_from_portal_supported_regions1 {}
        db_dml delete_theme_from_portal_supported_regions2 {}
        db_dml delete_theme_from_portal_supported_regions3 {}
        db_dml delete_theme_from_dotlrn_site_templates {}
        db_dml delete_theme_from_portal_element_themes {}
    } on_error {
        ns_log notice "$errmsg"
    }
    
    # delete subsite_theme
    subsite::delete_subsite_theme -key dotlrn_bootstrap3
}

