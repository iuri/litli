alter table static_portal_content add body clob;
update static_portal_content set body = empty_clob();
update static_portal_content set body = content;
alter table static_portal_content drop column content;

-- recreate package 
create or replace package static_portal_content_item 
as
    function new (
        package_id     in static_portal_content.package_id%TYPE default null,
        pretty_name     in static_portal_content.pretty_name%TYPE default null,
        content         in varchar default null,
        object_type     in acs_objects.object_type%TYPE default 'static_portal_content',
        creation_date   in acs_objects.creation_date%TYPE default sysdate,
        creation_user   in acs_objects.creation_user%TYPE default null,
        creation_ip     in acs_objects.creation_ip%TYPE default null,
        context_id      in acs_objects.context_id%TYPE default null
    ) return acs_objects.object_id%TYPE;

    procedure del (
        content_id      in static_portal_content.content_id%TYPE
    );

end static_portal_content_item;
/ 
show errors

create or replace package body static_portal_content_item
as
    function new (
        package_id     in static_portal_content.package_id%TYPE default null,
        pretty_name     in static_portal_content.pretty_name%TYPE default null,
        content         in varchar default null,
        object_type     in acs_objects.object_type%TYPE default 'static_portal_content',
        creation_date   in acs_objects.creation_date%TYPE default sysdate,
        creation_user   in acs_objects.creation_user%TYPE default null,
        creation_ip     in acs_objects.creation_ip%TYPE default null,
        context_id      in acs_objects.context_id%TYPE default null
    ) return acs_objects.object_id%TYPE
    is
        v_content_id static_portal_content.content_id%TYPE;
    begin
        v_content_id := acs_object.new (
            object_type => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
	);

        insert into static_portal_content
        (content_id, package_id, pretty_name, body)
        values
        (v_content_id, new.package_id, new.pretty_name, new.content);

        return v_content_id;        
    end new;

    procedure del (
        content_id    in static_portal_content.content_id%TYPE
    )        
    is
    begin 
        delete from static_portal_content where content_id = content_id;

        acs_object.del(content_id);
    end del;

end static_portal_content_item;
/
show errors
