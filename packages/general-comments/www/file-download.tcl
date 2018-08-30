# /packages/general-comments/www/file-download.tcl

ad_page_contract {
    Downloads a file

    @param item_id The id of the file attachment

    @author Phong Nguyen (phong@arsdigita.com)
    @author Pascal Scheffers (pascal@scheffers.net)
    @creation-date 2000-10-12
    @cvs-id $Id: file-download.tcl,v 1.4.2.1 2015/09/12 11:06:35 gustafn Exp $
} {
    item_id:naturalnum,notnull
}

# check for permissions
permission::require_permission -object_id $item_id -privilege read

cr_write_content -item_id $item_id

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
