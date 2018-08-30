ad_page_contract {

    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date August 8,2005

} {
    {user_id:naturalnum,optional ""}
    {reset:optional}
    {reltype:optional}
    {referer "./"}
}

set community_id [dotlrn_community::get_community_id]

if { $user_id ne "" } {
    # we're dropping just one user
    set page_title "Drop Membership"
    set confirm_message "Are you sure you want to remove this user from this community ?"
    set action_url "deregister?user_id=$user_id&referer=$referer"
} else {
    # we're dropping a group of members
    set rel_types [dotlrn_community::get_roles -community_id $community_id]
    foreach role $rel_types {
        if {$reltype eq [lindex $role 0]} { 
            set role_shortname [lang::util::localize [lindex $role 0]]
            set role_prettyname [lang::util::localize [lindex $role 2]] 
        }
    }
    set page_title "Remove Members"
    set confirm_message "Are you sure you want to delete all members with the role $role_prettyname ?"
    set action_url "members?reset=1&reltype=$role_shortname"
}

template::add_body_script -script [subst {
    document.getElementById('member-confirm-button-yes').addEventListener('click', function (event) {
        event.preventDefault();
        window.location= '$action_url';
    }, false);
    document.getElementById('member-confirm-button-no').addEventListener('click', function (event) {
        event.preventDefault();
        history.go(-1);
    }, false);
}]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
