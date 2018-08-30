::xo::library doc {
  XoWiki - Callback procs

  @creation-date 2006-08-08
  @author Gustaf Neumann
  @cvs-id $Id: xowf-calllback-procs.tcl,v 1.2.2.2 2017/07/01 11:48:31 gustafn Exp $
}

namespace eval ::xowf {

  ad_proc -private after-instantiate {-package_id:required } {
    Callback when this an xowf instance is created
  } {
    ns_log notice "++++ BEGIN ::xowf::after-instantiate -package_id $package_id"
    # General setup
    ::xo::Package initialize -package_id $package_id
    set folder_id [::$package_id folder_id]
    
    #
    # Create a parameter page for conveniance
    #
    set pform_id [::xowiki::Weblog instantiate_forms -forms en:Parameter.form \
                      -package_id $package_id]

    ::xo::db::sql::content_item set_live_revision \
        -revision_id [$pform_id revision_id] \
        -publish_status production

    set ia {
      MenuBar t top_includelet none production_mode t with_user_tracking t with_general_comments f
      with_digg f with_tags f
      ExtraMenuEntries {{entry -name New.Extra.Workflow -label "#xowf.menu-New-Extra-Workflow#" -form /en:Workflow.form}}
      with_delicious f with_notifications f security_policy ::xowiki::policy1
    }
    
    set parameter_page_name en:xowf-default-parameter
    set p [$pform_id create_form_page_instance \
               -name $parameter_page_name \
               -nls_language en_US \
               -default_variables [list title "XoWf Default Parameter" parent_id $folder_id \
                                       package_id $package_id instance_attributes $ia]]
    $p save_new

    #
    # Make the paramter page the default
    #
    parameter::set_value -package_id $package_id -parameter parameter_page -value $parameter_page_name
    callback subsite::parameter_changed -package_id $package_id -parameter parameter_page -value $parameter_page_name

    ns_log notice "++++ END ::xowf::after-instantiate -package_id $package_id"
  }
}

#
# Local variables:
#    mode: tcl
#    tcl-indent-level: 2
#    indent-tabs-mode: nil
# End:
