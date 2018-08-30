ad_page_contract {

    Delete a revision of a file

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-12-29

} {
    version_id:integer
}


set result "{\"success\":true}"
set viewing_user_id [ad_conn user_id]

db_1row item_select "
    select item_id
    from   cr_revisions
    where  revision_id = :version_id"

db_1row version_name "
    select i.name as title,r.title as version_name 
    from cr_items i,cr_revisions r
    where i.item_id = r.item_id
    and revision_id = :version_id"

db_transaction  {

    ad_require_permission $version_id delete
    
    db_exec_plsql delete_version "select file_storage__delete_version(:item_id,:version_id)"
    
} on_error {

    ns_return 500 "text/html" "{\"success\":false,\"error\":\"$errmsg\"}"
    ad_script_abort

}