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

# www/portal-config.tcl

ad_page_contract {
    Main configuration page for a portal

    @author Arjun Sanyal (arjun@openforce.net)
    @creation-date 10/20/2001
    @cvs-id $Id: portal-config.tcl,v 1.10.20.1 2015/09/12 11:06:39 gustafn Exp $
} {
    {referer:optional ""}
    portal_id:naturalnum,notnull
}

set page_url [ad_conn url]
set name ""
set rendered_page [portal::configure \
        -referer $referer \
        -template_p f \
        $portal_id ""
]
set name [portal::get_name $portal_id]
set return_url "$page_url?portal_id=$portal_id"









# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
