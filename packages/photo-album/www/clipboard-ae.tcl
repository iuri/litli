# /packages/photo-album/www/clipboard-ae.tcl
ad_page_contract {
    add/edit a photo clipboard.

    If a photo_id provided, it is attached after the add/edit finishes.

    @author Jeff Davis davis@xarg.net
    @creation-date 10/30/2002
    @cvs-id $Id: clipboard-ae.tcl,v 1.6 2014/08/07 07:59:50 gustafn Exp $
} {
    collection_id:naturalnum,optional
    {photo_id:naturalnum,optional {}}
}

set user_id [ad_conn user_id]
set peeraddr [ad_conn peeraddr]
set context [ad_conn package_id]

ad_form -name clip_ae -export {photo_id} -form {
    collection_id:key(acs_object_id_seq)
    
    {title:text(text)             {label "[_ photo-album._Clipboard]"}
        {html {size 60}}}
} -select_query {
    select title from pa_collections where collection_id = :collection_id
} -validate {
    {title
        {![string is space $title]} 
        "[_ photo-album._You]"
    }
} -new_data {
    db_exec_plsql new_collection {}
} -edit_data {
    db_dml do_update "
            update pa_collections 
            set title = :title 
            where collection_id = :collection_id"
} -after_submit {
    if {$photo_id ne ""} { 
        ad_returnredirect "clipboard-attach?photo_id=$photo_id&collection_id=$collection_id"
    } else { 
        ad_returnredirect "clipboards"
    }
    ad_script_abort
}

