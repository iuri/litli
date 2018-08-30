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
    A simple target for the portal configuration

    @author Arjun Sanyal (arjun@openforce.net)
    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-10-24
} -query {
}


set form [ns_getform]
set portal_id [ns_set get $form portal_id]
set anchor [ns_set get $form anchor]

# Check if this is a community type level thing
if {[parameter::get -parameter community_type_level_p] == 1} {
    ad_returnredirect "one-community-type"
    return
}

portal::configure_dispatch -portal_id $portal_id -form $form

ad_returnredirect "configure#$anchor"


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
