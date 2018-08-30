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
-- The DotLRN communities membership constructs
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @creation-date  November 6th, 2001
-- @version $Id: community-memberships-create.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

create table dotlrn_member_rels (
    rel_id                      integer
                                constraint dotlrn_member_rels_rel_id_fk
                                references membership_rels (rel_id)
                                constraint dotlrn_member_rels_rel_id_pk
                                primary key
);                                          

create view dotlrn_member_rels_full
as
    select acs_rels.rel_id as rel_id,
           acs_rels.object_id_one as community_id,
           acs_rels.object_id_two as user_id,
           acs_rels.rel_type,
           (select acs_rel_types.role_two
            from acs_rel_types
            where acs_rel_types.rel_type = acs_rels.rel_type) as role,
           membership_rels.member_state
    from dotlrn_member_rels,
         acs_rels,
         membership_rels
    where dotlrn_member_rels.rel_id = acs_rels.rel_id
    and acs_rels.rel_id = membership_rels.rel_id;

create view dotlrn_member_rels_approved
as
    select *
    from dotlrn_member_rels_full
    where member_state = 'approved';

create table dotlrn_admin_rels (
    rel_id                      integer
                                constraint dotlrn_admin_rels_rel_id_fk
                                references dotlrn_member_rels (rel_id)
                                constraint dotlrn_admin_rels_rel_id_pk
                                primary key
);

create view dotlrn_admin_rels_full
as
    select dotlrn_member_rels_full.rel_id,
           dotlrn_member_rels_full.community_id,
           dotlrn_member_rels_full.user_id,
           dotlrn_member_rels_full.rel_type,
           dotlrn_member_rels_full.role,
           dotlrn_member_rels_full.member_state
    from dotlrn_member_rels_full,
         dotlrn_admin_rels
    where dotlrn_member_rels_full.rel_id = dotlrn_admin_rels.rel_id;

-- Store emails to be sent when user joins a community
create table dotlrn_member_emails (
        email_id	serial primary key,
        community_id    integer references dotlrn_communities_all
                        on delete cascade,
-- Might be useful
        type            text default 'on join',
        from_addr       text,
        subject         text,
        email           text,
        enabled_p       boolean default 'f',
	                constraint dotlrn_member_emails_un unique(community_id, type)
);
