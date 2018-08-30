namespace eval openacs_bootstrap3_theme {}
namespace eval openacs_bootstrap3_theme::apm {}

ad_proc openacs_bootstrap3_theme::apm::after_install {} {
    Package after installation callback proc.  Add our themes, and set the acs-subsite's
    default master template parameter's default value to our "plain" theme.
} {

    # Insert this package's themes
    db_transaction {

        subsite::new_subsite_theme \
            -key openacs_bootstrap3 \
            -name #openacs-bootstrap3-theme.tabbed# \
            -template tabbed-master \
            -css {
{-href /resources/acs-subsite/site-master.css -media all -order 0}
{-href //maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css -media all -order 1}
{-href /resources/openacs-bootstrap3-theme/css/main.css -media all -order 2}
{-href /resources/openacs-bootstrap3-theme/css/color/blue.css -media all -order 3}
{-href /resources/acs-templating/forms.css -media all -order 4}
{-href /resources/acs-templating/lists.css -media all -order 5}
            } \
            -js {
{-src "/resources/openacs-bootstrap3-theme/js/jquery-1.11.3.min.js" -order 1}
{-src "//maxcdn.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" -order 2}
            } \
            -form_template standard \
            -list_template table \
            -list_filter_template filters \
            -dimensional_template dimensional \
            -resource_dir /packages/openacs-bootstrap3-theme/resources \
            -streaming_head tabbed-streaming-head \
            
         subsite::new_subsite_theme \
            -key openacs_bootstrap3_turquois \
            -name #openacs-bootstrap3-theme.tabbed-turquois# \
            -template tabbed-master-turquois \
            -css {
{-href /resources/acs-subsite/site-master.css -media all -order 0}
{-href //maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css -media all -order 1}
{-href /resources/openacs-bootstrap3-theme/css/main.css -media all -order 2}
{-href /resources/openacs-bootstrap3-theme/css/color/turquois.css -media all -order 3}
{-href /resources/acs-templating/forms.css -media all -order 4}
{-href /resources/acs-templating/lists.css -media all -order 5}
            } \
            -js {
{-src "/resources/openacs-bootstrap3-theme/js/jquery-1.11.3.min.js" -order 1}
{-src "//maxcdn.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" -order 2}
            } \
            -form_template standard \
            -list_template table \
            -list_filter_template filters \
            -dimensional_template dimensional \
            -resource_dir /packages/openacs-bootstrap3-theme/resources \
            -streaming_head tabbed-streaming-head-turquois \
    }
}

ad_proc -public openacs_bootstrap3_theme::apm::before_uninstall {} {
    Uninstall the package
} {
    if {[subsite::get_theme] in {openacs_bootstrap3 openacs_bootstrap3_turquois}} {
        subsite::set_theme -theme default_plain
    }
    subsite::delete_subsite_theme -key openacs_bootstrap3
    subsite::delete_subsite_theme -key openacs_bootstrap3_turquois
}

