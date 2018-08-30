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
-- @author dan chak (chak@openforce.net)
-- @creation-date 2001-09-25
-- ported 2002-07-01
-- @version $Id: dotlrn-sanitize.sql,v 1.4 2013/11/01 21:08:29 gustafn Exp $
--
-- @note We remember September 11th, 2001
--

CREATE OR REPLACE FUNCTION inline_0()  RETURNS integer AS $$
BEGIN

    perform acs_rel_type__drop_type(
        'dotlrn_admin_rel',
        't'
    );

    -- all rels to communities must have a portal_id
    perform acs_attribute__drop_attribute(
        'dotlrn_member_rel',
        'portal_id'
    );

    -- drop basic rel_types
    perform acs_rel_type__drop_type(
        'dotlrn_member_rel',
        't'
    );

    -- drop roles
    perform acs_rel_type__drop_role(
        'student'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'student_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'student_pretty_plural'
    );

    perform acs_rel_type__drop_role(
        'course_assistant'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'course_assistant_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'course_assistant_pretty_plural'
    );

    perform acs_rel_type__drop_role(
        'teaching_assistant'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'teaching_assistant_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'teaching_assistant_pretty_plural'
    );

    perform acs_rel_type__drop_role(
        'instructor'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'instructor_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'instructor_pretty_plural'
    );

    perform acs_rel_type__drop_role(
        'course_admin'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'course_admin_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'course_admin_pretty_plural'
    );

    perform acs_rel_type__drop_role(
        'admin'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'admin_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'admin_pretty_plural'
    );

    -- drop the dotlrn_club community type
    perform dotlrn_community_type__delete(
        'dotlrn_club'
    );

    -- drop the dotlrn_class community type
    perform dotlrn_community_type__delete(
        'dotlrn_class_instance'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'header_font'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'header_font_size'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'header_font_color'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'header_logo_item_id'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'member_pretty_name'
    );

    perform acs_attribute__drop_attribute(
        'dotlrn_community',
        'member_pretty_plural'
    );

    -- drop the base community type
    perform dotlrn_community_type__delete(
        'dotlrn_community'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

