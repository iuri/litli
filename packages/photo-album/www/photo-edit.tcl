# /packages/photo-album/www/photo-edit.tcl

ad_page_contract {

    Edit Photo Properties

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/11/2000
    @cvs-id $Id: photo-edit.tcl,v 1.8 2014/08/07 07:59:51 gustafn Exp $
} {
    {hide:integer 0}
    {photo_id:naturalnum,notnull 0}
    d:array,integer,optional
} -properties {
    path:onevalue
    height:onevalue
    width:onevalue
}

#  -validate {
#     valid_photo -requires {photo_id:integer} {
# 	if [string equal [pa_is_photo_p $photo_id] "f"] {
# 	    ad_complain "[_ photo-album._The_2]"
# 	}
#     }
# }

permission::require_permission -object_id $photo_id -privilege "write"

set user_id [ad_conn user_id]
set context_list [pa_context_bar_list -final "[_ photo-album._Edit_2]" $photo_id]

#clear the cached value 
util_memoize_flush $photo_id

foreach id [array names d] { 
    if { $d($id) > 0 } { 
        pa_rotate $photo_id $d($photo_id)
    }
}

template::form create edit_photo

template::element create edit_photo photo_id -label "photo ID" \
  -datatype integer -widget hidden

template::element create edit_photo revision_id -label "revision ID" \
  -datatype integer -widget hidden

template::element create edit_photo previous_revision -label "previous_revision" \
  -datatype integer -widget hidden

template::element create edit_photo title -html { size 30 } \
  -label "<#_Title#>" -optional -datatype text

template::element create edit_photo caption -html { size 30 } \
  -label "<#_Caption#>" -help_text "Displayed on the thumbnail page" -optional -datatype text

template::element create edit_photo description -html { size 50} \
  -label "<#_Description#>" -help_text "Displayed when viewing the photo" -optional -datatype text

template::element create edit_photo story -html { cols 50 rows 4 } \
  -label "<#_Story#>" -optional -datatype text  -help_text "Displayed when viewing the photo" -widget textarea

template::element create edit_photo submit_b -widget submit \
        -label submit -optional -datatype text

# moved outside is_request_block so that vars exist during form error reply


db_1row get_photo_info { *SQL* }
db_1row get_thumbnail_info { *SQL* }

if {$live_revision eq ""} {
    set checked_string "checked"
} else {
    set checked_string ""
}
#ad_return_error $checked_string  "$live_revision"
set path $image_id

if { [template::form is_request edit_photo] } {
    set revision_id [db_string get_next_object_id "select acs_object_id_seq.nextval from dual"]
    template::element set_properties edit_photo revision_id -value $revision_id
    template::element set_properties edit_photo photo_id -value $photo_id
    template::element set_properties edit_photo previous_revision -value $previous_revision
    template::element set_properties edit_photo title -value $title
    template::element set_properties edit_photo description -value $description
    template::element set_properties edit_photo story -value $story
    template::element set_properties edit_photo caption -value $caption
}

if { [template::form is_valid edit_photo] } {
    set photo_id [template::element::get_value edit_photo photo_id]
    set revision_id [template::element::get_value edit_photo revision_id]
    set new_title [template::element::get_value edit_photo title]
    set new_desc [template::element::get_value edit_photo description]
    set new_story [template::element::get_value edit_photo story]
    set new_caption [template::element::get_value edit_photo caption]
    set previous_revision [template::element::get_value edit_photo previous_revision]
    set peeraddr [ad_conn peeraddr]
    
    db_transaction {
	db_exec_plsql update_photo_attributes {} 
	db_dml insert_photo_attributes { *SQL* }

	# for now all the attributes about the specific binary file stay the same
	# not allowing users to modify the binary yet
	# will need to modify thumb and view binaries when photo binary is changed 

#	db_dml update_photo_user_filename {} 

	db_exec_plsql set_live_revision {} 

	if {$hide} {
	    db_dml update_hides { *SQL* }
	} 
    } on_error {
	ad_return_complaint 1 "[_ photo-album._An_1]
	  <pre>$errmsg</pre>"
	
	ad_script_abort
    }
    
    ad_returnredirect "photo?photo_id=$photo_id"
    ad_script_abort
}

# These lines are to uncache the image in Netscape, Mozilla. 
# IE6 & Safari (mac) have a bug with the images cache
ns_set put [ns_conn outputheaders] "Expires" "-"
ns_set put [ns_conn outputheaders] "Last-Modified" "-"
ns_set put [ns_conn outputheaders] "Pragma" "no-cache"
ns_set put [ns_conn outputheaders] "Cache-Control" "no-cache"

ad_return_template
