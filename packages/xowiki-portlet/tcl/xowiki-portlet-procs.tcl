ad_library {
  Procedures to supports xowiki portlets.
  
  @creation-date 2008-02-26
  @author Gustaf Neumann
  @cvs-id $Id: xowiki-portlet-procs.tcl,v 1.3 2008/04/24 08:38:30 gustafn Exp $
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
# class, which provides some of the common behaviour defined here...
#

Object xowiki_portlet
xowiki_portlet proc name {} {
  return "xowiki-portlet"
}

xowiki_portlet proc pretty_name {} {
  return ""
}

xowiki_portlet proc package_key {} {
  return "xowiki-portlet"
}

xowiki_portlet proc link {} {
  return ""
}

xowiki_portlet ad_proc add_self_to_page {
  {-portal_id:required}
  {-package_id:required}
} {
  Adds a PE to the given page
} {
  ns_log notice "xowiki_portlet::add_self_to_page - Don't call me. "
  error "don't call me"
}

xowiki_portlet ad_proc remove_self_from_page {
  portal_id
  element_id
} {
  Removes PE from the given page
} {
  # This is easy since there's one and only one instace_id
  portal::remove_element $element_id
}

xowiki_portlet ad_proc show {cf} {
} {
  portal::show_proc_helper \
      -package_key [my package_key] \
      -config_list $cf \
      -template_src "xowiki-portlet"
}

#
# install
#
xowiki_portlet proc install {} {
  my log "--portlet calling [self proc]"
  set name [my name]
  #
  # create the datasource
  #
  db_transaction {
    set ds_id [::xo::db::sql::portal_datasource new -name $name \
                   -css_dir "" \
                   -description "Displays an xowiki page as a portlet"]
    
    # default configuration
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "shadeable_p" -value t
    
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
    
    # xowiki-specific configuration
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p f \
        -key "package_id" -value ""
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
      -config_required_p t -configured_p f \
	-key "page_name" -value ""
    
    #
    # service contract managemet
    #
    # create the implementation
    ::xo::db::sql::acs_sc_impl new \
        -impl_contract_name "portal_datasource" -impl_name $name \
        -impl_pretty_name "" -impl_owner_name $name
    
    # add the operations
    foreach {operation call} {
      GetMyName     	"xowiki_portlet name"
      GetPrettyName 	"xowiki_portlet pretty_name"
      Link          	"xowiki_portlet link"
      AddSelfToPage 	"xowiki_portlet add_self_to_page"
      Show          	"xowiki_portlet show"
      Edit          	"xowiki_portlet edit"
      RemoveSelfFromPage	"xowiki_portlet remove_self_from_page"
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

#
# uninstall
#

xowiki_portlet proc uninstall {} {
  my log "--portlet calling [self proc]"
  #
  # completely identical to "xowiki_admin_portlet uninstall"
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

    #
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

::xowiki_portlet proc after-install {} {
  ::xowiki_portlet install
  ::xowiki_admin_portlet install
}

::xowiki_portlet proc before-uninstall {} {
  ::xowiki_portlet uninstall
  ::xowiki_admin_portlet uninstall
}