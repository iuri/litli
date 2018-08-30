-- create or replace invalidated views

create or replace view dotlrn_communities
as
    select dotlrn_communities_all.*
    from dotlrn_communities_all
    where dotlrn_communities_all.archived_p = 'f';

create or replace view dotlrn_communities_not_closed
as
    select dotlrn_communities.*,
           groups.join_policy
    from dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id
    and groups.join_policy <> 'closed';

create or replace view dotlrn_active_communities
as
    select dotlrn_communities.*
    from dotlrn_communities
    where (dotlrn_communities.active_start_date is null or dotlrn_communities.active_start_date < sysdate)
    and (dotlrn_communities.active_end_date is null or dotlrn_communities.active_end_date > sysdate);

create or replace view dotlrn_active_comms_not_closed
as
    select dotlrn_communities.*,
           groups.join_policy
    from dotlrn_active_communities dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id
    and groups.join_policy <> 'closed';

create or replace view dotlrn_class_instances_full
as
    select dotlrn_class_instances.class_instance_id,
           dotlrn_class_instances.class_key,
           dotlrn_class_instances.term_id,
           dotlrn_terms.term_name,
           dotlrn_terms.term_year,
           dotlrn_terms.start_date,
           dotlrn_terms.end_date,
           dotlrn_communities.*,
           dotlrn_community.url(dotlrn_communities.community_id) as url,
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

create or replace view dotlrn_class_instances_current
as
    select *
    from dotlrn_class_instances_full
    where active_end_date >= sysdate
    and active_start_date <= sysdate;

create or replace view dotlrn_class_instances_not_old
as
    select *
    from dotlrn_class_instances_full
    where active_end_date >= sysdate;

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

create or replace view dotlrn_communities_full
as
    select dotlrn_communities.*,
           dotlrn_community.url(dotlrn_communities.community_id) as url,
           groups.group_name,
           groups.join_policy
    from dotlrn_communities,
         groups
    where dotlrn_communities.community_id = groups.group_id;

