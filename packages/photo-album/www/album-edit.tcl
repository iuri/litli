# /packages/photo-album/www/album-edit.tcl

ad_page_contract {

    Edit Photo Properties

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/11/2000
    @cvs-id $Id: album-edit.tcl,v 1.7 2014/08/07 07:59:50 gustafn Exp $
} {
    album_id:naturalnum,notnull
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "[_ photo-album._The_1]"
	}
    }
} -properties {
    context_list:onevalue
}

permission::require_permission -object_id $album_id -privilege "write"

set user_id [ad_conn user_id]
set context_list [pa_context_bar_list -final "[_ photo-album._Edit]" $album_id]

template::form create edit_album

template::element create edit_album album_id -label "album ID" \
  -datatype integer -widget hidden

template::element create edit_album revision_id -label "revision ID" \
  -datatype integer -widget hidden

template::element create edit_album previous_revision -label "previous_revision" \
  -datatype integer -widget hidden

template::element create edit_album iconic -label "Iconic" \
  -datatype integer -widget hidden -optional

template::element create edit_album title -html { size 30 } \
  -label "[_ photo-album._Album_2]" -datatype text

template::element create edit_album photographer -html { size 50} \
  -label "[_ photo-album.Photographer]"  -datatype text -optional

template::element create edit_album description -html { size 50} \
  -label "[_ photo-album._Album]"  -datatype text -optional

template::element create edit_album story -html { cols 50 rows 4 } \
  -label "[_ photo-album._Album_1]" -datatype text -widget textarea -optional


# this needs to be outside of the s_request block so title attribute
# is defined during a form error

db_1row get_album_info {}

if { [template::form is_request edit_album] } {
    set revision_id [db_nextval acs_object_id_seq]
    template::element set_properties edit_album revision_id -value $revision_id
    template::element set_properties edit_album album_id -value $album_id
    template::element set_properties edit_album previous_revision -value $previous_revision
    template::element set_properties edit_album title -value $title
    template::element set_properties edit_album description -value $description
    template::element set_properties edit_album story -value $story
    template::element set_properties edit_album iconic -value $iconic
    template::element set_properties edit_album photographer -value $photographer
}

if { [template::form is_valid edit_album] } {
    set album_id [template::element::get_value edit_album album_id]
    set revision_id [template::element::get_value edit_album revision_id]
    set new_title [template::element::get_value edit_album title]
    set new_desc [template::element::get_value edit_album description]
    set new_story [template::element::get_value edit_album story]
    set iconic [template::element::get_value edit_album iconic]
    set new_photographer [template::element::get_value edit_album photographer]
    set previous_revision [template::element::get_value edit_album previous_revision]
    set peeraddr [ad_conn peeraddr]

    db_transaction {
	db_exec_plsql update_album_attributes {}

	db_dml insert_pa_albums {}

	db_exec_plsql set_live_album {}
    } on_error {
	ad_return_complaint 1 "[_ photo-album._An]"
	
	ad_script_abort
    }
    ad_returnredirect "album?album_id=$album_id"
    ad_script_abort
}

ad_return_template
