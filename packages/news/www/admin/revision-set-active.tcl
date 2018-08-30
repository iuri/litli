# /packages/news/www/admin/revision-set-active.tcl

ad_page_contract {
    
    This page changes the active revision of a news item and returns to item

    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: revision-set-active.tcl,v 1.4.2.2 2016/01/02 20:34:50 gustafn Exp $
    
} {

    item_id:naturalnum,notnull
    new_rev_id:naturalnum,notnull
    
}


db_exec_plsql update_forum {}
    
ad_returnredirect "item?item_id=$item_id"







# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
