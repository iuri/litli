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
-- /news-portlet/sql/postgresql/news-portlet-create.sql
--

-- Creates news portlet

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)
-- @creation-date 2001-30-09

-- $Id: news-portlet-create.sql,v 1.3 2014/10/27 16:41:49 victorg Exp $

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

  ds_id = portal_datasource__new(
    'news_portlet',						-- Name
    'News portlet'						-- description     
  );

  --  the standard 4 params

  -- shadeable_p 
  perform portal_datasource__set_def_param (
	ds_id,						-- datasource_id
	't',						-- config_required_p
	't',						-- configured_p 
	'shadeable_p',			-- key 
	't'						-- value
);	


  -- hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'hideable_p',
	't'
);	

  -- user_editable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'user_editable_p',
	'f'
);	

  -- shaded_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'shaded_p',
	'f'
);	

  -- link_hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'link_hideable_p',
	't'
);  

-- news-specific params

  -- community_id must be configured
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	'f',
	'package_id',
	''
);

  return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();


CREATE OR REPLACE FUNCTION inline_1() RETURNS integer AS $$
BEGIN

	-- create the implementation
	perform acs_sc_impl__new (
		'portal_datasource',
		'news_portlet',
		'news_portlet'
	);

	-- add all the hooks
	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'GetMyName',
	       'news_portlet::get_my_name',
	       'TCL'
	);

	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'GetPrettyName',
	       'news_portlet::get_pretty_name',
	       'TCL'
	);

	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'Link',
	       'news_portlet::link',
	       'TCL'
	);

	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'AddSelfToPage',
	       'news_portlet::add_self_to_page',
	       'TCL'
	);

	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'Show',
	       'news_portlet::show',
	       'TCL'
	);

	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'Edit',
	       'news_portlet::edit',
	       'TCL'
	);

	perform  acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_portlet',
	       'RemoveSelfFromPage',
	       'news_portlet::remove_self_from_page',
	       'TCL'
	);

	-- Add the binding
	perform acs_sc_binding__new (
	    'portal_datasource',
	    'news_portlet'
	);

	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();

drop function inline_1();


\i news-admin-portlet-create.sql
