# /packages/photo-album/www/album-add.tcl

ad_page_contract {

    Add a album to an existing folder

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/8/2000
    @cvs-id $Id: album-add.tcl,v 1.9 2018/03/29 08:19:43 gustafn Exp $
} {
    parent_id:naturalnum,notnull
} -validate {
    valid_parent_folder -requires {parent_id:integer} {
	if [string equal [pa_is_folder_p $parent_id] "f"] {
	    ad_complain "[_ photo-album._The]"
	}
    }
} -properties {
    context_list:onevalue
}

permission::require_permission -object_id $parent_id -privilege "pa_create_album"

set context_list [pa_context_bar_list -final "[_ photo-album._Create]" $parent_id]

template::form create album_add

template::element create album_add album_id -label "album ID" \
  -datatype integer -widget hidden

template::element create album_add parent_id -label "Parent ID" \
  -datatype integer -widget hidden

template::element create album_add title -html { size 30 } \
    -label "[_ photo-album.Album_Name]" -datatype text

template::element create album_add photographer -html { size 50} \
  -label "[_ photo-album.Photographer_]"  -datatype text -optional

template::element create album_add description -html { size 50 } \
  -label "[_ photo-album._Album]" -datatype text -optional

template::element create album_add story -html {cols 50 rows 4} \
  -label "[_ photo-album._Album_1]" -datatype text -widget textarea -optional

if { [template::form is_request album_add] } {
    set album_id [db_nextval acs_object_id_seq]
    template::element set_properties album_add album_id -value $album_id
    template::element set_properties album_add parent_id -value $parent_id
}

if { [template::form is_valid album_add] } {
    # valid new album submission so create new album
    set user_id [ad_conn user_id]
    set peeraddr [ad_conn peeraddr]
    set album_id [template::element::get_value album_add album_id]
    set parent_id [template::element::get_value album_add parent_id]
    set title [template::element::get_value album_add title]
    set description [template::element::get_value album_add description]
    set story [template::element::get_value album_add story]
    set photographer [template::element::get_value album_add photographer]
    # file safe title into name
    regsub -all { +} [string tolower $title] {_} name
    regsub -all {/+} $name {-} name

    db_transaction {
	# add the album
	db_exec_plsql new_album {}

	pa_grant_privilege_to_creator $album_id $user_id

    } on_error {
	# most likely a duplicate name or a double click

	if {[db_string duplicate_check "
	  select count(*)
	  from   cr_items
	  where  (item_id = :album_id or name = :name)
	  and    parent_id = :parent_id"]} {
	      ad_return_complaint 1 "[_ photo-album._Either]"
	} else {
	    ad_return_complaint 1 "[_ photo-album._We]"
	}
    
	ad_script_abort
    }
    #redirect back to index page with parent_id
    
    ad_returnredirect "?folder_id=$parent_id"
    
    ad_script_abort
}

ad_return_template