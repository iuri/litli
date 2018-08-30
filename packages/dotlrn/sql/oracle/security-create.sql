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
-- create dotLRN permissions
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2001-11-28
-- @version $Id: security-create.sql,v 1.5 2006/08/08 21:26:21 donb Exp $
--

declare
begin

    -- the ability to browse dotLRN in general
    acs_privilege.create_privilege('dotlrn_browse');

    -- the ability to even view that a community exists
    acs_privilege.create_privilege('dotlrn_view_community');

    -- the ability to participate in a community
    acs_privilege.create_privilege('dotlrn_edit_community');

    -- the ability to admin a community
    acs_privilege.create_privilege('dotlrn_admin_community');

    -- the ability to create a community
    acs_privilege.create_privilege('dotlrn_create_community');

    -- the ability to even view a community type
    acs_privilege.create_privilege('dotlrn_view_community_type');

    -- the ability to admin a community type
    acs_privilege.create_privilege('dotlrn_admin_community_type');

    -- the ability to create a community type
    acs_privilege.create_privilege('dotlrn_create_community_type');

    -- the ability to spam a community
    acs_privilege.create_privilege('dotlrn_spam_community');

    -- consistent permissions
    acs_privilege.add_child('dotlrn_edit_community', 'dotlrn_view_community');
    acs_privilege.add_child('dotlrn_admin_community', 'dotlrn_edit_community');
    acs_privilege.add_child('dotlrn_admin_community', 'dotlrn_spam_community');

    -- inheritance
    acs_privilege.add_child('create', 'dotlrn_create_community_type');
    acs_privilege.add_child('create', 'dotlrn_create_community');
    acs_privilege.add_child('write', 'dotlrn_edit_community');
    acs_privilege.add_child('read', 'dotlrn_view_community');
    acs_privilege.add_child('read', 'dotlrn_view_community_type');
    acs_privilege.add_child('admin', 'dotlrn_admin_community');
    acs_privilege.add_child('admin', 'dotlrn_admin_community_type');

    -- for now, we only want admins to be able to browse by default
    acs_privilege.add_child('admin', 'dotlrn_browse');

end;
/
show errors
