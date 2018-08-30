ad_library {

     Theme Zen Package APM callbacks library

     Procedures that deal with installing.

     @creation-date May 2006
     @author  Don Baccus (dhogaza@pacifier.com)
     @cvs-id $Id: apm-callback-procs.tcl,v 1.2.8.2 2015/09/12 19:00:46 gustafn Exp $

}

namespace eval theme_zen {}
namespace eval theme_zen::apm {}

ad_proc -public theme_zen::apm::after_install {} {

    Create the Zen Theme for the new-portals and dotlrn packages.

    Done here as a Tcl callback because ...

    1. It's simpler than writing SQL
    2. It works for both Oracle and PostgreSQL

} {

    set var_list [list \
        [list name "#theme-zen.Zen_1_column#"] \
        [list description "#theme-zen.Zen_1_column#"] \
        [list resource_dir /resources/theme-zen/css/zen1] \
        [list filename ../../theme-zen/lib/layouts/zen1]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    set var_list [list \
        [list layout_id $layout_id] \
        [list region 1]
    ]
    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
        [list name "#theme-zen.Zen_2_column#"] \
        [list description "#theme-zen.Zen_2_column#"] \
        [list resource_dir /resources/theme-zen/css/zen2] \
        [list filename ../../theme-zen/lib/layouts/zen2]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
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
        [list name "#theme-zen.Zen_3_column#"] \
        [list description "#theme-zen.Zen_3_column#"] \
        [list resource_dir /resources/theme-zen/css/zen3] \
        [list filename ../../theme-zen/lib/layouts/zen3]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
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

    set var_list [list \
        [list name "#theme-zen.Zen_thin_thick#"] \
        [list description "#theme-zen.Zen_thin_thick#"] \
        [list resource_dir /resources/theme-zen/css/zen-thin-thick] \
        [list filename ../../theme-zen/lib/layouts/zen2]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
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
        [list name "#theme-zen.Zen_thin_thick_thin#"] \
        [list description "#theme-zen.Zen_thin_thick_thin#"] \
        [list resource_dir /resources/theme-zen/css/zen-thin-thick] \
        [list filename ../../theme-zen/lib/layouts/zen3]
    ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
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
       
    set var_list [list \
        [list name "#theme-zen.Zen_Theme#"] \
        [list description "#theme-zen.Zen_Theme#"] \
        [list filename ../../theme-zen/lib/themes/zen-theme] \
        [list resource_dir ../../theme-zen/lib/themes/zen-theme]
    ]

    set theme_id [package_instantiate_object -var_list $var_list portal_element_theme]

    set site_template_id [db_nextval acs_object_id_seq]
    db_dml insert_theme_to_dotlrn_site_templates {}

    db_transaction {

        subsite::new_subsite_theme \
            -key dotlrn_zen \
            -name #theme-zen.Zen_Theme# \
            -template /packages/theme-zen/lib/lrn-master \
            -css {
		{-href /resources/acs-templating/forms.css -media all}
		{-href /resources/acs-templating/lists.css -media all}
		{-href "/resources/acs-subsite/default-master.css" -media "screen" -order 1}
		{-href "/resources/theme-zen/css/main.css" -media "screen" -order 2}
		{-href "/resources/theme-zen/css/print.css" -media "print" -order 3}
		{-href "/resources/theme-zen/css/handheld.css" -media "handheld" -order 4}
		{-alternate -href "/resources/theme-zen/css/highContrast.css" -title "highContrast"}
		{-alternate -href "/resources/theme-zen/css/508.css" -title "508"}
	    } \
	    -js {
		{-src "/resources/theme-zen/js/styleswitcher.js"}
	    } \
            -form_template "" \
            -list_template "" \
            -list_filter_template "" \
	    -dimensional_template ""
    }
    
    subsite::set_theme -theme dotlrn_zen

}

ad_proc -public theme_zen::apm::before_uninstall {} {
    Uninstall the package
} {
    subsite::delete_subsite_theme -key dotlrn_zen

    #
    # At least, the code for Deleting the created portal layouts is
    # missing to uninstall this package
    #
    # see portal_layout__delete(integer)
    # select * from portal_layouts ;
}


ad_proc -public theme_zen::apm::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    Upgrade the package
} {
    if {[apm_version_names_compare $from_version_name "2.9.0d4"] == -1 &&
        [apm_version_names_compare $to_version_name "2.9.0d4"] > -1} {
	ns_log notice "-- upgrading to 2.9.0d4"

	#
	# Register the theme if not already there
	#
	set themes [db_list get_themes {select key from subsite_themes}]
	if {"dotlrn_zen" ni $themes} {
	    subsite::new_subsite_theme \
		-key dotlrn_zen \
		-name #theme-zen.Zen_Theme# \
		-template /packages/theme-zen/lib/lrn-master \
		-css {
		    {-href /resources/acs-templating/forms.css -media all}
		    {-href /resources/acs-templating/lists.css -media all}
		    {-href "/resources/acs-subsite/default-master.css" -media "screen" -order 1}
		    {-href "/resources/theme-zen/css/main.css" -media "screen" -order 2}
		    {-href "/resources/theme-zen/css/print.css" -media "print" -order 3}
		    {-href "/resources/theme-zen/css/handheld.css" -media "handheld" -order 4}
		    {-alternate -href "/resources/theme-zen/css/highContrast.css" -title "highContrast"}
		    {-alternate -href "/resources/theme-zen/css/508.css" -title "508"}
		} \
		-js {
		    {-src "/resources/theme-zen/js/styleswitcher.js"}
		} \
		-form_template "" \
		-list_template "" \
		-list_filter_template "" \
		-dimensional_template ""
	}
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
