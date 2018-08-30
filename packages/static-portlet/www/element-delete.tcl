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
    delete a static element
    
    @author arjun (arjun@openforce)
    @cvs_id $Id: element-delete.tcl,v 1.8.2.1 2015/09/12 19:00:46 gustafn Exp $
} -query {
    {content_id:naturalnum,notnull}
    {referer:notnull}
    portal_id:naturalnum,notnull
}  -properties {
    title:onevalue
}

set ds_name [static_portlet::get_my_name]
set pretty_name [static_portal_content::get_pretty_name -content_id $content_id]

# THIS NEEDS TO BE GENERALIZED (FIXME - ben)
set element_id [db_string select_element_id "
select pep.element_id
from portal_element_parameters pep, 
     portal_pages pp,
     portal_element_map pem
where pp.portal_id= :portal_id
and pp.page_id = pem.page_id
and pem.element_id = pep.element_id
and pep.key = 'content_id' 
and pep.value = :content_id
"]

db_transaction {
    # Remove element
    portal::remove_element -element_id $element_id

    # do the deed
    static_portal_content::delete -content_id $content_id
}

# redirect and abort
ad_returnredirect $referer
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
