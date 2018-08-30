set show_p [dotlrn_toolbar::show_p]

if { $show_p } {
    set user_id [ad_conn user_id]
    set package_id [ad_conn package_id]
    set community_id [dotlrn_community::get_community_id]
    set dotlrn_url [dotlrn::get_url]
    set dotlrn_admin_url [dotlrn::get_admin_url]
    set return_url [ad_conn url]

    set info_show_p [dotlrn_toolbar::info_show_p]
    # Developers Info
    if { $info_show_p  } {
	set info_action "info_hide"
	set info_title "Hide Xtra Info"
    } else {
	set info_action "info_show"
	set info_title "Show Xtra Info"
    }
    set info_url [export_vars -base "$dotlrn_admin_url/toolbar-actions" {{action $info_action} return_url}]

    # hide/show dotlrn toolbar
    set hide_me_url [export_vars -base "$dotlrn_admin_url/toolbar-actions" {{action hide} return_url}]

    if { $community_id eq "" } {
	set portal_id [dotlrn::get_portal_id -user_id $user_id]
    } else {
	set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
    }
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
