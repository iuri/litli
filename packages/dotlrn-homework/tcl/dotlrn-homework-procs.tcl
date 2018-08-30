ad_library {

    General purpose procedures used by the homework package

    @author Don Baccus (dhogaza@pacifier.com)

}

ad_proc dotlrn_homework_post_instantiation {
    package_id
} {

    Post package instantiation procedure to insert a package_id, 
    folder_id pair in fs_root_folders.   The homework package wants its own root folder
    because we don't want it to be visible to any mounted instance of file storage.

    This proc is automatically called by the APM whenever an instance of dotlrn_homework
    is mounted.

} {
    return [fs::new_root_folder -package_id $package_id]
}

namespace eval dotlrn_homework {

    ad_proc -public encode_name {
        -user_id:required
        unencoded_name
    } {

        Encode the user-supplied file name with the user's ID.  We do this because the homework
        folder hides files uploaded by other users and we want to avoid apparently mysterious duplicate
        file name errors when two different users give their homework assignment the same name.

    } {
        return "${user_id}_$unencoded_name"
    }

    ad_proc -public decode_name {
        encoded_name
    } {

        Undo what encode_name does

    } {
        if { [regexp {^([0-9]+)_(.*)} $encoded_name match user_id unencoded_name] } {
            return $unencoded_name
        } else {
            return -code error "Name was not encoded"
        }
    }

    # Convenient Tcl procs for uploading file content vaguely based on code from the GPL'd work DRB
    # did for Greenpeace International combined with code poached from file-storage.

    ad_proc -public new {
        -file_id:required
        -new_file_p:required
        -parent_folder_id
        -title
        -description:required
        -upload_file:required
        -homework_file_id
	{-package_id ""}
    } {

        Build a new content revision in the given folder.  If new_file_p is set true then
        a new item is first created, otherwise a new revision is created for the item indicated
        by file_id.

        This code provides better double-click protection (old ACS 3.x style) than file-storage and
        integrates nicely with ad_form.  I couldn't use the standard file-storage pages without hacking
        on them so decided it would be easiest to just write new ones.

        @param file_id The item to update or create.
        @param new_file_p If true make a new item using file_id
        @param title The title given the new revision
        @param description The description of the new revision
        @param upload_file The file structure passed us by the browser
        @param homework_file_id If nonzero, this is a correction file to relate to homework_file_id
        @param package_id Package ID of the homework package used

    } {

        set user_id [ad_conn user_id]
        set creation_ip [ad_conn peeraddr]

        set filename [template::util::file::get_property filename $upload_file]
        set tmp_filename [template::util::file::get_property tmp_filename $upload_file]

        # The content repository is kinda stupid about mime types,
        # so we have to check if we know about this one and possibly 
        # add it.
        set mime_type [cr_filename_to_mime_type $filename]

        # Get the storage type
        set indb_p [ad_decode [parameter::get -package_id [ad_conn package_id] -parameter "StoreFilesInDatabaseP"] 1 "t" "f"]

        if { $new_file_p } {

            if { $homework_file_id > 0 } {
                db_1row get_owner_id {}
            } else {
                set homework_user_id $user_id
            }

            set encoded_filename [encode_name -user_id $homework_user_id $filename]

            if { [db_0or1row check_duplicate {}]} {

		# AG: Make a reasonable attempt at avoiding collisions by
		# converting a duplicate filename foo.txt to foo-2.txt,
		# foo-3.txt and so on.
		set success_p 0
		set saved_filename $encoded_filename
		for {set i 2} {$i < 11} {incr i} {
		    set encoded_filename "[file rootname $saved_filename]-${i}[file extension $saved_filename]"
		    if { ![db_0or1row check_duplicate {}]} {
			set success_p 1
			break
		    }
		}
		if { !$success_p } {
		    return -code error "[_ dotlrn-homework.lt_file_named]"
		}
            }

            db_exec_plsql new_lob_file {}

            # The file storage package more or less sucks as the API makes unnecessary assumptions about
            # the desired permissions.  I'd like to fix that in 4.6 but don't really want to tread on
            # OF's toes by making more last-minute changes to the OpenACS 4 CVS tip.

            # This hack will leave the site-wide admin able to munge user homework files.  That's probably
            # a good thing ...

            db_dml update_context {
                update acs_objects
                set context_id = null
                where object_id = :file_id
            }

            set community_id [dotlrn_community::get_community_id]
            set admins [dotlrn_community::get_rel_segment_id \
                            -community_id $community_id \
                            -rel_type dotlrn_admin_rel]

            # admins of this community can admin the file
            permission::grant -party_id $admins -object_id $file_id -privilege admin
            
            if { $homework_file_id == 0 } {

                # The student uploading a homework file can read and edit it
                permission::grant -party_id $user_id -object_id $file_id -privilege write
                permission::grant -party_id $user_id -object_id $file_id -privilege read

            } else {

                # A correction file. Relate it to the homework file.
                add_correction_relation -homework_file_id $homework_file_id -correction_file_id $file_id

                # And let the homework file's owner read it.
                permission::grant -party_id $homework_user_id -object_id $file_id -privilege read

                # All admins can upload a correction file
                permission::grant -party_id $admins -object_id $file_id -privilege admin

            }

        } else {

	    # When updating we simply query for the title of the live
	    # revision.  The title is used by the new_version query
	    # below.
	    set title [db_string live_version_title {}]

	}

        # Grab key for new revision
        set revision_id [db_exec_plsql new_version {}]

        # A community admin can admin their own comment file revision
        if { $homework_file_id > 0 } {
            permission::grant -party_id $user_id -object_id $revision_id -privilege admin
        }

        if { [string is true $indb_p] } {

            db_dml lob_content {} -blob_files [list $tmp_filename]

            # Unfortunately, we can only calculate the file size after the lob is uploaded 
            db_dml lob_size {}

        } else {

            set tmp_filename [cr_create_content_file $file_id $revision_id $tmp_filename]
            set tmp_size [cr_file_size $tmp_filename]

            db_dml fs_content_size {}

        }

        return $revision_id

    }

    ad_proc -public get_file_storage_url {
    } {

        Return the URL of our sibling file-storage package

    } {

        # The proc I need to do this went missing after an Open Force CVS update so for now we'll
        # just guarantee that file-storage is mounted under dotlrn and run with it.

        site_node::get -url "/dotlrn/file-storage"
        return "/dotlrn/file-storage"

    }

    ad_proc -public add_correction_relation {
        -homework_file_id:required
        -correction_file_id:required
    } {

        Add a correction file to a homework file, using the Content Repository's handy-dandy,
        built-in item relations facility.

    } {
        db_exec_plsql relate {}
    }

    ad_proc -public send_homework_alerts {
        -folder_id:required
        -file_id:required
    } {

        Send any alerts triggered by uploading a homework file

    } {

        # Forums build HTML but then slam it out as text.  We should probably build
        # text and convert to HTML later and include http: links as the text to html
        # routine in text-html-procs turns these into links automatically.

        # For now we'll just build vanilla text

        db_1row get_alert_info {}

	set decoded_name [decode_name $name]

        set message "

[_ dotlrn-homework.lt_a_file_named_1]

"

        notification::new -type_id [notification::type::get_type_id -short_name homework_upload] \
            -object_id $folder_id -response_id $folder_id -notif_subject "[_ dotlrn-homework.lt_homework_upload]" \
            -notif_text $message


    }

    ad_proc -public send_correction_alerts {
        -homework_file_id:required
        -folder_id:required
    } {

        Send any alerts triggered by uploading a correction file

    } {

        set user_id [ad_conn user_id]

        db_1row get_alert_info {}

	set decoded_name [decode_name $name]

        set message "

[_ dotlrn-homework.lt_admin_has_uploaded]"


        notification::new -type_id [notification::type::get_type_id -short_name correction_upload] \
            -object_id $homework_file_id -response_id $homework_file_id -notif_subject "[_ dotlrn-homework.lt_correction_file_alert]" \
            -notif_text $message


    }

    ad_proc -public request_correction_alert {
        -homework_file_id:required
    } {

        Set an alert for the user on our recently uploaded homework file

    } {

    set type_id [notification::type::get_type_id -short_name correction_upload]

    set intervals [notification::get_intervals -type_id $type_id]
    set delivery_methods [notification::get_delivery_methods -type_id $type_id]

    # Sanity check to make sure the db entries are set up correctly.

    if { [llength $intervals] != 1 || [llength $delivery_methods] != 1 } {
        return -code error "Internal error: interval or delivery method for homework notifications broken"
    }

    # The get routines return a list of name/id pairs so extract the ids
    set interval_id [lindex $intervals 0 1]
    set delivery_method_id [lindex $delivery_methods 0 1]

    # Add the alert
    notification::request::new -type_id $type_id -user_id [ad_conn user_id] -object_id $homework_file_id \
            -interval_id $interval_id -delivery_method_id $delivery_method_id

    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
