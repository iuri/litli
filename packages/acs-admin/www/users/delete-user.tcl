ad_page_contract {
    Delete a single user
    @author Gustaf Neumann <neumann@wu-wien.ac.at>
    @creation-date 23 Dez 2008

    @cvs-id $Id: delete-user.tcl,v 1.2.2.3 2016/05/20 19:52:59 gustafn Exp $
} {
  user_id:naturalnum,notnull
  {return_url:localurl .}
  {permanent:boolean f}
}

set site_wide_admin_p [acs_user::site_wide_admin_p -user_id [ad_conn user_id]]
if {!$site_wide_admin_p} {
  ad_return_warning "Insufficient Permissions" \
      "Only side wide admins are allowed to delete a user!"
  ad_script_abort
}

if {$permanent} {
  acs_user::delete -user_id $user_id -permanent
} else {
  acs_user::delete -user_id $user_id
}

ad_returnredirect $return_url
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
