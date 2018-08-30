create or replace package body dotlrn_community_type
is
    function new (
        community_type in dotlrn_community_types.community_type%TYPE,
        parent_type in dotlrn_community_types.supertype%TYPE default 'dotlrn_community', 
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in dotlrn_community_types.pretty_name%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_community_types.community_type%TYPE
    is
        v_parent_object_type acs_object_types.object_type%TYPE;
        v_unique_name acs_objects.object_id%TYPE;
    begin
        if parent_type is null then
            v_parent_object_type:= 'application_group';
        else
            v_parent_object_type:= parent_type;
        end if;

        select acs_object_id_seq.nextval
        into v_unique_name
        from dual;

        acs_object_type.create_type (
            supertype => v_parent_object_type,
            object_type => dotlrn_community_type.new.community_type,
            pretty_name => dotlrn_community_type.new.community_type,
            pretty_plural => dotlrn_community_type.new.community_type,
            table_name => v_unique_name,
            id_column => v_unique_name,
            package_name => v_unique_name,
            name_method => 'acs_group.name'
        );

        insert
        into group_types
        (group_type, default_join_policy)
        values
        (dotlrn_community_type.new.community_type, 'closed');

        insert
        into dotlrn_community_types
        (community_type,
         pretty_name,
         description,
         package_id,
         supertype)
        values
        (dotlrn_community_type.new.community_type,
         dotlrn_community_type.new.pretty_name,
         dotlrn_community_type.new.description,
         dotlrn_community_type.new.package_id,
         dotlrn_community_type.new.parent_type);

        return community_type;
    end;

    procedure del (
        community_type in dotlrn_community_types.community_type%TYPE
    )
    is
    begin
        delete
        from dotlrn_community_types
        where community_type = dotlrn_community_type.del.community_type;

        delete
        from group_types
        where group_types.group_type = dotlrn_community_type.del.community_type;

        acs_object_type.drop_type(dotlrn_community_type.del.community_type);
    end;

    function name (
        community_type in dotlrn_community_types.community_type%TYPE
    ) return varchar
    is
        v_name dotlrn_community_types.pretty_name%TYPE;
    begin
        select dotlrn_community_types.pretty_name
        into v_name
        from dotlrn_community_types
        where dotlrn_community_types.community_type = dotlrn_community_type.name.community_type;

        return v_name;
    end;
end;
/
show errors

create or replace package body dotlrn_community
as

    function new (
        community_id in dotlrn_communities_all.community_id%TYPE default null,
        parent_community_id in dotlrn_communities_all.parent_community_id%TYPE default null,
        community_type in dotlrn_communities_all.community_type%TYPE,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        archived_p in dotlrn_communities_all.archived_p%TYPE default 'f',
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_communities_all.community_id%TYPE
    is
        c_id integer;
    begin
        c_id := application_group.new (
            context_id => dotlrn_community.new.context_id,
            group_id => dotlrn_community.new.community_id,
            object_type => dotlrn_community.new.community_type,
            creation_date => dotlrn_community.new.creation_date,
            creation_user => dotlrn_community.new.creation_user,
            creation_ip => dotlrn_community.new.creation_ip,
            group_name => dotlrn_community.new.community_key,
            join_policy => dotlrn_community.new.join_policy,
            package_id => dotlrn_community.new.package_id
        );

        insert into dotlrn_communities_all
          (community_id, 
           parent_community_id,
           community_type, 
           community_key, 
           pretty_name,  
           description, 
           package_id, 
           archived_p,
           portal_id, 
           non_member_portal_id)
        values
          (c_id, 
           dotlrn_community.new.parent_community_id, 
           dotlrn_community.new.community_type, 
           dotlrn_community.new.community_key, 
           dotlrn_community.new.pretty_name, 
           dotlrn_community.new.description,    
           dotlrn_community.new.package_id, 
           dotlrn_community.new.archived_p, 
           dotlrn_community.new.portal_id, 
           dotlrn_community.new.non_member_portal_id);

        return c_id;
    end;

    procedure set_active_dates (
        community_id in dotlrn_communities_all.community_id%TYPE,
        start_date in dotlrn_communities_all.active_start_date%TYPE,
        end_date in dotlrn_communities_all.active_end_date%TYPE
    )
    is
    begin
        update dotlrn_communities_all
        set active_start_date = dotlrn_community.set_active_dates.start_date,
            active_end_date = dotlrn_community.set_active_dates.end_date
        where dotlrn_communities_all.community_id = dotlrn_community.set_active_dates.community_id;
    end;

    procedure del (
        community_id in dotlrn_communities_all.community_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_communities_all
        where dotlrn_communities_all.community_id = dotlrn_community.del.community_id;

        acs_group.del(dotlrn_community.del.community_id);
    end;

    function name (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return varchar
    is
    begin
        return acs_group.name(dotlrn_community.name.community_id);
    end;

    function member_p (
        community_id in dotlrn_communities_all.community_id%TYPE,
        party_id in parties.party_id%TYPE
    ) return char
    is
        v_member_p              char(1);
    begin
        select decode(count(*), 0, 'f', 't')
        into v_member_p
        from dual
        where exists (select 1
                      from dotlrn_member_rels_approved
                      where dotlrn_member_rels_approved.user_id = dotlrn_community.member_p.party_id
                      and dotlrn_member_rels_approved.community_id = dotlrn_community.member_p.community_id);

        return v_member_p;
    end;

    function admin_p (
        community_id in dotlrn_communities_all.community_id%TYPE,
        party_id in parties.party_id%TYPE
    ) return char
    is
        v_rv char(1);
    begin
        select decode(
                   acs_permission.permission_p(dotlrn_community.admin_p.community_id, dotlrn_community.admin_p.party_id, 'dotlrn_admin_community'),
                   'f',
                   acs_permission.permission_p(dotlrn_community.admin_p.community_id, dotlrn_community.admin_p.party_id, 'admin'),
                   't'
               ) into v_rv
        from dual;

        return v_rv;
    end;

    function url (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return varchar2
    is
        v_node_id site_nodes.node_id%TYPE;
    begin
        select site_nodes.node_id into v_node_id
        from dotlrn_communities_all,
             site_nodes
        where dotlrn_communities_all.community_id = dotlrn_community.url.community_id
        and site_nodes.object_id = dotlrn_communities_all.package_id;

        return site_node.url(v_node_id);

        exception
            when no_data_found then
                return '';
    end;

    function has_subcomm_p (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return char
    is
        v_rv char(1);
    begin
        select decode(count(*), 0, 'f', 't')
        into v_rv
        from dual
        where exists (select 1
                      from dotlrn_communities_all
                      where dotlrn_communities_all.parent_community_id = dotlrn_community.has_subcomm_p.community_id);
        return v_rv;
    end;

end;
/
show errors

