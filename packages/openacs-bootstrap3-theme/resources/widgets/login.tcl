set user_id [ad_conn user_id]
set untrusted_user_id [ad_conn untrusted_user_id]
if {[catch {
   set user_name [person::name -person_id $untrusted_user_id]
} errorMsg]} {
   ns_log notice "Cannot determine user_name for user-id $untrusted_user_id"
   set use_name "Unknown"
}
set system_name [ad_system_name]

# User Portrait
set portrait_id [acs_user::get_portrait_id -user_id $user_id]
if {$portrait_id == 0} {
    set email [party::email -party_id $user_id]
    if {[info commands ns_md5] ne ""} {
	set md5 [string tolower [ns_md5 $email]]
    } else {
	package require md5
	set md5 [string tolower [md5::Hex [md5::md5 -- $email]]]
    }
    set src //www.gravatar.com/avatar/$md5?size=35&d=mm
    security::csp::require img-src www.gravatar.com
} else {
    set src [export_vars -base /shared/portrait-bits.tcl {user_id {size x50}}]
}
set photo "<img width='35' height='35' class='photo' src='[ns_quotehtml $src]'>"

# Who's Online
set num_users_online [lc_numeric [whos_online::num_users]]
set whos_online_url "[subsite::get_element -element url]shared/whos-online"

set return_url [ad_return_url]
if {!$user_id} {
    set login_p 0
    set login_url [export_vars -base /register/ return_url]
    set register_url [export_vars -base /register/user-new return_url]
} else {
    set login_p 1
    acs_user::get -user_id $user_id -array user
    # set name "$user(first_names) $user(last_name)"
    set name "$user(first_names)"
}

