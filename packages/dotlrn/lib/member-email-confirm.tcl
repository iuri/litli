ad_page_contract {
    Ask admin to confirm email and if so
    let the admin edit the email before sending
} {
    user_id:naturalnum,notnull
    {type "on join"}
    {return_url:localurl ""}
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $community_id \
    -privilege admin

# FIXME list/unlist user_id since hidden vars can't be multiple
set user_id [split $user_id]

ad_form -name member-email-confirm \
    -export { user_id community_id return_url type } \
    -has_submit 1 \
    -form {
	{from_addr:text {label "\#dotlrn.From\#"}}
	{subject:text {label "\#dotlrn.Subject\#"}}
	{email:richtext {label "\#dotlrn.Email_1\#"} {html {rows 20 cols 80 style width:100%}}}
	{btn_ok:text(submit) {label "[_ dotlrn.OK_Send_Email]"}}
	{btn_cancel:text(submit) {label "[_ dotlrn.Cancel_Dont_Send_email]"}}
    } -on_request {
	set community_name [dotlrn_community::get_community_name $community_id]

        if {![db_0or1row member_email {}]} {
	    set default_email [lindex [callback dotlrn::default_member_email -community_id $community_id -type $type -var_list [list course_name $community_name community_name $community_name]] 0]
	    if {![llength $default_email]} {
		set from_addr [party::email -party_id [ad_conn user_id]]
		set subject "Welcome to ${community_name}!"
	    }
	    set from_addr [lindex $default_email 0]
	    set subject [lindex $default_email 1]
	    set email [lindex $default_email 2]
	}
        set package [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL]
	if {$subject eq ""} {
 	    set subject [_ dotlrn.added_community_subject]
	}
	if {$email eq ""} {
 	    set email [_ dotlrn.added_community_message]
	}
	if {$from_addr eq ""} {
	    set from_addr [party::email -party_id [ad_conn user_id]]
	}
        set email [template::util::richtext::create $email text/html]
    } -on_submit {
	if {![info exists btn_cancel] || $btn_cancel eq ""} {
	    set email [template::util::richtext::get_property content $email]
	    if {$community_id ne ""} {

		foreach one_user_id $user_id {
		    dotlrn_community::send_member_email \
			-community_id $community_id \
			-to_user $one_user_id \
			-type $type \
			-override_email $email \
			-override_subject $subject
		}
		
		
	    }
	    set message [_ dotlrn.Email_Sent]
	} else {
	    set message [_ dotlrn.Email_Cancelled]
	}

    ad_returnredirect -message $message $return_url
    ad_script_abort
}

ad_return_template



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
