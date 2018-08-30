# packages/ajax-filestorage-ui/tcl/apm-callback-procs.tcl

ad_library {

    APM Callbacks

    @author Hamilton Chua (ham@solutiongrove.com)

}

namespace eval ajaxfs::apm {}

ad_proc -private ajaxfs::apm::after_mount {
    -package_id
    -node_id
} {
    After install callback.
    Creates a new category tree for tagging.

    @author Hamilton Chua (ham@solutiongrove.com)

} {

    set tree_id [category_tree::add -name "Tags"]
    parameter::set_value -package_id $package_id -parameter "CategoryTreeId" -value $tree_id

}

ad_proc -private ajaxfs::apm::after_upgrade {
    -from_version_name
    -to_version_name
} {

    Upgrade scripts

    @author Roel Canicula (roelmc@pldtdsl.net)

} {

    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            0.8d 0.81d {

                array set node [site_node::get -url /ajaxfs2]
                set package_id $node(package_id)
                set tree_id [category_tree::add -name "Tags"]
                parameter::set_value -package_id $package_id -parameter "CategoryTreeId" -value $tree_id

            }


    }

}
