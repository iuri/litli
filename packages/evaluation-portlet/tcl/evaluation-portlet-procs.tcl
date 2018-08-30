ad_library {

    Procedures to support the evaluation portlets

    @creation-date May 2004
    @author jopez@galileo.edu
    @cvs-id $Id: evaluation-portlet-procs.tcl,v 1.11.2.1 2015/09/12 11:06:10 gustafn Exp $

}

namespace eval evaluation_assignments_portlet {}
namespace eval evaluation_evaluations_portlet {}
namespace eval evaluation_admin_portlet {}


#
# evaluation assignments namespace
#

ad_proc -private evaluation_assignments_portlet::get_my_name {
} {
    return "evaluation_assignments_portlet"
}



ad_proc -private evaluation_assignments_portlet::my_package_key {
} {
    return "evaluation-portlet"
}



ad_proc -public evaluation_assignments_portlet::get_pretty_name {
} {
    return "#evaluation-portlet.Assignments#"
}



ad_proc -public evaluation_assignments_portlet::link {
} {
    return ""
}



ad_proc -public evaluation_assignments_portlet::add_self_to_page {
    {-portal_id:required}
    {-package_id:required}
    {-param_action:required}
    {-force_region ""}
    {-page_name "" }
} {
    Adds a evaluation PE to the given portal.
    
    @param portal_id The page to add self to
    @param package_id The community with the folder
    
    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -value $package_id \
                -force_region $force_region \
		-page_name $page_name \
                -pretty_name [get_pretty_name] \
                -param_action $param_action
           ]
}



ad_proc -public evaluation_assignments_portlet::remove_self_from_page {
    {-portal_id:required}
    {-package_id:required}
} {
    Removes a evaluation PE from the given page or the package_id of the
    evaluation package from the portlet if there are others remaining
    
    @param portal_id The page to remove self from
    @param package_id
} {
    portal::remove_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id
}



ad_proc -public evaluation_assignments_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "evaluation-assignments-portlet"
}


#
# evaluation evaluations namespace
#

ad_proc -private evaluation_evaluations_portlet::get_my_name {
} {
    return "evaluation_evaluations_portlet"
}



ad_proc -private evaluation_evaluations_portlet::my_package_key {
} {
    return "evaluation-portlet"
}



ad_proc -public evaluation_evaluations_portlet::get_pretty_name {
} {
    return "#evaluation-portlet.Evaluations_#"
}



ad_proc -public evaluation_evaluations_portlet::link {
} {
    return ""
}



ad_proc -public evaluation_evaluations_portlet::add_self_to_page {
    {-portal_id:required}
    {-package_id:required}
    {-param_action:required}
    {-force_region ""}
    {-page_name "" }
} {
    Adds a evaluation PE to the given portal.
    
    @param portal_id The page to add self to
    @param package_id The community with the folder
    
    @return element_id The new element's id
} {

    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -value $package_id \
                -force_region $force_region \
		-page_name $page_name \
                -pretty_name [get_pretty_name] \
                -param_action $param_action
           ]
}



ad_proc -public evaluation_evaluations_portlet::remove_self_from_page {
    {-portal_id:required}
    {-package_id:required}
} {
    Removes a evaluation PE from the given page or the package_id of the
    evaluation package from the portlet if there are others remaining
    
    @param portal_id The page to remove self from
    @param package_id
} {
    portal::remove_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id
}



ad_proc -public evaluation_evaluations_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "evaluation-evaluations-portlet"
}

ad_proc -private evaluation_admin_portlet::get_my_name {} {
    return "evaluation_admin_portlet"
}


ad_proc -public evaluation_admin_portlet::get_pretty_name {} {
    return "#evaluation-portlet.lt_Evaluation_Administra#"
}



ad_proc -private evaluation_admin_portlet::my_package_key {} {
    return "evaluation-portlet"
}



ad_proc -public evaluation_admin_portlet::link {} {
    return ""
}



ad_proc -public evaluation_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a evaluation admin PE to the given portal

    @param portal_id The page to add self to
    @param package_id The package_id of the evaluation package

    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}



ad_proc -public evaluation_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a evaluation admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}



ad_proc -public evaluation_admin_portlet::show {
    cf
} {
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "evaluation-admin-portlet"

}



#
# evaluation assignments namespace
#

ad_proc -private evaluation_admin_portlet::get_my_name {} {
    return "evaluation_admin_portlet"
}


ad_proc -public evaluation_admin_portlet::get_pretty_name {} {
    return "#evaluation-portlet.lt_Evaluation_Administra#"
}



ad_proc -private evaluation_admin_portlet::my_package_key {} {
    return "evaluation-portlet"
}



ad_proc -public evaluation_admin_portlet::link {} {
    return ""
}



ad_proc -public evaluation_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a evaluation admin PE to the given portal

    @param portal_id The page to add self to
    @param package_id The package_id of the evaluation package

    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}



ad_proc -public evaluation_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a evaluation admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}



ad_proc -public evaluation_admin_portlet::show {
    cf
} {
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "evaluation-admin-portlet"

}

ad_proc -private evaluation_assignments_portlet::after_install {} {
    Create the datasources needed by the evaluation assignments portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
                   -name "evaluation_assignments_portlet" \
                   -description "#evaluation-portlet.lt_Evaluation_Assignment#"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl

    }
}

ad_proc -private evaluation_assignments_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the evaluation assignments portlet.
} {
    set spec {
        name "evaluation_assignments_portlet"
	contract_name "portal_datasource"
	owner "evaluation-portlet"
        aliases {
	    GetMyName evaluation_assignments_portlet::get_my_name
	    GetPrettyName  evaluation_assignments_portlet::get_pretty_name
	    Link evaluation_assignments_portlet::link
	    AddSelfToPage evaluation_assignments_portlet::add_self_to_page
	    Show evaluation_assignments_portlet::show
	    Edit evaluation_assignments_portlet::edit
	    RemoveSelfFromPage evaluation_assignments_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private evaluation_evaluations_portlet::after_install {} {
    Create the datasources needed by the evaluation evaluations portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
                   -name "evaluation_evaluations_portlet" \
                   -description "#evaluation-portlet.lt_Evaluation_Evaluation#"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl

    }
}

ad_proc -private evaluation_evaluations_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the evaluation evaluations portlet.
} {
    set spec {
        name "evaluation_evaluations_portlet"
	contract_name "portal_datasource"
	owner "evaluation-portlet"
        aliases {
	    GetMyName evaluation_evaluations_portlet::get_my_name
	    GetPrettyName  evaluation_evaluations_portlet::get_pretty_name
	    Link evaluation_evaluations_portlet::link
	    AddSelfToPage evaluation_evaluations_portlet::add_self_to_page
	    Show evaluation_evaluations_portlet::show
	    Edit evaluation_evaluations_portlet::edit
	    RemoveSelfFromPage evaluation_evaluations_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}


ad_proc -private evaluation_admin_portlet::after_install {} {
    Create the datasources needed by the evaluation portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
                   -name "evaluation_admin_portlet" \
                   -description "#evaluation-portlet.lt_Evaluation_Admin_Port#"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value f

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
    }
}



ad_proc -private evaluation_admin_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the evaluation admin portlet.
} {
    set spec {
        name "evaluation_admin_portlet"
	contract_name "portal_datasource"
	owner "evaluation-portlet"
        aliases {
	    GetMyName evaluation_admin_portlet::get_my_name
	    GetPrettyName  evaluation_admin_portlet::get_pretty_name
	    Link evaluation_admin_portlet::link
	    AddSelfToPage evaluation_admin_portlet::add_self_to_page
	    Show evaluation_admin_portlet::show
	    Edit evaluation_admin_portlet::edit
	    RemoveSelfFromPage evaluation_admin_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private evaluation_assignments_portlet::uninstall {} {
    Evaluation Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id evaluation_assignments_portlet]
    db_exec_plsql delete_assignments_ds { *SQL* }
}

ad_proc -private evaluation_evaluations_portlet::uninstall {} {
    Evaluation Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id evaluation_evaluations_portlet]
    db_exec_plsql delete_evaluations_ds { *SQL* }
}

ad_proc -private evaluation_admin_portlet::uninstall {} {
    Evaluation Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id evaluation_admin_portlet]
    db_exec_plsql delete_admin_ds { *SQL* }
}

ad_proc -private evaluation_assignments_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "evaluation_assignments_portlet"
}

ad_proc -private evaluation_evaluations_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "evaluation_evaluations_portlet"
}

ad_proc -private evaluation_admin_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "evaluation_admin_portlet"
}
ad_proc -private evaluation_evaluations_portlet::get_package_id_from_key {
    {-package_key:required}
} {
    Gets the package_id of the evaluation instance related to the evaluation portlet for this community
} {
    set community_id [dotlrn_community::get_community_id]
    set package_id  [db_string get_package_id {} -default 0]
    return $package_id
}




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
