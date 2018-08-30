#
#  Copyright (C) 2001, 2002 MIT
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

ad_page_contract {
    Displays a community type

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-10-04
    @version $Id: one-community-type.tcl,v 1.25.4.1 2015/09/11 11:40:45 gustafn Exp $
} -query {
} -properties {
    context_bar:onevalue
    pretty_name:onevalue
    description:onevalue
    supertype:onevalue
    community_type:onevalue
    ancestor_type:onevalue
    community_type_title:onevalue
    communities_title:onevalue
    title:onevalue
}

set self_registration_p [parameter::get -parameter SelfRegistrationP -package_id [dotlrn::get_package_id] -default 1]


# Check that this is a community type
if {[parameter::get -localize -parameter community_type_level_p] != 1} {
    ad_returnredirect "./"
    ad_script_abort
}

set user_id [ad_conn user_id]

set context_bar [_ dotlrn.View]

# What community type are we at?
set community_type [dotlrn_community::get_community_type]
set ancestor_type [dotlrn_community::get_toplevel_community_type -community_type $community_type]

# Load some community type info
db_1row select_community_type_info {}

set description [lang::util::localize $description]

if {$community_type eq "dotlrn_class_instance"} {
    set community_type_title [parameter::get -localize -parameter classes_pretty_plural]
    set communities_title [parameter::get -localize -parameter class_instances_pretty_name]
    set title [parameter::get -localize -parameter classes_pretty_plural]
} elseif {$community_type eq "dotlrn_club"} {
    set community_type_title [parameter::get -localize -parameter clubs_pretty_plural]
    set communities_title [parameter::get -localize -parameter clubs_pretty_plural]
    set title [parameter::get -localize -parameter clubs_pretty_plural]
} elseif {$ancestor_type eq "dotlrn_class_instance"} {
    set community_type_title [parameter::get -localize -parameter classes_pretty_plural]
    set communities_title [parameter::get -localize -parameter class_instances_pretty_name]
    set title [lang::util::localize $pretty_name]
} else {
    set community_type_title "[_ dotlrn.Community_Types]"
    set communities_title "[_ dotlrn.Communities]"
    set title "[_ dotlrn.Community_Type]"
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
