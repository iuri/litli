-- Drops fs admin portlet

-- @author Tracy Adams (teadams@mit.edu)
-- @creation-date 2004-07-07

-- $Id: fs-admin-portlet-drop.sql,v 1.3 2014/10/27 16:41:41 victorg Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE  
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN

--  begin 
    select datasource_id into ds_id
      from portal_datasources
     where name = 'fs-admin-portlet';
--   exception when no_data_found then
--     ds_id := null;
--  end;

  if ds_id is not null then
    portal_datasource__delete(ds_id);
  end if;

return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
	foo integer;
BEGIN

	-- drop the hooks
	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'GetMyName'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'GetPrettyName'
	);


	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'Link'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'AddSelfToPage'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'Show'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'Edit'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs_admin_portlet',
	       'RemoveSelfFromPage'
	);

	-- Drop the binding
	perform acs_sc_binding__delete (
	    'portal_datasource',
	    'fs_admin_portlet'
	);

	-- drop the impl
	foo := acs_sc_impl__delete (
		'portal_datasource',
		'fs_admin_portlet'
	);

	return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();



