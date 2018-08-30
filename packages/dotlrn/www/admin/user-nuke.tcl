ad_page_contract {

    Try to delete a pending user from the database.
    
    @author Andrew Grumet (aegrumet@alum.mit.edu)
    @creation-date 2002-08-08
    @version $Id: user-nuke.tcl,v 1.7.2.1 2015/09/11 11:40:53 gustafn Exp $
} {
    user_id:naturalnum,notnull
    {referer "[dotlrn::get_admin_url]/users"}
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

db_1row select_user_info {}

set pretty_last_visit [lc_time_fmt $last_visit "%Q %T"]

form create confirm_delete

element create confirm_delete user_id \
    -label "[_ dotlrn.User_ID_1]" \
    -datatype integer \
    -widget hidden \
    -value $user_id

element create confirm_delete confirmed_p \
    -label "[_ dotlrn.Are_you_sure]" \
    -datatype text \
    -widget radio \
    -options [list [list [_ dotlrn.No] f] [list [_ dotlrn.Yes] t]] \
    -value f

set context_bar [list [list users [_ dotlrn.Users]] [_ dotlrn.Nuke]]

if {[form is_valid confirm_delete]} {
    form get_values confirm_delete user_id confirmed_p
    if {$confirmed_p == "t"} {
	if {[catch { dotlrn::remove_user_completely -user_id $user_id } errMsg ]} {
        set error_msg $errMsg
	    ad_return_template user-nuke-error
	} else {
	    # Nuke was successful.
	    ad_returnredirect $referer
	    ad_script_abort
	}
    } else {
	# Nuke cancelled
	ad_returnredirect $referer
	ad_script_abort
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
