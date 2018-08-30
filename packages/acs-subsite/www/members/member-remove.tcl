ad_page_contract {
    Remove member(s).
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-02
    @cvs-id $Id: member-remove.tcl,v 1.4.2.2 2017/06/19 17:16:16 antoniop Exp $
} {
    user_id:naturalnum,multiple
    {return_url:localurl "."}
}

set group_id [application_group::group_id_from_package_id]

permission::require_permission -object_id $group_id -privilege "admin"

foreach id $user_id {
    group::remove_member \
        -group_id $group_id \
        -user_id $user_id
}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
