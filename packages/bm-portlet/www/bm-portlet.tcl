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

    The display logic for the bulk-mail portlet

    @author yon (yon@openforce.net)
    @creation-date 2002-05-13
    @version $Id: bm-portlet.tcl,v 1.6.20.1 2015/09/10 08:30:13 gustafn Exp $

} -query {
} -properties {
    user_id:onevalue
    admin_p:onevalue
    package_id:onevalue
    scoped_p:onevalue
}

array set config $cf

set user_id [ad_conn user_id]
set package_id $config(package_id)
set scoped_p [ad_decode $config(scoped_p) t 1 0]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

set spam_name [bulk_mail::parameter -localize -parameter pretty_name]
set spam_url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
