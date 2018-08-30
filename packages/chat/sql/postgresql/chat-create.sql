--
-- packages/chat/sql/chat-create.sql
--
-- @author ddao@arsdigita.com
-- @creation-date November 09, 2000
-- @cvs-id $Id: chat-create.sql,v 1.8.2.6 2017/04/21 20:21:49 gustafn Exp $
--


-- create the privileges
select acs_privilege__create_privilege('chat_room_create', 'Create chat room', null);
select acs_privilege__create_privilege('chat_room_view', 'View room information', null);
select acs_privilege__create_privilege('chat_room_edit', 'Edit chat room', null);
select acs_privilege__create_privilege('chat_room_delete', 'Delete chat room', null);

select acs_privilege__create_privilege('chat_transcript_create', 'Create chat transcript', null);
select acs_privilege__create_privilege('chat_transcript_view', 'View chat transcript', null);
select acs_privilege__create_privilege('chat_transcript_edit', 'Edit chat transcipt', null);
select acs_privilege__create_privilege('chat_transcript_delete', 'Delete chat transcript', null);

select acs_privilege__create_privilege('chat_room_moderate', 'Moderate chat room', null);

select acs_privilege__create_privilege('chat_moderator_grant', 'Add moderator to a chat room', null);
select acs_privilege__create_privilege('chat_moderator_revoke', 'Remove moderator from a chat room', null);

select acs_privilege__create_privilege('chat_user_grant', 'Grant user to a chat room', null);
select acs_privilege__create_privilege('chat_user_revoke', 'Remove user from a chat room', null);
select acs_privilege__create_privilege('chat_user_ban', ' Ban user from a chat room', null);
select acs_privilege__create_privilege('chat_user_unban', 'Unban user from a chat room', null);

select acs_privilege__create_privilege('chat_ban', 'Ban from a chat room', null);
select acs_privilege__create_privilege('chat_read', 'View chat message', null);
select acs_privilege__create_privilege('chat_write', 'Write chat message', null);

-- Set of privileges for regular chat user.
select acs_privilege__create_privilege('chat_user', 'Regular chat user', null);
select acs_privilege__add_child('chat_user', 'chat_read');
select acs_privilege__add_child('chat_user', 'chat_write');

-- Set of privileges for moderator of the chat room.
select acs_privilege__create_privilege('chat_moderator', 'Chat room moderator', null);
select acs_privilege__add_child('chat_moderator', 'chat_room_moderate');
select acs_privilege__add_child('chat_moderator', 'chat_user_ban');
select acs_privilege__add_child('chat_moderator', 'chat_user_unban');
select acs_privilege__add_child('chat_moderator', 'chat_user_grant');
select acs_privilege__add_child('chat_moderator', 'chat_user_revoke');
select acs_privilege__add_child('chat_moderator', 'chat_transcript_create');
select acs_privilege__add_child('chat_moderator', 'chat_transcript_view');
select acs_privilege__add_child('chat_moderator', 'chat_transcript_edit');
select acs_privilege__add_child('chat_moderator', 'chat_transcript_delete');
select acs_privilege__add_child('chat_moderator', 'chat_user');

 -- Set of privileges for administrator of the chat room.
select acs_privilege__create_privilege('chat_room_admin', 'Chat room administrator', null);
select acs_privilege__add_child('chat_room_admin', 'chat_room_create');
select acs_privilege__add_child('chat_room_admin', 'chat_room_delete');
select acs_privilege__add_child('chat_room_admin', 'chat_room_edit');
select acs_privilege__add_child('chat_room_admin', 'chat_room_view');
select acs_privilege__add_child('chat_room_admin', 'chat_moderator_grant');
select acs_privilege__add_child('chat_room_admin', 'chat_moderator_revoke');
select acs_privilege__add_child('chat_room_admin', 'chat_moderator');

-- Site wite admin also administrator of the chat room.
select acs_privilege__add_child('admin', 'chat_room_admin');


-- create chat room object type
CREATE FUNCTION inline_0() returns integer
AS 'declare
       attr_id acs_attributes.attribute_id%TYPE;
    begin
       PERFORM

       acs_object_type__create_type(
          ''chat_room'',  -- object_type
          ''Chat Room'',  -- pretty_name
          ''Chat Rooms'', -- pretty_plural
          ''acs_object'', -- supertype
          ''CHAT_ROOMS'', -- table_name
          ''ROOM_ID'',    -- id_column
          null,           -- package_name
          ''f'',          -- abstract_p
          null,           -- type_extension_table
          null            -- name_method
       );


       attr_id := acs_attribute__create_attribute (
          ''chat_room'',       -- object_type
          ''pretty_name'',     -- attribute_name
          ''string'',          -- datatype
          ''Room name'',       -- pretty_name
          ''Room names'',      -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );



        attr_id := acs_attribute__create_attribute (
          ''chat_room'',       -- object_type
          ''description'',     -- attribute_name
          ''string'',          -- datatype
          ''Description'',     -- pretty_name
          ''Descriptions'',    -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );


        attr_id := acs_attribute__create_attribute (
          ''chat_room'',       -- object_type
          ''moderated_p'',     -- attribute_name
          ''boolean'',         -- datatype
          ''Moderated'',       -- pretty_name
          ''Moderated'',       -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );


        attr_id := acs_attribute__create_attribute (
          ''chat_room'',       -- object_type
          ''active_p'',        -- attribute_name
          ''boolean'',         -- datatype
          ''Activated'',       -- pretty_name
          ''Activated'',       -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );


        attr_id := acs_attribute__create_attribute (
          ''chat_room'',       -- object_type
          ''archive_p'',       -- attribute_name
          ''boolean'',         -- datatype
          ''Archived'',        -- pretty_name
          ''Archived'',        -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );


         return 0;

    end;'

language 'plpgsql';
SELECT inline_0();
DROP function inline_0();


create table chat_rooms (

    room_id            integer
                       constraint chat_rooms_room_id_pk primary key
                       constraint chat_rooms_room_id_fk
                       references acs_objects(object_id),
    -- This is room name.
    pretty_name        varchar(100)
                       constraint chat_rooms_pretty_name_nn not null,
    description        varchar(2000),
    moderated_p        boolean
                       default 'f'
                       constraint chat_rooms_moderate_p_ck
                       check (moderated_p in ('t','f')),
    active_p           boolean
                       default 't'
                       constraint chat_rooms_active_p_ck
                       check (active_p in ('t','f')),
    -- if set then log all chat messages in this room.
    archive_p          boolean
                        default 't'
                       constraint chat_rooms_archive_p_ck
                        check (archive_p in ('t', 'f')),
    -- flush the rooms messages every night at 00:05
    auto_flush_p        boolean default 't',
    -- automatically create a transcript after flushing the room
    auto_transcript_p   boolean default 'f',
    -- allow to set whether we want login/logout messages or not
    login_messages_p    boolean default 't',
    logout_messages_p   boolean default 't',
    -- set how much in the past users will see when entering a chat in
    -- seconds this is needed to specify, for example, that users will
    -- see only the previous 10 minutes of the conversation
    messages_time_window integer default 600
);


-- create chat transcript object type
CREATE FUNCTION inline_0() returns integer
AS 'declare
       attr_id acs_attributes.attribute_id%TYPE;
    begin
       PERFORM

     acs_object_type__create_type(
          ''chat_transcript'',  -- object_type
          ''Chat Transcript'',  -- pretty_name
          ''Chat Transcripts'', -- pretty_plural
          ''acs_object'',       -- supertype
          ''CHAT_TRANSCRIPTS'', -- table_name
          ''TRANSCRIPT_ID'',    -- id_column
          null,           -- package_name
          ''f'',          -- abstract_p
          null,           -- type_extension_table
          null            -- name_method
       );


       attr_id := acs_attribute__create_attribute (
          ''chat_transcript'', -- object_type
          ''pretty_name'',     -- attribute_name
          ''string'',          -- datatype
          ''Transcript name'', -- pretty_name
          ''Transcript names'',-- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );


        attr_id := acs_attribute__create_attribute (
          ''chat_transcript'', -- object_type
          ''description'',     -- attribute_name
          ''string'',          -- datatype
          ''Description'',     -- pretty_name
          ''Descriptions'',    -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );


        attr_id := acs_attribute__create_attribute (
          ''chat_transcript'',          -- object_type
          ''contents'',                 -- attribute_name
          ''string'',                   -- datatype
          ''Transcript content'',       -- pretty_name
          ''Transcript contents'',      -- pretty_plural
          null,                -- table_name (default)
          null,                -- column_name (default)
          null,                -- default_value (default)
          1,                   -- min_n_values (default)
          1,                   -- max_n_values (default)
          null,                -- sort_order (default)
          ''type_specific'',   -- storage (default)
          ''f''                -- static_p (default)
        );



         return 0;

    end;'

language 'plpgsql';
SELECT inline_0();
DROP function inline_0();


---------------------------------

create table chat_transcripts (
    transcript_id      integer
                       constraint chat_trans_transcript_id_pk primary key
                       constraint chat_trans_transcript_id_fk
                       references acs_objects(object_id),
    contents           varchar(32000)
                       constraint chat_trans_contents_nn not null,
    -- Chat transcript name.
    pretty_name        varchar(100)
                       constraint chat_trans_pretty_name_nn not null,
    description        varchar(2000),
    room_id            integer
                       constraint chat_trans_room_id_fk references chat_rooms
);


---------------------------------

create table chat_msgs (
    msg_id             integer
                       constraint chat_msgs_msg_id_pk primary key,
    msg                varchar(4000),
    msg_len            integer
                       constraint chat_msgs_msg_len_ck
                       check (msg_len >= 0),
    html_p             boolean
                       default 'f'
                       constraint chat_msgs_html_p_ck
                       check (html_p in ('t','f')),
    approved_p         boolean
                       default 't'
                       constraint chat_msgs_approve_p_ck
                       check(approved_p in ('t','f')),
    creation_user      integer
                       constraint chat_msgs_creation_user_fk
                       references parties(party_id)
                       constraint chat_msgs_creation_user_nn not null,
    creation_ip        varchar(50) ,
    creation_date      timestamptz,
    room_id            integer
                       constraint chat_msgs_room_id_fk references chat_rooms
);


---------------------------------


-- added
select define_function_args('chat_room__delete_all_msgs','room_id');

--
-- procedure chat_room__delete_all_msgs/1
--
CREATE OR REPLACE FUNCTION chat_room__delete_all_msgs(
   p_room_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
   delete from chat_msgs where room_id = p_room_id;
   return 0;
END;
$$ LANGUAGE plpgsql;

---------------------------------


-- added
select define_function_args('chat_room__del','room_id');

--
-- procedure chat_room__del/1
--
CREATE OR REPLACE FUNCTION chat_room__del(
   p_room_id integer
) RETURNS integer AS $$
DECLARE
BEGIN

    --TO DO: delete transcriptions?


    -- First erase all the messages relate to this chat room.
    delete from chat_msgs where room_id = p_room_id;

     -- Delete all privileges associate with this room
     delete from acs_permissions where object_id = p_room_id;

     -- Now delete the chat room itself.
     delete from chat_rooms where room_id = p_room_id;

     PERFORM acs_object__delete(p_room_id);

   return 0;
END;
$$ LANGUAGE plpgsql;


---------------------------------


-- added
select define_function_args('chat_transcript__del','transcript_id');

--
-- procedure chat_transcript__del/1
--
CREATE OR REPLACE FUNCTION chat_transcript__del(
   p_transcript_id integer
) RETURNS integer AS $$
DECLARE
BEGIN

        -- Delete all privileges associate with this transcript
        delete from acs_permissions where object_id = p_transcript_id;

        delete from chat_transcripts
        where transcript_id = p_transcript_id;

        PERFORM acs_object__delete(p_transcript_id);
        return 0;
END;
$$ LANGUAGE plpgsql;
----------------------------


-- added
select define_function_args('chat_room__message_post','room_id,msg,creation_user,creation_ip');

--
-- procedure chat_room__message_post/4
--
CREATE OR REPLACE FUNCTION chat_room__message_post(
   p_room_id integer,
   p_msg varchar,
   p_creation_user integer,
   p_creation_ip varchar
) RETURNS integer AS $$
DECLARE
   v_msg_id chat_msgs.msg_id%TYPE;
   v_msg_archive_p chat_rooms.archive_p%TYPE;
   v_msg chat_msgs.msg%TYPE;
BEGIN
    -- Get msg id from the global acs_object sequence.
    select nextval('t_acs_object_id_seq') into v_msg_id from dual;

    select archive_p into v_msg_archive_p from chat_rooms where room_id = p_room_id;

    if v_msg_archive_p = 't' then
            v_msg := p_msg;
        else
            v_msg := null;
        end if;

     -- Insert into chat_msgs table.
     insert into chat_msgs (
            msg_id,
            room_id,
            msg,
            creation_user,
            creation_ip,
            creation_date)
        values (
            v_msg_id,
            p_room_id,
            v_msg,
            p_creation_user,
            p_creation_ip,
            now()) ;



return 0;
END;
$$ LANGUAGE plpgsql;

---------------------------
