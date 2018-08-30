# /packages/photo-album/www/album-add.tcl

ad_page_contract {

    Export an existing album

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/8/2000
    @cvs-id $Id: album-export.tcl,v 1.8 2018/01/21 00:39:44 gustafn Exp $
} {
    album_id:naturalnum,notnull
    {path ""}
} -validate {
} -properties {
    context_list:onevalue
}

set error_message ""
# Create the folder
if {$path eq ""} {

    db_1row get_album_data {    select 
      cr.title as album_name,
      cr. description,
      pa.story,
      pa.iconic as iconic,
      pa.photographer,
      ci.live_revision as previous_revision
    from cr_items ci,
      cr_revisions cr,
      pa_albums pa
    where ci.live_revision = cr.revision_id
      and cr.revision_id = pa.pa_album_id
      and ci.item_id = :album_id
    }

    #    set path [ad_tmpnam]
    regsub -all -- {[^a-zA-Z0-9\.-]} $album_name {_} album_name
    set original_path [file join [acs_root_dir] album-exports $album_name]
    set path $original_path
    set count 2
    while { [file exists $path] } {
        set path "${original_path}-$count"
        incr count 1
    }
    file mkdir $path
}

foreach photo_id [pa_all_photos_in_album $album_id] {
    
    # query all the photo and permission info with a single trip to database
    if {![db_0or1row get_photo_info {}]} {
        ad_return_error \
	    "[_ photo-album.No_Photo]" \
	    "[_ photo-album.lt_No_Photo_was_found_fo]"
	ad_script_abort
    } else {
        db_1row select_object_metadata {}

        set storage_type "file"
        # Now write the file
        switch $storage_type {
            lob {

                # FIXME: db_blob_get_file is failing when i use bind variables

                # DRB: you're out of luck - the driver doesn't support them and while it should
                # be fixed it will be a long time before we'll want to require an updated
                # driver.  I'm substituting the Tcl variable value directly in the query due to
                # this.  It's safe because we've pulled the value ourselves from the database,
                # don't need to worry about SQL smuggling etc.
                
                db_blob_get_file select_object_content {} -file [file join ${path} ${file_name}]
            }
            text {
                set content [db_string select_object_content {}]
                
                set fp [open [file join ${path} ${file_name}] w]
                puts $fp $content
                close $fp
            }
            file {
                set cr_path [cr_fs_path $storage_area_key]
                set cr_file_name [db_string select_file_name {}]
                if { [file exists "${cr_path}${cr_file_name}"] } {
                    regsub -all -- {[^a-zA-Z0-9\.-]} $file_name {_} file_name
                    if { ![string match -nocase {*[\.][jgp][pin][gfg]} $file_name] } {
                        append file_name ".jpg"
                    }
                    
                    set count 2
                    set original_destination [file join ${path} ${file_name}]
                    set destination $original_destination
                    while { [file exists $destination] } {
                        set destination "[string range ${original_destination} 0 end-4]-$count[string range ${original_destination} end-3 end]"
                        incr count 1
                    }
                    
                    file copy -- "${cr_path}${cr_file_name}" $destination
                } else {
                    append error_message "${file_name}, "
                }
            }
        }
    }
}
