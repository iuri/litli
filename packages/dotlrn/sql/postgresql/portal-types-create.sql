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
-- DotLRN portal types map - a mapping table b/w  a type
-- like "subgroups" or "user" and their portal_id
--
-- @author arjun (arjun@openforce.net)
-- @version $Id: portal-types-create.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

create table dotlrn_portal_types_map (
    type                        varchar(100)
                                constraint dotlrn_p_t_map_type_pk
                                primary key,
    portal_id                   integer
				constraint dotlrn_p_t_map_portal_id_fk
                                references portals (portal_id)
                                constraint dotlrn_p_t_map_portal_id_un
                                unique
);
