--
-- Alter caveman style booleans (type character(1)) to real SQL boolean types.
--
-- Unforunately, all attributes of the three tables affected are used
-- (blindly) in a bunch of views, which are as well used in other
-- views. So we have to drop and recreate many dotlrn views.  If your
-- installation have modifications to these views, make sure to
-- recreate these later correctly.
--

drop view dotlrn_communities_full;
drop view dotlrn_clubs_full;
drop view dotlrn_class_instances_current;
drop view dotlrn_class_instances_not_old;
drop view dotlrn_class_instances_full;
drop view dotlrn_communities_not_closed;
drop view dotlrn_active_comms_not_closed;
drop view dotlrn_active_communities;
drop view dotlrn_communities;

ALTER TABLE dotlrn_applets
      DROP constraint IF EXISTS dotlrn_applets_active_p_ck,
      ALTER COLUMN active_p DROP DEFAULT,
      ALTER COLUMN active_p TYPE boolean
      USING active_p::boolean,
      ALTER COLUMN active_p SET DEFAULT true;

ALTER TABLE dotlrn_community_applets
      DROP constraint IF EXISTS dotlrn_ca_active_p_ck,
      ALTER COLUMN active_p DROP DEFAULT,
      ALTER COLUMN active_p TYPE boolean
      USING active_p::boolean,
      ALTER COLUMN active_p SET DEFAULT true;

ALTER TABLE dotlrn_communities_all
      DROP constraint IF EXISTS dotlrn_c_archived_p_ck,
      ALTER COLUMN archived_p DROP DEFAULT,
      ALTER COLUMN archived_p TYPE boolean
      USING archived_p::boolean,
      ALTER COLUMN archived_p SET DEFAULT false;

create view dotlrn_communities
as
    select dotlrn_communities_all.*
    from dotlrn_communities_all
    where dotlrn_communities_all.archived_p = false;

create view dotlrn_communities_not_closed
as
    select dotlrn_communities.*,
           groups.join_policy
    from dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id
    and groups.join_policy <> 'closed';
    
create view dotlrn_active_communities
as
    select *
    from dotlrn_communities
    where (active_start_date is null or active_start_date < now())
    and (active_end_date is null or active_end_date > now());

create view dotlrn_active_comms_not_closed
as
    select dotlrn_communities.*,
           groups.join_policy
    from dotlrn_active_communities dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id
    and groups.join_policy <> 'closed';

create view dotlrn_communities_full
as
    select dotlrn_communities.*,
           dotlrn_community__url(dotlrn_communities.community_id) as url,
           groups.group_name,
           groups.join_policy
    from dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id;

create view dotlrn_class_instances_full
as
    select dotlrn_class_instances.class_instance_id,
           dotlrn_class_instances.class_key,
           dotlrn_class_instances.term_id,
           dotlrn_terms.term_name,
           dotlrn_terms.term_year,
           dotlrn_terms.start_date,
           dotlrn_terms.end_date,
           dotlrn_communities.*,
           dotlrn_community__url(dotlrn_communities.community_id) as url,
           dotlrn_classes_full.pretty_name as class_name,
           dotlrn_classes_full.url as class_url,
           dotlrn_classes_full.department_key,
           dotlrn_departments_full.pretty_name as department_name,
           dotlrn_departments_full.url as department_url,
           groups.join_policy
    from dotlrn_communities,
         dotlrn_class_instances,
         dotlrn_terms,
         dotlrn_classes_full,
         dotlrn_departments_full,
         groups
    where dotlrn_communities.community_id = dotlrn_class_instances.class_instance_id
    and dotlrn_class_instances.term_id = dotlrn_terms.term_id
    and dotlrn_communities.community_type = dotlrn_classes_full.class_key
    and dotlrn_classes_full.department_key = dotlrn_departments_full.department_key
    and dotlrn_communities.community_id = groups.group_id;

create view dotlrn_class_instances_current
as
    select *
    from dotlrn_class_instances_full
    where now() between active_start_date and active_end_date;

create view dotlrn_class_instances_not_old
as
    select *
    from dotlrn_class_instances_full
    where active_end_date >= now();

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
