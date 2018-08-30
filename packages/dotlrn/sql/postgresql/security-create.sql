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
-- dotLRN Project
--
-- ben@openforce
-- ported to PG by Yon and Ben
-- @author dan chak (chak@openforce.net)
-- @version $Id: security-create.sql,v 1.7 2013/11/01 21:08:29 gustafn Exp $
--
-- creation date 11/28/2001
--
-- Security Setup for dotLRN
-- privileges, privilege inheritance
--
CREATE OR REPLACE FUNCTION inline0() RETURNS integer AS $$
BEGIN
        -- the ability to browse dotLRN in general
        perform acs_privilege__create_privilege('dotlrn_browse');

        -- the ability to even view that a community exists
        perform acs_privilege__create_privilege('dotlrn_view_community');

        -- the ability to participate in a community
        perform acs_privilege__create_privilege('dotlrn_edit_community');

        -- the ability to admin a community
        perform acs_privilege__create_privilege('dotlrn_admin_community');

        -- the ability to create a community
        perform acs_privilege__create_privilege('dotlrn_create_community');

        -- the ability to even view a community type
        perform acs_privilege__create_privilege('dotlrn_view_community_type');

        -- the ability to admin a community type
        perform acs_privilege__create_privilege('dotlrn_admin_community_type');
        
        -- the ability to create a community type
        perform acs_privilege__create_privilege('dotlrn_create_community_type');

        -- the ability to spam a community
        perform acs_privilege__create_privilege('dotlrn_spam_community');

        -- Consistent permissions
        perform acs_privilege__add_child('dotlrn_edit_community', 'dotlrn_view_community');
        perform acs_privilege__add_child('dotlrn_admin_community', 'dotlrn_edit_community');
        perform acs_privilege__add_child('dotlrn_admin_community', 'dotlrn_spam_community');

        -- inheritance
        perform acs_privilege__add_child('create', 'dotlrn_create_community_type');
        perform acs_privilege__add_child('create', 'dotlrn_create_community');
        perform acs_privilege__add_child('write', 'dotlrn_edit_community');
        perform acs_privilege__add_child('read', 'dotlrn_view_community');
        perform acs_privilege__add_child('read', 'dotlrn_view_community_type');
        perform acs_privilege__add_child('admin', 'dotlrn_admin_community');
        perform acs_privilege__add_child('admin', 'dotlrn_admin_community_type');
        -- for now, we only want admins to be able to browse by default
        perform acs_privilege__add_child('admin', 'dotlrn_browse');

        -- no default permissions
        return 0;

END;
$$ LANGUAGE plpgsql;

select inline0();
drop function inline0();
