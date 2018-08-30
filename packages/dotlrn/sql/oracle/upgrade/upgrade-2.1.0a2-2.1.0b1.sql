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

-- Members in classes that self-joined or were moved where labeled as 
-- 'dotlrn_member_rel' instead of 'dotlrn_student_rel'

-- This caused issues when roles were selected for bulk_mail 

update acs_rels set rel_type = 'dotlrn_student_rel' where rel_type = 'dotlrn_member_rel' and object_id_one  in (select community_id from dotlrn_communities where community_type not in ('dotlrn_community', 'dotlrn_club'));