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
-- /faq-portlet/sql/oracle/faq-portlet-drop.sql
--

-- Drops faq portlet

-- @author Arjun Sanyal (arjun@openforce.net)
-- @creation-date 2001-30-09

-- $Id: faq-portlet-drop.sql,v 1.3 2014/10/27 16:41:30 victorg Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html
--
-- Postgresql port adarsh@symphinity.com
--  
-- 29 June 2002




--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE  
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN

  select datasource_id into ds_id
    from portal_datasources
    where name = 'faq_portlet';

--  Exception handling?


    if not found then
        raise notice 'No datasource_id found here ', ds_id ;
	ds_id := null;        
    end if;

      
  if ds_id is NOT null then
    perform portal_datasource__delete(ds_id);
  end if;

return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0 ();

drop function inline_0 ();


-- drop the hooks
select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'GetMyName'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'GetPrettyName'
	);


select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'Link'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'AddSelfToPage'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'Show'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'Edit'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'faq_portlet',
	       'RemoveSelfFromPage'
);

-- Drop the binding
select acs_sc_binding__delete (
	'portal_datasource',
	'faq_portlet'
);

-- drop the impl
select acs_sc_impl__delete (
		'portal_datasource',
		'faq_portlet'
);

\i faq-admin-portlet-drop.sql
