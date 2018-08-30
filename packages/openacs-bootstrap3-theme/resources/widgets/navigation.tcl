# Organize standard top level navigation, if any, for output by groups (rows of
# horizontal tabs by default)
#
set subsite_name [lang::util::localize [subsite::get_element -element instance_name]]

if { [template::multirow exists navigation] } {
    set selected_main_nav_item ""
    if { ![info exists navigation_groups] } {
        set navigation_groups [list]
    }
    for {set i 1} {$i <= [template::multirow size navigation]} {incr i} {
        template::multirow get navigation $i
        if {$navigation(group) ni $navigation_groups} {
            lappend navigation_groups $navigation(group)
        }
        if {$navigation(id) ne "" && $navigation(group) eq "main"} {
            set selected_main_nav_item $navigation(name)
            # ns_log notice "set selected_main_nav_item <$selected_main_nav_item>"
        }
    }
}

#for {set i 1} {$i <= [template::multirow size navigation]} {incr i} {
#    template::multirow get navigation $i
#    ns_log notice [array get navigation]
#}
array set submenus [list]
for {set i 1} {$i <= [template::multirow size navigation]} {incr i} {
    template::multirow get navigation $i
    if {$navigation(display_template) ne ""} {
        set template_code [template::adp_compile -string $navigation(display_template)]
        set item_html [template::adp_eval template_code]
        set navigation(display_template) $item_html
    } else {
        set item_html "<li><a href='$navigation(href)'>[ns_quotehtml $navigation(label)]</a></li>"
    }
    set nav_parent $navigation(parent)
    if {$nav_parent ne ""} {
	if {[info exists submenus($nav_parent)]} {
	    set submenus($nav_parent) "$submenus($nav_parent) $item_html"
	} else {
	    set submenus($nav_parent) ""
	}
    }
}

template::multirow extend navigation submenu
template::multirow foreach navigation {
    if {[info exists submenus($name)]} {
	set submenu $submenus($name)
    }
}
