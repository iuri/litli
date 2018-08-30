ad_library {
    Notification procs for Survey

    Currently this is a place holder file. These procs are not currently needeed and have not been implemented.

    At some point the notification procs in survey-procs should be moved into this file.

    @creation-date 2002-10-29

}

namespace eval survey::notification {}

ad_proc -public survey::notification::get_url {
    object_id
} {
    set package_id [db_string get_package_id {}]
    set package_url [site_node::get_url_from_object_id -object_id $package_id]
    return "${package_url}admin/one?survey_id=$object_id"
}

ad_proc -public survey::notification::process_reply {
    reply_id
} {

}