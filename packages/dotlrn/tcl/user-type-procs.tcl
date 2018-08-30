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

    general support for dotLRN user types

    @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
    @creation-date 2002-07-26
    @cvs-id $Id: user-type-procs.tcl,v 1.5.2.1 2015/09/11 11:40:40 gustafn Exp $

}

namespace eval dotlrn::user::type {

    ad_proc -public get {
        {-type:required}
    } {
        get the user type info for the given dotlrn_user_type (cached)
    } {
        return [util_memoize "dotlrn::user::type::get_not_cached -type $type"]
    }

    ad_proc -public get_not_cached {
        {-type:required}
    } {
        get the user type info for the given dotlrn_user_type (cached)
    } {
        db_1row select_dotlrn_user_type_info {} -column_array row
        return [array get row]
    }

    ad_proc -public get_rel_type {
        {-type:required}
    } {
        get the rel_type for a given dotlrn_user_type
    } {
        array set user_type [get -type $type]
        return $user_type(rel_type)
    }

    ad_proc -public get_group_id {
        {-type:required}
    } {
        get the group_id of a dotlrn_user_type
    } {
        array set user_type [get -type $type]
        return $user_type(group_id)
    }

    ad_proc -public get_segment_id {
        {-type:required}
    } {
        get the rel_segment_id of a dotlrn_user_type
    } {
        array set user_type [get -type $type]
        return $user_type(segment_id)
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
