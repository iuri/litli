ad_page_contract {
    A chunked version of a folder

    @author Jeff Davis (davis@xarg.net)
    @creation-date 17 June 2003
    @cvs-id $Id: album-chunk.tcl,v 1.2 2006/08/08 21:27:09 donb Exp $
} {
}


set folder_id [pa_get_root_folder $package_id]
set root_folder_id [pa_get_root_folder $package_id]

set user_id [ad_conn user_id]
set context [pa_context_bar_list $folder_id]

# get all the info about the current folder and permissions with a single trip to database
db_1row get_folder_info {}

if { $has_children_p } {
    db_multirow child get_children {}
} else {
    set child:rowcount 0
}

set url [site_node::get_url_from_object_id -object_id $package_id]

