# /packages/photo-album/www/folder-move.tcl

ad_page_contract {
    Allows user to move an folder from one folder to another folder in the same package instance

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 1/8/2000
    @cvs-id $Id: folder-move.tcl,v 1.8 2017/05/26 18:05:37 gustafn Exp $
} {
    folder_id:naturalnum,notnull
} -validate {
    valid_folder -requires {folder_id:integer} {
	if [string equal [pa_is_folder_p $folder_id] "f"] {
	    ad_complain "[_ photo-album._The_3]"
	}
    }

    not_root_folder -requires {folder_id} {
	if { $folder_id == [pa_get_root_folder] } {
	    ad_complain "[_ photo-album._You_2]"
	}
    }
}

set context_list [pa_context_bar_list -final "[_ photo-album._Move_1]" $folder_id]
set user_id [ad_conn user_id]

# to move an folder need write on folder, and old parent folder
# and pa_create_folder on new parent folder (which is check in the is_valid block)

set old_folder_id [db_string get_parent_folder "select parent_id from cr_items where item_id = :folder_id"]
permission::require_permission -object_id $folder_id -privilege write
permission::require_permission -object_id $old_folder_id -privilege write

db_1row get_folder_info {select content_folder.get_label(:folder_id) as title from dual}

# build form

template::form create move_folder

template::element create move_folder folder_id -label "folder ID" \
  -datatype integer -widget hidden


# options query retrieve all folders in package that user can add an folder to
set root_folder_id [pa_get_root_folder]

template::element create move_folder new_folder_id -label "[_ photo-album._Choose_1]" \
  -datatype integer -widget select \
  -options [db_list_of_lists get_folders "select padded_name, folder_id from (select
    ci.item_id,
    lpad ('&nbsp;&nbsp;&nbsp;',((level - 1) * 18),'&nbsp;&nbsp;&nbsp;') || content_folder.get_label(ci.item_id) as padded_name,
    ci.item_id as folder_id
    from cr_items ci
    where ci.content_type = 'content_folder'
    start with ci.item_id = :root_folder_id
    connect by prior ci.item_id = ci.parent_id
      and ci.item_id != :folder_id
    )
    where acs_permission.permission_p(item_id, :user_id, 'pa_create_folder') = 't'
    "]

if { [template::form is_request move_folder] } {
    template::element set_properties move_folder folder_id -value $folder_id
}

if { [template::form is_valid move_folder] } {
    set new_folder_id [template::element::get_value move_folder new_folder_id]

    permission::require_permission -object_id $new_folder_id -privilege "pa_create_folder"

    if [string equal [pa_is_folder_p $new_folder_id] "f"] {
	# may add some sort of error message
	# but this case only happens due to url hacking
	# (or coding errors, which never happen)
	ad_script_abort
    }

    db_transaction {
        
	db_exec_plsql  folder_move "
	begin 
	content_folder.move (
	  folder_id           => :folder_id,
	  target_folder_id  => :new_folder_id
	);
	end;
	"

	db_dml context_update "
	update acs_objects
	set    context_id = :new_folder_id
	where  object_id = :folder_id
	"
	
    } on_error {
	# most likely a duplicate name or a double click
	
	set folder_name [db_string folder_name "
	select name from cr_items where item_id = :folder_id"]
	
	if {[db_string duplicate_check "
	select count(*)
	from   cr_items
	where  name = :folder_name
	and    parent_id = :new_folder_id"]} {
	    ad_return_complaint 1 "[_ photo-album._Either_3]"
	} else {
	    ad_return_complaint 1 "[_ photo-album._We]"
	}
	
	ad_script_abort
    }

    ad_returnredirect "?folder_id=$new_folder_id"
    ad_script_abort
}

ad_return_template

