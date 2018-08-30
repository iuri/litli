# /packages/photo-album/www/clipboard-delete.tcl
ad_page_contract {
    delete a photo clipboard.

    @author Robert Locke rlocke@infiniteinfo.com
    @creation-date 06/27/2003
    @cvs-id $Id: clipboard-delete.tcl,v 1.2 2014/08/07 07:59:50 gustafn Exp $
} {
    collection_id:naturalnum,notnull
}

permission::require_permission -object_id $collection_id -privilege delete

db_exec_plsql delete_collection {
    select pa_collection__delete(:collection_id)
}

ad_returnredirect clipboards