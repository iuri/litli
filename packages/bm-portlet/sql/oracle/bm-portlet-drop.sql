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
-- Drops the bulk-mail portlet
--
-- @author yon (yon@openforce.net)
-- @creation-date 2002-05-13
-- @version $Id: bm-portlet-drop.sql,v 1.3 2003/09/30 13:11:39 mohanp Exp $
--

declare  
    ds_id portal_datasources.datasource_id%TYPE;
    foo integer;
begin

    begin 
        select datasource_id into ds_id
        from portal_datasources
        where name = 'bm_portlet';
    exception when no_data_found then
        ds_id := null;
    end;

    if ds_id is not null then
        portal_datasource.del(ds_id);
    end if;

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'GetMyName'
    );

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'GetPrettyName'
    );

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'Link'
    );

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'AddSelfToPage'
    );

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'Show'
    );

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'Edit'
    );

    foo := acs_sc_impl.delete_alias (
        'portal_datasource',
        'bm_portlet',
        'RemoveSelfFromPage'
    );

    acs_sc_binding.del (
        contract_name => 'portal_datasource',
        impl_name => 'bm_portlet'
    );

    acs_sc_impl.del (
        'portal_datasource',
        'bm_portlet'
    );

end;
/
show errors
