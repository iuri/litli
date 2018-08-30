ad_page_contract {

    Receives an object id and a comma separated list of categories.
     Categorizes the object_id to the categories passed
      If category exists, use it, otherwise create a new category

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-07-23

} {
    package_id
    object_id
    tags
}

# ns_log notice "ADDTAG : $object_id : $tags "

set user_id [ad_conn user_id]
set result "{\"success\":true}"
set tree_id [parameter::get -parameter "CategoryTreeId"]

db_dml "delmap" "delete from category_object_map where object_id = :object_id"

foreach tag [split $tags ,] {

    set tag [string trim $tag]

    if { ![template::util::is_nil tag] } {

        set category_id [category::get_id [string tolower [string trim $tag]]]

        if { $category_id == "" } {
          
            # remove spaces and any html from tags
            regsub -all {<.+?>} $tag "" tag
            set tag [string tolower [string trim $tag]]

            if { [catch {set creation_ip [ad_conn peeraddr] } ] } {
                set creation_ip "0.0.0.0"
            }

            set category_id [category::add -tree_id $tree_id -name $tag -parent_id "" -user_id $user_id -creation_ip "0.0.0.0"]
            category::map_object -object_id $object_id $category_id
    
        } else {
    
            # map object_id to category
            category::map_object -object_id $object_id $category_id
    
        }
    }
}

# TODO : detect if we're using search, then reindex the item
# reindex for search
# search::queue -object_id $object_id -event "UPDATE"