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
-- drop the dotLRN memberships packages
--
-- @author Ben Adida (ben@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date 2001-11-06
-- PG Port 2002-07-01
-- @version $Id: community-memberships-packages-drop.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

select drop_package('dotlrn_cadmin_rel');
select drop_package('dotlrn_ca_rel');
select drop_package('dotlrn_ta_rel');
select drop_package('dotlrn_instructor_rel');
select drop_package('dotlrn_student_rel');
select drop_package('dotlrn_admin_rel');
select drop_package('dotlrn_member_rel');
