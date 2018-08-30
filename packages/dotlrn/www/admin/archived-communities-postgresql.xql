<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <!-- AEG: This query has gotten pretty nasty.  Basically we need
         to provide the site-wide admin more information about
         communities than just the name.  Time information is key,
         so we try to associate classes with a term.  If the
         community is not a class, we look to see if the parent
         is a class.  We don't do the full recursion for
         sub-subgroups etc.  We could push that into some expensive
         plsql if the current version turns out to be too hackish.
         Or maybe creation date is all we need, and we can throw
         the rest out?
    -->
    <fullquery name="select_archived_comms">
        <querytext>
            select child.community_id,
                   child.pretty_name, 
                   child.description,
                   dotlrn_community__url(child.community_id) as url,
                   parent.community_id as parent_community_id,
                   parent.pretty_name as parent_pretty_name,
                   case when parent.community_id is null then null
                     else dotlrn_community__url(parent.community_id) end
                     as parent_url,
                   class.term_name,
                   class.term_year,
                   parent_class.term_name as parent_term_name,
                   parent_class.term_year as parent_term_year,
                   to_char(o.creation_date, 'Mon YYYY') as creation_date,
                   to_char(o.last_modified, 'Mon YYYY') as last_modified
            from dotlrn_communities_all child left outer join
                 dotlrn_communities_all parent using (community_id),
                 dotlrn_communities_all child1 left outer join
                 (select i.class_instance_id,
                         t.term_name,
                         t.term_year
                  from dotlrn_class_instances i,
                       dotlrn_terms t
                  where t.term_id = i.term_id) class on child1.community_id = class.class_instance_id,
                 dotlrn_communities_all child2 left outer join
                 (select i.class_instance_id,
                         t.term_name,
                         t.term_year
                  from dotlrn_class_instances i,
                       dotlrn_terms t
                  where t.term_id = i.term_id) parent_class on child2.community_id = parent_class.class_instance_id,
                  acs_objects o
            where child.archived_p = 't' 
              and child1.archived_p = 't' and child2.archived_p = 't' and child1.community_id = child.community_id and child2.community_id = child.community_id              
              and o.object_id = child.community_id
            order by child.pretty_name
        </querytext>
    </fullquery>

</queryset>
