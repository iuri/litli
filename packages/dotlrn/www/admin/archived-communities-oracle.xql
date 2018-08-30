<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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
                   dotlrn_community.url(child.community_id) as url,
                   parent.community_id as parent_community_id,
                   parent.pretty_name as parent_pretty_name,
                   case when parent.community_id is null then null
                     else dotlrn_community.url(parent.community_id) end
                     as parent_url,
                   class.term_name,
                   class.term_year,
                   parent_class.term_name as parent_term_name,
                   parent_class.term_year as parent_term_year,
                   to_char(o.creation_date, 'Mon YYYY') as creation_date,
                   to_char(o.last_modified, 'Mon YYYY') as last_modified
            from dotlrn_communities_all child,
                 dotlrn_communities_all parent,
                 (select i.class_instance_id,
                         t.term_name,
                         t.term_year
                  from dotlrn_class_instances i,
                       dotlrn_terms t
                  where t.term_id = i.term_id) class,
                 (select i.class_instance_id,
                         t.term_name,
                         t.term_year
                  from dotlrn_class_instances i,
                       dotlrn_terms t
                  where t.term_id = i.term_id) parent_class,
                  acs_objects o
            where child.archived_p = 't'
              and child.parent_community_id = parent.community_id(+)
              and child.community_id = class.class_instance_id(+)
              and child.parent_community_id = parent_class.class_instance_id(+)
              and o.object_id = child.community_id
            order by child.pretty_name
        </querytext>
    </fullquery>

</queryset>
