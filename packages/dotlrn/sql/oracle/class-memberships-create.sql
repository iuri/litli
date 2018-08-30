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
-- @creation-date 2001-08-18
-- @version $Id: class-memberships-create.sql,v 1.3.10.1 2017/04/21 20:45:16 gustafn Exp $
--

create table dotlrn_student_rels (
    rel_id                      constraint dotlrn_student_rels_rel_id_fk
                                references dotlrn_member_rels (rel_id)
                                constraint dotlrn_student_rels_rel_id_pk
                                primary key
);

create or replace view dotlrn_student_rels_full
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
    rel_id                      constraint dotlrn_ta_rels_rel_id_fk
                                references dotlrn_admin_rels (rel_id)
                                constraint dotlrn_ta_rels_rel_id_pk
                                primary key
);

create or replace view dotlrn_ta_rels_full
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
    rel_id                      constraint dotlrn_ca_rels_rel_id_fk
                                references dotlrn_admin_rels (rel_id)
                                constraint dotlrn_ca_rels_rel_id_pk
                                primary key
);

create or replace view dotlrn_ca_rels_full
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
    rel_id                      constraint dotlrn_cadmin_rels_rel_id_fk
                                references dotlrn_admin_rels (rel_id)
                                constraint dotlrn_cadmin_rels_rel_id_pk
                                primary key
);

create or replace view dotlrn_cadmin_rels_full
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
    rel_id                      constraint dotlrn_instructor_rels_rel_fk
                                references dotlrn_admin_rels(rel_id)
                                constraint dotlrn_instructor_rels_rel_pk
                                primary key
);

create or replace view dotlrn_instructor_rels_full
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



declare
begin
    acs_rel_type.create_type (
        rel_type => 'dotlrn_student_rel',
        supertype => 'dotlrn_member_rel',
        pretty_name => 'dotLRN Student Community Membership',
        pretty_plural => 'dotLRN Student Community Memberships',
        package_name => 'dotlrn_student_rel',
        table_name => 'dotlrn_student_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_class_instance', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'student',
        min_n_rels_two => 0, max_n_rels_two => null
    );

    acs_rel_type.create_type (
        rel_type => 'dotlrn_ta_rel',
        supertype => 'dotlrn_admin_rel',
        pretty_name => 'dotLRN Teaching Assistant Community Membership',
        pretty_plural => 'dotLRN Teaching Assistant Community Memberships',
        package_name => 'dotlrn_ta_rel',
        table_name => 'dotlrn_ta_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_class_instance', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'teaching_assistant',
        min_n_rels_two => 0, max_n_rels_two => null
    );

    acs_rel_type.create_type (
        rel_type => 'dotlrn_ca_rel',
        supertype => 'dotlrn_admin_rel',
        pretty_name => 'dotLRN Course Assistant Community Membership',
        pretty_plural => 'dotLRN Course Assistant Community Memberships',
        package_name => 'dotlrn_ca_rel',
        table_name => 'dotlrn_ca_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_class_instance', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'course_assistant',
        min_n_rels_two => 0, max_n_rels_two => null
    );

    acs_rel_type.create_type (
        rel_type => 'dotlrn_cadmin_rel',
        supertype => 'dotlrn_admin_rel',
        pretty_name => 'dotLRN Course Administrator Community Membership',
        pretty_plural => 'dotLRN Course Administrator Community Memberships',
        package_name => 'dotlrn_cadmin_rel',
        table_name => 'dotlrn_cadmin_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_class_instance', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'course_admin',
        min_n_rels_two => 0, max_n_rels_two => null
    );

    acs_rel_type.create_type (
        rel_type => 'dotlrn_instructor_rel',
        supertype => 'dotlrn_admin_rel',
        pretty_name => 'dotLRN Instructor Community Membership',
        pretty_plural => 'dotLRN Instructor Community Memberships',
        package_name => 'dotlrn_instructor_rel',
        table_name => 'dotlrn_instructor_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_class_instance', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'instructor',
        min_n_rels_two => 0, max_n_rels_two => null
    );
end;
/
show errors
