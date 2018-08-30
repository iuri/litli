ad_page_contract {
} -query {
    {community_id:integer ""}
    {referer ""}
}

set spam_name [bulk_mail::parameter -parameter PrettyName -default [_ dotlrn.Spam]]
set context_bar [list [list $referer [_ dotlrn.Admin]] "$spam_name [_ dotlrn.Community]"]

if { (![info exists community_id] || $community_id eq "") } {
  set community_id [dotlrn_community::get_community_id]
}
set community_name [dotlrn_community::get_community_name $community_id]

# use my_user_id here so we don't confuse with user_id from the query
set my_user_id [ad_conn user_id]

dotlrn::require_user_read_private_data -user_id $my_user_id -object_id $community_id

set site_wide_admin_p [permission::permission_p \
    -object_id [acs_magic_object security_context_root] \
    -privilege admin \
]
if {!$site_wide_admin_p} {
    set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
    set read_private_data_p [dotlrn::user_can_read_private_data_p -user_id $my_user_id -object_id $community_id]
} else {
    set admin_p 1
    set read_private_data_p 1
}


set community_id [dotlrn_community::get_community_id]

#element create spam_message rel_type \
#    -label [_ dotlrn.To] \
#    -datatype text \
 #   -widget select \
 #   -options [list [list [_ dotlrn.Members] dotlrn_member_rel] [list [_ dotlrn.Administrators] dotlrn_admin_rel]] \
 #   -value $rel_type


# SET THE PROPERTIES RIGHT

set roles [dotlrn_community::get_roles -community_id $community_id]
set rel_types_html ""

foreach {rel_type role pretty_name pretty_plural} [eval concat $roles] {
    append rel_types_html "<div><label for=\"rel_types_$role\"><input type=checkbox value=$rel_type name=rel_types id=\"rel_types_$role\">  [lang::util::localize $pretty_plural]</label></div>"

}

db_multirow -extend {recipients url} current_members select_current_members {} {
    set url "/dotlrn/admin/user?user_id=$user_id"
    set recipients $user_id
}

template::list::create \
    -name current_members \
    -multirow current_members \
    -key recipients \
    -bulk_actions {
            "\#dotlrn.Compose_bulk_message\#" "spam" "\#dotlrn.Compose_bulk_message\#"
    } \
    -elements {
        first_names {
            label "\\#dotlrn.First_Name\\#"
            html { style "width:200" }
            link_url_eval {$url}
        }
        last_name {
            label "\\#dotlrn.Last_Name\\#"
            html { style "width:200" }
            link_url_eval {$url}
        }
        email {
            label "\\#dotlrn.Email_1\\#"
            html { style "width:200" }
            display_template {
                <a href="mailto:@current_members.email@">@current_members.email@</a>
            }
        }
    }

set exported_vars [export_vars -form { referer }]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
