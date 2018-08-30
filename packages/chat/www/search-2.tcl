ad_page_contract {

} {
    {email ""}
    {last_name ""}
    keyword:optional
    target
    type:notnull
    room_id:naturalnum,notnull
    {passthrough ""}
    {limit_users_in_group_id:naturalnum ""}
} -properties {
    group_name:onevalue
    search_type:onevalue
    keyword:onevalue
    email:onevalue
    last_name:onevalue
    export_authorize:onevalue
    passthrough_parameters:onevalue
    context:onevalue
}

# Check input.
set exception_count 0
set exception_text ""
set SQL_LIMIT 20

set context [list "Search"]

if {[info exists keyword]} {
    # this is an administrator 
    if { $keyword eq "" } {
        incr exception_count
        append exception_text "<li>You forgot to type a search string!\n"
    }
} else {
    # from one of the user pages
    if { (![info exists email] || $email eq "") && \
            (![info exists last_name] || $last_name eq "") } {
        incr exception_count
        append exception_text "<li>You must specify either an email address or last name to search for.\n"
    }

    if { [info exists email] && [info exists last_name] && \
            $email ne "" && $last_name ne "" } {
        incr exception_count
        append exception_text "<li>You can only specify either email or last name, not both.\n"
    }

    if { ![info exists target] || $target eq "" } {
        incr exception_count
        append exception_text "<li>Target was not specified. This shouldn't have happened,
please contact the <a href=\"mailto:[ad_host_administrator]\">administrator</a>
and let them know what happened.\n"
    }
}

if { $exception_count != 00 } {
    ad_return_complaint $exception_count $exception_text
    return
}

####
# Input okay. Now start building the SQL

set where_clause [list]
if { [info exists keyword] } {
    set search_type "keyword"
    set sql_keyword "%[string tolower $keyword]%"
    lappend where_clause "(username like :sql_keyword or email like :sql_keyword or lower(first_names || ' ' || last_name) like :sql_keyword)"
} elseif { [info exists email] && $email ne "" } {
    set search_type "email"    
    set sql_email "%[string tolower $email]%"
    lappend where_clause "email like :sql_email"
} else {
    set search_type "last"        
    set sql_last_name "%[string tolower $last_name]%"
    lappend where_clause "lower(last_name) like :sql_last_name"
}

lappend where_clause {member_state = 'approved'}

if { ![info exists passthrough] } {
    set passthrough_parameters ""
} else {
    set passthrough_parameters "[export_entire_form_as_url_vars $passthrough]"
}

if { ([info exists limit_to_users_in_group_id] && $limit_to_users_in_group_id ne "") } {
set query "select distinct first_names, last_name, email, member_state, email_verified_p, cu.user_id
from cc_users cu, group_member_map gm, membership_rels mr
where cu.user_id = gm.member_id
  and gm.rel_id = mr.rel_id
  and gm.group_id = :limit_to_users_in_group_id
  and [join $where_clause "\nand "]"

} else {
set query "select username, user_id, email_verified_p, first_names, last_name, email, member_state
from cc_users
where [join $where_clause "\nand "]
limit $SQL_LIMIT"
}

set i 0

set user_items ""

set rowcount 0
set only_authorized_p 1

db_foreach user_search_admin $query {
    incr rowcount

    set user_id_from_search $user_id
    set first_names_from_search $first_names
    set last_name_from_search $last_name
    set email_from_search $email
    
    set user_search:[set rowcount](user_id) $user_id
    set user_search:[set rowcount](first_names) $first_names
    set user_search:[set rowcount](last_name) $last_name
    set user_search:[set rowcount](email) $email
    set user_search:[set rowcount](export_vars) [export_vars {user_id_from_search first_names_from_search last_name_from_search email_from_search}]
    set user_search:[set rowcount](member_state) $member_state
    set user_search:[set rowcount](url) [export_vars -base "search-3" {room_id type {party_id $user_id}}]

    
    if { $member_state ne "approved" } {
        set user_search:[set rowcount](user_finite_state_links) [join [ad_registration_finite_state_machine_admin_links $member_state $email_verified_p $user_id_from_search [export_vars -base search {email last_name keyword target passthrough limit_users_in_group_id only_authorized_p}]] " | "]
    } else {
        set user_search:[set rowcount](user_finite_state_links) ""
    }
}

set user_search:rowcount $rowcount

# We are limiting the search to one group - display that group's name
if { ([info exists limit_to_users_in_group_id] && $limit_to_users_in_group_id ne "") && ![regexp {[^0-9]} $limit_to_users_in_group_id] } {
    set group_name [db_string user_group_name_from_id "select group_name from user_groups where group_id = :limit_to_users_in_group_id"]
    set title "User search in $group_name"
} else {
    set group_name ""
    set title "User search"
}

set export_authorize [export_ns_set_vars {url} {only_authorized_p}]

ad_return_template
