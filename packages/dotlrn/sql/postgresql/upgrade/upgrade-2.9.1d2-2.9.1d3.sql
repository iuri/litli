drop function if exists dotlrn_community__new(
   p_community_id integer,
   p_parent_community_id integer,
   p_community_type varchar,
   p_community_key varchar,
   p_pretty_name varchar,
   p_description varchar,
   p_archived_p character varying,
   p_portal_id integer,
   p_non_member_portal_id integer,
   p_package_id integer,
   p_join_policy varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer
   );
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
