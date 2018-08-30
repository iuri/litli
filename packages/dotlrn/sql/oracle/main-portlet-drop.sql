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


-- Drops dotLRN main portlet datasources for portal portlets

-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2001-11-04

-- $Id: main-portlet-drop.sql,v 1.5 2006/08/08 21:26:21 donb Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html

declare  
    ds_id portal_datasources.datasource_id%TYPE;
    foo integer;
begin

    acs_sc_binding.del(
        contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'GetMyName'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'GetPrettyName'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'Link'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'AddSelfToPage'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'RemoveSelfFromPage'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'Show'
    );

    foo := acs_sc_impl.delete_alias(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet',
        impl_operation_name => 'Edit'
    );

    acs_sc_impl.del(
        impl_contract_name => 'portal_datasource',
        impl_name => 'dotlrn_main_portlet'
    );

    begin 
        select datasource_id into ds_id
        from portal_datasources
        where name = 'dotlrn-main-portlet';
    exception when no_data_found then
        ds_id := null;
    end;

    if ds_id is not null then
        portal_datasource.del(ds_id);
    end if;

end;
/
show errors;

