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
-- @creation-date 2001-11-28
-- @version $Id: security-drop.sql,v 1.4 2006/08/08 21:26:21 donb Exp $
--

declare
begin

    acs_privilege.remove_child('admin', 'dotlrn_admin_community');
    acs_privilege.remove_child('admin', 'dotlrn_admin_community_type');
    acs_privilege.remove_child('admin', 'dotlrn_browse');
    acs_privilege.remove_child('create', 'dotlrn_create_community');
    acs_privilege.remove_child('create', 'dotlrn_create_community_type');
    acs_privilege.remove_child('read', 'dotlrn_view_community');
    acs_privilege.remove_child('read', 'dotlrn_view_community_type');
    acs_privilege.remove_child('write', 'dotlrn_edit_community');

    acs_privilege.remove_child('dotlrn_edit_community', 'dotlrn_view_community');
    acs_privilege.remove_child('dotlrn_admin_community', 'dotlrn_edit_community');
    acs_privilege.remove_child('dotlrn_admin_community', 'dotlrn_spam_community');

    delete
    from acs_permissions
    where privilege in ('dotlrn_admin_community',
                        'dotlrn_admin_community_type',
                        'dotlrn_browse',
                        'dotlrn_create_community',
                        'dotlrn_create_community_type',
                        'dotlrn_edit_community',
                        'dotlrn_view_community',
                        'dotlrn_view_community_type',
                        'dotlrn_spam_community');

    acs_privilege.drop_privilege('dotlrn_admin_community');
    acs_privilege.drop_privilege('dotlrn_admin_community_type');
    acs_privilege.drop_privilege('dotlrn_browse');
    acs_privilege.drop_privilege('dotlrn_create_community');
    acs_privilege.drop_privilege('dotlrn_create_community_type');
    acs_privilege.drop_privilege('dotlrn_edit_community');
    acs_privilege.drop_privilege('dotlrn_view_community');
    acs_privilege.drop_privilege('dotlrn_view_community_type');
    acs_privilege.drop_privilege('dotlrn_spam_community');

end;
/
show errors
