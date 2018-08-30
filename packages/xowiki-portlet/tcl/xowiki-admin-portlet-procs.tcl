ad_library {
  Procedures to supports xowiki admin portlets.
  
  @creation-date 2008-02-26
  @author Gustaf Neumann
  @cvs-id $Id: xowiki-admin-portlet-procs.tcl,v 1.3 2008/04/24 08:38:30 gustafn Exp $
}

#
# This is the first approach to make the portlet-procs 
#
#  (a) in an oo-style (the object below contains everything 
#      for the management of the portlet) and
#  (b) independent from the database layer 
#      (supposed to work under postgres and Oracle)
#
# In the next steps, it would make sense to define a ::dotlrn::Portlet
# class, which provides some of the the common behaviour defined here...
#
Object xowiki_admin_portlet
xowiki_admin_portlet proc name {} {
  return "xowiki-admin-portlet"
}

xowiki_admin_portlet proc pretty_name {} {
  return [parameter::get_from_package_key \
              -package_key [my package_key] \
              -parameter xowiki_admin_portlet_pretty_name]
}

xowiki_admin_portlet proc package_key {} {
  return "xowiki-portlet"
}

xowiki_admin_portlet proc link {} {
  return ""
}

xowiki_admin_portlet ad_proc add_self_to_page {
  {-portal_id:required}
  {-package_id:required}
} {
  Adds a xowiki admin PE to the given portal
} {
  return [portal::add_element_parameters \
              -portal_id $portal_id \
              -portlet_name [my name] \
              -key package_id \
              -value $package_id \
             ]
  ns_log notice "end of add_self_to_page"
}

xowiki_admin_portlet ad_proc remove_self_from_page {
  {-portal_id:required}
} {
  Removes xowiki admin PE from the given page
} {
  # This is easy since there's one and only one instace_id
  portal::remove_element \
      -portal_id $portal_id \
      -portlet_name [my name]
}

xowiki_admin_portlet ad_proc show {
  cf
} {
  Display the xowiki admin PE
} {
  portal::show_proc_helper \
      -package_key [my package_key] \
      -config_list $cf \
      -template_src "xowiki-admin-portlet"
}

xowiki_admin_portlet proc install {} {
  my log "--portlet calling [self proc]"
  set name [my name]
  db_transaction {

    #
    # create the datasource
    #
    set ds_id [::xo::db::sql::portal_datasource new -name $name \
                   -css_dir "" \
                   -description "Displays the admin interface for the xowiki data portlets"]
    
    # default configuration
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "shadeable_p" -value f
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "shaded_p" -value f
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "hideable_p" -value t
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "user_editable_p" -value f
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "link_hideable_p" -value t
    
    # xowiki-admin-specific procs
    
    # package_id must be configured
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p f \
        -key "package_id" -value ""
    
    
    #
    # service contract managemet
    #
    # create the implementation
    ::xo::db::sql::acs_sc_impl new \
        -impl_contract_name "portal_datasource" -impl_name $name \
        -impl_pretty_name "" -impl_owner_name $name
    
    # add the operations
    foreach {operation call} {
      GetMyName     	"xowiki_admin_portlet name"
      GetPrettyName 	"xowiki_admin_portlet pretty_name"
      Link          	"xowiki_admin_portlet link"
      AddSelfToPage 	"xowiki_admin_portlet add_self_to_page"
      Show          	"xowiki_admin_portlet show"
      Edit          	"xowiki_admin_portlet edit"
      RemoveSelfFromPage	"xowiki_admin_portlet remove_self_from_page"
    } {
      ::xo::db::sql::acs_sc_impl_alias new \
          -impl_contract_name "portal_datasource" -impl_name $name  \
          -impl_operation_name $operation -impl_alias $call \
          -impl_pl "TCL"
    }
    
    # Add the binding
    ::xo::db::sql::acs_sc_binding new \
        -contract_name "portal_datasource" -impl_name $name
  }
  my log "--portlet end of [self proc]"
}

xowiki_admin_portlet proc uninstall {} {
  my log "--portlet calling [self proc]"
  #
  # completely identical to "xowiki_portlet uninstall"
  #
  set name [my name]
  db_transaction {

    # 
    # get the datasource
    #
    set ds_id [db_string dbqd..get_ds_id {
      select datasource_id from portal_datasources where name = :name
    } -default "0"]
    
    if {$ds_id != 0} {
      #
      # drop the datasource
      #
      ::xo::db::sql::portal_datasource delete -datasource_id $ds_id
      #
    } else {
      ns_log notice "No datasource id found for $name"
    }

    #  drop the operations
    #
    foreach operation {
      GetMyName GetPrettyName Link AddSelfToPage 
      Show Edit RemoveSelfFromPage
    } {
      ::xo::db::sql::acs_sc_impl_alias delete \
          -impl_contract_name "portal_datasource" -impl_name $name \
          -impl_operation_name $operation
    }
    #
    #  drop the binding
    #
    ::xo::db::sql::acs_sc_binding delete \
        -contract_name "portal_datasource" -impl_name $name
    #
    #  drop the implementation
    #
    ::xo::db::sql::acs_sc_impl delete \
        -impl_contract_name "portal_datasource" -impl_name $name 
  }  
  my log "--portlet end of [self proc]"
}
  



