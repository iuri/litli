#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    The display logic for the fs contents portlet.

    These portlets show the contents of the given folder in a table

    re-using a lot of code from fs-portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs-id $Id: fs-contents-portlet.tcl,v 1.13 2018/06/29 17:27:19 hectorr Exp $

} -query {
} -properties {
    user_id:onevalue
    user_root_folder:onevalue
    user_root_folder_present_p:onevalue
    url:onevalue
    folders:multirow
    n_folders:onevalue
}

array set config $cf
set user_id [ad_conn user_id]
set list_of_folder_ids $config(folder_id)
set n_folders [llength $list_of_folder_ids]

if {$n_folders != 1} {
    # something went wrong, we can't have more than one folder here
    return -code error "can't have more than one folder"
}

# Get the root folder for the file storage instance we belong to, which is defined as the
# one mounted beneath the current package (dotlrn or acs-subsite).  Root folder should really
# be a parameter to the portlet, something I'll consider for 5.2/2.2.

set file_storage_node_id [site_node::get_node_id_from_object_id \
                             -object_id [ad_conn package_id]]
set file_storage_package_id [site_node::get_children \
                                -package_key file-storage \
                                -node_id $file_storage_node_id \
                                -element package_id]
set root_folder_id [fs::get_root_folder -package_id $file_storage_package_id]

set folder_id [lindex $list_of_folder_ids 0]
set scope_fs_url "/packages/file-storage/www/folder-chunk"
set n_past_days ""
set url [site_node_object_map::get_url -object_id $folder_id]
set recurse_p 1
set contents_url [export_vars -base ${url}folder-contents {folder_id recurse_p}]&

# Enable Notifications

set folder_name [fs_get_folder_name $folder_id]
set folder_url [export_vars -base [ad_conn url] {folder_id}]

if {$file_storage_package_id ne ""} {
    set use_webdav_p  [parameter::get -package_id $file_storage_package_id -parameter "UseWebDavP"]
    
    if { $use_webdav_p == 1} { 
	set webdav_url [fs::webdav_url -item_id $folder_id -package_id $file_storage_package_id]
    }
}

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
