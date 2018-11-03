# /packages/photo-album/www/photos-add.tcl

ad_page_contract {
    Upload a collection of photos from a tar or zip file.
    Initial form data

    @author Jeff Davis (davis@xorch.net)
    @creation-date 6/28/2002
    @cvs_id $Id: photos-add.tcl,v 1.9 2014/08/07 07:59:51 gustafn Exp $
} {
    album_id:naturalnum,notnull
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "[_ photo-album._The_1]"
	}
    }
} -properties {
    album_id:onevalue
    context:onevalue
}

# check for read permission on folder
permission::require_permission -object_id $album_id -privilege pa_create_photo

set context [pa_context_bar_list -final "[_ photo-album._Upload]" $album_id]

set photo_id [db_nextval "acs_object_id_seq"]

ad_form -name photos_upload -action photos-add-2 -html {enctype multipart/form-data} \
    -export {album_id} -form {
    {-section Either}
    {upload_file:text(file),optional  {label {[_ photo-album._Choose_3]}}
                                      {help_text {[_ photo-album._Use_1]}}
    }
    {-section Or}
    {directory:text                   {html {size 50}}
                                      {label {[_ photo-album.Upload_photos]}}
                                      {help_text {[_ photo-album._the]}}
                                      {value {[parameter::get -parameter FullTempPhotoDir -package_id [ad_conn package_id]]}}
                                      {mode display}
    }
}

ad_return_template


