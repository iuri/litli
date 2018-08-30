ad_page_contract {

} {
    action:notnull
    {search_type ""}
    {keyword ""}
    {return_url:localurl ""}
} -validate {
    if_search {
	if { $action eq "search" && ( $search_type eq "" || $keyword eq "" ) } {
	    ad_complain "If you want to search please type some keyword and in where to search"
	}
    }
    if_not_admin {
	if { ![acs_user::site_wide_admin_p] && ![dotlrn::admin_p] } {
	    ad_complain "Not authorized to do toolbar actions"
	}
    }
}

switch $action {
    "search" {
	switch $search_type {
	    "departments" {
		set url "/dotlrn/admin/departments?keyword=$keyword"
	    }
	    "subjects" {
		set url "/dotlrn/admin/classes?keyword=$keyword"
	    }
	    "classes" {
		set url "/dotlrn/admin/term?keyword=$keyword&term_id=-1"
	    }
	    default {
		set url "/dotlrn/admin/users-search?name=$keyword&form:id=user_search"
	    }
	}
    }
    "hide" {
	parameter::set_value -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_enabled_p -value 0
	set url $return_url
    }
    "show" {
	parameter::set_value -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_enabled_p -value 1
	set url $return_url
    }
    "info_hide" {
	parameter::set_value -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_show_info_p -value 0
	set url $return_url
    }
    "info_show" {
	parameter::set_value -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_show_info_p -value 1
	set url $return_url
    }
}


ad_returnredirect $url
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
