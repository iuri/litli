ad_page_contract {

    Return the JSON for the album or folder given its id
        The JSON is suitable for creating a new tree node


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2008-9-21

} {
    node_id:integer,notnull
    {type "folder"}
    {mode "display"}
}

set user_id [ad_conn user_id]

switch $type {
    "folder" {

        set query "select label as name,
                        description
                    from cr_folders
                    where folder_id = :node_id"

    }
    "album" {

        set query "select i.item_id,
                r.title as name,
                r.description,
                a.story,
                a.photographer,
                i.live_revision as previous_revision
            from cr_items i,
                cr_revisions r,
                pa_albums a 
            where i.content_type = 'pa_album'
                and i.live_revision = r.revision_id
                and i.live_revision = a.pa_album_id
                and i.item_id = :node_id"

    }
    default { }
}

if { [exists_and_not_null query] && [db_0or1row "get_folder_info" $query] } {

    set name [ajaxpa::json_normalize -value $name]
    set description [ajaxpa::json_normalize -value $description]
    if { ![exists_and_not_null story] } { set story "" } else { set story [ajaxpa::json_normalize -value $story]}
    if { ![exists_and_not_null photographer] } { set photographer "" } else { set photographer [ajaxpa::json_normalize -value $photographer] }

    if { $mode == "edit" && $type == "album"} {
        set revision_id [db_nextval acs_object_id_seq]
    } else {
        set revision_id ""
    }

    # can the user see this folder or album
    set read_p [permission::permission_p -party_id $user_id -object_id $node_id -privilege "read"]

    # can the user write to this folder or album
    # write privileges allow users to create stuff
    set write_p [permission::permission_p -party_id $user_id -object_id $node_id -privilege "write"]

    if { ![exists_and_not_null previous_revision] } { set previous_revision "" } 

    set nodeinfo "{ \"text\": \"$name\",\"qtip\":\"$description\",\"id\":\"$node_id\",\"iconCls\":\"$type\",\"singleClickExpand\":true,\"leaf\":false,\"attributes\":{\"type\":\"$type\",\"story\":\"$story\",\"photographer\":\"$photographer\",\"revision_id\":\"$revision_id\",\"previous_revision\":\"$previous_revision\",\"read_p\":$read_p,\"write_p\":$write_p}}"

} else { 

    set nodeinfo "\"null\"" 

}


ns_return 200 "text/html" "{\"success\":true, \"info\":$nodeinfo}"