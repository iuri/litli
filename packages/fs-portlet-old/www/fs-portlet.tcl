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

# fs-portlet/www/fs-portlet.tcl

ad_page_contract {
    The display logic for the fs portlet

    @author yon (yon@openforce.net)
    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id: fs-portlet.tcl,v 1.26.2.2 2015/09/20 17:30:52 gustafn Exp $
} -query {
    {n_past_days "99999"}
    {page_num:naturalnum ""}
} -properties {
    user_id:onevalue
    user_root_folder:onevalue
    user_root_folder_present_p:onevalue
    write_p:onevalue
    admin_p:onevalue
    delete_p:onevalue
    url:onevalue
    folders:multirow
    n_folders:onevalue
}

array set config $cf
set user_id [ad_conn user_id]
set list_of_folder_ids $config(folder_id)
set n_folders [llength $list_of_folder_ids]
set scoped_p [ad_decode $config(scoped_p) t 1 0]

set user_root_folder [dotlrn_fs::get_user_root_folder -user_id $user_id]
set user_root_folder_present_p 0

if {$user_root_folder ne "" && $user_root_folder in $list_of_folder_ids} {
    set folder_id $user_root_folder
    set user_root_folder_present_p 1
    set use_ajaxfs_p 0
} else {
    set folder_id [lindex $list_of_folder_ids 0]
    set file_storage_node_id [site_node::get_node_id_from_object_id \
                             -object_id [ad_conn package_id]]
    set file_storage_package_id [site_node::get_children \
                                -package_key file-storage \
                                -node_id $file_storage_node_id \
                                -element package_id]
    set use_ajaxfs_p [parameter::get -package_id $file_storage_package_id -parameter UseAjaxFs -default 0]

}

set url [site_node_object_map::get_url -object_id $folder_id]
set contents_url [lindex $config(contents_url) 0]

if {$contents_url eq ""} {
    set recurse_p 1
    set contents_url [export_vars -base ${url}folder-contents {folder_id recurse_p}]&
} else {
    set contents_url "${contents_url}?"
}

if { !$scoped_p } {
    set admin_p [permission::permission_p -object_id $folder_id -privilege "admin"]
    set write_p $admin_p
    if {!$write_p} {
        set write_p [permission::permission_p -object_id $folder_id -privilege "write"]
    }
    set delete_p $admin_p
    if {!$delete_p} {
        set delete_p [permission::permission_p -object_id $folder_id -privilege "delete"]
    }
}

set query "select_folders"
if {$scoped_p} {
    set scope_fs_url "/packages/file-storage/www/folder-chunk"
} else {

    template::list::create -name folders -multirow folders -key forum_id -pass_properties {
    } -elements {
        icon {
            label "[_ file-storage.Type]"
            display_template {
                <if @folders.type@ eq "folder">
                <img src="/resources/file-storage/folder.gif" height="16" width="16" alt="#file-storage.Folder#" style="border:0">
                #file-storage.folder_type_pretty_name#
                </if>
                <elseif @folders.type@ eq "url">
                <img src="/resources/file-storage/file.gif" alt="#file-storage.File#" style="border:0">
                @folders.type@
                </elseif>
                <else>
                <img src="/resources/file-storage/file.gif" alt="#file-storage.File#" style="border:0">
                @folders.type@
                </else>
            }
        }
        name {
            label "[_ file-storage.Name]"
            display_template {
                <if @folders.type@ eq "folder">
                <a href="@folders.url@?folder_id=@folders.object_id@">@folders.name@</a>      
                </if>
                <elseif @folders.type@ eq "url">
                <a href="@folders.url@url-goto?url_id=@folders.object_id@">@folders.name@</a>
                </elseif>
                <else>
                <a href="@folders.url@download/@folders.file_upload_name@?version_id=@folders.live_revision@">@folders.name@</a>
                </else>
            }
        }
        size {
            label "[_ file-storage.Size]"
            display_template {
                <if @folders.type@ eq "folder">
                <if @folders.content_size@ eq 0>
                0 #fs-portlet.items#
                </if>
                <elseif @folders.content_size@ gt 1>
                @folders.content_size@ #fs-portlet.items#
                </elseif>
                <else>
                @folders.content_size@ #fs-portlet.item#
                </else>
                </if>
                <elseif @folders.type@ eq "url">
                <i>n/a</i>
                </elseif>
                <else>
                @folders.content_size@ <if @folders.content_size eq 1>#fs-portlet.byte#</if><else>#fs-portlet.bytes#</else>
                \[<a href="@folders.url@file?file_id=@folders.object_id@">#fs-portlet.view_details#</a>\]
                </else>
            }
        }
    }

    db_multirow folders $query {
        # The name of the folder may contain message keys that need to be localized on the fly
        set name [lang::util::localize $name]
    }
}

# Enable Notifications

set folder_name [fs_get_folder_name $folder_id]
set folder_url [ad_conn url]?[ad_conn query]&folder_id=$folder_id

if {([info exists file_storage_package_id] && $file_storage_package_id ne "")} {
    set use_webdav_p  [parameter::get -package_id $file_storage_package_id -parameter "UseWebDavP"]
    
    if { $use_webdav_p == 1} { 
	set webdav_url [fs::webdav_url -item_id $folder_id -package_id $file_storage_package_id]
        regsub -all {/\$} $webdav_url {/\\$} webdav_url
    }
}

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
