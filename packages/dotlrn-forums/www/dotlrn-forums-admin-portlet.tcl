#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

#  This version of the forums-admin-portlet has been customized for dotLRN

ad_page_contract {
    The display logic for the forums admin portlet
    
    @author Ben Adida (ben@openforce)
    @cvs_id $Id: dotlrn-forums-admin-portlet.tcl,v 1.3.20.1 2015/09/11 11:40:56 gustafn Exp $
} -properties {
    
}

array set config $cf	

set list_of_package_ids $config(package_id)

if {[llength $list_of_package_ids] > 1} {
    # We have a problem!
    return -code error "[_ dotlrn-forums.lt_There_should_be_only_]"
}

set package_id [lindex $list_of_package_ids 0]
set return_url "[ad_conn url]?[ad_conn query]"
set community_id [dotlrn_community::get_community_id]

db_multirow -extend {query_vars} forums select_forums {
    select forum_id, name, enabled_p, autosubscribe_p
    from forums_forums
    where package_id = :package_id
} {
    set query_vars [export_vars {return_url community_id forum_id}]
}

set url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]
set dotlrn_url [dotlrn::get_url]

set package_id [ad_conn package_id]
set default_name [db_string select_package_name {
    select instance_name from apm_packages where package_id= :package_id
}]

append default_name " [_ dotlrn-forums.forums_default_name_suffix]"

set encoded_default_name [ns_urlencode $default_name]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
