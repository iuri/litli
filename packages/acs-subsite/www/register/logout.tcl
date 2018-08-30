# /www/register/logout.tcl

ad_page_contract {
    Logs a user out

    @cvs-id $Id: logout.tcl,v 1.4.12.3 2016/05/20 20:02:44 gustafn Exp $

} {
    {return_url:localurl ""}
}

if { $return_url eq "" } {
    if { [permission::permission_p -object_id [subsite::get_element -element package_id] -party_id 0 -privilege read] } {
        set return_url [subsite::get_element -element url]
    } else {
        set return_url /
    }
}

ad_user_logout 
db_release_unused_handles

ad_returnredirect $return_url


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
