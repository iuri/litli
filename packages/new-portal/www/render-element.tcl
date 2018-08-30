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

# www/render-element.tcl
ad_page_contract {
    Render an element.

    @author 
    @creation-date 
    @cvs_id $Id: render-element.tcl,v 1.15.4.1 2015/09/12 11:06:39 gustafn Exp $
} -properties {
    element_id:onevalue
    region:onevalue
}

# get the complete, evaluated element.
# if there's an error, report it.
if { [catch {set element_data [portal::evaluate_element $element_id $theme_id] } errmsg ] } {
    if { [parameter::get -parameter show_datasource_errors_p] == 1} {
	set element(content) "<div class=portal_alert>$errmsg</div>"
    } else {
	return
    }
} else {
    array set element $element_data
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
