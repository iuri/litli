ad_page_contract {

    Move one or more photos to an album


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2009-03-15

} {
    target_album_id:integer,notnull
    image_ids:multiple
}

set success "true"
set msg ""

db_transaction {

    foreach image_id $image_ids {
        set old_parent_id [db_string "get_old_parent" "select parent_id from cr_items where item_id = :image_id"]
        pa_flush_photo_in_album_cache $old_parent_id
        db_dml "update_critem" "update cr_items set parent_id = :target_album_id  where item_id=:image_id"
        db_dml "update_child_rels" "update cr_child_rels set parent_id = :target_album_id where child_id = :image_id"
    }

} on_error {

    set success "false"
    set msg "Sorry, an error occurred"

}

pa_flush_photo_in_album_cache $target_album_id

ns_return 200 "text/html" "{\"success\":$success,\"msg\":\"$msg\"}"