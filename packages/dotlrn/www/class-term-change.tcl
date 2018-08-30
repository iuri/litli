#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    Change Term of a class

    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-10-05
    @version $Id: class-term-change.tcl,v 1.2.10.1 2015/09/11 11:40:41 gustafn Exp $
} -query {
    {referer "one-community-admin"}
    {pretty_name ""}
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id
set description [dotlrn_community::get_community_description -community_id $community_id]
set class_key [dotlrn_community::get_community_key -community_id $community_id]
set class_instance_id $community_id
set term_id [dotlrn_class::get_term_id -class_instance_id $class_instance_id]
#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

ad_form -name change_class_term -form {
    {term_id:text(select),optional
	{label "[_ dotlrn.Term]"}
	{options {[db_list_of_lists select_terms_for_select_widget {} ]}}
	{value "$term_id"}
    }
    
    {pretty_name:text(inform)
	{label "[_ dotlrn.Name]"}
	{value "$pretty_name"}
    }

} -on_submit {
    
    db_dml update_term_info "update dotlrn_class_instances set term_id = :term_id where class_instance_id = :class_instance_id"
    
    ad_returnredirect "$referer"
}

set class_name $pretty_name
set class_instances_pretty_name [parameter::get -localize -parameter class_instances_pretty_name]

set context_bar [list \
                     [list classes [parameter::get -localize -parameter classes_pretty_plural]] \
                                         [_ dotlrn.new_class_instance]]

ad_return_template
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
