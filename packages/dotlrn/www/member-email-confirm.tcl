ad_page_contract {
    Send word of welcome
} -query {
    community_id:naturalnum,notnull
} -validate {
    community_id_is_dotlrn_community {
	if {[dotlrn_community::get_community_key -community_id $community_id] eq ""} {
	    ad_complain "$community_id is not a valid community_id"
	}
    }
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $community_id \
    -privilege admin

set page_title "[_ dotlrn.Send_Welcome_Message]"
set context [list $page_title]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
