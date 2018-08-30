-- 
-- 
-- 
-- @author Andrew Grumet (aegrumet@alum.mit.edu)
-- @creation-date 2005-07-07
-- @cvs-id $Id: upgrade-2.1.2d1-2.1.2d2.sql,v 1.2 2006/08/08 21:27:12 donb Exp $
--

-- altering static_portal_content in order to support 
-- defining different format type for the content of the static portlet

alter table static_portal_content add format varchar2(30) default 'text/html';
update static_portal_content set format = 'text/html';
alter table static_portal_content add constraint static_p_c_format_ck check (format in ('text/enhanced', 'text/plain', 'text/fixed-width', 'text/html'));

-- updating data
update static_portal_content
set format = 'text/enhanced',
    body = dbms_lob.substr(body,dbms_lob.getlength(body)-13,1)
where dbms_lob.substr(body,13,dbms_lob.getlength(body)-12) = 'text/enhanced';

update static_portal_content
set format = 'text/plain',
    body = dbms_lob.substr(body,dbms_lob.getlength(body)-10,1)
where dbms_lob.substr(body,10,dbms_lob.getlength(body)-9) = 'text/plain';

update static_portal_content
set format = 'text/fixed-width',
    body = dbms_lob.substr(body,dbms_lob.getlength(body)-16,1)
where dbms_lob.substr(body,16,dbms_lob.getlength(body)-15) = 'text/fixed-width';

update static_portal_content
set format = 'text/html',
    body = dbms_lob.substr(body,dbms_lob.getlength(body)-9,1)
where dbms_lob.substr(body,9,dbms_lob.getlength(body)-8) = 'text/html';

--
-- API
-- 

-- content is still a varchar, even though it is being used to put content
-- into body, a clob, because a varchar is what's being passed in from the
-- Tcl script.
create or replace package static_portal_content_item 
as
    function new (
        package_id     in static_portal_content.package_id%TYPE default null,
        pretty_name     in static_portal_content.pretty_name%TYPE default null,
        content         in varchar default null,
        format          in varchar default 'text/html',
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
        format          in varchar default 'text/html',
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
        (content_id, package_id, pretty_name, body, format)
        values
        (v_content_id, new.package_id, new.pretty_name, new.content, new.format);

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
