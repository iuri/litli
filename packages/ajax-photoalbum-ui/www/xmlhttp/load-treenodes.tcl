ad_page_contract {

    Returns a JSON structure suitable for building the nodes of a tree
        for the ajax photo album ui.

    Requires the package_id


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-18

} {
    package_id:integer,notnull
    {node ""}
}

set user_id [ad_conn user_id]

set query_name dbqd.photo-album.www.index.get_children
set folder_id $node

db_multirow -extend { text id cls leaf story photographer write_p read_p} treenodes $query_name ""  {

    set cls "folder"
    set leaf "false"

    if { $type == "Album" } {
        set cls "album"
        # set leaf "true"
    }

    # can the user see this folder or album
    set read_p [permission::permission_p -party_id $user_id -object_id $item_id -privilege "read"]

    # can the user write to this folder or album
    # write privileges allow users to create stuff
    set write_p [permission::permission_p -party_id $user_id -object_id $item_id -privilege "write"]

    set text $name
    set id $item_id
    
    if { ![exists_and_not_null description] } {
        set description ""
    }

    set name [ajaxpa::json_normalize -value $name]
    set description [ajaxpa::json_normalize -value $description]
    if { ![exists_and_not_null story] } { set story "" } else { set story [ajaxpa::json_normalize -value $story]}
    if { ![exists_and_not_null photographer] } { set photographer "" } else { set photographer [ajaxpa::json_normalize -value $photographer] }

}

ad_return_template