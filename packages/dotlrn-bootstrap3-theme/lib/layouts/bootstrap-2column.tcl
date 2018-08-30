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

# new-portal/www/layouts/simple2.tcl

ad_page_contract {
    This is a simple 2 column layout called from portal::render and the like. 
    It laysout the elements with portal::layout_elements and hands off rendering
    of the individual portlets to the template in the "element_src" var

    @version $Id: bootstrap-2column.tcl,v 1.1 2017/02/20 09:49:14 gustafn Exp $
} -properties {
    element_list:onevalue
    element_src:onevalue
    action_string:onevalue
    theme_id:onevalue
    return_url:onevalue
}

if {![info exists action_string]} {
    set action_string ""
}

if {![info exists theme_id]} {
    set theme_id ""
}

if {![info exists return_url]} {
    set return_url ""
}

if {[info exists resource_dir] && $resource_dir ne ""} {
    portal::set_page_css $resource_dir
}

portal::layout_elements $element_list

set element_2_first_num [llength $element_ids_1] 

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
