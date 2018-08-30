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

ad_library {

    Procs to manage dotLRN toolbar

    @author Enrique Catalan (quio@galileo.edu)
    @creation-date 2004-11-10
    @cvs-id $Id: toolbar-procs.tcl,v 1.4.2.1 2015/09/11 11:40:40 gustafn Exp $
}

namespace eval dotlrn_toolbar {

    ad_proc -public permission_p {} {
	Do we have permission to view dotlrn toolbar
    } {
	if { [acs_user::site_wide_admin_p] || [dotlrn::admin_p] } {
	    return 1
	}
	return 0
    }

    ad_proc -public enabled_p {} { 
 	Returns 1 if dotlrn toolbar is enabled.
    } {
	if { ![parameter::get -localize -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_enabled_p -default 1] } {
	    return 0
	}
	return 1
    }

    ad_proc show_p {} { 
	Should we show dotlrn toolbar on the current connection.
    } {
	if { [enabled_p] && [permission_p] } {
	    return 1
	}
	return 0
    }
 
    ad_proc info_show_p {} { 
	Should we show Xtra info in the toolbar. 
	More relevant for developers
    } {
	if { [parameter::get -localize -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_show_info_p -default 1] } {
	    return 1
	}
	return 0
    }
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
