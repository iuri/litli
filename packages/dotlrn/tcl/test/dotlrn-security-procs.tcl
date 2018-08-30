# packages/dotlrn/tcl/test/dotlrn-security-procs.tcl

ad_library {
    
    dotlrn Tcl helper procs for acs-automated-testing
    
    @author Deds Castillo (deds@i-manila.com.ph)
    @creation-date 2004-08-11
    @arch-tag: 34c82a30-948a-410d-ab15-a58da2eeb3d3
    @cvs-id $Id: dotlrn-security-procs.tcl,v 1.4.4.2 2017/06/30 17:43:06 gustafn Exp $
}

aa_register_case -cats {api} \
    -procs {dotlrn::user_add dotlrn::remove_user_completely} \
    dotlrn__remove_user_completely {test the sequence of creating a user, adding to dotlrn, then removing the user } {
        aa_run_with_teardown \
            -rollback \
            -test_code {
                array set creation_info [auth::create_user -email "an.email.unlikely.to.exist@i.hope.it.does.not" -first_names "test" -last_name "user"]
                aa_log "create user result is: $creation_info(creation_status)"
                aa_equals creation_ok $creation_info(creation_status) ok
                
                set rel_id [dotlrn::user_add -user_id $creation_info(user_id)]
                aa_false "dotlrn_rel_created" [string equal $rel_id ""]
                aa_log "dotlrn::user_add rel_id result is: $rel_id"
                
                aa_log "now calling dotlrn::remove_user_completely to try and remove this user"
                dotlrn::remove_user_completely -user_id $creation_info(user_id)
                aa_true "user_must_not_exist" [string equal [db_string check_user "select count(*) from users where user_id = $creation_info(user_id)"] "0"]
        }
    }

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
