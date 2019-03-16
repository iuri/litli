# ajax-photoalbum-ui/lib/ajaxpa-include.tcl
# This include should be placed on a page
#  where you wish to have an ajaxpa instance
#  this include expects the following variables
# package_id : package_id of the file storage instance
# container_id : the object_id of the folder or album that will be opened on load, defaults to the root folder
# layoutdiv : the id of the div element where you want ajaxpa to be rendered, defaults to the entire page
# theme : can be any of the following
# - default
# - gray

if { ![exists_and_not_null theme] } {
    set theme "gray"
}

if { [exists_and_not_null package_id] } {

    set user_id [ad_conn user_id]
    set options [list]
    set rootfolder_id [pa_get_root_folder $package_id]
    set instance_name [db_string "get_folder_name" "select name as instance_name from fs_folders where folder_id = :rootfolder_id"]

    lappend options "package_id:$package_id"
    
    # get the pa root folder based on package_id
    lappend options "rootfolder_id:$rootfolder_id"
    lappend options "rootfolder_name:\"$instance_name\""
    
    # url to the current photo album package
    lappend options "package_url:\"[apm_package_url_from_id $package_id]\""

    # get the path to ajaxpa
    lappend options "xmlhttpurl:\"[ajaxpa::get_url]\xmlhttp/\""

    # thumbnails per page
    lappend options "pagesize:\"[parameter::get -package_id $package_id -parameter ThumbnailsPerPage]\""

    # user_id
    lappend options "user:\"$user_id\""

    # perms for the user on root
    lappend options "root_write_p:[permission::permission_p -party_id $user_id -object_id $rootfolder_id -privilege write]"
    lappend options "root_read_p:[permission::permission_p -party_id $user_id -object_id $rootfolder_id -privilege read]"

    if { [exists_and_not_null layoutdiv] } {
        lappend options "layoutdiv:\"$layoutdiv\""
    }

    set options [join $options ","]

} else {

    ad_return_complaint 1 "Package id is required."
    ad_script_abort

}