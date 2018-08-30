# include fragment to display the active surveys in a package
#
# @author Tom Ayles (tom@beatniq.net)
# @creation-date 2004-02-17
# @cvs-id $Id: portlet.tcl,v 1.2 2013/11/06 07:33:53 gustafn Exp $
#
# parameters:
#  package_id - the ID of the surveys package to query
#  base_url - the base URL of the package
#  display_empty_p - if true, display when empty (default 1)
#  class - CSS CLASS attribute value
#  id - CSS ID attribute value
#  cache - cache period, default 0 meaning no cache

if { (![info exists package_id] || $package_id eq "")
     && (![info exists base_url] || $base_url eq "") } {
    error "must specify package_id and/or base_url"
}

if { ![info exists cache] || $cache eq "" } {
    set cache 0
}

if { ![info exists display_empty_p] || $display_empty_p eq "" } {
    set display_empty_p 1
}

if { ![info exists base_url] || $base_url eq "" } {
    set base_url [lindex [site_node::get_url_from_object_id \
                              -object_id $package_id] 0]
}
if { ![info exists package_id] || $package_id eq "" } {
    set package_id [site_node::get_element \
                        -url $base_url -element object_id]
}
set package_name [apm_instance_name_from_id $package_id]

set script "# /packages/survey/lib/portlet.tcl
db_list_of_lists ls {} -bind { package_id $package_id }"

multirow create active survey_id name url

foreach row [util_memoize $script $cache] {
    set survey_id [lindex $row 0]
    set name [lindex $row 1]
    set url "${base_url}respond?survey_id=$survey_id"

    multirow append active $survey_id $name $url
}

ad_return_template
