ad_page_contract { 
    Make a given photo the cover photo for the album.
} { 
    photo_id:naturalnum,notnull
} -validate {
    valid_photo -requires {photo_id:integer} {
	if {[pa_is_photo_p $photo_id] != "t" } {
	    ad_complain "The specified photo is not valid."
	}
    }
}

set album_id [db_string get_album_id { 
  SELECT a.item_id
    FROM cr_items i, cr_items a
   WHERE i.item_id = :photo_id
     and a.item_id = i.parent_id
     and i.content_type = 'pa_photo'
     and i.live_revision is not null 
} -default 0]

# If we did not get an album ID 
if {! $album_id } { 
    ad_return_error \
	"Photo Internal Error" \
	"The photo is either not live or not in an album.  Please inform the webmaster of the error"
    ad_script_abort
}

permission::require_permission -object_id $album_id -privilege "write"

db_dml photo_iconic {}

ad_returnredirect "album?album_id=$album_id"
