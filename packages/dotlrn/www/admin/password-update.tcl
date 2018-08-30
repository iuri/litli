ad_page_contract {
    Let's the admin change a user's password.
   

    @version $Id: password-update.tcl,v 1.5.2.2 2016/05/20 20:17:34 gustafn Exp $
} {
    {user_id:naturalnum,notnull}
    {return_url:localurl ""}
    {password_old ""}
}  -validate {
    dotlrn_cannot_become_wide_admin {
	if { [acs_user::site_wide_admin_p -user_id $user_id] && ![acs_user::site_wide_admin_p] } {
	    ad_complain "[_ acs-admin.lt_You_dont_have_permiss]"
	}
    }
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users Users] [list "user.tcl?user_id=$user_id" "usuario"] "[_ dotlrn.Update_Password]"]

set site_link [ad_site_home_link]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
