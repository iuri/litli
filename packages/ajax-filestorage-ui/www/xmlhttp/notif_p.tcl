ad_page_contract {

    Determine if the current user is subscribed to file storage notifications for the given object_id.

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2008-06-28

} {
    object_id:integer
}

set user_id [ad_conn user_id]
set type_id [notification::type::get_type_id -short_name fs_fs_notif]

set request_id [notification::request::get_request_id -type_id $type_id \
    -object_id $object_id -user_id $user_id]

if { [exists_and_not_null request_id] } {
    ns_return 200 text/html 1
} else {
    ns_return 200 text/html 0
}


