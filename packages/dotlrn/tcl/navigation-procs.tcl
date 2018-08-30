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

    Procs for dotLRN navigation, including helper procs for dotlrn-master

    @author ben@openforce.net
    @author arjun@openforce.net
    @cvs-id $Id: navigation-procs.tcl,v 1.28.2.2 2017/04/21 20:45:16 gustafn Exp $

}

namespace eval dotlrn {

    ad_proc -public admin_navbar {
        args
    } {
        do an admin navbar
    } {
        # Prepend some args
        set first_args [list [list [get_url] "dotLRN"]]
        set admin_pretty_name [_ dotlrn.admin_pages_navbar_name]
        if {[llength $args] > 0} {
            lappend first_args [list [get_admin_url] $admin_pretty_name]
        } else {
            lappend first_args $admin_pretty_name
        }

        set args [concat $first_args $args]

        return [raw_navbar $args]
    }

    ad_proc -public user_context_bar {
        {-community_id:required}
    } {
        <p>
          Produce a helpful context bar for .LRN users. The context
          bar is intended to aid navigation inside applications mounted
          under dotlrn packages (classes, communities, and the .LRN home).
          The proc will fetch the context var from the callers scope with upvar.
        </p>

        <p>
          Disclaimer: so far the proc has only been tested to work under
          classes and communities.
        </p>

        @param community_id The id of the community/class we are at.

        @author Peter Marklund
    } {
        set community_context [dotlrn_community::navigation_context $community_id]
        
        upvar context context
    
        # Need to handle empty context as well
        if { [info exists context] } {
            # The application context doesn't contain the application node itself so we need to prepend that
            array set node_array [site_node::get -node_id [ad_conn node_id]]
            set application_name $node_array(instance_name)
            set application_url $node_array(url)
    
            if { [string match "admin/*" [ad_conn extra_url]] } {
                set application_admin_context [list [list "${application_url}admin/" "Administration"]]
            } else {
                set application_admin_context [list]
            }
    
            if { $node_array(package_key) ne "dotlrn" } {
                set application_context [list [list $application_url $application_name]]
            } else {
                set application_context [list]
            }
    
            if { [llength $application_admin_context] > 0 } {
                set application_context [concat $application_context $application_admin_context] 
            }
    
            if { $context ne "" } {
                set application_context [concat $application_context $context]
            } else {
                # Make last entry be just the label
                set application_context [lreplace $application_context end end [lindex $application_context end 1]]
            }
        } else {
            set application_context [list]
        }
    
        if { [llength $application_context] > 0 } {
            set context_bar_context [concat $community_context $application_context]
        } else {
            # We need the last entry in the community context be just the label, so remove
            # the URL
            set community_context_last [lindex $community_context end]
            set community_context_last_label [lindex $community_context_last 1]
    
            if { [llength $community_context] == 1} {
                set context_bar_context [list $community_context_last_label]
            } else {
                set community_context_before_last [lrange $community_context 0 end-1]
                set context_bar_context [concat $community_context_before_last [list $community_context_last_label]]
            }
        }
       
        return [dotlrn::raw_navbar $context_bar_context]
    }

    ad_proc -public navbar {
        { -community_id "" }
        { -community_type "" }
        args
    } {
        Creates a Navigation Bar for dotLRN
    } {
        # Fetch community_id and community_type if they're not there
        if {$community_id eq "" && $community_type eq ""} {
            set community_id [dotlrn_community::get_community_id]
            set community_type [dotlrn_community::get_community_type]
        }

        if {$community_id ne ""} {
            set community_type [dotlrn_community::get_community_type_from_community_id $community_id]
        }

        set first_args []
        lappend first_args [list [get_url] dotLRN]

        if {$community_type eq "dotlrn_class_instance"} {
            lappend first_args [list [dotlrn_community::get_community_type_url $community_type] [parameter::get -localize -parameter classes_pretty_plural]]
        } elseif {$community_type eq "dotlrn_club"} {
            lappend first_args [list [dotlrn_community::get_community_type_url $community_type] [parameter::get -localize -parameter clubs_pretty_plural]]
        } elseif {$community_type eq "dotlrn_community"} {
        } else {
            lappend first_args [list [dotlrn_community::get_community_type_url $community_type] [dotlrn_community::get_community_type_name $community_type]]
        }

        if {$community_id ne ""} {
            lappend first_args [list [dotlrn_community::get_community_url $community_id] [dotlrn_community::get_community_name $community_id]]
        }

        return [raw_navbar [concat $first_args $args]]
    }

    ad_proc -public raw_navbar {
        list_of_args
    } {
        do the raw navbar thing (both for admin and such)
    } {
        set args $list_of_args
        set list_of_links [list]
        set total_n_args [llength $args]
        set count 0

        foreach arg $args {
            incr count
            if {$count < $total_n_args && [llength $arg] == 2 } {
                lappend list_of_links "<a href=\"[lindex $arg 0]\">[lindex $arg 1]</a>"
            } else {
                lappend list_of_links "$arg"
            }
        }

        return "[join $list_of_links " : "]<br>"
    }

    ad_proc -public portal_navbar {
        {-user_id:required}
        {-link_control_panel:required}
        {-control_panel_text:required}
	{-link_all 0}
        {-pre_html ""}
        {-post_html ""}
    } {
        A helper procedure that generates the PORTAL navbar (the thing
        with the portal pages on it) for dotlrn. It is called from the
        dotlrn-master template
    } {

	set navbar "<div id=main-navigation><ul>"
        set dotlrn_url [dotlrn::get_url]
        set community_id [dotlrn_community::get_community_id]
        set control_panel_name control-panel
	set control_panel_url "$dotlrn_url/$control_panel_name"
           
        if {$community_id eq ""} {
            # We are not under a dotlrn community. However we could be
            # under /dotlrn (i.e. in the user's portal) or anywhere
            # else on the site
            set link "[dotlrn::get_url]/"
            
            if {[dotlrn::user_p -user_id $user_id]} {
                # this user is a dotlrn user, show their personal portal
                # navbar, including the control panel link
                set portal_id [dotlrn::get_portal_id -user_id $user_id]
                set show_control_panel 1
            } else {
                # not a dotlrn user, so no user portal to show
                set portal_id {}
                set show_control_panel 0
            }

        } else {
            #
            # We are under a dotlrn community. Get the community's portal_id, etc.
            #
            
            # some defaults
            set text [dotlrn_community::get_community_header_name $community_id] 
            set control_panel_name one-community-admin
            set link [dotlrn_community::get_community_url $community_id]
	    set control_panel_url "$link/$control_panel_name"

            if { ![parameter::get -parameter hide_personal_portal_p -package_id [dotlrn::get_package_id] -default 0] } {
                # add the my space tab, which isn't part of the class portal but is super useful for the end user
                append navbar "<li><a href=\"$dotlrn_url\">#dotlrn.user_portal_page_home_title#</a></li>"
            }

            # figure out what this privs this user has on the community
            set admin_p [dotlrn::user_can_admin_community_p \
                -user_id $user_id \
                -community_id $community_id
            ]
        
            if {!$admin_p} {
                # the user can't admin this community, perhaps they are a
                # humble member instead?
                set member_p [dotlrn_community::member_p $community_id $user_id]
                set show_control_panel 0
            } else {
                # admins always get the control_panel_link, unless it's
                # explicitly turned off
                set show_control_panel 1
            }
        
            if {$admin_p || $member_p} {
    
                set portal_id [dotlrn_community::get_portal_id \
                    -community_id $community_id
                ]
            } else {
                # show this person the comm's non-member-portal
                set portal_id [dotlrn_community::get_non_member_portal_id \
                    -community_id $community_id
                ]
            }
        }

	#AG: This code belongs in the portal package, near portal::navbar.  For display reasons we need to do this
	#as a ul instead of a table, which portal::navbar returns.  Obviously we shouldn't be letting display-level
	#stuff decide where we put our code, but first we'll need to mod the portal package accordingly.

	set page_num [ns_queryget page_num]
	#Strip out extra anchors and other crud.
	#page_num will be empty_string for special pages like
	#My Space and Control Panel
	regsub -all {[^0-9]} $page_num {} page_num

	db_foreach list_page_nums_select {} {
	    if { ("$dotlrn_url/" == [ad_conn url] || "$dotlrn_url/index" == [ad_conn url]) && $sort_key == 0 && $page_num eq ""} {
		# active tab is  first tab and page_num may be ""
		append navbar "<li class=\"current\"><a href=\"#\">$pretty_name</a></li>"
	     } elseif {$page_num == $sort_key} {
		 # We are looking at the active tab
		 append navbar "<li class=\"current\"><a href=\"#\">$pretty_name</a></li>"
	     } else {
		 append navbar "<li><a href=\"$link?page_num=$sort_key\">$pretty_name</a> </li>"
	     }
	 }

        #
        # Common code for the the behavior of the control panel link (class administration
        # or my account)
        #

	 if {$show_control_panel} {
	     if {$link_control_panel} {
		 append navbar "<li><a href=\"$control_panel_url\">$control_panel_text</a></li>"

	     } else {
		 append navbar "<li class=\"current\"><a href=\"#\">$control_panel_text</a></li>"
	     } 
	 }

	append navbar "</ul></div>"

    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
