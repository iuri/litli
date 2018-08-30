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
-- The DotLRN basic system
--
-- @author Ben Adida (ben@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date 2001-09-25
-- @version $Id: dotlrn-init.sql,v 1.14.4.1 2016/08/31 18:57:41 gustafn Exp $
--
-- @note We remember September 11th, 2001
--

CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN

    -- Create the base community type
    perform dotlrn_community_type__new(
        'dotlrn_community',
        null,
        '#dotlrn.dotlrn_community_pretty_name#',
        '#dotlrn.dotlrn_community_pretty_plural#',
        '#dotlrn.dotlrn_community_description#'
    );

    -- these are the possible attributes of a community
    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'header_font',
	   'string',
	   '#dotlrn.Header_Font#',
	   '#dotlrn.Header_Fonts#',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'header_font_size',
	   'string',
	   '#dotlrn.Header_Font_Size#',
	   '#dotlrn.Header_Font_Sizes#',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'header_font_color',
	   'string',
	   '#dotlrn.Header_Font_Color#',
	   '#dotlrn.Header_Font_Colors#',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'header_logo_item_id',
	   'integer',
	   '#dotlrn.Header_Logo_Item_ID#',
	   '#dotlrn.Header_Logo_Item_ID#',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'header_logo_alt_text',
	   'integer',
	   '#dotlrn.Header_Logo_Alt_Text#',
	   '#dotlrn.Header_Logo_Alt_Text#',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );


    -- create the dotlrn_class community type
    perform dotlrn_community_type__new(
        'dotlrn_class_instance',
        'dotlrn_community',
        '#dotlrn.dotlrn_class_instance_pretty_name#',
        '#dotlrn.dotlrn_class_instance_pretty_plural#',
        '#dotlrn.dotlrn_class_instance_description#'
    );

    -- create the dotlrn_club community type
    perform dotlrn_community_type__new(
        'dotlrn_club',
        'dotlrn_community',
        '#dotlrn.dotlrn_club_pretty_name#',
        '#dotlrn.dotlrn_club_pretty_plural#',
        '#dotlrn.dotlrn_club_description#'
    );

    update acs_object_types set table_name = 'dotlrn_community', package_name = 'dotlrn_community' where object_type = 'dotlrn_community';
    update acs_object_types set table_name = 'dotlrn_class_instance', package_name = 'dotlrn_class_instance' where object_type = 'dotlrn_class_instance';
    update acs_object_types set table_name = 'dotlrn_club', package_name = 'dotlrn_club' where object_type = 'dotlrn_club';

    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'member_pretty_name',
	   'string',
	   'Member Pretty Name',
	   'Member Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute(
	   'dotlrn_community',
	   'member_pretty_plural',
	   'string',
	   'Member Pretty Plural',
	   'Member Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    -- create roles
    perform acs_rel_type__create_role('student', '#dotlrn.student_role_pretty_name#', '#dotlrn.student_role_pretty_plural#');
    perform acs_rel_type__create_role('course_assistant', '#dotlrn.course_assistant_role_pretty_name#', '#dotlrn.course_assistant_role_pretty_plural#');
    perform acs_rel_type__create_role('teaching_assistant', '#dotlrn.teaching_assistant_role_pretty_name#', '#dotlrn.teaching_assistant_role_pretty_plural#');
    perform acs_rel_type__create_role('instructor', '#dotlrn.instructor_role_pretty_name#', '#dotlrn.instructor_role_pretty_plural#');
    perform acs_rel_type__create_role('course_admin', '#dotlrn.course_admin_role_pretty_name#', '#dotlrn.course_admin_role_pretty_plural#');

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'student_pretty_name',
	   'string',
	   'Student Pretty Name',
	   'Student Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'student_pretty_plural',
	   'string',
	   'Student Pretty Plural',
	   'Student Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'course_assistant_pretty_name',
	   'string',
	   'Course Assistant Pretty Name',
	   'Course Assistant Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'course_assistant_pretty_plural',
	   'string',
	   'Course Assistant Pretty Plural',
	   'Course Assistant Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'teaching_assistant_pretty_name',
	   'string',
	   'Teaching Assistant Pretty Name',
	   'Teaching Assistant Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'teaching_assistant_pretty_plural',
	   'string',
	   'Teaching Assistant Pretty Plural',
	   'Teaching Assistant Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'instructor_pretty_name',
	   'string',
	   'Professor Pretty Name',
	   'Professor Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'instructor_pretty_plural',
	   'string',
	   'Professor Pretty Plural',
	   'Professor Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'course_admin_pretty_name',
	   'string',
	   'Course Administrator Pretty Name',
	   'Course Administrator Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'course_admin_pretty_plural',
	   'string',
	   'Course Administrator Pretty Plural',
	   'Course Administrator Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',		  
	   'admin_pretty_name',
	   'string',
	   'Administrator Pretty Name',
	   'Administrator Pretty Name',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    perform acs_attribute__create_attribute (
	   'dotlrn_community',
	   'admin_pretty_plural',
	   'string',
	   'Administrator Pretty Plural',
	   'Administrator Pretty Plural',
	   null, null, null,
	   0,
	   1,
	   null,
	   'generic',
	   'f'
    );

    -- create basic rel_types

    perform acs_rel_type__create_type (
	   'dotlrn_member_rel',                        -- rel_type
	   '#dotlrn.dotlrn_member_rel_pretty_name#',   -- pretty_name
	   '#dotlrn.dotlrn_member_rel_pretty_plural#', -- pretty_plural
	   'membership_rel',                           -- supertype
	   'dotlrn_member_rels',                       -- table_name
	   'rel_id',                                   -- id_column
	   'dotlrn_member_rel',                        -- package_name
	   'dotlrn_community',                         -- object_type_one
	   null,                                       -- role_one
	   0,                                          -- min_n_rels_one
	   null::integer,                              -- max_n_rels_one
	   'user',                                     -- object_type_two
	   'member',                                   -- role_two
	   0,                                          -- min_n_rels_two
	   null::integer                               -- max_n_rels_two
    );

    perform acs_rel_type__create_type (
	   'dotlrn_admin_rel',
	   '#dotlrn.dotlrn_admin_rel_pretty_name#',
	   '#dotlrn.dotlrn_admin_rel_pretty_plural#',
	   'dotlrn_member_rel',
	   'dotlrn_admin_rels',
	   'rel_id',
	   'dotlrn_admin_rel',
	   'dotlrn_community',
	   null,
	   0,
	   null::integer,
	   'user',
	   'admin',
	   0,
	   null::integer
    );

    -- all rels to communities must have a portal_id
    perform acs_attribute__create_attribute (
	  'dotlrn_member_rel',
	  'portal_id',
	  'integer',
	  'Page ID',
	  'Page IDs',
	  null, null, null,
	  1,
	  1,
	  null,
	  'type_specific',
	  'f'
    );

    return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();
