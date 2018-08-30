--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or(at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Creates the bulk-mail portlet
--
-- @author yon (yon@openforce.net)
-- @creation-date 2002-05-13
-- @version $Id: dotlrn-bm-create.sql,v 1.4 2003/09/30 13:11:39 mohanp Exp $
--

declare
    foo integer;
begin

    foo := acs_sc_impl.new(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_pretty_name => 'dotlrn_bm',
        impl_owner_name => 'dotlrn_bm'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'GetPrettyName',
        impl_alias => 'dotlrn_bm::get_pretty_name',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'AddApplet',
        impl_alias => 'dotlrn_bm::add_applet',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'RemoveApplet',
        impl_alias => 'dotlrn_bm::remove_applet',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'AddAppletToCommunity',
        impl_alias => 'dotlrn_bm::add_applet_to_community',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'RemoveAppletFromCommunity',
        impl_alias => 'dotlrn_bm::remove_applet_from_community',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'AddUser',
        impl_alias => 'dotlrn_bm::add_user',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'RemoveUser',
        impl_alias => 'dotlrn_bm::remove_user',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'AddUserToCommunity',
        impl_alias => 'dotlrn_bm::add_user_to_community',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'RemoveUserFromCommunity',
        impl_alias => 'dotlrn_bm::remove_user_from_community',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'AddPortlet',
        impl_alias => 'dotlrn_bm::add_portlet',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'RemovePortlet',
        impl_alias => 'dotlrn_bm::remove_portlet',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'Clone',
        impl_alias => 'dotlrn_bm::clone',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm',
        impl_operation_name => 'ChangeEventHandler',
        impl_alias => 'dotlrn_bm::change_event_handler',
        impl_pl => 'TCL'
    );

    acs_sc_binding.new(
        contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_bm'
    );

end;
/
show errors
