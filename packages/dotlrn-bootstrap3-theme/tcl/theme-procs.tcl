ad_library {

    Provides a simple API theme interactions
    
    @author Gustaf Neumann
    @creation-date 05 July 2015
}

ad_proc -public -callback subsite::theme_changed -impl dotlrn-bootstrap3-theme {
    -subsite_id:required
    -old_theme:required
    -new_theme:required
} {

    Implementation of the theme_changed callback which is called, whenever a theme is changed
    
    @param subsite_id subsite, of which the theme was changed
    @param old_theme the name of the old theme
    @param new_theme the name of the new theme
} { 
    
    dotlrn_bootstrap3_theme::portal_page_parameter_update -new_theme $new_theme
    
}

ad_proc -public dotlrn_bootstrap3_theme::portal_page_parameter_update {
    -new_theme:required
} {
    Set parameters depending on new activated theme
} {
    # ns_log notice "-----PROC CALLED"
    
    set package_id [site_node::get_element -url /dotlrn -element package_id]
    
    if {$new_theme eq "dotlrn_bootstrap3"} {
        db_transaction {
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter class_instance_pages_csv \
                    -value "#dotlrn.class_page_home_title#,#dotlrn-bootstrap3-theme.bootstrap-2column#,#dotlrn.class_page_home_accesskey#;#dotlrn.class_page_calendar_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.class_page_calendar_accesskey#;#dotlrn.class_page_file_storage_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.class_page_file_storage_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter club_pages_csv \
                    -value "#dotlrn.club_page_home_title#,#dotlrn-bootstrap3-theme.bootstrap-2column#,#dotlrn.club_page_home_accesskey#;#dotlrn.club_page_calendar_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.club_page_calendar_accesskey#;#dotlrn.club_page_file_storage_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.club_page_file_storage_accesskey#;#dotlrn.club_page_people_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.club_page_people_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter subcomm_pages_csv \
                    -value "#dotlrn.subcomm_page_home_title#,#dotlrn-bootstrap3-theme.bootstrap-2column#,#dotlrn.subcomm_page_home_accesskey#;#dotlrn.subcomm_page_info_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.subcomm_page_info_accesskey#;#dotlrn.subcomm_page_calendar_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.subcomm_page_calendar_accesskey#;#dotlrn.subcomm_page_file_storage_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.subcomm_page_file_storage_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter user_portal_pages_csv \
                    -value "#dotlrn.user_portal_page_home_title#,#dotlrn-bootstrap3-theme.bootstrap-2column#,#dotlrn.user_portal_page_home_accesskey#;#dotlrn.user_portal_page_calendar_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.user_portal_page_calendar_accesskey#;#dotlrn.user_portal_page_file_storage_title#,#dotlrn-bootstrap3-theme.bootstrap-1column#,#dotlrn.user_portal_page_file_storage_accesskey#"
                
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter admin_layout_name \
                    -value "#dotlrn-bootstrap3-theme.bootstrap-2column#"                    
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter non_member_layout_name \
                    -value "#dotlrn-bootstrap3-theme.bootstrap-2column#"                    
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter DefaultMaster_p \
                    -value "/packages/dotlrn-bootstrap3-theme/resources/masters/dotlrn-master"                    
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter DefaultSiteTemplate \
                    -value "#dotlrn-bootstrap3-theme.bootstrap3-theme#"                    
                    
                parameter::set_from_package_key \
                    -package_key new-portal \
                    -parameter default_theme_name \
                    -value "#dotlrn-bootstrap3-theme.bootstrap3-theme#"                    
                    
                parameter::set_from_package_key \
                    -package_key new-portal \
                    -parameter default_layout \
                    -value "#dotlrn-bootstrap3-theme.bootstrap-2column#"
	    }
        
    } elseif {$new_theme eq "dotlrn_zen"} {
        db_transaction {
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter class_instance_pages_csv \
                    -value "#dotlrn.class_page_home_title#,#theme-zen.Zen_thin_thick#,#dotlrn.class_page_home_accesskey#;#dotlrn.class_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.class_page_calendar_accesskey#;#dotlrn.class_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.class_page_file_storage_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter club_pages_csv \
                    -value "#dotlrn.club_page_home_title#,#theme-zen.Zen_thin_thick#,#dotlrn.club_page_home_accesskey#;#dotlrn.club_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.club_page_calendar_accesskey#;#dotlrn.club_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.club_page_file_storage_accesskey#;#dotlrn.club_page_people_title#,#theme-zen.Zen_1_column#,#dotlrn.club_page_people_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter subcomm_pages_csv \
                    -value "#dotlrn.subcomm_page_home_title,#theme-zen.Zen_thin_thick#,#dotlrn.subcomm_page_home_accesskey#;#dotlrn.subcomm_page_info_title#,#theme-zen.Zen_1_column#,#dotlrn.subcomm_page_info_accesskey#;#dotlrn.subcomm_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.subcomm_page_calendar_accesskey#;#dotlrn.subcomm_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.subcomm_page_file_storage_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter user_portal_pages_csv \
                    -value "#dotlrn.user_portal_page_home_title#,#theme-zen.Zen_thin_thick#,#dotlrn.user_portal_page_home_accesskey#;#dotlrn.user_portal_page_calendar_title#,#theme-zen.Zen_1_column#,#dotlrn.user_portal_page_calendar_accesskey#;#dotlrn.user_portal_page_file_storage_title#,#theme-zen.Zen_1_column#,#dotlrn.user_portal_page_file_storage_accesskey#"
            
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter admin_layout_name \
                    -value "#theme-zen.Zen_2_column#"
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter non_member_layout_name \
                    -value "#theme-zen.Zen_2_column#"
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter DefaultMaster_p \
                    -value "/packages/theme-zen/lib/lrn-master"
                    
                parameter::set_default \
                    -package_key dotlrn \
                    -parameter DefaultSiteTemplate \
                    -value "#theme-zen.Zen_Theme#"
                    
                parameter::set_from_package_key \
                    -package_key new-portal \
                    -parameter default_theme_name \
                    -value "#theme-zen.Zen_Theme#"
                
                parameter::set_from_package_key \
                    -package_key new-portal \
                    -parameter default_layout \
                    -value "#theme-zen.Zen_2_column#"
        }
    }
    
    if {$new_theme eq "dotlrn_bootstrap3" || $new_theme eq "dotlrn_zen"} {
        set site_template_name [db_string get_site_template_name {}]
        set site_template_id [db_string select_st_id {}]
        
        # for communities
        parameter::set_value -package_id $package_id \
            -parameter  "CommDefaultSiteTemplate_p" \
            -value $site_template_id
               
        # for users
        parameter::set_value -package_id $package_id \
            -parameter  "UserDefaultSiteTemplate_p" \
            -value $site_template_id
        
        # Theme switching: theme of portlet design
        # Note that dotlrn uses same name for theme name and subsite name !
        db_1row get_theme {}
        db_dml update_theme {}
        # ns_log notice "---THEME: DONE"
        
        # Layout switching: Layout of portal page e.g. 2-column, 1-column etc
        if {$new_theme eq "dotlrn_bootstrap3"} {
            set layout_blueprint ZenToBootstrapMap
        } elseif {$new_theme eq "dotlrn_zen"} {
            set layout_blueprint BootstrapToZenMap
        }

        # ns_log notice "PARAMETER: <[parameter::get_from_package_key -package_key dotlrn-bootstrap3-theme -parameter $layout_blueprint]>"
        
        db_transaction {
            foreach {old new} [parameter::get_from_package_key -package_key dotlrn-bootstrap3-theme -parameter $layout_blueprint] {
                db_1row get_old {}
                # ns_log notice "OLD: $old"
                db_1row get_new {}
                # ns_log notice "NEW: $new"
                db_dml update_layouts {}
                # ns_log notice "---LAYOUT: DONE"
                
            }
        } on_error {
            ns_log notice "$errmsg"
        }
    }
            
    # ns_log notice "---PROC FINISHED"
    
}
