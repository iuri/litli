ad_page_contract {

    Determine if the user is subscribed for notifications for the given object_id.
    If yes, redirect to notifications page to delete the notification.
    If no, redirect to the notifications page to allow user to subscribe to notifications

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2008-06-28

} {
    object_id:integer
    pretty_name
    return_url
}

set user_id [ad_conn user_id]
set type_id [notification::type::get_type_id -short_name fs_fs_notif]

set request_id [notification::request::get_request_id -type_id $type_id \
    -object_id $object_id -user_id $user_id]

if { [exists_and_not_null request_id] } {
    ad_returnredirect "/notifications/request-delete?request_id=${request_id}&return_url=${return_url}"
} else {
    ad_returnredirect "/notifications/request-new?pretty_name=${pretty_name}&type_id=${type_id}&object_id=${object_id}&return_url=${return_url}"
}

ad_script_abort


