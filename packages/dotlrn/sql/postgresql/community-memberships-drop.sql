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
-- drop the dotLRN communities membership model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date  November 6th, 2001
-- porting to PG 2002-07-01
-- @version $Id: community-memberships-drop.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

drop table dotlrn_member_emails;
drop view dotlrn_admin_rels_full;
drop table dotlrn_admin_rels;
drop view dotlrn_member_rels_approved;
drop view dotlrn_member_rels_full;
drop table dotlrn_member_rels;
