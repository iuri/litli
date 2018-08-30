# ajax-filestorage-ui/lib/ajaxfs-include.tcl
# This include should be placed on a page
#  where you wish to have an ajaxfs instance
#  this include expects the following variables
# package_id : package_id of the file storage instance
# folder_id : the folder that will be opened on load, defaults to the root folder
# layoutdiv : the id of the div element where you want ajaxfs to be rendered
# theme : can be any of the following
# - default
# - aero
# - gray
# - vista

if { ![exists_and_not_null theme] } {
    set theme "gray"
}

set debug [parameter::get -package_id [ajaxfs::get_package_id] -parameter "debug" -default 1]
set create_url_p [parameter::get -package_id $package_id -parameter "EnableCreateUrl" -default 1]
set share_folders_p [parameter::get -package_id $package_id -parameter "EnableFolderShare" -default 0]
set multi_file_upload_p [parameter::get -package_id $package_id -parameter "EnableMultiUpload" -default 1]
set max_file_size [parameter::get -package_id $package_id -parameter "MaximumFileSize" -default 2000000]
set user_id [ad_conn user_id]

# ** autosuggest ***
set tree_id [parameter::get -package_id [ajaxfs::get_package_id] -parameter "CategoryTreeId"]
if { [exists_and_not_null tree_id] } {
    set locale [ad_conn locale]
    set sql_query "select t.name, t.name
    from categories c, category_translations t
    where c.category_id = t.category_id
    and c.tree_id = $tree_id
    and t.locale = 'en_US'
    order by lower(t.name)
    "
    set suggestion_list [db_list_of_lists get_array_list $sql_query]
    set suggestion_formatted_list {}
    foreach suggestion $suggestion_list {
        lappend suggestion_formatted_list "\[\"[lindex $suggestion 0]\",\"[lindex $suggestion 1]\"\]"
    }
    append suggestions_stub [join $suggestion_formatted_list ","]
} else {
    set suggestions_stub ""
}
# ********************

set template_head_p 0
if { [info commands ::template::head::add_javascript] ne "" } {
    set template_head_p 1
    template::head::add_css -order 500 -href "/resources/ajaxhelper/ext2/resources/css/ext-all.css"
    template::head::add_css -order 501 -href "/resources/ajaxhelper/ext2/resources/css/xtheme-${theme}.css"
    template::head::add_css -order 502 -href "http://yui.yahooapis.com/2.6.0/build/autocomplete/assets/skins/sam/autocomplete.css"
    template::head::add_css -order 503 -href "/resources/ajax-filestorage-ui/ajaxfs.css"
    template::head::add_javascript -order 101 -src "http://yui.yahooapis.com/2.6.0/build/utilities/utilities.js"
    template::head::add_javascript -order 102 -src "http://yui.yahooapis.com/2.6.0/build/datasource/datasource-min.js"
    template::head::add_javascript -order 103 -src "http://yui.yahooapis.com/2.6.0/build/autocomplete/autocomplete-min.js"
    template::head::add_javascript -order 104 -src "/resources/ajaxhelper/ext2/adapter/yui/ext-yui-adapter.js"
    template::head::add_javascript -order 105 -src "/resources/ajaxhelper/ext2/ext-all.js"
    template::head::add_javascript -order 106 -src "/resources/ajax-filestorage-ui/swfupload/swfupload.js"
    template::head::add_javascript -order 107 -src "/resources/ajax-filestorage-ui/swfupload/swfupload.queue.js"
    template::head::add_javascript -order 108 -src "/resources/ajax-filestorage-ui/swfupload/fileprogress.js"
    template::head::add_javascript -order 109 -src "/resources/ajax-filestorage-ui/utils.js"
    if { $debug } {
        template::head::add_javascript -order 110 -src "/resources/ajax-filestorage-ui/ajaxfs.js"
    } else {
        template::head::add_javascript -order 110 -src "/resources/ajax-filestorage-ui/ajaxfs-min.js"
    }
}


if { [exists_and_not_null package_id] } {

    set options [list]

    # get the root folder
    set rootfolder_id [fs_get_root_folder -package_id $package_id]
    set instance_name [db_string "get_folder_name" "select name as instance_name from fs_folders where folder_id = :rootfolder_id"]
    set roottext [db_string "get_folder_name" "select name from fs_folders where folder_id = :rootfolder_id"]
    set views_p [db_0or1row "check_views_package" "select package_key from apm_packages where package_key = 'views'"]

    # c/o Franz Penz
    regsub -all {"} $instance_name {\"} instance_name
    regsub -all {"} $roottext {\"} roottext

    if {[permission::permission_p -no_cache -party_id [ad_conn user_id] -object_id ${rootfolder_id} -privilege "write"]}  { set rootwrite_p "t" }  else { set rootwrite_p "f" }
#    if {[permission::permission_p -no_cache -party_id [ad_conn user_id] -object_id ${rootfolder_id} -privilege "delete"]} { set rootdelete_p "t" } else { set rootdelete_p "f" }
set rootdelete_p "f";   # Community root folder doesn't been delete
    if {[permission::permission_p -no_cache -party_id [ad_conn user_id] -object_id ${rootfolder_id} -privilege "admin"]}  { set rootadmin_p "t" }  else { set rootadmin_p "f" }

    lappend options "treerootnode:{text:\"$roottext\", id:\"$rootfolder_id\",\"attributes\":{\"write_p\":\"$rootwrite_p\",\"delete_p\":\"$rootdelete_p\",\"admin_p\":\"$rootadmin_p\"}}"

    lappend options "package_id:$package_id"
    lappend options "package_url:\"[apm_package_url_from_id $package_id]\""
    lappend options "xmlhttpurl:\"[ajaxfs::get_url]\xmlhttp/\""

    lappend options "rootfolder:$rootfolder_id"
    lappend options "rootfoldername:\"$instance_name\""

    if { [exists_and_not_null folder_id] && $folder_id != $rootfolder_id } {
        lappend options "initOpenFolder:$folder_id"
        lappend options "pathToFolder: new Array([ajaxfs::generate_path -folder_id $folder_id])"
    }

    if { [exists_and_not_null public] || [permission::permission_p -no_login -no_cache -party_id [db_string "get_public" "select object_id from acs_magic_objects where name ='the_public'"] -object_id $package_id -privilege "read"] } {
        lappend options "ispublic:true"
    }

    # notification type id
    set notif_type_id [notification::type::get_type_id -short_name fs_fs_notif]

    lappend options "notif_type_id:\"$notif_type_id\""

    if { [exists_and_not_null layoutdiv] } {
        lappend options "layoutdiv:\"$layoutdiv\""
    }

    lappend options "max_file_size:\"$max_file_size\""
    lappend options "create_url:$create_url_p"
    lappend options "share_folders:$share_folders_p"
    lappend options "multi_file_upload:$multi_file_upload_p"
    lappend options "user_id:\"$user_id\""
    lappend options "views_p:\"$views_p\""

    set options [join $options ","]

} else {

    ad_return_complaint 1 "Package id is required."
    ad_script_abort

}