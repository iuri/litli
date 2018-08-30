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
-- create the dotLRN class membership model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @author chak (chak@openforce.net)
-- @creation-date 2002-07-01
-- @version $Id: class-memberships-create.sql,v 1.4.4.2 2017/04/21 20:45:16 gustafn Exp $
--

create table dotlrn_student_rels (
    rel_id                      integer
				constraint dotlrn_student_rels_rel_id_fk
                                references dotlrn_member_rels (rel_id)
                                constraint dotlrn_student_rels_rel_id_pk
                                primary key
);

create view dotlrn_student_rels_full
as
    select dotlrn_member_rels_full.rel_id,
           dotlrn_member_rels_full.community_id,
           dotlrn_member_rels_full.user_id,
           dotlrn_member_rels_full.rel_type,
           dotlrn_member_rels_full.role,
           dotlrn_member_rels_full.member_state
    from dotlrn_member_rels_full,
         dotlrn_student_rels
    where dotlrn_member_rels_full.rel_id = dotlrn_student_rels.rel_id;

create table dotlrn_ta_rels (
    rel_id                      integer
				constraint dotlrn_ta_rels_rel_id_fk
                                references dotlrn_admin_rels (rel_id)
                                constraint dotlrn_ta_rels_rel_id_pk
                                primary key
);

create view dotlrn_ta_rels_full
as
    select dotlrn_admin_rels_full.rel_id,
           dotlrn_admin_rels_full.community_id,
           dotlrn_admin_rels_full.user_id,
           dotlrn_admin_rels_full.rel_type,
           dotlrn_admin_rels_full.role,
           dotlrn_admin_rels_full.member_state
    from dotlrn_admin_rels_full,
         dotlrn_ta_rels
    where dotlrn_admin_rels_full.rel_id = dotlrn_ta_rels.rel_id;

create table dotlrn_ca_rels (
    rel_id                      integer
				constraint dotlrn_ca_rels_rel_id_fk
                                references dotlrn_admin_rels (rel_id)
                                constraint dotlrn_ca_rels_rel_id_pk
                                primary key
);

create view dotlrn_ca_rels_full
as
    select dotlrn_admin_rels_full.rel_id,
           dotlrn_admin_rels_full.community_id,
           dotlrn_admin_rels_full.user_id,
           dotlrn_admin_rels_full.rel_type,
           dotlrn_admin_rels_full.role,
           dotlrn_admin_rels_full.member_state
    from dotlrn_admin_rels_full,
         dotlrn_ca_rels
    where dotlrn_admin_rels_full.rel_id = dotlrn_ca_rels.rel_id;

create table dotlrn_cadmin_rels (
    rel_id                      integer
				constraint dotlrn_cadmin_rels_rel_id_fk
                                references dotlrn_admin_rels (rel_id)
                                constraint dotlrn_cadmin_rels_rel_id_pk
                                primary key
);

create view dotlrn_cadmin_rels_full
as
    select dotlrn_admin_rels_full.rel_id,
           dotlrn_admin_rels_full.community_id,
           dotlrn_admin_rels_full.user_id,
           dotlrn_admin_rels_full.rel_type,
           dotlrn_admin_rels_full.role,
           dotlrn_admin_rels_full.member_state
    from dotlrn_admin_rels_full,
         dotlrn_cadmin_rels
    where dotlrn_admin_rels_full.rel_id = dotlrn_cadmin_rels.rel_id;

create table dotlrn_instructor_rels (
    rel_id                      integer
				constraint dotlrn_instructor_rels_rel_fk
                                references dotlrn_admin_rels(rel_id)
                                constraint dotlrn_instructor_rels_rel_pk
                                primary key
);

create view dotlrn_instructor_rels_full
as
    select dotlrn_admin_rels_full.rel_id,
           dotlrn_admin_rels_full.community_id,
           dotlrn_admin_rels_full.user_id,
           dotlrn_admin_rels_full.rel_type,
           dotlrn_admin_rels_full.role,
           dotlrn_admin_rels_full.member_state
    from dotlrn_admin_rels_full,
         dotlrn_instructor_rels
    where dotlrn_admin_rels_full.rel_id = dotlrn_instructor_rels.rel_id;


CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN
    perform acs_rel_type__create_type (
        'dotlrn_student_rel',
        'dotLRN Student Community Membership',
        'dotLRN Student Community Memberships',
        'dotlrn_member_rel',
        'dotlrn_student_rels',        
        'rel_id',
        'dotlrn_student_rel',
        'dotlrn_class_instance', 
	null, 
        0, 
	null::integer,
        'user',
	'student',
        0, 
	null::integer
    );

    perform acs_rel_type__create_type (
        'dotlrn_ta_rel',
        'dotLRN Teaching Assistant Community Membership',
        'dotLRN Teaching Assistant Community Memberships',
        'dotlrn_admin_rel',
        'dotlrn_ta_rels',        
        'rel_id',
        'dotlrn_ta_rel',
        'dotlrn_class_instance', 
	null, 
        0,
	null::integer,
        'user',
	'teaching_assistant',
        0,
	null::integer
    );

    perform acs_rel_type__create_type (
        'dotlrn_ca_rel',
        'dotLRN Course Assistant Community Membership',
        'dotLRN Course Assistant Community Memberships',
        'dotlrn_admin_rel',
        'dotlrn_ca_rels',        
        'rel_id',
        'dotlrn_ca_rel',
        'dotlrn_class_instance', null, 
        0, 
	null::integer,
        'user',
	'course_assistant',
        0, 
	null::integer
    );

    perform acs_rel_type__create_type (
        'dotlrn_cadmin_rel',
        'dotLRN Course Administrator Community Membership',
        'dotLRN Course Administrator Community Memberships',
        'dotlrn_admin_rel',
        'dotlrn_cadmin_rels',        
        'rel_id',
        'dotlrn_cadmin_rel',
        'dotlrn_class_instance', 
	null, 
        0, 
	null::integer,
        'user',	
	'course_admin',
        0, 
	null::integer
    );

    perform acs_rel_type__create_type (
        'dotlrn_instructor_rel',
        'dotLRN Instructor Community Membership',
        'dotLRN Instructor Community Memberships',
        'dotlrn_admin_rel',
        'dotlrn_instructor_rels',        
        'rel_id',
        'dotlrn_instructor_rel',
        'dotlrn_class_instance', null, 
        0, 
	null::integer,
        'user', 
	'instructor',
        0, 
	null::integer
    );
    
    return 0;

END;

$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();
