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
auth::require_login
ad_page_contract {
    Remove dotLRN Administrators 

    @author Hector Amado (hr_amado@galileo.edu)
    @creation-date 2004-07-02
    @cvs-id $Id: admin-remove.tcl,v 1.6.4.1 2015/09/11 11:40:49 gustafn Exp $
} {
    user_id
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set group_id [db_string group_id_from_name "
            select group_id from groups where group_name='dotlrn-admin'" -default ""]
        if {$group_id ne "" } {
           group::remove_member -group_id $group_id -user_id $user_id
        }

template::forward dotlrn-admins


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
