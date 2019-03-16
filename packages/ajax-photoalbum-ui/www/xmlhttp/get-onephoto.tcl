ad_page_contract {

    Retrieve info about one photo


    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-11-25

} {
    photo_id:integer,notnull
    package_id:integer,notnull
    {mode "display"}
}

set user_id [ad_conn user_id]
set package_url [apm_package_url_from_id $package_id]
set success "false"
set photoinfo "{}"

set query_name dbqd.photo-album.www.photo-edit.get_photo_info

if { [db_0or1row $query_name { }] } {
    set success "true"
    set caption [ajaxpa::json_normalize -value $caption] 
    if { $mode == "edit"} { 
        set revision_id [db_nextval acs_object_id_seq] 
    } else { 
        set revision_id "" 
    }
    set title [ajaxpa::json_normalize -value $title]
    set description [ajaxpa::json_normalize -value $description]
    set story [ajaxpa::json_normalize -value $story]

    set photoinfo "{\"photo_id\":${photo_id},\"title\":\"${title}\",\"caption\":\"${caption}\",\"description\":\"${description}\",\"story\":\"${story}\",\"revision_id\":\"${revision_id}\",\"prevrevision_id\":\"${previous_revision}\"}"
} 

ns_set put [ns_conn outputheaders] "Content-Type" "text/html"

ns_return 200 "text/html" "{\"success\":${success}, \"info\":$photoinfo}"