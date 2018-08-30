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
-- Drop the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: users-drop.sql,v 1.3 2006/08/08 21:26:21 donb Exp $
--

-- drop external users
@@ externals-drop.sql

-- drop students
@@ students-drop.sql

-- drop professors
@@ professors-drop.sql

-- drop admins
@@ admins-drop.sql

@@ users-package-drop.sql
@@ users-sanitize.sql
@@ user-profile-provider-drop.sql

drop view dotlrn_users;

drop table dotlrn_user_types;
drop table dotlrn_user_profile_rels;
