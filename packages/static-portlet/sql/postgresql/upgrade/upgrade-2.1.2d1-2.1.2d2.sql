-- 
-- 
-- 
-- @author Victor Guerra (guerra@galileo.edu)
-- @creation-date 2005-07-07
-- @arch-tag: 42606216-8bd1-43d1-9e86-b7ac723080c9
-- @cvs-id $Id: upgrade-2.1.2d1-2.1.2d2.sql,v 1.3 2014/10/27 16:41:56 victorg Exp $
--

-- altering static_portal_content in order to support 
-- defining different format type for the content of the static portlet

alter table static_portal_content add column body text;
alter table static_portal_content add column format varchar(30);
alter table static_portal_content alter column format set default 'text/html';

update static_portal_content set format = 'text/html';
	
alter table static_portal_content add constraint static_p_c_format_in check ( format in ('text/enhanced', 'text/plain', 'text/fixed-width', 'text/html'));


-- updating data
update static_portal_content
set format = 'text/enhanced',
    body = substring(body from 2 for (length(body) - 16))
where substring(body from (length(body)-12) for 13) = 'text/enhanced';

update static_portal_content
set format = 'text/plain',
    body = substring(body from 2 for (length(body) - 13))
where substring(body from (length(body)-9) for 10) = 'text/plain';

update static_portal_content
set format = 'text/plain',
    body = substring(body from 2 for (length(body) - 19))
where substring(body from (length(body)-15) for 16) = 'text/fixed-width';

update static_portal_content 
set format = 'text/html',
    body = substring(body from 2 for (length(body) - 12))
where substring(body from (length(body)-8) for 9) = 'text/html';

-- API modifications

drop function static_portal_content_item__new (integer, varchar, varchar);


-- added

--
-- procedure static_portal_content_item__new/4
--
CREATE OR REPLACE FUNCTION static_portal_content_item__new(
   p_package_id integer,
   p_pretty_name varchar,
   p_content varchar,
   p_format varchar
) RETURNS integer AS $$
DECLARE
BEGIN
    return static_portal_content_item__new(
        p_package_id,
        p_pretty_name,
        p_content,
	p_format,
        null,
        null,
        null,
        null,
        null
    );
END;

$$ LANGUAGE plpgsql;

drop function static_portal_content_item__new (integer,varchar,varchar,varchar,timestamptz,integer,varchar,integer);


-- added
select define_function_args('static_portal_content_item__new','package_id,pretty_name,content,format,object_type,creation_date,creation_user,creation_ip,context_id');

--
-- procedure static_portal_content_item__new/9
--
CREATE OR REPLACE FUNCTION static_portal_content_item__new(
   p_package_id integer,
   p_pretty_name varchar,
   p_content varchar,
   p_format varchar,
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
    (content_id, package_id, pretty_name, body, format)
    values
    (v_content_id, p_package_id, p_pretty_name, p_content, p_format);

    return v_content_id;
END;
$$ LANGUAGE plpgsql;
