ad_page_contract {

    OpenACS.org  plain master, bootstrap3 flavor

    @author modified by Patrick Colgan pat pat@museatech.net
    @author modified by Ola Hansson ola@polyxena.net
    @author modified by Monika Andergassen manderga@wu.ac.at
    @creation-date 9/6/2001


} {
    { email "" }
} -properties {
    form_vars:onevalue
    allow_persistent_login_p:onevalue
    remember_password:onevalue
    name:onevalue
    first_names:onevalue
    email:onevalue
    home_url:onevalue
    home_url_name:onevalue
    oacs_admin_p:onevalue
    pkid:onevalue
}

set pkid [ad_conn package_id]

if {![info exists title]}     { set title     [ad_system_name]   }
if {![info exists signatory]} { set signatory [ad_system_owner] }

if {![info exists subsite_link]} {
    set subsite_link "/"
}

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
     && [ad_graphics_site_available_p] } {
  template::multirow append attribute background \
    [parameter::get -package_id $pkg_id -parameter background -default "/graphics/bg.gif"]
}

# User messages
util_get_user_messages -multirow user_messages

#
# Security settings
#
set csrf [security::csrf::new]

security::csp::require img-src ipv6-test.com

security::csp::require style-src maxcdn.bootstrapcdn.com
security::csp::require script-src maxcdn.bootstrapcdn.com

security::csp::require font-src 'self'
security::csp::require font-src maxcdn.bootstrapcdn.com

