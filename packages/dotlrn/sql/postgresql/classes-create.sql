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
-- @creation-date 2001-08-18
-- @version $Id: classes-create.sql,v 1.7 2013/11/01 21:08:29 gustafn Exp $
--

create table dotlrn_departments (
    department_key              varchar(100) 
                                constraint dotlrn_departments_dept_key_fk
                                references dotlrn_community_types (community_type)
                                constraint dotlrn_departments_pk
                                primary key,
    external_url                varchar(4000)
);

create view dotlrn_departments_full
as
    select dotlrn_departments.department_key,
           dotlrn_community_types.pretty_name,
           dotlrn_community_types.description,
           dotlrn_community_types.package_id,
           dotlrn_community_types.supertype,
           (select site_node__url(site_nodes.node_id)
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
    term_name                   varchar(20)
                                constraint dotlrn_t_term_name_nn
                                not null,
    term_year                   varchar(9)
                                constraint dotlrn_t_term_year_nn
                                not null,
    start_date                  date
                                default now()
                                constraint dotlrn_t_start_date_nn
                                not null,
    end_date                    date
                                default (now() + '180 days'::interval)
                                constraint dotlrn_t_end_date_nn
                                not null
);

create table dotlrn_classes (
    class_key                   varchar(100) 
				constraint dotlrn_classes_class_key_fk
                                references dotlrn_community_types (community_type)
                                constraint dotlrn_classes_pk
                                primary key,
    department_key              varchar(100) 
				constraint dotlrn_classes_dept_key_fk
                                references dotlrn_departments (department_key)
                                constraint dotlrn_classes_dept_key_nn
                                not null
);

create view dotlrn_classes_full
as
    select dotlrn_classes.class_key,
           dotlrn_community_types.pretty_name,
           dotlrn_community_types.description,
           dotlrn_community_types.package_id,
           dotlrn_community_types.supertype,
           (select site_node__url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = dotlrn_community_types.package_id) as url,
           dotlrn_classes.department_key
    from dotlrn_classes,
         dotlrn_community_types
    where dotlrn_classes.class_key = dotlrn_community_types.community_type;

create table dotlrn_class_instances (
    class_instance_id           integer 
				constraint dotlrn_ci_class_instance_id_fk
                                references dotlrn_communities_all (community_id)
                                constraint dotlrn_class_instances_pk
                                primary key,
    class_key                   varchar(100) 
				constraint dotlrn_ci_class_key_fk
                                references dotlrn_classes (class_key)
                                constraint dotlrn_ci_class_key_nn
                                not null,
    term_id                     integer
				constraint dotlrn_ci_term_id_fk
                                references dotlrn_terms (term_id)
                                constraint dotlrn_ci_term_id_nn
                                not null
);

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


select define_function_args ('dotlrn_department__new','department_key,pretty_name,pretty_plural,description,package_id,creation_date,creation_user,creation_ip,context_id');

select define_function_args ('dotlrn_department__delete', 'department_key');




--
-- procedure dotlrn_department__new/9
--
CREATE OR REPLACE FUNCTION dotlrn_department__new(
   p_department_key varchar,
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
        v_department_key dotlrn_departments.department_key%TYPE;
BEGIN
        v_department_key := dotlrn_community_type__new (
            p_department_key,
            'dotlrn_class_instance',
            p_pretty_name,
            p_pretty_plural,
            p_description,
            p_package_id,
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            p_context_id
        );

        insert
        into dotlrn_departments
        (department_key) values (v_department_key);

        return v_department_key;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_department__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_department__delete(
   p_department_key varchar
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_departments
        where department_key = p_department_key;

        PERFORM dotlrn_community_type__delete(p_department_key);
        return(0);
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_class__new','class_key,department_key,pretty_name,pretty_plural,description,package_id,creation_date,creation_user,creation_ip,context_id');

select define_function_args('dotlrn_class__delete','class_key');




--
-- procedure dotlrn_class__new/10
--
CREATE OR REPLACE FUNCTION dotlrn_class__new(
   p_class_key varchar,
   p_department_key varchar,
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
        v_class_key dotlrn_classes.class_key%TYPE;
BEGIN
        v_class_key := dotlrn_community_type__new (
            p_class_key,
            p_department_key,
            p_pretty_name,
            p_pretty_plural,
            p_description,
            p_package_id,
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            p_context_id
        );

        insert
        into dotlrn_classes
        (class_key, department_key) values (v_class_key, p_department_key);

        return v_class_key;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_class__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_class__delete(
   p_class_key varchar
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_classes
        where class_key = p_class_key;

        PERFORM dotlrn_community_type__delete(p_class_key);
        return(0);
END;

$$ LANGUAGE plpgsql;



select define_function_args('dotlrn_class_instance__new','class_instance_id,class_key,term_id,community_key,pretty_name,description,package_id,portal_id,non_member_portal_id,join_policy,creation_date,creation_user,creation_ip,context_id');

select define_function_args('dotlrn_class_instance__delete','class_instance_id');




--
-- procedure dotlrn_class_instance__new/14
--
CREATE OR REPLACE FUNCTION dotlrn_class_instance__new(
   p_class_instance_id integer,
   p_class_key varchar,
   p_term_id integer,
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
        v_class_instance_id dotlrn_class_instances.class_instance_id%TYPE;
BEGIN
        v_class_instance_id := dotlrn_community__new (
            p_class_instance_id,
            null,
            p_class_key,
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
        into dotlrn_class_instances
        (class_instance_id, class_key, term_id)
        values
        (v_class_instance_id, p_class_key, p_term_id);

        return v_class_instance_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_class_instance__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_class_instance__delete(
   p_class_instance_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_class_instances
        where class_instance_id= p_class_instance_id;

        PERFORM dotlrn_community__delete(p_class_instance_id);
        return(0);
END;

$$ LANGUAGE plpgsql;

