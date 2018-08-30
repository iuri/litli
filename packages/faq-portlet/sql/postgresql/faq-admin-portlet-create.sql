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
-- Creates FAQ portlet
--
-- @author Arjun Sanyal (arjun@openforce.net)
-- @author Ben Adida (ben@openforce)
-- @creation-date 2002-01-19
-- @version $Id: faq-admin-portlet-create.sql,v 1.3 2014/10/27 16:41:30 victorg Exp $
--
-- Postgresql port adarsh@symphinity.com
--  
-- 10th July 2002
--



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
  ds_id 	portal_datasources.datasource_id%TYPE;
BEGIN
	ds_id = portal_datasource__new(
        		'faq_admin_portlet',
        		'Displays a FAQ'
			);

RAISE NOTICE ' created new ds';

	perform portal_datasource__set_def_param (
	 	ds_id,
		't',
   		't',
    		'shadeable_p',
		'f'
	);

RAISE NOTICE ' set shadeable';
	perform portal_datasource__set_def_param (
 	  	ds_id,
  		't',
   	 	't',
    	 	'hideable_p',
     	 	'f'
	);

RAISE NOTICE ' set hideable';
	perform portal_datasource__set_def_param (
		ds_id,
		't',
 		't',
		'user_editable_p',
 		'f'
	);

	perform portal_datasource__set_def_param (
 	       ds_id,
  	      't',
	      't',
	      'shaded_p',
	      'f'
	);

	perform portal_datasource__set_def_param (
	        ds_id,
	        't',
	        't',
	        'link_hideable_p',
	        't'
	);

	perform portal_datasource__set_def_param (
		ds_id,
	        't',
	        'f',
	        'package_id',
	        ' '
	);


return 0;

END;
$$ LANGUAGE plpgsql;



select inline_0();

drop function inline_0 ();

-- create the implementation
select acs_sc_impl__new (
        'portal_datasource',
        'faq_admin_portlet',
        'faq_admin_portlet'
);

-- add all the hooks
select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'GetMyName',
        'faq_admin_portlet::get_my_name',
        'TCL'
);

select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'GetPrettyName',
        'faq_admin_portlet::get_pretty_name',
        'TCL'
);

select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'Link',
        'faq_admin_portlet::link',
        'TCL'
);

select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'AddSelfToPage',
        'faq_admin_portlet::add_self_to_page',
        'TCL'
);

select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'Show',
        'faq_admin_portlet::show',
        'TCL'
);

select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'Edit',
        'faq_admin_portlet::edit',
        'TCL'
);

select acs_sc_impl_alias__new(
        'portal_datasource',
        'faq_admin_portlet',
        'RemoveSelfFromPage',
        'faq_admin_portlet::remove_self_from_page',
        'TCL'
);

-- Add the binding
select acs_sc_binding__new(
	'portal_datasource',
 	'faq_admin_portlet'
);
