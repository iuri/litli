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
-- create dotLRN clubs model
--
-- @author yon (yon@openforce.net)
-- @creation-date August 18th, 2001
-- @version $Id: clubs-create.sql,v 1.6 2006/08/08 21:26:21 donb Exp $
--

create table dotlrn_clubs (
    club_id                     constraint dotlrn_clubs_club_id_fk
                                references dotlrn_communities_all (community_id)
                                constraint dotlrn_clubs_pk
                                primary key
);

create or replace view dotlrn_clubs_full
as
    select dotlrn_clubs.club_id,
           dotlrn_communities.*,
           dotlrn_community.url(dotlrn_communities.community_id) as url,
           groups.join_policy
    from dotlrn_communities,
         dotlrn_clubs,
         groups
    where dotlrn_communities.community_id = dotlrn_clubs.club_id
    and dotlrn_communities.community_id = groups.group_id;

create or replace package dotlrn_club
is
    function new (
        club_id in dotlrn_clubs.club_id%TYPE default null,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_clubs.club_id%TYPE;

    procedure del (
        club_id in dotlrn_clubs.club_id%TYPE
    );
end;
/
show errors

create or replace package body dotlrn_club
is
    function new (
        club_id in dotlrn_clubs.club_id%TYPE default null,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_clubs.club_id%TYPE
    is
        v_club_id integer;
    begin
        v_club_id := dotlrn_community.new(
            community_id => club_id,
            community_type => 'dotlrn_club',
            community_key => community_key,
            pretty_name => pretty_name,
            description => description,
            package_id => package_id,
            portal_id => portal_id,
            non_member_portal_id => non_member_portal_id,
            join_policy => join_policy,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_clubs (club_id)
        values (v_club_id);

        return v_club_id;
    end;

    procedure del (
        club_id in dotlrn_clubs.club_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_clubs
        where club_id = dotlrn_club.del.club_id;

        dotlrn_community.del(community_id => club_id);
    end;
end;
/
show errors
