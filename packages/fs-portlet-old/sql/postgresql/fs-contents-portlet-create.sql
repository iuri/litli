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
-- @version $Id: fs-contents-portlet-create.sql,v 1.3 2014/10/27 16:41:41 victorg Exp $
--



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
    ds_id portal_datasources.datasource_id%TYPE;
    foo integer;
BEGIN

    ds_id := portal_datasource__new(
          'fs_contents_portlet',
          'Displays one fs folder in a table'
    );

    perform portal_datasource__set_def_param(
          ds_id,
          't',
          't',
          'shadeable_p',
          't'
    );

    perform portal_datasource__set_def_param(
          ds_id,
          't',
          't',
          'hideable_p',
          't'
    );

    perform portal_datasource__set_def_param(
          ds_id,
          't',
          't',
          'user_editable_p',
          'f'
    );

    perform portal_datasource__set_def_param(
          ds_id,
          't',
          't',
          'shaded_p',
          'f'
    );

    perform portal_datasource__set_def_param(
          ds_id,
          't',
          't',
          'link_hideable_p',
          't'
    );

    perform portal_datasource__set_def_param(
          ds_id,
          't',
          'f',
          'folder_id',
          ''
    );

    -- create the implementation
    foo := acs_sc_impl__new(
        'portal_datasource',
        'fs_contents_portlet',
        'fs_contents_portlet'
    );

    -- add all the hooks
    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'GetMyName',
        'fs_contents_portlet::get_my_name',
        'TCL'
    );

    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'GetPrettyName',
        'fs_contents_portlet::get_pretty_name',
        'TCL'
    );

    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'Link',
        'fs_contents_portlet::link',
        'TCL'
    );

    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'AddSelfToPage',
        'fs_contents_portlet::add_self_to_page',
        'TCL'
    );

    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'Show',
        'fs_contents_portlet::show',
        'TCL'
    );

    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'Edit',
        'fs_contents_portlet::edit',
        'TCL'
    );

    foo := acs_sc_impl_alias__new(
        'portal_datasource',
        'fs_contents_portlet',
        'RemoveSelfFromPage',
        'fs_contents_portlet::remove_self_from_page',
        'TCL'
    );

    -- Add the binding
    perform acs_sc_binding__new(
          'portal_datasource',
          'fs_contents_portlet'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();


