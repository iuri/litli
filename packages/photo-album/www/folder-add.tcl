# /packages/photo-album/www/folder-add.tcl

ad_page_contract {

    Add a folder to an existing folder

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/8/2000
    @cvs-id $Id: folder-add.tcl,v 1.7 2014/08/07 07:59:50 gustafn Exp $
} {
    parent_id:naturalnum,notnull
} -validate {
    valid_parent -requires {parent_id:integer} {
	if [string equal [pa_is_folder_p $parent_id] "f"] {
	    ad_complain "[_ photo-album._The]"
	}
    }
} -properties {
    context_list:onevalue
}

# check for permission
permission::require_permission -object_id $parent_id -privilege pa_create_folder

 
set context_list [pa_context_bar_list -final "[_ photo-album._Create_1]" $parent_id]

template::form create folder_add

template::element create folder_add folder_id -label "Sub-folder ID" \
  -datatype integer -widget hidden

template::element create folder_add parent_id -label "Parent ID" \
  -datatype integer -widget hidden

template::element create folder_add label -html { size 30 } \
  -label "[_ photo-album._Folder]" -datatype text

template::element create folder_add description -html { size 50 } \
  -label "[_ photo-album._Folder_1]" -optional -datatype text

if { [template::form is_request folder_add] } {

    set folder_id [db_nextval acs_object_id_seq]
    template::element set_properties folder_add folder_id -value $folder_id
    template::element set_properties folder_add parent_id -value $parent_id
}

if { [template::form is_valid folder_add] } {

    # valid new sub-folder submission so create new subfolder

    set user_id [ad_conn user_id]
    set peeraddr [ad_conn peeraddr]
    set folder_id [template::element::get_value folder_add folder_id]
    set parent_id [template::element::get_value folder_add parent_id]
    set label [template::element::get_value folder_add label]
    set description [template::element::get_value folder_add description]

    #file-safe the label into name
    regsub -all { +} [string tolower $label] {_} name
    regsub -all {/+} $name {-} name

    db_transaction {

	# add the folder
	db_exec_plsql new_folder {
	    declare
	      fldr_id    integer;
	    begin
	    
	    fldr_id :=content_folder.new (
	      name          => :name,
              label         => :label,
              description   => :description,
              parent_id     => :parent_id,
              folder_id     => :folder_id,
              creation_date => sysdate,
              creation_user => :user_id,
              creation_ip   => :peeraddr
	    );

	    -- content_folder.new automatically registers 
	    -- the content_types of the parent to the new folder
	
	    end;
	}
	
	pa_grant_privilege_to_creator $folder_id $user_id

    } on_error {
	# most likely a duplicate name or a double click
        
	if {[db_string duplicate_check "
	  select count(*)
	  from   cr_items
	  where  (item_id = :folder_id or name = :name)
	  and    parent_id = :parent_id"]} {
	      ad_return_complaint 1 "[_ photo-album._Either_2]"
	} else {
	    ad_return_complaint 1 "[_ photo-album._We]"
	}
    
	ad_script_abort
    }

    #redirect back to index page with parent_id
    ad_returnredirect "?folder_id=$parent_id"
    ad_script_abort
}
