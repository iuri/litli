# Set the tabs then use the plain master to render the page.

subsite_navigation::define_pageflow -navigation_multirow navigation -group main -subgroup sub -include_all \
    -show_applications_p [parameter::get -package_id [ad_conn subsite_id] -parameter ShowApplications -default 1] \
    -no_tab_application_list [parameter::get -package_id [ad_conn subsite_id] -parameter NoTabApplicationList -default ""] \
    -initial_pageflow [parameter::get -package_id [ad_conn subsite_id] -parameter UserNavbarTabsList -default ""]
    
set subsite_logo "/resources/openacs-bootstrap3-theme/images/logo_dotlrn_xs.png"
set streaming_head 1

if {![info exists subsite_link]} {
    set subsite_link "/"
}

set doc(title) $title
ad_context_bar_multirow -- $context

