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
-- Drop the dotLRN Professors package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- author dan chak (chak@openforce.net)
-- @version $Id: professors-drop.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

\i professors-package-drop.sql
\i professors-sanitize.sql
\i professor-profile-provider-drop.sql

drop table dotlrn_professor_profile_rels;
