ad_library {
    Tcl procs for managing privacy.

    @author aegrumet@alum.mit.edu
    @creation-date 2000-12-02
    @cvs-id $Id: privacy-procs.tcl,v 1.4.4.1 2015/09/11 11:40:40 gustafn Exp $
}

namespace eval dotlrn_privacy {

    ad_proc -public set_user_guest_p {
        {-user_id:required}
        {-value:required}
    } {
        't' adds the user to the guest relational segment
        'f' adds the user to the non-guest relational segment
    } {
        if { [template::util::is_true $value] } {
            #put the user in the dotlrn_guest_relseg and remove them
            #from the dotlrn_non_guest_relseg
            db_exec_plsql set_user_guest {}
        } else {
            #put the user in the dotlrn_guest_relseg and remove them
            #from the dotlrn_non_guest_relseg
            db_exec_plsql set_user_non_guest {}
        }
    }

    ad_proc -public set_user_is_non_guest {
        {-user_id:required}
        {-value:required}
    } {
        't' adds the user to the non-guest relational segment
        'f' adds the user to the guest relational segment
    } {
        if { [template::util::is_true $value] } {
            set_user_guest_p -user_id $user_id -value f
        } else {
            set_user_guest_p -user_id $user_id -value t
        }
    }

    ad_proc -private set_read_private_data_for_rel {action rel_type object_id} {
        action should be "grant" or "revoke"
        rel_type should be "dotlrn_guest_rel" or "dotlrn_non_guest_rel"
    } {
        if {$action eq "grant"} {
            set db_proc "grant_rd_prv_dt_to_rel"
        } else {
            set db_proc "revoke_rd_prv_dt_from_rel"
        }            
        db_exec_plsql set_read_private_data_for_rel {}
    }

    ad_proc -public grant_read_private_data_to_non_guests {
        {-object_id:required}
    } {
        comments
    } {
        set_read_private_data_for_rel grant dotlrn_non_guest_rel $object_id
    }

    ad_proc -public revoke_read_private_data_from_non_guests {
        {-object_id:required}
    } {
        comments
    } {
        set_read_private_data_for_rel revoke dotlrn_non_guest_rel $object_id
    }

    ad_proc -public grant_read_private_data_to_guests {
        {-object_id:required}
    } {
        comments
    } {
        set_read_private_data_for_rel grant dotlrn_guest_rel $object_id
    }

    ad_proc -public revoke_read_private_data_from_guests {
        {-object_id:required}
    } {
        comments
    } {
        set_read_private_data_for_rel revoke dotlrn_guest_rel $object_id
    }

    ad_proc -public guests_can_view_private_data_p {
        {-object_id:required}
    } {
        checks for a direct permission grant
    } {
        return [db_string guests_granted_read_private_data_p {}]
    }
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
