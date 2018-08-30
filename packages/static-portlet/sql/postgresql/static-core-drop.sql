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
-- static-core-drop.sql
--
-- arjun@openforce.net
--
-- The core DM and API for static portal content
-- 
-- $Id: static-core-drop.sql,v 1.4 2014/10/27 16:41:55 victorg Exp $
-- 
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--


--drop permissions
delete from acs_permissions where object_id in (select content_id from static_portal_content);

--drop objects


--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
	object_rec		record;
BEGIN
	for object_rec in select object_id from acs_objects where object_type='static_portal_content'
	loop
		perform acs_object__delete( object_rec.object_id );
	end loop;

	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();

--
-- Datamodel
--


drop  table static_portal_content;

--
-- Objects
--


CREATE OR REPLACE FUNCTION inline_1() RETURNS integer AS $$
BEGIN

    perform acs_object_type__drop_type (
         'static_portal_content',			-- object_type
				 't'
    );
	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();

drop function inline_1();

--
-- API
-- 

drop function static_portal_content_item__new (
        	integer,	varchar, 	varchar, varchar,	timestamptz, 	integer,varchar,	integer	
    	) ;
drop  function static_portal_content_item__delete ( 	integer);


--
-- perms
--

CREATE OR REPLACE FUNCTION inline_2() RETURNS integer AS $$
BEGIN

      -- unbindbind privileges to global names

      perform acs_privilege__remove_child('create','static_portal_create');
      perform acs_privilege__remove_child('read','static_portal_read');
      perform acs_privilege__remove_child('delete','static_portal_delete');
      perform acs_privilege__remove_child('write','static_portal_modify');
      perform acs_privilege__remove_child('admin','static_portal_admin');

      -- set up the admin priv

      perform acs_privilege__remove_child('static_portal_admin', 'static_portal_create');
      perform acs_privilege__remove_child('static_portal_admin', 'static_portal_read');
      perform acs_privilege__remove_child('static_portal_admin', 'static_portal_delete');
      perform acs_privilege__remove_child('static_portal_admin', 'static_portal_modify');


      perform acs_privilege__drop_privilege('static_portal_create');
      perform acs_privilege__drop_privilege('static_portal_read');
      perform acs_privilege__drop_privilege('static_portal_delete');
      perform acs_privilege__drop_privilege('static_portal_modify');
      perform acs_privilege__drop_privilege('static_portal_admin');


	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_2();

drop function inline_2();

