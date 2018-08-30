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
-- create the dotLRN classes model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @creation-date 2001-08-18
-- @version $Id: classes-create.sql,v 1.7 2006/08/08 21:26:21 donb Exp $
--

create table dotlrn_departments (
    department_key              constraint dotlrn_departments_dept_key_fk
                                references dotlrn_community_types (community_type)
                                constraint dotlrn_departments_pk
                                primary key,
    external_url                varchar2(4000)
);

create or replace view dotlrn_departments_full
as
    select dotlrn_departments.department_key,
           dotlrn_community_types.pretty_name,
           dotlrn_community_types.description,
           dotlrn_community_types.package_id,
           dotlrn_community_types.supertype,
           (select site_node.url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = dotlrn_community_types.package_id) as url,
           dotlrn_departments.external_url
    from dotlrn_departments,
         dotlrn_community_types
    where dotlrn_departments.department_key = dotlrn_community_types.community_type;

create table dotlrn_terms (
    term_id                     integer
                                constraint dotlrn_terms_pk
                                primary key,
    term_name                   varchar2(20)
                                constraint dotlrn_t_term_name_nn
                                not null,
    term_year                   varchar2(9)
                                constraint dotlrn_t_term_year_nn
                                not null,
    start_date                  date
                                default sysdate
                                constraint dotlrn_t_start_date_nn
                                not null,
    end_date                    date
                                default (sysdate + 180)
                                constraint dotlrn_t_end_date_nn
                                not null
);

create table dotlrn_classes (
    class_key                   constraint dotlrn_classes_class_key_fk
                                references dotlrn_community_types (community_type)
                                constraint dotlrn_classes_pk
                                primary key,
    department_key              constraint dotlrn_classes_dept_key_fk
                                references dotlrn_departments (department_key)
                                constraint dotlrn_classes_dept_key_nn
                                not null
);

create or replace view dotlrn_classes_full
as
    select dotlrn_classes.class_key,
           dotlrn_community_types.pretty_name,
           dotlrn_community_types.description,
           dotlrn_community_types.package_id,
           dotlrn_community_types.supertype,
           (select site_node.url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = dotlrn_community_types.package_id) as url,
           dotlrn_classes.department_key
    from dotlrn_classes,
         dotlrn_community_types
    where dotlrn_classes.class_key = dotlrn_community_types.community_type;

create table dotlrn_class_instances (
    class_instance_id           constraint dotlrn_ci_class_instance_id_fk
                                references dotlrn_communities_all (community_id)
                                constraint dotlrn_class_instances_pk
                                primary key,
    class_key                   constraint dotlrn_ci_class_key_fk
                                references dotlrn_classes (class_key)
                                constraint dotlrn_ci_class_key_nn
                                not null,
    term_id                     constraint dotlrn_ci_term_id_fk
                                references dotlrn_terms (term_id)
                                constraint dotlrn_ci_term_id_nn
                                not null
);

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

create or replace package dotlrn_department
is
    function new (
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_departments.department_key%TYPE;

    procedure del (
        department_key in dotlrn_departments.department_key%TYPE
    );
end;
/
show errors

create or replace package body dotlrn_department
is
    function new (
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_departments.department_key%TYPE
    is
        v_department_key dotlrn_departments.department_key%TYPE;
    begin
        v_department_key := dotlrn_community_type.new (
            community_type => department_key,
            parent_type => 'dotlrn_class_instance',
            pretty_name => pretty_name,
            pretty_plural => pretty_plural,
            description => description,
            package_id => package_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_departments
        (department_key) values (v_department_key);

        return v_department_key;
    end;

    procedure del (
        department_key in dotlrn_departments.department_key%TYPE
    )
    is
    begin
        delete
        from dotlrn_departments
        where department_key = department_key;

        dotlrn_community_type.del(department_key);
    end;
end;
/
show errors

create or replace package dotlrn_class
is
    function new (
        class_key in dotlrn_classes.class_key%TYPE,
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_classes.class_key%TYPE;

    procedure del (
        class_key in dotlrn_classes.class_key%TYPE
    );
end;
/
show errors

create or replace package body dotlrn_class
is
    function new (
        class_key in dotlrn_classes.class_key%TYPE,
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_classes.class_key%TYPE
    is
        v_class_key dotlrn_classes.class_key%TYPE;
    begin
        v_class_key := dotlrn_community_type.new (
            community_type => class_key,
            parent_type => department_key,
            pretty_name => pretty_name,
            pretty_plural => pretty_plural,
            description => description,
            package_id => package_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_classes
        (class_key, department_key) values (v_class_key, department_key);

        return v_class_key;
    end;

    procedure del (
        class_key in dotlrn_classes.class_key%TYPE
    )
    is
    begin
        delete
        from dotlrn_classes
        where class_key = class_key;

        dotlrn_community_type.del(class_key);
    end;
end;
/
show errors

create or replace package dotlrn_class_instance
is
    function new (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE default null,
        class_key in dotlrn_class_instances.class_key%TYPE,
        term_id in dotlrn_class_instances.term_id%TYPE,
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
    ) return dotlrn_class_instances.class_instance_id%TYPE;

    procedure del (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE
    ); 
end;
/
show errors

create or replace package body dotlrn_class_instance
is
    function new (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE default null,
        class_key in dotlrn_class_instances.class_key%TYPE,
        term_id in dotlrn_class_instances.term_id%TYPE,
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
    ) return dotlrn_class_instances.class_instance_id%TYPE
    is
        v_class_instance_id dotlrn_class_instances.class_instance_id%TYPE;
    begin
        v_class_instance_id := dotlrn_community.new (
            community_id => class_instance_id,
            community_type => class_key,
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
        into dotlrn_class_instances
        (class_instance_id, class_key, term_id)
        values
        (v_class_instance_id, class_key, term_id);

        return v_class_instance_id;
    end;

    procedure del (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_class_instances
        where class_instance_id= class_instance_id;

        dotlrn_community.del(community_id => class_instance_id);
    end;
end;
/
show errors
