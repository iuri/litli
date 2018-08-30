ad_library {

	Library for Ajax File Storage UI
 	uses Ajax Helper package with ExtJS and the Yahoo User Interface Library.
	http://developer.yahoo.net/yui/index.html
    http://extjs.com/deploy/ext/docs/

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2006-02-24
}

namespace eval ajaxfs { }

ad_proc -private ajaxfs::get_package_id  {

} {
	Return the package_id of the installed and mounted ajax file storage ui

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-24
	@return 

	@error 

} {
	return [apm_package_id_from_key "ajax-filestorage-ui"]
}

ad_proc -private ajaxfs::get_url  {

} {
	Return the URL to the mounted ajax file storage ui instance

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-24
	@return 

	@error 

} {
	return [apm_package_url_from_id [ajaxfs::get_package_id]]
}

ad_proc -private ajaxfs::root_folder_p  {
	-folder_id:required
} {
	Determine if the given folder id is a root folder
	if it is, this proc returns the package id of the root folder.
	if not, this proc returns an empty string.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-24
	@return 

	@error 

} {
	if { [db_0or1row "isroot" "select package_id from fs_root_folders where folder_id=:folder_id"] } {
		return $package_id
	} else  {
		return ""
	}
}

ad_proc -private ajaxfs::get_root_folder {
	-folder_id:required
} {
	Check if the given folder is a root folder, if not then get the parent. Continue to get the parent until 
	the root folder is retrieved. Then return the package_id of the root folder.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-24
	@return 

	@error 
} {
	set root_found 0
	while {$root_found == 0} {
		set root_package_id [ajaxfs::root_folder_p -folder_id $folder_id]
		if { $root_package_id != "" } {
			set root_found 1			
		} else {
			set folder_id  [db_string "getfolderparent" "select parent_id from cr_items where item_id=:folder_id"]
		}
	}
	return $root_package_id
}

ad_proc -private ajaxfs::generate_path {
    -folder_id:required
} {

    Generates a comma separated list of folder_id's that start from the root folder to the given folder_id

    @author Hamilton Chua (ham@solutiongrove.com)   
    @creation-date 2007-07-07
    @return 

    @error 
} {
    set id_list [list]
    lappend id_list $folder_id
    set root_found 0
    while {$root_found == 0} {
        set root_package_id [ajaxfs::root_folder_p -folder_id $folder_id]
        if { $root_package_id != "" } {
            set root_found 1            
        } else {
            set folder_id  [db_string "getfolderparent" "select parent_id from cr_items where item_id=:folder_id"]
            lappend id_list $folder_id
        }
    }

    proc lreverse l {
        set result {}
        set i [llength $l]
        incr i -1
        while {$i >= 0} {
        lappend result [lindex $l $i]
        incr i -1
        }
        return $result
    }

    # reverse order of list
    # join with ',' and return
    set path [join [lreverse $id_list] ","]
    return $path
}
