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
    
    Subscribe group members to a forum and set autosubscription mode
    
    @author Don Baccus (dhogaza@pacifier.com)
    @cvs_id $Id: unsubscribe-members.tcl,v 1.4.2.2 2016/05/20 20:17:34 gustafn Exp $
} {
    forum_id:naturalnum,notnull
    community_id:naturalnum,notnull
    return_url:localurl,notnull
}

db_transaction {
    db_dml update_autosubscribe_p {}
    notification::request::delete_all -object_id $forum_id
}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
