alter table static_portal_content add body text;
update static_portal_content set body = content;
alter table static_portal_content drop column content;



-- added
select define_function_args('static_portal_content_item__new','package_id,pretty_name,content,object_type,creation_date,creation_user,creation_ip,context_id');

--
-- procedure static_portal_content_item__new/8
--
CREATE OR REPLACE FUNCTION static_portal_content_item__new(
   p_package_id integer,
   p_pretty_name varchar,
   p_content varchar,
   p_object_type varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer
) RETURNS integer AS $$
DECLARE
    v_content_id                    static_portal_content.content_id%TYPE;
    v_object_type                   varchar;
BEGIN
    if p_object_type is null then
        v_object_type := 'static_portal_content';
    else
        v_object_type := p_object_type;
    end if;

    v_content_id := acs_object__new(
        null,
        v_object_type,
        p_creation_date,
        p_creation_user,
        p_creation_ip,
        p_context_id
    );

    insert
    into static_portal_content
    (content_id, package_id, pretty_name, body)
    values
    (v_content_id, p_package_id, p_pretty_name, p_content);

    return v_content_id;
END;
$$ LANGUAGE plpgsql;
