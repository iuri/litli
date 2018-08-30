# /packages/news/www/item.tcl

ad_page_contract {
    
    Page to view one item (live or archived) in its active revision
    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: summary.tcl,v 1.9.4.1 2015/09/12 11:06:45 gustafn Exp $
    
} {

} -properties {
    title:onevalue
    item_exist_p:onevalue
    publish_title:onevalue
    publish_date:onevalue
    publish_body:onevalue
    publish_format:onevalue
    creator_link:onevalue
    comments:onevalue
    comment_link:onevalue
}

permission::require_permission -object_id [ad_conn package_id] -privilege news_read


# live view of a news item in its active revision
set item_exist_p [db_0or1row one_item "
select item_id,
       live_revision,
       publish_title,
       publish_body,
       publish_format,
       publish_date,
       creation_user,
       item_creator
from   news_items_live_or_submitted
where  item_id = :item_id"]

set publish_date [lc_time_fmt $publish_date "%x"]
set creator_url [acs_community_member_url -user_id $creation_user]

if { $item_exist_p } {

#currently not using comments in the summary but someone might want to change the template so they are available.    
    if { [parameter::get -parameter SolicitCommentsP -default 0] &&
         [permission::permission_p -object_id $item_id -privilege general_comments_create] } {
	set comment_link [general_comments_create_link $item_id "[ad_conn package_url]item?item_id=$item_id"]
	set comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 \
		$item_id "[ad_conn package_url]item?item_id=$item_id"]
    } else {
	set comment_link ""
        set comments ""
    }


} else {
    set context_bar {}
    set title "Error"
}

#This is a summary in the portlet we don't want it to be too long.

set more_link ""
set summary_length [news_portlet::get_summary_length]
if { [string length $publish_body] > $summary_length } {
    set publish_body [string_truncate -len $summary_length -- $publish_body]
    set more_link "<p><b>&raquo;</b> <a href=\"$url\">[_ news-portlet.Read_more]</a></p>"
}

set publish_body "<p>[ad_html_text_convert -from $publish_format -to "text/html" -- $publish_body]</p>"

set display_item_attribution_p [parameter::get_from_package_key -package_key news-portlet -parameter display_item_attribution_p -default 1]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
