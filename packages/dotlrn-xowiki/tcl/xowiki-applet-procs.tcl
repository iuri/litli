ad_library {
  Procedures to supports xowiki as an dotlrn applet
  
  @creation-date 2008-02-26
  @author Gustaf Neumann
  @cvs-id $Id: xowiki-applet-procs.tcl,v 1.6.2.1 2017/04/22 12:37:46 gustafn Exp $
}

#
# This is the first approach to make the applets
#
#  (a) in an oo-style (the object below contains everything 
#      for the management of the portlet) and
#  (b) independent from the database layer 
#      (supposed to work under postgres and Oracle)
#
# In the next steps, it would make sense to define a ::dotlrn::Applet
# class, which provides some of the common behavior defined here...
#

Object xowiki_applet
xowiki_applet proc applet_key {} {
  return "dotlrn_xowiki"
}

xowiki_applet proc my_package_key {} {
  return "dotlrn-xowiki"
}

xowiki_applet ad_proc package_key {
} {
  What package do I deal with?
} {
  return "xowiki"
}
    
xowiki_applet ad_proc node_name {
} {
  returns the node name
} {
  return "xowiki"
}

xowiki_applet ad_proc pretty_name {
} {
  returns the pretty name
} {
  return "XoWiki"
}

xowiki_applet ad_proc add_applet {
} {
  One time init - must be repeatable!
} {
  dotlrn_applet::add_applet_to_dotlrn \
      -applet_key [my applet_key] \
      -package_key [my my_package_key]
}

xowiki_applet ad_proc remove_applet {
} {
  One time destroy. 
} {
  ad_return_complaint 1 "[my applet_key] remove_applet not implemented!"
}
    
xowiki_applet ad_proc add_applet_to_community {
  community_id
} {
  Add the xowiki applet to a specifc dotlrn community
} {
  # get the community portal id
  set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

  # get applet id
  set applet_id [dotlrn_applet::get_applet_id_from_key -applet_key [my applet_key]]
  
  # create the package instance
  set package_id [dotlrn::instantiate_and_mount $community_id [my package_key]]

  # set up the admin portlet
  set admin_portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
  xowiki_admin_portlet add_self_to_page \
      -portal_id $admin_portal_id \
      -package_id $package_id
  
  # set up the xowiki portlet for this community
  set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

  return $package_id
}


xowiki_applet ad_proc remove_applet_from_community {
  community_id
} {
  remove the applet from the community
} {
  # get package id
  set package_id [dotlrn_community::get_applet_package_id \
                      -community_id $community_id \
                      -applet_key [my applet_key]]

  set applet_id [dotlrn_applet::get_applet_id_from_key -applet_key [my applet_key]]
  dotlrn::unmount_package -package_id $package_id
  set url "[dotlrn_community::get_community_url $community_id][my node_name]/"
  # delete site node
  if { [site_node::exists_p -url $url] } {
    # get site node of mounted xowiki instance
    set node_id [site_node::get_node_id -url $url]
    # delete site node
    site_node::delete -node_id $node_id
  }
}

xowiki_applet ad_proc add_user {
  user_id
} {
  one time user-specific init
} {
  # noop
}

xowiki_applet ad_proc remove_user {
  user_id
} {
} {
  ad_return_complaint 1 "[my applet_key] remove_user not implemented!"
}

xowiki_applet ad_proc add_user_to_community {
  community_id
  user_id
} {
  Add a user to a specifc dotlrn community
} {
  # nothing happens here
}

xowiki_applet ad_proc remove_user_from_community {
  community_id
  user_id
} {
  Remove a user from a community
} {
  # nothing happens here
}
	
xowiki_applet ad_proc add_portlet {
  portal_id
} {
  A helper proc to add the underlying portlet to the given portal. 
  
  @param portal_id
} {
  # simple, no type specific stuff, just set some dummy values

  # nothing happens here
}

xowiki_applet ad_proc add_portlet_helper {
  portal_id
  args
} {
  A helper proc to add the underlying portlet to the given portal.
  @param portal_id
} {
  #xowiki_portlet add_self_to_page \
       #	  -portal_id $portal_id \
       #	  -package_id [ns_set get $args "package_id"] \
       #	  -param_action [ns_set get $args "param_action"]
}
    
xowiki_applet ad_proc remove_portlet {
  portal_id
  args
} {
  A helper proc to remove the underlying portlet from the given portal. 
  
  @param portal_id
  @param args A list of key-value pairs (possibly user_id, community_id, and more)
} { 
#     	xowiki_portlet remove_self_from_page \
#             -portal_id $portal_id \
#             -package_id [ns_set get $args "package_id"] 
}

xowiki_applet ad_proc clone {
  old_community_id
  new_community_id
} {
  Clone this applet's content from the old community to the new one
} {
  #ns_log notice "Cloning: [my applet_key]"
  #set new_package_id [my add_applet_to_community $new_community_id]
  #set old_package_id [dotlrn_community::get_applet_package_id \
  #                        -community_id $old_community_id \
  #                        -applet_key [my applet_key] \
  #                   ]
  #db_exec_plsql clone_data {}
  #return $new_package_id
}

xowiki_applet ad_proc change_event_handler {
  community_id
  event
  old_value
  new_value
} { 
  listens for the following events: 
} { 
  #; nothing
}   

xowiki_applet proc install {} {
  set name [my applet_key]
  db_transaction {
    
    # register the applet implementation
    ::xo::db::sql::acs_sc_impl new \
        -impl_contract_name "dotlrn_applet" -impl_name $name \
        -impl_pretty_name "" -impl_owner_name $name

    # add the operations

    foreach {operation call} {
      GetPrettyName 	        "xowiki_applet pretty_name"
      AddApplet                 "xowiki_applet add_applet"
      RemoveApplet              "xowiki_applet remove_applet"
      AddAppletToCommunity      "xowiki_applet add_applet_to_community"
      RemoveAppletFromCommunity "xowiki_applet remove_applet_from_community"
      AddUser                   "xowiki_applet add_user"
      RemoveUser                "xowiki_applet remove_user"
      AddUserToCommunity        "xowiki_applet add_user_to_community"
      RemoveUserFromCommunity   "xowiki_applet remove_user_from_community"
      AddPortlet                "xowiki_applet add_portlet"
      RemovePortlet             "xowiki_applet remove_portlet"
      Clone                     "xowiki_applet clone"
      ChangeEventHandler        "xowiki_applet change_event_handler"
    } {
      ::xo::db::sql::acs_sc_impl_alias new \
          -impl_contract_name "dotlrn_applet" -impl_name $name  \
          -impl_operation_name $operation -impl_alias $call \
          -impl_pl "TCL"
    }

    # Add the binding
    ::xo::db::sql::acs_sc_binding new \
        -contract_name "dotlrn_applet" -impl_name $name
  }
}

xowiki_applet proc uninstall {} {
  my log "--applet calling [self proc]"
  #
  # pretty similar "xowiki_portlet uninstall"
  #
  set name [my applet_key]

  db_transaction {
    #
    #  drop the operation
    #
    foreach operation {
      GetPrettyName
      AddApplet
      RemoveApplet
      AddAppletToCommunity
      RemoveAppletFromCommunity
      AddUser
      RemoveUser
      AddUserToCommunity
      RemoveUserFromCommunity
      AddPortlet
      RemovePortlet
      Clone
    } {
      ::xo::db::sql::acs_sc_impl_alias delete \
          -impl_contract_name "dotlrn_applet" -impl_name $name \
          -impl_operation_name $operation
    }

    #
    #  drop the binding
    #
    ::xo::db::sql::acs_sc_binding delete \
        -contract_name "dotlrn_applet" -impl_name $name

    #
    #  drop the implementation
    #
    ::xo::db::sql::acs_sc_impl delete \
        -impl_contract_name "dotlrn_applet" -impl_name $name 

    xo::dc dml delete_applet "delete from dotlrn_applets where applet_key = :name"

  }
  my log "--applet end of [self proc]"
}

::xowiki_applet proc after-install {} {
  ::xowiki_applet install
}

::xowiki_applet proc before-uninstall {} {
  ::xowiki_applet uninstall
}

