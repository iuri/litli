
set streaming_head 1
set subsite_logo "/resources/openacs-bootstrap3-theme/images/logo_dotlrn_xs.png"

if {![info exists subsite_link]} {
    set subsite_link "/"
}

if {![info exists doc(title)]} {
    set doc(title) [ad_system_name]
}
if {[info exists context]} {
    set context_bar [ad_context_bar {*}$context]
}


###########################
# dotLRN stuff            #
###########################

# $Id: dotlrn-streaming-head.tcl,v 1.1.2.1 2017/02/22 12:58:34 gustafn Exp $

set user_id [ad_conn user_id] 
set untrusted_user_id [ad_conn untrusted_user_id]
set community_id [dotlrn_community::get_community_id]
set dotlrn_url [dotlrn::get_url]

set sitemap_url "$dotlrn_url/site-map"

if {[dotlrn::user_p -user_id $user_id]} {
    set portal_id [dotlrn::get_portal_id -user_id $user_id]
}

if {![info exists link_all]} {
    set link_all 0
}

if {![info exists return_url]} {
    set link [ad_conn -get extra_url]
} else {
    set link $return_url
}

if { [ad_conn package_key] ne [dotlrn::package_key] } {
    # Peter M: We are in a package (an application) that may or may not be under a dotlrn instance 
    # (i.e. in a news instance of a class)
    # and we want all links in the navbar to be active so the user can return easily to the class homepage
    # or to the My Space page
    set link_all 1
}

set control_panel_text [_ acs-subsite.Admin]

# Set dotlrn navbar
if { !([info exists no_navbar_p] && $no_navbar_p ne "" && $no_navbar_p)
     && [info exists portal_id] && $portal_id ne "" } {
    if { $community_id ne "" } {
        set youarehere "[dotlrn_community::get_community_name $community_id]"
    } else {
        set youarehere "[_ theme-zen.MySpace]"
    }

    set extra_spaces "<img src=\"/resources/dotlrn/spacer.gif\" alt=\"\" border='0' width='15'>"    
    set dotlrn_navbar [zen::portal_navbar]
    set dotlrn_subnavbar [zen::portal_subnavbar \
			      -user_id $user_id \
			      -control_panel_text $control_panel_text \
			      -pre_html "$extra_spaces" \
			      -post_html $extra_spaces \
			      -link_all $link_all
			 ]
} else {
    set dotlrn_navbar ""
    set dotlrn_subnavbar ""
}



###########################
# END dotLRN stuff        #
###########################

template::head::add_meta \
    -name "viewport" \
    -content "width=device-width, initial-scale=1"
template::head::add_meta \
    -content "text/css" \
    -http_equiv "content-style-type"

if {[info exists context]}      { set context_bar [ad_context_bar {*}$context]}
if {![info exists context_bar]} { set context_bar [ad_context_bar] }

# clean out title and context bar for index page.
if {[ad_conn url] eq "/" || [string match /index* [ad_conn url]] || [ad_conn url] eq "/community/"} { 
    set context_bar {} 
    set notitle 1
}

# stuff that is in the stock default-master

template::multirow create attribute key value

# Pull out the package_id of the subsite closest to our current node
set pkg_id [site_node::closest_ancestor_package -package_key "acs-subsite"]

template::multirow append \
    attribute bgcolor [parameter::get -package_id $pkg_id -parameter bgcolor   -default "white"]
template::multirow append \
    attribute text    [parameter::get -package_id $pkg_id -parameter textcolor -default "black"]

if { [info exists prefer_text_only_p]
     && $prefer_text_only_p == "f"
     && [ad_graphics_site_available_p]
 } {
    template::multirow append attribute background \
	[parameter::get -package_id $pkg_id -parameter background -default "/graphics/bg.gif"]
}

# User messages
util_get_user_messages -multirow user_messages

#
# Security setup
#
set csrf [security::csrf::new]

security::csp::require style-src maxcdn.bootstrapcdn.com
security::csp::require script-src maxcdn.bootstrapcdn.com
security::csp::require font-src maxcdn.bootstrapcdn.com
