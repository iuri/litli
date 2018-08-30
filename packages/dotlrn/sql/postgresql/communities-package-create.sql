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
-- The DotLRN communities construct
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net
-- @author arjun (arjun@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date September 20th, 2001 (redone)
-- @version $Id: communities-package-create.sql,v 1.11.4.2 2016/08/03 10:08:23 gustafn Exp $
--

select define_function_args ('dotlrn_community_type__new','community_type,parent_type;dotlrn_community,pretty_name,pretty_plural,description,package_id,creation_date,creation_user,creation_ip,context_id');

select define_function_args ('dotlrn_community_type__delete','community_type');
select define_function_args ('dotlrn_community_type__name','community_type');



--
-- procedure dotlrn_community_type__new/5
--
CREATE OR REPLACE FUNCTION dotlrn_community_type__new(
   p_community_type varchar,
   p_parent_type varchar,
   p_pretty_name varchar,
   p_pretty_plural varchar,
   p_description varchar
) RETURNS varchar AS $$
--
-- dotlrn_community_type__new/5 maybe obsolete, when we define proper defaults for /10
--
DECLARE
BEGIN
        return dotlrn_community_type__new(
            p_community_type,
            p_parent_type,
            p_pretty_name,
            p_pretty_plural,
            p_description,
            null,
            null,
            null,
            null,
            null
        );
END;

$$ LANGUAGE plpgsql;



--
-- procedure dotlrn_community_type__new/10
--
CREATE OR REPLACE FUNCTION dotlrn_community_type__new(
   p_community_type varchar,
   p_parent_type varchar, -- default 'dotlrn_community'
   p_pretty_name varchar,
   p_pretty_plural varchar,
   p_description varchar,
   p_package_id integer,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer

) RETURNS varchar AS $$
DECLARE
        v_parent_object_type acs_object_types.object_type%TYPE;
        v_unique_name acs_objects.object_id%TYPE;
BEGIN
        if p_parent_type is null then
            v_parent_object_type:= 'application_group';
        else
            v_parent_object_type:= p_parent_type;
        end if;

        select nextval('t_acs_object_id_seq')
        into v_unique_name
        from dual;

        PERFORM acs_object_type__create_type (
            p_community_type,
            p_community_type,
            p_community_type,
	    v_parent_object_type,
            cast(v_unique_name as varchar),
            cast(v_unique_name as varchar),
            cast(v_unique_name as varchar),
	    'f',
	    null,
            'acs_group.name'
        );

        insert
        into group_types
        (group_type, default_join_policy)
        values
        (p_community_type, 'closed');

        insert
        into dotlrn_community_types
        (community_type, 
	 pretty_name, 
	 description, 
	 package_id, 
	 supertype)
        values
        (p_community_type, 
	 p_pretty_name, 
	 p_description, 
	 p_package_id, 
	 p_parent_type);

        return p_community_type;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_community_type__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_community_type__delete(
   p_community_type varchar
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_community_types
        where community_type = p_community_type;

        delete
        from group_types
        where group_type = p_community_type;

        PERFORM acs_object_type__drop_type(p_community_type, 'f');
        return 0;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_community_type__name/1
--
CREATE OR REPLACE FUNCTION dotlrn_community_type__name(
   p_community_type varchar
) RETURNS varchar AS $$
DECLARE
        v_name dotlrn_community_types.pretty_name%TYPE;
BEGIN
        select dotlrn_community_types.pretty_name
        into v_name
        from dotlrn_community_types
        where dotlrn_community_types.community_type = p_community_type;

        return v_name;
END;

$$ LANGUAGE plpgsql;


-- dotlrn_community

select define_function_args('dotlrn_community__new','community_id,parent_community_id,community_type,community_key,pretty_name,description,archived_p;f,portal_id,non_member_portal_id,package_id,join_policy,creation_date,creation_user,creation_ip,context_id');



--
-- procedure dotlrn_community__new/15
--
CREATE OR REPLACE FUNCTION dotlrn_community__new(
   p_community_id integer,
   p_parent_community_id integer,
   p_community_type varchar,
   p_community_key varchar,
   p_pretty_name varchar,
   p_description varchar,
   p_archived_p boolean, -- default 'f'
   p_portal_id integer,
   p_non_member_portal_id integer,
   p_package_id integer,
   p_join_policy varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer

) RETURNS integer AS $$
DECLARE
        c_id                            integer;
        v_group_type_exists_p           integer;
BEGIN

        c_id := application_group__new (
            p_community_id,
            p_community_type,
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            null,
            null,
            p_community_key,
            p_package_id,
            p_join_policy,
            p_context_id
        );

        insert into dotlrn_communities_all
          (community_id, 
           parent_community_id,
           community_type, 
           community_key, 
           pretty_name,  
           description, 
           package_id, 
           portal_id,
           archived_p,
           non_member_portal_id)
        values
          (c_id, 
           p_parent_community_id, 
           p_community_type, 
           p_community_key, 
           p_pretty_name, 
           p_description,    
           p_package_id, 
           p_portal_id,
           p_archived_p,
           p_non_member_portal_id);

        return c_id;        
END;
$$ LANGUAGE plpgsql;

select define_function_args('dotlrn_community__set_active_dates','community_id,start_date,end_date');



--
-- procedure dotlrn_community__set_active_dates/3
--
CREATE OR REPLACE FUNCTION dotlrn_community__set_active_dates(
   p_community_id integer,
   p_start_date date,
   p_end_date date
) RETURNS integer AS $$
DECLARE
BEGIN
        update dotlrn_communities_all
        set active_start_date = p_start_date,
            active_end_date = p_end_date
        where community_id = p_community_id;

        return p_community_id;
END;

$$ LANGUAGE plpgsql;

select define_function_args('dotlrn_community__delete','community_id');



--
-- procedure dotlrn_community__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_community__delete(
   p_community_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_communities
        where community_id = p_community_id;

        PERFORM acs_group__delete(p_community_id);
        return 0;
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_community__name','community_id');



--
-- procedure dotlrn_community__name/1
--
CREATE OR REPLACE FUNCTION dotlrn_community__name(
   p_community_id integer
) RETURNS varchar AS $$
DECLARE
BEGIN
        return acs_group__name(p_community_id);
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_community__member_p','community_id,party_id');



--
-- procedure dotlrn_community__member_p/2
--
CREATE OR REPLACE FUNCTION dotlrn_community__member_p(
   p_community_id integer,
   p_party_id integer
) RETURNS boolean AS $$
DECLARE
        v_member_p			  boolean;
BEGIN
       select (count(*) = 0)
        into v_member_p
        from dual
        where exists (select 1
                      from dotlrn_member_rels_approved
                      where dotlrn_member_rels_approved.user_id = dotlrn_community.member_p.party_id
                      and dotlrn_member_rels_approved.community_id = dotlrn_community.member_p.community_id);

        return v_member_p;

END;
$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_community__admin_p','community_id,party_id');



--
-- procedure dotlrn_community__admin_p/2
--
CREATE OR REPLACE FUNCTION dotlrn_community__admin_p(
   p_community_id integer,
   p_party_id integer
) RETURNS boolean AS $$
DECLARE
        r_rv				  boolean;
BEGIN
	-- THIS NEEDS TO BE CHECKED!
	-- chak, 2002-07-01
	select CASE
		WHEN acs_permission__permission_p(p_community_id, p_party_id, 'dotlrn_admin_community') is false
		THEN acs_permission__permission_p(p_community_id,p_party_id,'admin')
		ELSE true
	     END
	   into r_rv
           from dual;

	return r_rv;
END;
$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_community__url','community_id');



--
-- procedure dotlrn_community__url/1
--
CREATE OR REPLACE FUNCTION dotlrn_community__url(
   p_community_id integer
) RETURNS varchar AS $$
DECLARE
        v_node_id		      site_nodes.node_id%TYPE;
BEGIN
        select site_nodes.node_id into v_node_id
        from dotlrn_communities_all,
             site_nodes
        where dotlrn_communities_all.community_id = p_community_id
        and site_nodes.object_id = dotlrn_communities_all.package_id;

	return site_node__url(v_node_id);

--        exception
--            when no_data_found then
--                return ';
END;

$$ LANGUAGE plpgsql;




-- added
select define_function_args('dotlrn_community__has_subcomm_p','community_id');

--
-- procedure dotlrn_community__has_subcomm_p/1
--
CREATE OR REPLACE FUNCTION dotlrn_community__has_subcomm_p(
   p_community_id integer
) RETURNS boolean AS $$
DECLARE
	r_rv boolean;
BEGIN
	select (count(*) = 0)
	  into r_rv
	  from dotlrn_communities_all 
         where dotlrn_communities_all.community_id = p_community_id;
	 
	 return r_rv;
END;
$$ LANGUAGE plpgsql;

create view dotlrn_communities_full
as
    select dotlrn_communities.*,
           dotlrn_community__url(dotlrn_communities.community_id) as url,
           groups.group_name,
           groups.join_policy
    from dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id;
