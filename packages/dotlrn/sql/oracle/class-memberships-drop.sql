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
-- drop the dotLRN class membership model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @creation-date 2001-08-18
-- @version $Id: class-memberships-drop.sql,v 1.3 2006/08/08 21:26:21 donb Exp $
--

declare
begin

    acs_rel_type.drop_type (
        rel_type => 'dotlrn_student_rel',
        cascade_p => 't'
    );

    acs_rel_type.drop_type (
        rel_type => 'dotlrn_ta_rel',
        cascade_p => 't'
    );

    acs_rel_type.drop_type (
        rel_type => 'dotlrn_ca_rel',
        cascade_p => 't'
    );

    acs_rel_type.drop_type (
        rel_type => 'dotlrn_cadmin_rel',
        cascade_p => 't'
    );

    acs_rel_type.drop_type (
        rel_type => 'dotlrn_instructor_rel',
        cascade_p => 't'
    );

end;
/
show errors

drop view dotlrn_instructor_rels_full;
drop table dotlrn_instructor_rels;
drop view dotlrn_cadmin_rels_full;
drop table dotlrn_cadmin_rels;
drop view dotlrn_ca_rels_full;
drop table dotlrn_ca_rels;
drop view dotlrn_ta_rels_full;
drop table dotlrn_ta_rels;
drop view dotlrn_student_rels_full;
drop table dotlrn_student_rels;
