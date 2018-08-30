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

-- drop the dotLRN communities tree model
-- @author dan chak (chak@openforce.net)

drop trigger dotlrn_communities_in_tr on dotlrn_communities_all;
drop trigger dotlrn_community_types_in_tr on dotlrn_community_types;
drop function dotlrn_communities_in_tr();
drop function dotlrn_community_types_in_tr();
