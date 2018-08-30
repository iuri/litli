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
-- bootstrap dotLRN
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2001-09-25
-- @version $Id: dotlrn-init.sql,v 1.32 2006/08/08 21:26:21 donb Exp $
--
-- @note We remember September 11th, 2001
--

declare
    foo dotlrn_community_types.community_type%TYPE;
    bar integer;
begin

    -- create the base community type
    foo := dotlrn_community_type.new(
        community_type => 'dotlrn_community',
        parent_type => null,
        pretty_name => '#dotlrn.dotlrn_community_pretty_name#',
        pretty_plural => '#dotlrn.dotlrn_community_pretty_plural#',
        description => '#dotlrn.dotlrn_community_description#'
    );

    -- these are the possible attributes of a community
    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_font',
        datatype => 'string',
        pretty_name => '#dotlrn.Header_Font#',
        pretty_plural => '#dotlrn.Header_Fonts#',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_font_size',
        datatype => 'string',
        pretty_name => '#dotlrn.Header_Font_Size#',
        pretty_plural => '#dotlrn.Header_Font_Sizes#',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_font_color',
        datatype => 'string',
        pretty_name => '#dotlrn.Header_Font_Color#',
        pretty_plural => '#dotlrn.Header_Font_Colors#',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_logo_item_id',
        datatype => 'integer',
        pretty_name => '#dotlrn.Header_Logo_Item_ID#',
        pretty_plural => '#dotlrn.Header_Logo_Item_ID#',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_logo_alt_text',
        datatype => 'integer',
        pretty_name => '#dotlrn.Header_Logo_Alt_Text#',
        pretty_plural => '#dotlrn.Header_Logo_Alt_Text#',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    -- create the dotlrn_class community type
    foo := dotlrn_community_type.new(
        community_type => 'dotlrn_class_instance',
        parent_type => 'dotlrn_community',
        pretty_name => '#dotlrn.dotlrn_class_instance_pretty_name#',
        pretty_plural => '#dotlrn.dotlrn_class_instance_pretty_plural#',
        description => '#dotlrn.dotlrn_class_instance_description#'
    );

    -- create the dotlrn_club community type
    foo := dotlrn_community_type.new(
        community_type => 'dotlrn_club',
        parent_type => 'dotlrn_community',
        pretty_name => '#dotlrn.dotlrn_club_pretty_name#',
        pretty_plural => '#dotlrn.dotlrn_club_pretty_plural#',
        description => '#dotlrn.dotlrn_club_description#'
    );

    update acs_object_types set table_name = 'dotlrn_community', package_name = 'dotlrn_community' where object_type = 'dotlrn_community';
    update acs_object_types set table_name = 'dotlrn_class_instance', package_name = 'dotlrn_class_instance' where object_type = 'dotlrn_class_instance';
    update acs_object_types set table_name = 'dotlrn_club', package_name = 'dotlrn_club' where object_type = 'dotlrn_club';

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'member_pretty_name',
        datatype => 'string',
        pretty_name => 'Member Pretty Name',
        pretty_plural => 'Member Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'member_pretty_plural',
        datatype => 'string',
        pretty_name => 'Member Pretty Plural',
        pretty_plural => 'Member Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    -- create roles
    acs_rel_type.create_role(
        role => 'student',
        pretty_name => '#dotlrn.student_role_pretty_name#',
        pretty_plural => '#dotlrn.student_role_pretty_plural#'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'student_pretty_name',
        datatype => 'string',
        pretty_name => 'Student Pretty Name',
        pretty_plural => 'Student Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'student_pretty_plural',
        datatype => 'string',
        pretty_name => 'Student Pretty Plural',
        pretty_plural => 'Student Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    acs_rel_type.create_role(
        role => 'course_assistant',
        pretty_name => '#dotlrn.course_assistant_role_pretty_name#',
        pretty_plural => '#dotlrn.course_assistant_role_pretty_plural#'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_assistant_pretty_name',
        datatype => 'string',
        pretty_name => 'Course Assistant Pretty Name',
        pretty_plural => 'Course Assistant Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_assistant_pretty_plural',
        datatype => 'string',
        pretty_name => 'Course Assistant Pretty Plural',
        pretty_plural => 'Course Assistant Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    acs_rel_type.create_role(
        role => 'teaching_assistant',
        pretty_name => '#dotlrn.teaching_assistant_role_pretty_name#',
        pretty_plural => '#dotlrn.teaching_assistant_role_pretty_plural#'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'teaching_assistant_pretty_name',
        datatype => 'string',
        pretty_name => 'Teaching Assistant Pretty Name',
        pretty_plural => 'Teaching Assistant Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'teaching_assistant_pretty_plural',
        datatype => 'string',
        pretty_name => 'Teaching Assistant Pretty Plural',
        pretty_plural => 'Teaching Assistant Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    acs_rel_type.create_role(
        role => 'instructor',
        pretty_name => '#dotlrn.instructor_role_pretty_name#',
        pretty_plural => '#dotlrn.instructor_role_pretty_plural#'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'instructor_pretty_name',
        datatype => 'string',
        pretty_name => 'Professor Pretty Name',
        pretty_plural => 'Professor Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'instructor_pretty_plural',
        datatype => 'string',
        pretty_name => 'Professor Pretty Plural',
        pretty_plural => 'Professor Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    acs_rel_type.create_role(
        role => 'course_admin',
        pretty_name => '#dotlrn.course_admin_role_pretty_name#',
        pretty_plural => '#dotlrn.course_admin_role_pretty_plural#'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_admin_pretty_name',
        datatype => 'string',
        pretty_name => 'Course Adminsitrator Pretty Name',
        pretty_plural => 'Course Adminsitrator Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_admin_pretty_plural',
        datatype => 'string',
        pretty_name => 'Course Adminsitrator Pretty Plural',
        pretty_plural => 'Course Adminsitrator Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'admin_pretty_name',
        datatype => 'string',
        pretty_name => 'Administrator Pretty Name',
        pretty_plural => 'Administrator Pretty Name',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'admin_pretty_plural',
        datatype => 'string',
        pretty_name => 'Administrator Pretty Plural',
        pretty_plural => 'Administrator Pretty Plural',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

    -- create basic rel_types
    acs_rel_type.create_type(
        rel_type => 'dotlrn_member_rel',
        supertype => 'membership_rel',
        pretty_name => '#dotlrn.dotlrn_member_rel_pretty_name#',
        pretty_plural => '#dotlrn.dotlrn_member_rel_pretty_plural#',
        package_name => 'dotlrn_member_rel',
        table_name => 'dotlrn_member_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_community', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'member',
        min_n_rels_two => 0, max_n_rels_two => null
    );

    acs_rel_type.create_type(
        rel_type => 'dotlrn_admin_rel',
        supertype => 'dotlrn_member_rel',
        pretty_name => '#dotlrn.dotlrn_admin_rel_pretty_name#',
        pretty_plural => '#dotlrn.dotlrn_admin_rel_pretty_plural#',
        package_name => 'dotlrn_admin_rel',
        table_name => 'dotlrn_admin_rels',        
        id_column => 'rel_id',
        object_type_one => 'dotlrn_community', role_one => null, 
        min_n_rels_one => 0, max_n_rels_one => null,
        object_type_two => 'user', role_two => 'admin',
        min_n_rels_two => 0, max_n_rels_two => null
    );

    -- all rels to communities must have a portal_id
    bar := acs_attribute.create_attribute(
        object_type => 'dotlrn_member_rel',
        attribute_name => 'portal_id',
        datatype => 'integer',
        pretty_name => 'Page ID',
        pretty_plural => 'Page IDs'
    );

end;
/
show errors
