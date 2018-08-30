# 

ad_page_contract {
    
    WebDAV enable folders
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2004-02-15
    @cvs-id $Id: enable.tcl,v 1.2.2.1 2015/09/12 19:00:43 gustafn Exp $
} {
    folder_id:naturalnum,multiple
} -properties {
} -validate {
} -errors {
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id [ad_conn package_id ] \
    -privilege "admin"

foreach id $folder_id {

    db_dml enable_folder ""
    
}
util_user_message -message [_ oacs-dav.Folders_Enabled]
ad_returnredirect "."
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
