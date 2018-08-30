ad_page_contract {
    Share a folder with another file storage instance, 
    create a symlink in the target
} {
    target_folder_id
    folder_id
}

set result 1
set user_id [ad_conn user_id]

# create a symlink for each target community
set symlink_id [content::symlink::new \
            -target_id $folder_id \
            -parent_id $target_folder_id \
            -label [content::folder::get_label -folder_id $folder_id]]

# give permission to the owners of the root folder
# get subsite application group for the target file-storage
# and grant admin over the original folder
set target_package_id [lindex \
                [fs::get_folder_package_and_root $target_folder_id] 0]
set target_subsite_package_id [site_node::closest_ancestor_package -node_id [site_node::get_node_id_from_object_id -object_id $target_package_id]]
set target_application_group [application_group::group_id_from_package_id -package_id $target_subsite_package_id]
set target_admins [group::get_rel_segment -group_id $target_application_group -type "admin_rel"]
set target_members [group::get_rel_segment -group_id $target_application_group -type "membership_rel"]
foreach {type privilege} {admins admin members read members create members delete members write} {
    permission::grant \
        -object_id $folder_id \
        -party_id [set target_$type] \
        -privilege $privilege
}
