--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Create File Storage Admin Portlet
--
-- @author Tracy Adams (teadams@mit.edu)
-- @creation-date 2004-07-07
-- @version $Id: fs-admin-portlet-create.sql,v 1.2 2004/07/24 08:34:21 jeffd Exp $

declare
    ds_id portal_datasources.datasource_id%TYPE;
begin

    ds_id := portal_datasource.new(
        name => 'fs_admin_portlet',
        description => 'Displays a File Storage Admin portlet'
    );

    portal_datasource.set_def_param (
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'shadeable_p',
        value => 'f'
    );

    portal_datasource.set_def_param (
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'hideable_p',
        value => 'f'
    );

    portal_datasource.set_def_param (
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'user_editable_p',
        value => 'f'
    );

    portal_datasource.set_def_param (
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'shaded_p',
        value => 'f'
    );

    portal_datasource.set_def_param (
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'link_hideable_p',
        value => 't'
    );

    portal_datasource.set_def_param (
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 'f',
        key => 'package_id',
        value => ''
    );

end;
/
show errors

declare
    foo integer;
begin

    -- create the implementation
    foo := acs_sc_impl.new (
        impl_contract_name => 'portal_datasource',
        impl_name => 'fs_admin_portlet',
        impl_pretty_name => 'File Storage Admin Portlet',
        impl_owner_name => 'fs_admin_portlet'
    );

    -- add all the hooks
    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'GetMyName',
        'fs_admin_portlet::get_my_name',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'GetPrettyName',
        'fs_admin_portlet::get_pretty_name',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'Link',
        'fs_admin_portlet::link',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'AddSelfToPage',
        'fs_admin_portlet::add_self_to_page',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'Show',
        'fs_admin_portlet::show',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'Edit',
        'fs_admin_portlet::edit',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_admin_portlet',
        'RemoveSelfFromPage',
        'fs_admin_portlet::remove_self_from_page',
        'TCL'
    );

    -- Add the binding
    acs_sc_binding.new(
        contract_name => 'portal_datasource',
        impl_name => 'fs_admin_portlet'
    );

end;
/
show errors

