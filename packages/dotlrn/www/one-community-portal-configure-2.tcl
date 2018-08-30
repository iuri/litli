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
    Form target for the Configuration page for an instance's portal template

    @author Arjun Sanyal (arjun@openforce.net)
    @version $Id: one-community-portal-configure-2.tcl,v 1.12.2.2 2016/05/20 20:17:34 gustafn Exp $
} {
    portal_id:naturalnum,notnull
    return_url:localurl
    {anchor {}}
}

ns_log warning "starting one-community-portal-configure"

ns_log warning "about to call dispatch"

portal::configure_dispatch -portal_id $portal_id -form [ns_getform]

ad_returnredirect "one-community-portal-configure?portal_id=$portal_id&referer=$return_url#$anchor"


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
