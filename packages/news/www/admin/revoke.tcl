# /packages/news/www/admin/revoke.tcl

ad_page_contract {

    This page allows the News Admin to revoke one or many news item.
    No intermediate page is shown.

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date  2000-12-20
    @cvs-id $Id: revoke.tcl,v 1.4.2.2 2016/01/02 20:34:50 gustafn Exp $

} {
    item_id:naturalnum,notnull
    {revision_id: ""}
} 


db_exec_plsql news_item_revoke {}

ad_returnredirect "item?item_id=$item_id"









# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
