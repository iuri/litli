
set streaming_head 1

if {![info exists subsite_link]} {
    set subsite_link "/"
}

if {![info exists title]}     { set title     [ad_system_name]   }
if {![info exists doc(title)]}     { set doc(title)     $title   }
if {[info exists context]}      { set context_bar [ad_context_bar {*}$context]}

