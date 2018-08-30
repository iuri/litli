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
-- Create the dotLRN Users package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: users-create.sql,v 1.5 2006/08/08 21:26:22 donb Exp $
--

create table dotlrn_user_profile_rels (
    rel_id                      integer
                                constraint dotlrn_usr_prfl_rels_rel_id_fk
                                references dotlrn_user_profile_rels (rel_id)
                                constraint dotlrn_user_profile_rels_pk
                                primary key,
    portal_id                   integer
				constraint dotlrn_user_p_rels_portal_fk
                                references portals (portal_id)
                                constraint dotlrn_user_p_rels_portal_nn
                                not null,
    theme_id                    integer
				constraint dotlrn_user_p_rels_theme_id_fk
                                references portal_element_themes (theme_id),
    id                          varchar(100),
    site_template_id		integer
			        constraint dotlrn_user_p_rels_site_template_id_fk
				references dotlrn_site_templates(site_template_id)
);

create table dotlrn_user_types (
    type                        varchar(100)
                                constraint dotlrn_user_types_pk
                                primary key,
    pretty_name                 varchar(200),
    rel_type                    varchar(100)
                                constraint dotlrn_user_types_rel_type_fk
                                references acs_rel_types (rel_type)
                                constraint dotlrn_user_types_rel_type_nn
                                not null,
    group_id                    integer
                                constraint dotlrn_user_types_group_id_fk
                                references profiled_groups (group_id)
                                constraint dotlrn_user_types_group_id_nn
                                not null,
    segment_id                  integer
                                constraint dotlrn_user_types_segment_fk
                                references rel_segments (segment_id)
                                constraint dotlrn_user_types_segment_nn
                                not null
);

create view dotlrn_users
as
    select acs_rels.rel_id,
           dotlrn_user_profile_rels.portal_id,
           dotlrn_user_profile_rels.theme_id,
           dotlrn_user_profile_rels.id,
           dotlrn_user_profile_rels.site_template_id,
           users.user_id,
           persons.first_names,
           persons.last_name,
           parties.email,
           dotlrn_user_types.type,
           dotlrn_user_types.pretty_name as pretty_type,
           dotlrn_user_types.rel_type,
           dotlrn_user_types.group_id,
           dotlrn_user_types.segment_id
    from dotlrn_user_profile_rels,
         dotlrn_user_types,
         acs_rels,
         parties,
         users,
         persons
    where dotlrn_user_profile_rels.rel_id = acs_rels.rel_id
    and acs_rels.object_id_one = dotlrn_user_types.group_id
    and acs_rels.object_id_two = parties.party_id
    and parties.party_id = users.user_id
    and users.user_id = persons.person_id;

\i user-profile-provider-create.sql
\i users-init.sql
\i users-package-create.sql

-- create administrators
\i admins-create.sql

-- create professors
\i professors-create.sql

-- create students
\i students-create.sql

-- create external users
\i externals-create.sql

