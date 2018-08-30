set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set dotlrn_package_id [dotlrn::get_package_id]

if {$community_id ne ""} {
    set dotlrn_master [dotlrn_community::get_dotlrn_master -community_id $community_id]
} elseif {$user_id } {
    set dotlrn_master [dotlrn::get_dotlrn_master -user_id $user_id]
} else {    
    set dotlrn_master  [parameter::get -package_id $dotlrn_package_id -parameter "DefaultMaster_p" \
			    -default "/packages/dotlrn/www/dotlrn-master"]
}

# Set page title
if { ![info exists doc(title)] && [info exists title] && $title ne "" } {
    set doc(title) $title
} elseif { [info exists doc(title)] && ![info exists title] || $title eq "" } {
    set title $doc(title)
} elseif { ![info exists doc(title)] && [info exists title] && $title ne "" } {
    set title [ad_system_name]
    set doc(title) $title
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
