ad_page_contract {
    Toggle the admin's alert on the given folder.

    We don't use the standard request form because it will ask the user to
    choose an interval and delivery type.  The homework package only supports
    instant e-mail notifications of file uploads.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 2002-07-25
    @cvs-id $Id: toggle-homework-alert.tcl,v 1.4.2.2 2016/05/20 20:26:15 gustafn Exp $
} {
    folder_id:integer,notnull
    request_id:integer
    type_id:integer,notnull
    subscribe_p:boolean,notnull
    return_url:localurl,notnull
} -validate {
    valid_folder -requires {folder_id:integer} {
	if {![fs_folder_p $folder_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_parent]"
	}
    }
}

set community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -community_id $community_id

if { $subscribe_p } {

    set intervals [notification::get_intervals -type_id $type_id]
    set delivery_methods [notification::get_delivery_methods -type_id $type_id]

    # Sanity check to make sure the db entries are set up correctly.

    if { [llength $intervals] != 1 || [llength $delivery_methods] != 1 } {
        ad_return_error "[_ dotlrn-homework.lt_internal_error]" "[_ dotlrn-homework.lt_interval_or_del]"
    }

    # The get routines return a list of name/id pairs so extract the ids
    set interval_id [lindex $intervals 0 1]
    set delivery_method_id [lindex $delivery_methods 0 1]

    # Add the alert
    notification::request::new -type_id $type_id -user_id [ad_conn user_id] -object_id $folder_id \
            -interval_id $interval_id -delivery_method_id $delivery_method_id

} else {
    # Remove the alert
    notification::request::delete -request_id $request_id
}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
