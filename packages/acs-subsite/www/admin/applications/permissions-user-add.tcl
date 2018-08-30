ad_page_contract {
    Redirect page for adding users to the permissions list.
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-13
    @cvs-id $Id: permissions-user-add.tcl,v 1.2.2.1 2015/09/10 08:21:39 gustafn Exp $
} {
    object_id:naturalnum,notnull
}

set page_title "Add User"

set context [list [list "." "Applications"] [list "permissions" "[apm_instance_name_from_id $object_id] Permissions"] $page_title]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
