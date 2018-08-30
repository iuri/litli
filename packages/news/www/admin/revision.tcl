# /packages/news/www/admin/revision.tcl

ad_page_contract {
    
    Page to view one news item in an arbitrary revision
    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date 2000-12-20
    @cvs-id $Id: revision.tcl,v 1.12.2.1 2015/09/12 11:06:44 gustafn Exp $
    
} {

    item_id:naturalnum,notnull
    revision_id:naturalnum,notnull

} -properties {

    title:onevalue
    context:onevalue
    news_admin_p:onevalue
    item_exist_p:onevalue
    publish_title:onevalue
    publish_lead:onevalue
    publish_body:onevalue
    publish_format:onevalue
    html_p:onevalue
    creator_link:onevalue
}


# access restricted to admin as long as in news/admin/


# Access a news item in a particular revision
set item_exist_p [db_0or1row one_item {}]

if { $item_exist_p } {

    set title [_ news.Revision]
    set context [list [list [export_vars -base item item_id] [_ news.One_Item]] $title]

    set creation_date_pretty [lc_time_fmt $creation_date %q]
    set publish_date_pretty [lc_time_fmt $publish_date %q]
    set archive_date_pretty [lc_time_fmt $archive_date %q]
    
} else {
    ad_return_complaint 1 [_ news.lt_Could_not_find_corres]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
