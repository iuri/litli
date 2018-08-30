ad_page_contract {
    
    Page for information regarding accessibility features

}

set title [_ theme-zen.Accessibility]
set context $title

template::multirow create accesskeys name url key

# Add fixed accesskeys
template::multirow append accesskeys [_ theme-zen.Accessibility_page] "/theme-zen/accessibility" 0
template::multirow append accesskeys [_ theme-zen.skip_to_main_content] "#content-wrapper" 2
template::multirow append accesskeys [_ dotlrn.Site_Map] "[dotlrn::get_url]/site-map" 4

set dotlrn_admin_p [permission::permission_p \
                        -no_login \
                        -party_id [ad_conn user_id] \
                        -object_id [dotlrn::get_package_id] \
                        -privilege admin]

if { $dotlrn_admin_p } {
    template::multirow append accesskeys [_ dotlrn.Administration] "[dotlrn::get_url]/admin" 9
}

# Now add the ones for the tabs (home should be 1)
foreach {url name key} [parameter::get_from_package_key \
                            -package_key "theme-zen" \
                            -parameter "AdditionalNavbarTabs" \
                            -default ""] {
    template::multirow append accesskeys $name $url [lang::util::localize $key]
}

template::multirow sort accesskeys key

template::list::create -name zen_keys -multirow accesskeys -elements {
    key {
        label "#theme-zen.Access_key#"
        display_col key
    }
    page {
        label "#theme-zen.Associated_page#"
        display_col name
        link_url_col url
        link_html {title "@accesskeys.name@"}
    }
}

template::add_event_listener -id "set-style-sheet-std" -script {setActiveStyleSheet('std');}
template::add_event_listener -id "set-style-sheet-highContrast" -script {setActiveStyleSheet('highContrast');}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
