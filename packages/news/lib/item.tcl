# /packages/news/lib/item.tcl
ad_page_contract {
    
    Page to view one item (live or archived) in its active revision
    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: item.tcl,v 1.4.2.2 2016/01/02 20:34:49 gustafn Exp $
    
} {

    item_id:naturalnum,notnull

} -properties {
    title:onevalue
    context:onevalue 
    item_exist_p:onevalue
    publish_title:onevalue
    publish_lead:onevalue
    publish_date:onevalue
    publish_body:onevalue
    publish_image:onevalue
    html_p:onevalue
    creator_link:onevalue
    comments:onevalue
    comment_link:onevalue
}


set user_id [ad_conn untrusted_user_id]

permission::require_permission \
    -object_id $item_id \
    -party_id  $user_id \
    -privilege read


# live view of a news item in its active revision
set item_exist_p [db_0or1row get_news_info {
    select item_id,
       live_revision,
       publish_title,
       publish_lead,
       publish_format,
       publish_body,
       publish_date,
       '<a href=\"/shared/community-member?user_id=' || creation_user || '\">' || item_creator ||  '</a>' as creator_link
    from   news_items_live_or_submitted
    where  item_id = :item_id
}]

if { $item_exist_p } {

    # workaround to get blobs with >4000 chars into a var, content.blob_to_string fails! 
    # when this'll work, you get publish_body by selecting 'publish_body' directly from above view
    #
    # RAL: publish_body is already snagged in the 1st query above for postgres.
    #
    set get_content [db_map get_content]
    if {$get_content ne ""} {
	set publish_body [db_string get_content {
            select  content
            from    cr_revisions
            where   revision_id = :live_revision
        }]
    }

    # text-only body
    if {[info exists html_p] && $html_p == "f"} {
	set publish_body [ad_text_to_html -- $publish_body]
    }
    
    if { [parameter::get -parameter SolicitCommentsP -default 0]} {

        if {[permission::permission_p -object_id $item_id -privilege general_comments_create] } {
	    set comment_link [general_comments_create_link $item_id "[ad_conn package_url]item?item_id=$item_id"]

	} else {
            set comment_link "Log in to add a comment"
        }

        set comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 \
                          $item_id "[ad_conn package_url]item?item_id=$item_id"]

    } else {
        set comment_link ""
        set comments ""
    }

    set publish_image {}
    # # get image info, if any
    # set image_id [news_get_image_id $item_id]
    # if {$image_id ne ""} {
    #     set publish_image "image/$image_id"
    # } else {
    #     set publish_image {}
    # }

    if {[permission::permission_p -object_id $item_id -privilege write] } {
        set edit_link "<a href=\"admin/revision-add?item_id=$item_id\">Revise</a>"
    } else {
        set edit_link ""
    }

    set title $publish_title
    set context [list $title]
    set publish_title {}

} else {
    set context {}
    set title "[_ news.Error]"
}

























# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
