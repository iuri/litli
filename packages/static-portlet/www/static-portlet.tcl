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
    The display logic for the STATIC portlet
    
    @author arjun (arjun@openforce)
    @author Ben Adida (ben@openforce)    
    @cvs_id $Id: static-portlet.tcl,v 1.10.10.1 2015/09/12 19:00:46 gustafn Exp $
} 

array set config $cf    

# one piece of content only per portlet
set content_id $config(content_id)

set success_p 0

set success_p [db_0or1row select_content {
  select body, pretty_name, format
  from static_portal_content
  where content_id = :content_id
}]

# The pretty_name can be a message catalog key
set class_instances_pretty_name [_ dotlrn.class_instances_pretty_name]
set pretty_name [lang::util::localize $pretty_name]

set content_w [template::util::richtext::create $body $format]
set content [template::util::richtext::get_property html_value $content_w]



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
