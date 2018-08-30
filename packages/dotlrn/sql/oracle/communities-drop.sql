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
-- drop the dotLRN communities model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net
-- @author arjun (arjun@openforce.net)
-- @creation-date September 20th, 2001 (redone)
-- @version $Id: communities-drop.sql,v 1.5 2006/08/08 21:26:21 donb Exp $
--

@@ communities-tree-drop.sql;

drop view dotlrn_active_comms_not_closed;
drop view dotlrn_active_communities;
drop view dotlrn_communities_not_closed;
drop view dotlrn_communities;
drop table dotlrn_communities_all;
drop table dotlrn_community_types;
