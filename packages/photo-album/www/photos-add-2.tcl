# /packages/photo-album/www/photos-add-2.tcl
ad_page_contract {
    Upload a collection of photos from a tar or zip file.
    
    Process and insert photos.

    @author Jeff Davis (davis@xorch.net)
    @creation-date 6/28/2002
    @cvs_id $Id: photos-add-2.tcl,v 1.11 2014/08/07 07:59:51 gustafn Exp $
} {
    {upload_file:optional,trim ""}
    upload_file.tmpfile:optional,tmpfile
    album_id:naturalnum,notnull
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "The specified album is not valid."
	}
    }
    non_empty -requires {upload_file.tmpfile:notnull} {
	if {$upload_file ne "" && (![file exists ${upload_file.tmpfile}] || [file size ${upload_file.tmpfile}] < 4)} {
	    ad_complain "The upload failed or the file was empty"
	}
    }
    directory_exists {
        if {([info exists upload_file] && $upload_file ne "") && ![file isdirectory [parameter::get -parameter FullTempPhotoDir -package_id [ad_conn package_id]]]} { 
            ad_complain "The directory file does not exist"
        }
    }
} 

#check permission
set user_id [ad_conn user_id]
permission::require_permission -object_id $album_id -privilege "pa_create_photo"

if { $upload_file ne "" && 
     [ catch {set tmp_dir [pa_expand_archive $upload_file ${upload_file.tmpfile} pa-$album_id] } errMsg] } { 
    ad_return_complaint 1 "Unable to expand your archive file"
    ad_script_abort
} 

ReturnHeaders text/html
ns_write "<html><head><title>Upload Log</title></head><body><h1>Upload Log</h1><hr>\n"

if {$upload_file ne ""} { 
    ns_write "starting to load images from file $upload_file<br>\n"
    ns_log Debug "made directory $tmp_dir to extract from ${upload_file.tmpfile} ($upload_file)\n"
    set allfiles [pa_walk $tmp_dir]
    set remove 1
} else { 
    ns_write "starting to load images from directory [parameter::get -parameter FullTempPhotoDir -package_id [ad_conn package_id]]<br>\n"
    set allfiles [pa_walk [parameter::get -parameter FullTempPhotoDir -package_id [ad_conn package_id]]]
    set remove 0
}     

set new_photo_ids [pa_load_images -feedback_mode 1 -remove $remove $allfiles $album_id $user_id]

pa_flush_photo_in_album_cache $album_id 

set page [pa_page_of_photo_in_album [lindex $new_photo_ids 0] $album_id]
ns_write "<a href=\"album?album_id=$album_id&page=$page\">View the images</a>"
ns_write "</body></html>"

# Now that we are done working on the upload we delete the tmp file
if {[info exists tmp_dir]} { 
    file delete -force $tmp_dir
}
