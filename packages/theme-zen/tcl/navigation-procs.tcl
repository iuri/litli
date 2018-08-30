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

    Zen.

    @author Jeremy Monnet (jmonnet@gmail.com)
    @creation-date June 2005
    @cvs-id $Id: navigation-procs.tcl,v 1.6.2.2 2017/06/30 17:58:48 gustafn Exp $

}

# DRB: This needs to be cleaned up to return multirows rather than includee HTML
# in Tcl.

namespace eval zen {

    ad_proc -public portal_navbar {
        
    } {
        A helper procedure that generates the Navbar, ie the tabs,
        for dotlrn. It is called from the zen-master template.
    } {
        set current_url [ad_conn url]
        set dotlrn_url [dotlrn::get_url]

        # Set up some basic stuff
        set community_id [dotlrn_community::get_community_id]

        # Get user information
        set sw_admin_p 0
        set dotlrn_admin_p 0
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
        if { $untrusted_user_id != 0 } {
            set user_name [person::name -person_id $untrusted_user_id]
            set pvt_home_url [ad_pvt_home]
            set pvt_home_name [_ acs-subsite.Your_Account]
            set logout_url [ad_get_logout_url]
            
            # Site-wide admin link
            set admin_url {}
            set dotlrn_admin_url ""
            
            set sw_admin_p [acs_user::site_wide_admin_p -user_id $untrusted_user_id]
            set dotlrn_admin_p [permission::permission_p \
                                   -party_id $user_id \
                                   -object_id [dotlrn::get_package_id] \
                                   -privilege admin]
            if { $dotlrn_admin_p } {
                set dotlrn_admin_url [dotlrn::get_admin_url]
            }
            
            if { $sw_admin_p } {
                set admin_url "/acs-admin/"
                set locale_admin_url "/acs-lang/admin"
            } else {
                set subsite_admin_p [permission::permission_p \
                                         -object_id [subsite::get_element -element object_id] \
                                         -privilege admin \
                                         -party_id $untrusted_user_id]
                
                if { $subsite_admin_p  } {
                    set admin_url "[subsite::get_element -element url]admin/"
                }
            }
        } else {
            set login_url [ad_get_login_url -return]
            set user_name {}
        }
        
        set navbar "<ul>"

        set tabs_list [list]
        set which_tab_selected -1
        set which_tab 0
        set home_tab -1

        foreach {url name accesskey} [parameter::get_from_package_key -package_key "theme-zen" -parameter "AdditionalNavbarTabs" -default ""] {
            lappend tabs_list [list $url $name $accesskey]
            if { $current_url == $url ||
                 $current_url == "$dotlrn_url/index" && $name eq "#dotlrn.Home#" } {
                set which_tab_selected $which_tab
            }
            if { $name eq "#dotlrn.Home#" } {
                set home_tab $which_tab
            }
            incr which_tab
        }

        if { $dotlrn_admin_p } {
            lappend tabs_list [list $dotlrn_admin_url #dotlrn.Administration# 9]
            if { [string first $dotlrn_admin_url $current_url] != -1 } {
                set which_tab_selected $which_tab
            }
            incr which_tab
        }

        if { $community_id ne "" } {
            set type [dotlrn_community::get_community_type_from_community_id $community_id]
            if { $type eq "dotlrn_community" || $type eq "dotlrn_pers_community" } {
                 set community_message_key "#dotlrn.subcommunities_pretty_name#"
                 set community_access_key #dotlrn.subcommunities_access_key#
            } elseif { $type eq "dotlrn_club" } {
                 set community_message_key "#dotlrn.clubs_pretty_name#"
                 set community_access_key #dotlrn.club_access_key#
            } else {
                 set community_message_key "#dotlrn.dotlrn_class_instance_pretty_name#"
                 set community_access_key #dotlrn.dotlrn_class_instance_access_key#
            }

                if { ![parameter::get_from_package_key -package_key "theme-zen" -parameter "GenericCommunityTab" -default "0"] } {
                        # show title of the community instead of community type
                        # pretty name
                        set community_message_key [dotlrn_community::get_community_name $community_id]
                } 

            lappend tabs_list [list [dotlrn_community::get_community_url $community_id] $community_message_key $community_access_key]
            set which_tab_selected $which_tab
            incr which_tab
        } 

        # DRB: If we haven't found a tab to select, use the previous value if one
        # exists, otherwise don't select any tab.  Don't write to the database for
        # performance reasons.

        if { $which_tab_selected == -1 } {
            set which_tab_selected [ad_get_client_property dotlrn which_tab_selected]
        } else {
            ad_set_client_property -persistent f dotlrn which_tab_selected $which_tab_selected
        }

        # DRB: Let the subnavbar proc know whether or not the home tab has been selected.

        ad_set_client_property -persistent f dotlrn home_tab_selected_p \
            [expr { $which_tab_selected == $home_tab }]

        ns_log Debug "TABS" $tabs_list

        # DRB: don't understand how the access keys were named in mark's template...

        set which_tab 0
        foreach tab_entry $tabs_list {
            foreach {url name accesskey} $tab_entry {}
	    set localizedName [lang::util::localize $name]
            if { $which_tab == $which_tab_selected } {
                append navbar [subst {
		    <li id="main-navigation-active">
		    <a href="[ns_quotehtml $url]" title="[_ theme-zen.goto_tab_name]" accesskey="$accesskey">$localizedName</a>
		    </li>
		}]
            } else {
                append navbar [subst {
		    <li>
		    <a href="[ns_quotehtml $url]" title="[_ theme-zen.goto_tab_name]" accesskey="$accesskey">$localizedName</a>
		    </li>
		}]
            }
            incr which_tab 
        }
        
        append navbar "\n</ul>"

    }

    ad_proc -public portal_subnavbar {
        {-user_id:required}
        {-control_panel_text:required}
        {-link_all 0}
        {-pre_html ""}
        {-post_html ""}
    } {
        A helper procedure that generates the portal subnavbar (the thing
        with the portal pages on it) for dotlrn. It is called from the
        dotlrn-master template
    } {
                
        set dotlrn_url [dotlrn::get_url]
        set community_id [dotlrn_community::get_community_id]
        set control_panel_name control-panel
        set control_panel_url "$dotlrn_url/$control_panel_name"
           
        if { $community_id eq "" } {
            # We are not under a dotlrn community. However we could be
            # under /dotlrn (i.e. in the user's portal) or anywhere
            # else on the site
            set link "[dotlrn::get_url]/"
            
            if {[dotlrn::user_p -user_id $user_id] &&
                [ad_get_client_property dotlrn home_tab_selected_p] } {
                # this user is a dotlrn user, we've selected the home tab,
                # show their personal portal subnavbar, including the control panel link
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
            # link is important : it sets the options_set value, which will be used later to select the current page
            set link [dotlrn_community::get_community_url $community_id]
            set control_panel_url "$link/$control_panel_name"

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

       #AG: This code belongs in the portal package, near portal::subnavbar.  For display reasons we need to do this
        #as a ul instead of a table, which portal::subnavbar returns.  Obviously we shouldn't be letting display-level
        #stuff decide where we put our code, but first we'll need to mod the portal package accordingly.

        # DRB: the portal navbar stuff should return multirows which are then formatted by
        # the appropriate template, rather than include HTML as it does now.

        if { [catch {set page_num [ad_get_client_property dotlrn page_num]}] || $page_num eq "" || ![string is integer $page_num] } {
            set page_num [ns_queryget page_num]
            #Strip out extra anchors and other crud.
            #page_num will be empty_string for special pages like
            #My Space and Control Panel
            regsub -all {[^0-9]} $page_num {} page_num
        }
        
        
        set subnavbar ""
        db_foreach list_page_nums_select {} {
            if {$page_num eq $sort_key} {
                append subnavbar [subst {
		    <li id="sub-navigation-active">
		    <a href="$link?page_num=$sort_key" title="[_ theme-zen.goto_portal_page_pretty_name]" accesskey="$accesskey">$pretty_name</a>
		    </li>
		}]
            } else {
                append subnavbar [subst {
		    <li>
		    <a href="$link?page_num=$sort_key" title="[_ theme-zen.goto_portal_page_pretty_name]" accesskey="$accesskey">$pretty_name</a>
		    </li>
		}]
            }
         }

        if  { $community_id ne "" && $admin_p } {
            if {[string match "*/one-community-admin*" [ad_conn url]]} {
                append subnavbar [subst {
		    <li id="sub-navigation-active">
		    <a href="${link}one-community-admin" title="[_ theme-zen.goto_admin_page]" accesskey="[_ theme-zen.goto_admin_page_accesskey]">[_ dotlrn.Admin]</a>
		    </li>
		}]
            } else {
                append subnavbar [subst {
		    <li>
		    <a href="${link}one-community-admin" title="[_ theme-zen.goto_admin_page]" accesskey="[_ theme-zen.goto_admin_page_accesskey]">[_ dotlrn.Admin]</a>
		    </li>
		}]
            }
        }

        if { $subnavbar eq "" } {
            return ""
        } else {
            return "<ul>\n$subnavbar\n</ul>\n"
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
