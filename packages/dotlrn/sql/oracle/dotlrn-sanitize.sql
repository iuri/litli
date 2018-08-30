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
-- sanitize dotLRN
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2001-09-25
-- @version $Id: dotlrn-sanitize.sql,v 1.4 2006/08/08 21:26:21 donb Exp $
--
-- @note We remember September 11th, 2001
--

declare
begin

    acs_rel_type.drop_type(
        rel_type => 'dotlrn_admin_rel',
        cascade_p => 't'
    );

    -- all rels to communities must have a portal_id
    acs_attribute.drop_attribute(
        object_type => 'dotlrn_member_rel',
        attribute_name => 'portal_id'
    );

    -- drop basic rel_types
    acs_rel_type.drop_type(
        rel_type => 'dotlrn_member_rel',
        cascade_p => 't'
    );

    -- drop roles
    acs_rel_type.drop_role(
        role => 'student'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'student_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'student_pretty_plural'
    );

    acs_rel_type.drop_role(
        role => 'course_assistant'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_assistant_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_assistant_pretty_plural'
    );

    acs_rel_type.drop_role(
        role => 'teaching_assistant'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'teaching_assistant_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'teaching_assistant_pretty_plural'
    );

    acs_rel_type.drop_role(
        role => 'instructor'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'instructor_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'instructor_pretty_plural'
    );

    acs_rel_type.drop_role(
        role => 'course_admin'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_admin_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'course_admin_pretty_plural'
    );

    acs_rel_type.drop_role(
        role => 'admin'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'admin_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'admin_pretty_plural'
    );

    -- drop the dotlrn_club community type
    dotlrn_community_type.del(
        community_type => 'dotlrn_club'
    );

    -- drop the dotlrn_class community type
    dotlrn_community_type.del(
        community_type => 'dotlrn_class_instance'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_font'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_font_size'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_font_color'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_logo_item_id'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'member_pretty_name'
    );

    acs_attribute.drop_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'member_pretty_plural'
    );

    -- drop the base community type
    dotlrn_community_type.del(
        community_type => 'dotlrn_community'
    );

end;
/
show errors
