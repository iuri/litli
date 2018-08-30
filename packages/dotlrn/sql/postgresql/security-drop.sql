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
-- drop dotLRN permissions
--
-- @author Ben Adida (ben@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date 2001-11-28
-- ported 2002-07-01
-- @version $Id: security-drop.sql,v 1.5 2013/11/01 21:08:29 gustafn Exp $
--

CREATE OR REPLACE FUNCTION inline0() RETURNS integer AS $$
BEGIN

    perform acs_privilege__remove_child('admin', 'dotlrn_admin_community');
    perform acs_privilege__remove_child('admin', 'dotlrn_admin_community_type');
    perform acs_privilege__remove_child('admin', 'dotlrn_browse');
    perform acs_privilege__remove_child('create', 'dotlrn_create_community');
    perform acs_privilege__remove_child('create', 'dotlrn_create_community_type');
    perform acs_privilege__remove_child('read', 'dotlrn_view_community');
    perform acs_privilege__remove_child('read', 'dotlrn_view_community_type');
    perform acs_privilege__remove_child('write', 'dotlrn_edit_community');

    perform acs_privilege__remove_child('dotlrn_edit_community', 'dotlrn_view_community');
    perform acs_privilege__remove_child('dotlrn_admin_community', 'dotlrn_edit_community');
    perform acs_privilege__remove_child('dotlrn_admin_community', 'dotlrn_spam_community');


    delete
    from acs_permissions
    where privilege in ('dotlrn_admin_community',
                        'dotlrn_admin_community_type',
                        'dotlrn_browse',
                        'dotlrn_create_community',
                        'dotlrn_create_community_type',
                        'dotlrn_edit_community',
                        'dotlrn_view_community',
                        'dotlrn_view_community_type');

    perform acs_privilege__drop_privilege('dotlrn_admin_community');
    perform acs_privilege__drop_privilege('dotlrn_admin_community_type');
    perform acs_privilege__drop_privilege('dotlrn_browse');
    perform acs_privilege__drop_privilege('dotlrn_create_community');
    perform acs_privilege__drop_privilege('dotlrn_create_community_type');
    perform acs_privilege__drop_privilege('dotlrn_edit_community');
    perform acs_privilege__drop_privilege('dotlrn_view_community');
    perform acs_privilege__drop_privilege('dotlrn_view_community_type');
    perform acs_privilege__drop_privilege('dotlrn_spam_community');
    return 0;

END;
$$ LANGUAGE plpgsql;

select inline0();
drop function inline0();
