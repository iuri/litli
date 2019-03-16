ad_page_contract {

    Moves an album or folder into a folder


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2009-03-15

} {
    target_folder_id:integer,notnull
    item_id:integer,notnull
    {type "folder"}
}

set success "true"
set msg ""

db_transaction {


    if { $type == "folder" } {

        # move folder
    
        db_exec_plsql  folder_move "
            select content_folder__move (
            :item_id, -- folder_id           
            :target_folder_id -- target_folder_id  
            )
        "
    
        db_dml context_update "
        update acs_objects
        set    context_id = :target_folder_id
        where  object_id = :item_id
        "

    } else {

        # move album
    
        db_exec_plsql  album_move "
            select content_item__move (
            :item_id, -- item_id           
            :target_folder_id -- target_folder_id  
            )
        "
    
        db_dml context_update "
            update acs_objects
            set    context_id = :target_folder_id
            where  object_id = :item_id
        "

    }

} on_error {

    set success "false"
    set msg "Sorry, an error occurred."

}


ns_return 200 "text/html" "{\"success\":$success,\"msg\":\"$msg\"}"
