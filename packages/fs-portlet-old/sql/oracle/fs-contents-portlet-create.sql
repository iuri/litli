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

-- the fs contents portlet
--
-- @author Arjun Sanyal(arjun@openforce.net)
-- @version $Id: fs-contents-portlet-create.sql,v 1.4 2003/09/30 13:11:40 mohanp Exp $
--

declare
    ds_id portal_datasources.datasource_id%TYPE;
    foo integer;
begin

    ds_id := portal_datasource.new(
        name => 'fs_contents_portlet',
        description => 'Displays one fs folder in a table'
    );

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'shadeable_p',
        value => 't'
    );

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'hideable_p',
        value => 't'
    );

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'user_editable_p',
        value => 'f'
    );

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'shaded_p',
        value => 'f'
    );

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 't',
        key => 'link_hideable_p',
        value => 't'
    );

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 'f',
        key => 'folder_id',
        value => ''
    );

    -- create the implementation
    foo := acs_sc_impl.new(
        impl_contract_name => 'portal_datasource',
        impl_name => 'fs_contents_portlet',
        impl_pretty_name => 'FS Contents portlet',
        impl_owner_name => 'fs_contents_portlet'
    );

    -- add all the hooks
    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'GetMyName',
        'fs_contents_portlet::get_my_name',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'GetPrettyName',
        'fs_contents_portlet::get_pretty_name',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'Link',
        'fs_contents_portlet::link',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'AddSelfToPage',
        'fs_contents_portlet::add_self_to_page',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'Show',
        'fs_contents_portlet::show',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'Edit',
        'fs_contents_portlet::edit',
        'TCL'
    );

    foo := acs_sc_impl.new_alias(
        'portal_datasource',
        'fs_contents_portlet',
        'RemoveSelfFromPage',
        'fs_contents_portlet::remove_self_from_page',
        'TCL'
    );

    -- Add the binding
    acs_sc_binding.new(
        contract_name => 'portal_datasource',
        impl_name => 'fs_contents_portlet'
    );

end;
/
show errors
