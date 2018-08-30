ad_page_contract {

    Create a list of communities that the user will choose from to share a folder

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-30

} {
    {query ""}
}

set user_id [ad_conn user_id]

set query_name dbqd.file-storage.www.folder-share.target_folders

db_multirow -extend { instance_name } communities $query_name ""  { 
    set instance_name [site_node::closest_ancestor_package -node_id $node_id -package_key acs-subsite -element instance_name]
}

template::multirow sort communities instance_name

template::multirow create results target_folder_id instance_name

if { [exists_and_not_null query] } {
    template::multirow foreach communities {
        if { [string match "*[string toupper ${query}]*" [string toupper $instance_name]] } {
            template::multirow append results $target_folder_id $instance_name
        }
    }
} else {
    template::multirow foreach communities {
        template::multirow append results $target_folder_id $instance_name
    }
}