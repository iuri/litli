alter table portal_pages add accesskey varchar(200) default null;

create or replace package portal_page
as

    function new (
        page_id                     in portal_pages.page_id%TYPE default null,
        pretty_name                 in portal_pages.pretty_name%TYPE default 'Untitled Page',
        accesskey                   in portal_pages.accesskey%TYPE default null,
        portal_id                   in portal_pages.portal_id%TYPE,
        layout_id                   in portal_pages.layout_id%TYPE default null,
        hidden_p                    in portal_pages.hidden_p%TYPE default 'f',
        object_type                 in acs_object_types.object_type%TYPE default 'portal_page',
        creation_date               in acs_objects.creation_date%TYPE default sysdate,
        creation_user               in acs_objects.creation_user%TYPE default null,
        creation_ip                 in acs_objects.creation_ip%TYPE default null,
        context_id                  in acs_objects.context_id%TYPE default null
    ) return portal_pages.page_id%TYPE;

    procedure del (
        page_id                     in portal_pages.page_id%TYPE
    );

end portal_page;
/
show errors

create or replace package body portal_page
as

    function new (
        page_id                     in portal_pages.page_id%TYPE default null,
        pretty_name                 in portal_pages.pretty_name%TYPE default 'Untitled Page',
        accesskey                   in portal_pages.accesskey%TYPE default null,
        portal_id                   in portal_pages.portal_id%TYPE,
        layout_id                   in portal_pages.layout_id%TYPE default null,
        hidden_p                    in portal_pages.hidden_p%TYPE default 'f',
        object_type                 in acs_object_types.object_type%TYPE default 'portal_page',
        creation_date               in acs_objects.creation_date%TYPE default sysdate,
        creation_user               in acs_objects.creation_user%TYPE default null,
        creation_ip                 in acs_objects.creation_ip%TYPE default null,
        context_id                  in acs_objects.context_id%TYPE default null
    ) return portal_pages.page_id%TYPE
    is
        v_page_id                   portal_pages.page_id%TYPE;
        v_layout_id                 portal_pages.layout_id%TYPE;
        v_sort_key                  portal_pages.sort_key%TYPE;
    begin

        v_page_id := acs_object.new(
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        if layout_id is null then
            select min(layout_id)
            into v_layout_id
            from portal_layouts;
        else
            v_layout_id := layout_id;
        end if;

        select nvl(max(sort_key) + 1, 0)
        into v_sort_key
        from portal_pages
        where portal_id = portal_page.new.portal_id;

        insert into portal_pages
        (page_id, pretty_name, accesskey, portal_id, layout_id, sort_key, hidden_p)
        values
        (v_page_id, pretty_name, accesskey, portal_id, v_layout_id, v_sort_key, hidden_p);

        return v_page_id;

    end new;

    procedure del (
        page_id                     in portal_pages.page_id%TYPE
    )
    is
        v_portal_id                 portal_pages.portal_id%TYPE;
        v_sort_key                  portal_pages.sort_key%TYPE;
        v_curr_sort_key             portal_pages.sort_key%TYPE;
        v_page_count_from_0         integer;
    begin

        -- IMPORTANT: sort keys MUST be an unbroken sequence from 0 to max(sort_key)

        select portal_id, sort_key
        into v_portal_id, v_sort_key
        from portal_pages
        where page_id = portal_page.del.page_id;

        select (count(*) - 1)
        into v_page_count_from_0
        from portal_pages
        where portal_id = v_portal_id;

        for i in 0 .. v_page_count_from_0 loop

            if i = v_sort_key then

                delete
                from portal_pages
                where page_id = portal_page.del.page_id;

            elsif i > v_sort_key then

                update portal_pages
                set sort_key = -1
                where sort_key = i
		and page_id = portal_page.del.page_id;

                update portal_pages
                set sort_key = i - 1
                where sort_key = -1
		and page_id = portal_page.del.page_id;

            end if;

        end loop;

        acs_object.del(page_id);

    end del;

end portal_page;
/
show errors

create or replace package portal
as

    function new (
        portal_id                   in portals.portal_id%TYPE default null,
        name                        in portals.name%TYPE default 'Untitled',
        theme_id                    in portals.theme_id%TYPE default null,
        layout_id                   in portal_layouts.layout_id%TYPE default null,
        template_id                 in portals.template_id%TYPE default null,
        default_page_name           in portal_pages.pretty_name%TYPE default 'Main Page',
        default_accesskey           in portal_pages.accesskey%TYPE default null,
        object_type                 in acs_object_types.object_type%TYPE default 'portal',
        creation_date               in acs_objects.creation_date%TYPE default sysdate,
        creation_user               in acs_objects.creation_user%TYPE default null,
        creation_ip                 in acs_objects.creation_ip%TYPE default null,
        context_id                  in acs_objects.context_id%TYPE default null
    ) return portals.portal_id%TYPE;

    procedure del (
        portal_id                   in portals.portal_id%TYPE
    );
end portal;
/
show errors

create or replace package body portal
as
    function new (
        portal_id                   in portals.portal_id%TYPE default null,
        name                        in portals.name%TYPE default 'Untitled',
        theme_id                    in portals.theme_id%TYPE default null,
        layout_id                   in portal_layouts.layout_id%TYPE default null,
        template_id                 in portals.template_id%TYPE default null,
        default_page_name           in portal_pages.pretty_name%TYPE default 'Main Page',
        default_accesskey           in portal_pages.accesskey%TYPE default null,
        object_type                 in acs_object_types.object_type%TYPE default 'portal',
        creation_date               in acs_objects.creation_date%TYPE default sysdate,
        creation_user               in acs_objects.creation_user%TYPE default null,
        creation_ip                 in acs_objects.creation_ip%TYPE default null,
        context_id                  in acs_objects.context_id%TYPE default null
    ) return portals.portal_id%TYPE
    is
        v_portal_id                 portals.portal_id%TYPE;
        v_theme_id                  portals.theme_id%TYPE;
        v_layout_id                 portal_layouts.layout_id%TYPE;
        v_page_id                   portal_pages.page_id%TYPE;
        v_new_element_id            portal_element_map.element_id%TYPE;
        v_new_parameter_id          portal_element_parameters.parameter_id%TYPE;
    begin

        v_portal_id := acs_object.new(
            object_id  => portal_id,
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        if template_id is null then

            if portal.new.theme_id is null then
                select max(theme_id)
                into v_theme_id
                from portal_element_themes;
            else
                v_theme_id := portal.new.theme_id;
            end if;

            if layout_id is null then
                select min(layout_id)
                into v_layout_id
                from portal_layouts;
            else
                v_layout_id := portal.new.layout_id;
            end if;

            insert
            into portals
            (portal_id, name, theme_id)
            values
            (v_portal_id, name, v_theme_id);

            -- now insert the default page
            v_page_id := portal_page.new (
                portal_id => v_portal_id,
                pretty_name => default_page_name,
                accesskey => default_accesskey,
                layout_id => v_layout_id,
                creation_date => creation_date,
                creation_user => creation_user,
                creation_ip => creation_ip,
                context_id => context_id
            );

        else

            -- we have a portal as our template. copy it's theme, pages, layouts,
            -- elements, and element params.
            select theme_id
            into v_theme_id
            from portals
            where portal_id = portal.new.template_id;

            insert
            into portals
            (portal_id, name, theme_id, template_id)
            values
            (v_portal_id, name, v_theme_id, portal.new.template_id);

            -- now insert the pages from the portal template
            for page in (select *
                         from portal_pages
                         where portal_id = portal.new.template_id)
            loop

                v_page_id := portal_page.new(
                    portal_id => v_portal_id,
                    pretty_name => page.pretty_name,
                    accesskey => page.accesskey,
                    layout_id => page.layout_id
                );

                -- now get the elements on the template's page and put them on the new page
                for element in (select *
                                from portal_element_map
                                where page_id = page.page_id)
                loop

                    select acs_object_id_seq.nextval
                    into v_new_element_id
                    from dual;

                    insert
                    into portal_element_map
                    (element_id, name, pretty_name, page_id, datasource_id, region, state, sort_key)
                    select v_new_element_id, name, pretty_name, v_page_id, datasource_id, region, state, sort_key
                    from portal_element_map pem
                    where pem.element_id = element.element_id;

                    -- now for the element's params
                    for param in (select *
                                  from portal_element_parameters
                                  where element_id = element.element_id)
                    loop

                        select acs_object_id_seq.nextval
                        into v_new_parameter_id
                        from dual;

                        insert
                        into portal_element_parameters
                        (parameter_id, element_id, config_required_p, configured_p, key, value)
                        select v_new_parameter_id, v_new_element_id, config_required_p, configured_p, key, value
                        from portal_element_parameters
                        where parameter_id = param.parameter_id;

                    end loop;

                end loop;

            end loop;

        end if;

        return v_portal_id;

    end new;

    procedure del (
        portal_id                   in portals.portal_id%TYPE
    )
    is
    begin

        for page in (select page_id
                     from portal_pages
                     where portal_id = portal.del.portal_id
                     order by sort_key desc)
        loop
            portal_page.del(page_id => page.page_id);
        end loop;

        acs_object.del(portal_id);

    end del;

end portal;
/
show errors

