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
    Page that displays a system-wide list of portals and gives
    the option to view or edit them

    @author Arjun Sanyal (arjun@openforce.net)
    @creation-date 
    @cvs-id $Id: index.tcl,v 1.5.24.1 2015/09/12 11:06:39 gustafn Exp $
} { }


permission::require_permission -object_id [ad_conn package_id] -privilege admin

set query "select 
           portal_id, name, template_id
           from portals"

template::query get_portals portals multirow $query 

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
