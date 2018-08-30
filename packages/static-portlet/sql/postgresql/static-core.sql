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
-- static-core.sql
--
-- arjun@openforce.net
--
-- The core DM and API for static portal content
--
-- $Id: static-core.sql,v 1.7.2.2 2015/09/29 19:16:59 gustafn Exp $
--
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--

--
-- Objects
--


CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN

   perform acs_object_type__create_type (
        'static_portal_content',            -- object_type
        'Static Content',                            -- pretty_name
        'Static Content',                            -- pretty_plural
            'acs_object',                                    -- supertype
        'static_portal_content',            -- table_name
        'content_id',                                    -- id_column
                null,                                                        -- package_name
                'f',                                                    -- abstract_p
                null,                                                        -- type_extension_table
                null                                                        -- name_method
    );
    return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();


--
-- Datamodel
--
create table static_portal_content (
    content_id                  integer
                                constraint static_p_c_fk
                                references acs_objects(object_id)
                                constraint static_p_c_pk
                                primary key,
    package_id                  integer
                                references acs_objects(object_id) on delete cascade
                                not null,
    pretty_name                 varchar(100)
                                constraint static_p_c_pretty_name_nn
                                not null,
    body                        text,
    format			varchar(30) default 'text/html'
				constraint static_p_c_format_in
				check (format in ('text/enhanced', 'text/plain', 'text/fixed-width', 'text/html'))
);

create index static_portal_content_package_id_idx on static_portal_content(package_id);


--
-- API
--

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



--
-- procedure static_portal_content_item__delete/1
--
select define_function_args('static_portal_content_item__delete','content_id');

CREATE OR REPLACE FUNCTION static_portal_content_item__delete(
    p_content_id integer    -- content_id    in static_portal_content.content_id%TYPE
) RETURNS integer AS $$
DECLARE
BEGIN
        delete from static_portal_content where content_id = p_content_id;
        perform acs_object__delete(p_content_id);
        return 0;
end;
$$ LANGUAGE plpgsql;


--
-- perms
--

CREATE OR REPLACE FUNCTION inline_1() RETURNS integer AS $$
BEGIN

      perform acs_privilege__create_privilege('static_portal_create');
      perform acs_privilege__create_privilege('static_portal_read');
      perform acs_privilege__create_privilege('static_portal_delete');
      perform acs_privilege__create_privilege('static_portal_modify');
      perform acs_privilege__create_privilege('static_portal_admin');

      -- set up the admin priv

      perform acs_privilege__add_child('static_portal_admin', 'static_portal_create');
      perform acs_privilege__add_child('static_portal_admin', 'static_portal_read');
      perform acs_privilege__add_child('static_portal_admin', 'static_portal_delete');
      perform acs_privilege__add_child('static_portal_admin', 'static_portal_modify');

      -- bind privileges to global names

      perform acs_privilege__add_child('create','static_portal_create');
      perform acs_privilege__add_child('read','static_portal_read');
      perform acs_privilege__add_child('delete','static_portal_delete');
      perform acs_privilege__add_child('write','static_portal_modify');
      perform acs_privilege__add_child('admin','static_portal_admin');

    return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();

drop function inline_1();

