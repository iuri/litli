ad_page_contract {

    Display one folder chunk.  We don't use the file-storage version for a few
    reasons.  Among them are the fact that we don't need to check admin privs on
    each file, only the folder, which speeds stuff up considerably.

    We expect list_of_folder_ids, min and max levels, admin_p and package_id as parameters
    passed into this template by the calling include.   We need a list of folders rather than a
    single folder in order to make this useful for the user-level portlet that gathers all homework in
    a single mega-portlet.

    @author Don Baccus (dhogaza@pacifier.com)

} -properties {
    folders:multirow
    n_folders:onevalue
}

set return_url "[ad_conn url]?[ad_conn query]"
set user_id [ad_conn user_id]

set url [site_node::get_url_from_object_id -object_id $package_id]
set file_storage_url [dotlrn_homework::get_file_storage_url]

# Now set up the label and target for each choice on the toolbar.

multirow create toolbar label target

# This is a bit of a kludge - we only allow folder-specific actions if there's just one
# folder.  In our context this means we offer the links from the class portlet and 
# folder display pages, but not the user portlet that lists a summary of all homework
# files for the user (if this gets written).

if { [llength $list_of_folder_ids] == 1 } {
    set folder_id [lindex $list_of_folder_ids 0]
    if { $show_upload_url_p } {
        template::multirow append toolbar "[_ dotlrn-homework.lt_submit_new_assign]" \
            [export_vars -base ${url}file-add {folder_id return_url}]
    }
    if { $admin_actions_p } {
        template::multirow append toolbar "[_ dotlrn-homework.lt_create_new_folder]" \
            [export_vars -base ${url}folder-create {{parent_id $folder_id} return_url}]

        # Even a community admin can't delete the root homework folder
        if { ![string equal $folder_id [fs::get_root_folder -package_id [ad_conn package_id]]] } {
            template::multirow append toolbar "[_ dotlrn-homework.lt_delete_folder]" \
                [export_vars -base ${url}folder-delete {folder_id}]
        }
    }
}

# Hack to get around slow permissions checks.  Admins can read all files in the
# folder, non-admins can only read their own files and all homework folders.  When
# permission checks are sped up to an acceptable level this hack should be replaced
# with read checks.  

if { $admin_p } {
    set qualify_by_owner ""
} else {
    set qualify_by_owner [db_map qualify_by_owner]
}

#AG: In Oracle this query is a seemingly nonsensical "select 2 from dual".
#The problem is, the db logic in PG is completely different and requires a query.
#To avoid propagating these differences up to Tcl we use a query in Oracle too.
if {(![info exists min_level] || $min_level eq "")} {
    set min_level [db_string select_default_min_level {}]
}
if {(![info exists max_level] || $max_level eq "")} {
    set max_level $min_level
}

# If all the files belong to a single user we won't show the name of the user
# who has created the file.  
set show_users_p 0

db_multirow -extend {pretty_name download_url upload_version_url view_details_url contents_url upload_correction_url view_correction_details_url} \
    folders select_folder_contents {} {
	
	regsub -all " " $spaces {\&nbsp;\&nbsp;} spaces
	if {$content_type eq "content_folder"} {
	    set contents_url [export_vars -base ${url}folder-contents {{folder_id $object_id} return_url}]
	} else {

        if { $user_id != $creation_user } {
            set show_users_p 1
        }

        # Strip off the user_id
        set name [dotlrn_homework::decode_name $name]

        # If the user can read the file the user can read the file's details
        set view_details_url [export_vars -base ${url}file {folder_id {file_id $object_id}}]

        # And download the latest revision
        set file_storage_url [dotlrn_homework::get_file_storage_url]
        set download_url [export_vars -base ${file_storage_url}/download/$name {version_id}]

        # Admin and students can read correction files but only an admin can add one ...
        if { $homework_file_id ne "" } {
            set view_correction_details_url [export_vars -base ${url}file {
		folder_id
		{file_id $homework_file_id}
		{show_all_versions_p "t"}
	    }]
        } elseif { $admin_p } {
            set upload_correction_url \
                [export_vars -base ${url}file-add {
		    folder_id
		    return_url
		    {name "$title - [_ dotlrn-homework.Comments]"}
		    {homework_file_id $object_id}
		}]
        }
    }
}

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
