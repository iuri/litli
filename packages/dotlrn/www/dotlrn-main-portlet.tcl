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

# dotlrn/www/dotlrn-main-portlet-procs.tcl

ad_page_contract {
    The display logic for the dotlrn main (Groups) portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @version $Id: dotlrn-main-portlet.tcl,v 1.21.4.1 2015/09/11 11:40:43 gustafn Exp $
} {
}

if {(![info exists show_buttons_p] || $show_buttons_p eq "")} {
    set show_buttons_p 0
}

if {(![info exists show_archived_p] || $show_archived_p eq "")} {
    set show_archived_p 0
}

#DRB: This is a hack that depends on .LRN having clubs and classes.  Done quickly for
#theme-selva for .LRN 2.2.

set community_type_clause ""
if { ([info exists community_filter] && $community_filter ne "") } {
    set show_subtitle_p 0
    if { $community_filter eq "class_instances" } {
        set community_type_clause "and dotlrn_communities_all.community_type not in ('dotlrn_community', 'dotlrn_club', 'dotlrn_pers_community')"
    } elseif { $community_filter eq "communities" } {
        set community_type_clause "and dotlrn_communities_all.community_type in ('dotlrn_club', 'dotlrn_pers_community')"
    }
} else {
    set show_subtitle_p 1
}

set user_id [ad_conn user_id]
set user_can_browse_p [dotlrn::user_can_browse_p -user_id $user_id]

set show_drop_button_p [parameter::get_from_package_key \
                               -package_key dotlrn-portlet \
			       -parameter AllowMembersDropGroups]

if { $show_archived_p } {
    set archived_clause ""
} else {
    set archived_clause "and archived_p='f'"
}

set comm_type ""
set old_depth 0
set depth 0
db_multirow -extend {intra_type_ul_tags previous_type_ul_tags} communities select_communities {} {
    set intra_type_ul_tags ""
    set previous_type_ul_tags ""
    set new_type_p 0
    if {$simple_community_type ne "dotlrn_community" } {
        set comm_type $simple_community_type
    } else {
        set simple_community_type $comm_type
    }
    #Checking for existence of old_simple_community_type gives us an
    #easy way to detect the first row.  Don't pre-define it!
    if { ![info exists old_simple_community_type] ||
         $old_simple_community_type ne $simple_community_type } {
        set base_level $tree_level
        set new_type_p 1
    }
    if { [info exists old_simple_community_type] &&
         $old_simple_community_type ne $simple_community_type } {
        append previous_type_ul_tags [string repeat "</li></ul>" $old_depth]
        set old_depth 0
    }

    set depth [expr {$tree_level - $base_level}]
    if { $depth > $old_depth } {
        append intra_type_ul_tags [string repeat "<ul><li>" [expr {$depth - $old_depth}]]
    }
    if { $old_depth > $depth } {
        append intra_type_ul_tags [string repeat "</li></ul>" [expr {$old_depth - $depth}]]
        append intra_type_ul_tags "</li><li>"
    }
    if { $depth == $old_depth && !$new_type_p } {
        append intra_type_ul_tags "</li><li>"
    }

    set old_depth $depth
    set old_simple_community_type $simple_community_type
}

if { $old_depth > 0 } {
    set final_ul_tags [string repeat "</li></ul>" $old_depth]
} else {
    set final_ul_tags ""
}

set dotlrn_url [dotlrn::get_url]

# Add the dhtml tree javascript to the HEAD.
template::head::add_javascript -script "var mktree_remember = true;" -order 1
template::head::add_javascript -src "/resources/acs-templating/mktree.js" -order 2
template::head::add_css -href "/resources/acs-templating/mktree.css"

set self_registration_p [parameter::get -parameter SelfRegistrationP -package_id [dotlrn::get_package_id] -default 1]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
