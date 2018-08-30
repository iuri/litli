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
    Display the page for bulk uploading of a bunch of users

    @author ben (ben@openforce.net)
    @creation-date 2002-03-05
    @version $Id: users-bulk-upload.tcl,v 1.6.10.1 2015/09/11 11:40:54 gustafn Exp $
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [_ dotlrn.Bulk_Upload]]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
