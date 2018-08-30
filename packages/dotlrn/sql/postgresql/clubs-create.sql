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
-- The dotLRN basic system
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date August 18th, 2001
-- @version $Id: clubs-create.sql,v 1.6 2013/11/01 21:08:29 gustafn Exp $
--

create table dotlrn_clubs (
    club_id                     integer
                                constraint dotlrn_clubs_club_id_fk
                                references dotlrn_communities_all (community_id)
                                constraint dotlrn_clubs_pk
                                primary key
);

create view dotlrn_clubs_full
as
    select dotlrn_clubs.club_id,
	   dotlrn_communities.*,
           dotlrn_community__url(dotlrn_communities.community_id::integer) as url,
           groups.join_policy
    from dotlrn_communities,
         dotlrn_clubs,
         groups
    where dotlrn_communities.community_id = dotlrn_clubs.club_id
    and dotlrn_communities.community_id = groups.group_id;


select define_function_args ('dotlrn_club__new','club_id,community_key,pretty_name,description,package_id,portal_id,non_member_portal_id,join_policy,creation_date,creation_user,creation_ip,context_id');

select define_function_args ('dotlrn_club__delete','club_id');




--
-- procedure dotlrn_club__new/12
--
CREATE OR REPLACE FUNCTION dotlrn_club__new(
   p_club_id integer,
   p_community_key varchar,
   p_pretty_name varchar,
   p_description varchar,
   p_package_id integer,
   p_portal_id integer,
   p_non_member_portal_id integer,
   p_join_policy varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer
) RETURNS integer AS $$
DECLARE
        v_club_id                        integer;
BEGIN
        v_club_id := dotlrn_community__new(
            p_club_id,
            null,
            'dotlrn_club',
            p_community_key,
            p_pretty_name,
            p_description,
            'f',
            p_portal_id,
            p_non_member_portal_id,
            p_package_id,
            p_join_policy,
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            p_context_id
        );

        insert
        into dotlrn_clubs (club_id)
        values (v_club_id);

        return v_club_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_club__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_club__delete(
   p_club_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_clubs
        where club_id = p_club_id;

        PERFORM dotlrn_community__delete(p_club_id);
        return(0);
END;

$$ LANGUAGE plpgsql;

