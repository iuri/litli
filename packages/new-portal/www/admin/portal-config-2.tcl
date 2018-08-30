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

# www/element-layout-2.tcl
ad_page_contract {
    Do the actual moving/removing of the elements, or redirect to add.

    @author Arjun Sanyal
    @creation-date 9/28/2001
    @cvs_id $Id: portal-config-2.tcl,v 1.6.8.1 2015/09/12 11:06:39 gustafn Exp $
} { }

set form [ns_getform]
set portal_id [ns_set get $form portal_id]
set return_url [ns_set get $form return_url]
set anchor [ns_set get $form anchor]

portal::configure_dispatch -portal_id $portal_id -form $form

ad_returnredirect "portal-config?portal_id=$portal_id&referer=$return_url#$anchor"


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
