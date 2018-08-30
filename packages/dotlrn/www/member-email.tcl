# packages/dotlrn/www/member-email.tcl

ad_page_contract {
    
    Email to send users when they join this community
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2004-09-05
    @arch-tag: 64bff694-7a52-40ae-94f6-17d853356ccb
    @cvs-id $Id: member-email.tcl,v 1.3.8.2 2016/09/12 11:16:15 gustafn Exp $
} {

} -properties {
} -validate {
} -errors {
}

set community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -community_id $community_id

db_0or1row member_email { }

ad_form -name "member_email" -form {
    {email_id:key}
    {from_addr:text {label "From Address"} {html {size 40}}}
    {subject:text {label "Subject"} {html {size 40}}}
    {email:richtext,optional {label "Message"} {html {rows 30 cols 80}}}
} -on_request {

    set from_addr [party::email -party_id [ad_conn user_id]]
    set subject "Welcome to [dotlrn_community::get_community_name $community_id]!"

} -on_submit {

    set email [template::util::richtext::get_property contents $email]

} -new_data {
    
    db_dml new_email { }

} -edit_request {

    db_1row member_email_values { }

    set email [list $email ""]

} -edit_data {

    db_dml update_email { }

} -after_submit {
    
    ad_returnredirect "one-community-admin"
    ad_script_abort

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
