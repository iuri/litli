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
-- Create the dotLRN Externals package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: externals-create.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

create table dotlrn_external_profile_rels (
    rel_id                      integer
                                constraint dotlrn_external_p_rels_rel_fk
                                references dotlrn_user_profile_rels (rel_id)
                                constraint dotlrn_external_p_rels_pk
                                primary key
);

\i external-profile-provider-create.sql
\i externals-init.sql
\i externals-package-create.sql
