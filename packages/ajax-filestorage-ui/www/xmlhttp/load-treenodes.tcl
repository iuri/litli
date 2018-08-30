ad_page_contract {

    Returns a JSON structure suitable for building the nodes of a tree
        for the ajax file storage ui.
    Requires the package_id


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-06-03

} {
    package_id:integer,notnull
    {node ""}
}

# ns_log notice "ln called with package_id '$package_id' and node '$node'"

set viewing_user_id [ad_conn user_id]

# if node is empty, then get the rootfolder of the package_id

if { ![exists_and_not_null node] } {
    set node [fs::get_root_folder -package_id $package_id]
}

db_multirow -extend { text id  href cls qtip symlink_id content_size_pretty leaf expanded children } "treenodes" "treenodes" { } {

    if { [exists_and_not_null title] } {
        set text $title
    } else {
        set text $name
    }
        
    set symlink_id ""
    set id "$object_id"
    set cls "folder"
    set children ""
    set leaf "false"
    set expanded "false"

    set content_size_pretty [lc_numeric $content_size]

    #if { $content_size_pretty == 0 } {
    #        set leaf "true"
    #        set expanded "true"
    #        set children ",\"children\":\[\]"
    # }

    append content_size_pretty " [_ file-storage.items]"

    if { $type == "symlink" } {
        set cls "symlink"
        set target_id [db_string get_target_folder "select target_id from cr_symlinks where symlink_id=:object_id"]
        set symlink_id $id
        set id $target_id
        set target_package_id [ajaxfs::get_root_folder -folder_id $target_id]
        set instance_name [db_string get_subsite_name "select instance_name from apm_packages where package_id=(select context_id from acs_objects where object_id = ${target_package_id})"]
        set qtip "${text} <b>shared from</b> ${instance_name}"
    } else {
        set shared_with [db_list get_share_from "select p.instance_name 
                from cr_folders f, 
                     cr_symlinks s, 
                     cr_items i, 
                     acs_objects o, 
                     apm_packages p, 
                     site_nodes s1, 
                     site_nodes s2 
                where o.package_id = s2.object_id 
                and s1.node_id = s2.parent_id 
                and s1.object_id = p.package_id 
                and s.symlink_id = o.object_id 
                and s.symlink_id = i.item_id
                and s.target_id = :object_id 
                and f.folder_id=i.parent_id"]
        if { [llength $shared_with] > 0} {
            set cls "sharedfolder"
            set qtip "<div style='text-align:left'>${text} is <b>shared with</b><ul> <li>[join ${shared_with} "</li><li>"]</li></ul></div>"
        } else {
            set cls "folder"
            set qtip $text
        }
    }

    regsub -all {"} $qtip {\"} qtip
    regsub -all {"} $name {\"} name


}