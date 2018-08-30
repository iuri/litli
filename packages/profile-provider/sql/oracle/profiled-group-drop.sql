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
-- Groups that implement the profile provider interface
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: profiled-group-drop.sql,v 1.4 2002/08/09 20:56:32 yon Exp $
--

drop package profiled_group;

declare
begin
    acs_object_type.drop_type(
        object_type => 'profiled_group'
    );
end;
/
show errors

drop table profiled_groups;
