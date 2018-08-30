# packages/dotlrn/lib/member-email.tcl
#
# form for adding/editing a member email based on type
# as includeletized from roelc's original code
#
# @author Deds Castillo (deds@i-manila.com.ph)
# @creation-date 2005-07-20
# @arch-tag: 7d4ddca7-20cd-4e7d-9fc1-d23cd8b2a712
# @cvs-id $Id: member-email.tcl,v 1.6.4.2 2016/09/12 11:14:56 gustafn Exp $

foreach required_param {community_id type return_url} {
    if {![info exists $required_param]} {
        return -code error "$required_param is a required parameter."
    }
}

foreach optional_param {enabled_p extra_vars} {
    if {![info exists $optional_param]} {
        set $optional_param {}
    }
}
ns_log notice "dedsman: $extra_vars"
if {![template::util::is_true $enabled_p]} {
    set enabled_p f
} else {
    set enabled_p t
}

if {$community_id eq ""} {
    permission::require_permission -object_id [ad_conn package_id] -privilege "admin"
} else {
    dotlrn::require_user_admin_community -community_id $community_id
}

if {$community_id eq ""} {
    db_0or1row member_email {
	select email_id from
	dotlrn_member_emails
	where community_id is null
	and type = :type}
} else {
    db_0or1row member_email {
	select email_id
	from dotlrn_member_emails
	where community_id = :community_id 
	and type = :type
    }
}

array set available_vars [lindex [callback dotlrn::member_email_available_vars -type $type -community_id $community_id] 0]
set available_vars_help ""
foreach var [array names available_vars] {
    append available_vars_help "$var $available_vars($var) <br>"
}

ad_form \
    -name "member_email" \
    -export $extra_vars \
    -cancel_url $return_url \
    -form {
        {email_id:key}
    }

if {$available_vars_help ne ""} {
    ad_form -extend -name "member_email" -form {
	{help:text(inform) {label "Available variables"} {value $available_vars_help}}
    }
}

ad_form -extend -name "member_email" -form {
        {from_addr:text {label "From Address"} {html {size 40}}}
        {subject:text {label "Subject"} {html {size 40}}}
        {email:richtext,optional {label "Message"} {html {rows 30 cols 80}} {htmlarea_p 0}}
	{community_id:text(hidden) {value $community_id}}
        {type:text(hidden) {value $type}}
	{enabled_p:text(hidden) {value $type}}
        {return_url:text(hidden) {value $return_url}}
    } -on_request {
	if {$community_id ne "" } {
	    set community_name [dotlrn_community::get_community_name $community_id]
	} else {
	    set community_name ""
	}

        set default_email [lindex [callback dotlrn::default_member_email -community_id $community_id -type $type -var_list [list course_name $community_name community_name $community_name]] 0]
        if {![llength $default_email]} {
            set from_addr [party::email -party_id [ad_conn user_id]]
            set subject "Welcome to ${community_name}!"
        }
        set from_addr [lindex $default_email 0]
        set subject [lindex $default_email 1]
        set email [template::util::richtext::create [lindex $default_email 2] text/html]
    } -edit_request {
        db_1row member_email {
            select from_addr,
                   subject,
                   email
            from dotlrn_member_emails
            where email_id = :email_id
        }
        set email [list $email "text/html"]
    } -on_submit {
        set email [template::util::richtext::get_property contents $email]
    } -new_data {
        db_dml new_email {
            insert into dotlrn_member_emails
            (community_id, type, from_addr, subject, email, enabled_p)
            values
            (:community_id, :type, :from_addr, :subject, :email, :enabled_p)
        }
    } -edit_data {
        db_dml update_email {
            update dotlrn_member_emails
            set from_addr = :from_addr,
                subject = :subject,
                email = :email
            where email_id = :email_id
        }
    } -after_submit {
        ad_returnredirect $return_url
        ad_script_abort
    }

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
