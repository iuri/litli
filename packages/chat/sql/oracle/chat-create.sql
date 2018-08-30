--      
-- packages/chat/sql/chat-create.sql
--
-- @author ddao@arsdigita.com
-- @creation-date November 09, 2000
-- @cvs-id $Id: chat-create.sql,v 1.4.6.1 2016/10/28 18:57:36 antoniop Exp $
--

begin

    -- create the privileges
    acs_privilege.create_privilege('chat_room_create', 'Create chat room');
    acs_privilege.create_privilege('chat_room_view', 'View room information');
    acs_privilege.create_privilege('chat_room_edit', 'Edit chat room');
    acs_privilege.create_privilege('chat_room_delete', 'Delete chat room');

    acs_privilege.create_privilege('chat_transcript_create', 'Create chat transcript');
    acs_privilege.create_privilege('chat_transcript_view', 'View chat transcript');
    acs_privilege.create_privilege('chat_transcript_edit', 'Edit chat transcipt');
    acs_privilege.create_privilege('chat_transcript_delete', 'Delete chat transcript');

    acs_privilege.create_privilege('chat_room_moderate', 'Moderate chat room');

    acs_privilege.create_privilege('chat_moderator_grant', 'Add moderator to a chat room');
    acs_privilege.create_privilege('chat_moderator_revoke', 'Remove moderator from a chat room');

    acs_privilege.create_privilege('chat_user_grant', 'Grant user to a chat room');
    acs_privilege.create_privilege('chat_user_revoke', 'Remove user from a chat room');
    acs_privilege.create_privilege('chat_user_ban', ' Ban user from a chat room');
    acs_privilege.create_privilege('chat_user_unban', 'Unban user from a chat room');

    acs_privilege.create_privilege('chat_ban', 'Ban from a chat room');
    acs_privilege.create_privilege('chat_read', 'View chat message');
    acs_privilege.create_privilege('chat_write', 'Write chat message');

    -- Set of privileges for regular chat user.
    acs_privilege.create_privilege('chat_user', 'Regular chat user');
    acs_privilege.add_child('chat_user', 'chat_read');
    acs_privilege.add_child('chat_user', 'chat_write');

    -- Set of privileges for moderator of the chat room.
    acs_privilege.create_privilege('chat_moderator', 'Chat room moderator');
    acs_privilege.add_child('chat_moderator', 'chat_room_moderate');
    acs_privilege.add_child('chat_moderator', 'chat_user_ban');
    acs_privilege.add_child('chat_moderator', 'chat_user_unban');
    acs_privilege.add_child('chat_moderator', 'chat_user_grant');
    acs_privilege.add_child('chat_moderator', 'chat_user_revoke');
    acs_privilege.add_child('chat_moderator', 'chat_transcript_create');
    acs_privilege.add_child('chat_moderator', 'chat_transcript_view');    
    acs_privilege.add_child('chat_moderator', 'chat_transcript_edit');
    acs_privilege.add_child('chat_moderator', 'chat_transcript_delete');
    acs_privilege.add_child('chat_moderator', 'chat_user');

    -- Set of privileges for administrator of the chat room.
    acs_privilege.create_privilege('chat_room_admin', 'Chat room administrator');
    acs_privilege.add_child('chat_room_admin', 'chat_room_create');
    acs_privilege.add_child('chat_room_admin', 'chat_room_delete');
    acs_privilege.add_child('chat_room_admin', 'chat_room_edit');
    acs_privilege.add_child('chat_room_admin', 'chat_room_view');
    acs_privilege.add_child('chat_room_admin', 'chat_moderator_grant');
    acs_privilege.add_child('chat_room_admin', 'chat_moderator_revoke');
    acs_privilege.add_child('chat_room_admin', 'chat_moderator');

    -- Site wite admin also administrator of the chat room.
    acs_privilege.add_child('admin', 'chat_room_admin');        
end;
/
show errors


declare
    attr_id acs_attributes.attribute_id%TYPE;
begin
    -- create chat room object type
    acs_object_type.create_type (
        supertype      => 'acs_object',
        object_type    => 'chat_room',
        pretty_name    => 'Chat Room',
        pretty_plural  => 'Chat Rooms',
        table_name     => 'CHAT_ROOMS',
        id_column      => 'ROOM_ID'
    );    

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_room',
        attribute_name => 'pretty_name',
        pretty_name    => 'Room name',
        pretty_plural  => 'Room names',
        datatype       => 'string'
    );

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_room',
        attribute_name => 'description',
        pretty_name    => 'Description',
        pretty_plural  => 'Descriptions',
        datatype       => 'string'
    );

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_room',
        attribute_name => 'moderated_p',
        pretty_name    => 'Moderated',
        pretty_plural  => 'Moderated',
        datatype       => 'boolean'
    );

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_room',
        attribute_name => 'active_p',
        pretty_name    => 'Activated',
        pretty_plural  => 'Activated',
        datatype       => 'boolean'
    );

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_room',
        attribute_name => 'archive_p',
        pretty_name    => 'Archived',
        pretty_plural  => 'Archived',
        datatype       => 'boolean'
    );
end;
/
show errors;

create table chat_rooms ( 
    room_id            integer 
                       constraint chat_rooms_room_id_pk primary key
                       constraint chat_rooms_room_id_fk 
                       references acs_objects(object_id),
    -- This is room name.
    pretty_name        varchar2(100)
                       constraint chat_rooms_pretty_name_nn not null,
    description        varchar2(2000),
    moderated_p        char(1) default 'f'
                       constraint chat_rooms_moderate_p_ck 
                       check (moderated_p in ('t','f')), 
    active_p           char(1) default 't' 
                       constraint chat_rooms_active_p_ck 
                       check (active_p in ('t','f')),
    -- if set then log all chat messages in this room. 
    archive_p          char(1) default 'f'
                       constraint chat_rooms_archive_p_ck 
                       check (archive_p in ('t', 'f')),
	auto_flush_p	   char(1) default 't'
					   constraint chat_rooms_auto_flush_ck
					   check (auto_flush_p in ('t', 'f')),
	auto_transcript_p  char(1) default 'f'
					   constraint chat_rooms_auto_transcript_ck
					   check (auto_transcript_p in ('t', 'f')),
	login_messages_p  char(1) default 't'
					   constraint chat_rooms_login_messages_ck
					   check (login_messages_p in ('t', 'f')),

	logout_messages_p  char(1) default 't'
					   constraint chat_rooms_logout_messages_ck
					   check (logout_messages_p in ('t', 'f'))
); 

declare
    attr_id acs_attributes.attribute_id%TYPE;
begin
    -- create chat transcript object type
    acs_object_type.create_type (
        supertype      => 'acs_object',
        object_type    => 'chat_transcript',
        pretty_name    => 'Chat Transcript',
        pretty_plural  => 'Chat Transcripts',
        table_name     => 'CHAT_TRANSCRIPTS',
        id_column      => 'TRANSCRIPT_ID'
    ); 

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_transcript',
        attribute_name => 'pretty_name',
        pretty_name    => 'Transcript name',
        pretty_plural  => 'Transcript names',
        datatype       => 'string'
    );

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_transcript',
        attribute_name => 'description',
        pretty_name    => 'Description',
        pretty_plural  => 'Descriptions',
        datatype       => 'string'
    );

    attr_id := acs_attribute.create_attribute (
        object_type    => 'chat_transcript',
        attribute_name => 'contents',
        pretty_name    => 'Transcript content',
        pretty_plural  => 'Transcript contents',
        datatype       => 'string'
    );  
end;
/
show errors

create table chat_transcripts (
    transcript_id      integer
                       constraint chat_trans_transcript_id_pk primary key
                       constraint chat_trans_transcript_id_fk 
                       references acs_objects(object_id),
    contents           clob 
                       constraint chat_trans_contents_nn not null,
    -- Chat transcript name.
    pretty_name        varchar2(100)
                       constraint chat_trans_pretty_name_nn not null,
    description        varchar2(2000),
    room_id            integer
                       constraint chat_trans_room_id_fk references chat_rooms
);

create table chat_msgs (
    msg_id             integer 
                       constraint chat_msgs_msg_id_pk primary key, 
    msg                varchar2(4000),
    msg_len            integer 
                       constraint chat_msgs_msg_len_ck
                       check (msg_len >= 0), 
    html_p             char(1) default 'f' 
                       constraint chat_msgs_html_p_ck 
                       check (html_p in ('t','f')), 
    approved_p         char(1) default 't' 
                       constraint chat_msgs_approve_p_ck 
                       check(approved_p in ('t','f')), 
    creation_user      integer 
                       constraint chat_msgs_creation_user_fk 
                       references parties(party_id)
                       constraint chat_msgs_creation_user_nn not null,
    creation_ip        varchar2(50) ,
    creation_date      date
                       constraint chat_msgs_creation_date_nn not null,
    room_id            integer
                       constraint chat_msgs_room_id_fk references chat_rooms 
);

--
-- Package declaration
--

create or replace package chat_room
as
    function new (
        room_id        in chat_rooms.room_id%TYPE        default null,
        pretty_name    in chat_rooms.pretty_name%TYPE,
        description    in chat_rooms.description%TYPE    default null,
        moderated_p    in chat_rooms.moderated_p%TYPE    default 'f',
        active_p       in chat_rooms.active_p%TYPE       default 't',
        archive_p      in chat_rooms.archive_p%TYPE      default 'f',
	auto_flush_p   in chat_rooms.auto_flush_p%TYPE	 default 't',
	auto_transcript_p in chat_rooms.auto_transcript_p%TYPE default 'f',
	login_messages_p  in chat_rooms.login_messages_p%TYPE default  't',
	logout_messages_p in chat_rooms.logout_messages_p%TYPE default 't',	
        context_id     in acs_objects.context_id%TYPE    default null,
        creation_date  in acs_objects.creation_date%TYPE default sysdate,
        creation_user  in acs_objects.creation_user%TYPE default null,
        creation_ip    in acs_objects.creation_ip%TYPE   default null,
        object_type    in acs_objects.object_type%TYPE   default 'chat_room'
    ) return acs_objects.object_id%TYPE;

    procedure del (
        room_id        in chat_rooms.room_id%TYPE
    );    

    procedure edit (
        room_id        in chat_rooms.room_id%TYPE,
        pretty_name    in chat_rooms.pretty_name%TYPE,
        description    in chat_rooms.description%TYPE,
        moderated_p    in chat_rooms.moderated_p%TYPE,
        active_p       in chat_rooms.active_p%TYPE,
        archive_p      in chat_rooms.archive_p%TYPE,
   		auto_flush_p   in chat_rooms.auto_flush_p%TYPE,
		auto_transcript_p	in chat_rooms.auto_transcript_p%TYPE
    );        

    function name (
        room_id        in chat_rooms.room_id%TYPE
    ) return chat_rooms.pretty_name%TYPE;

    procedure message_post (
        room_id        in chat_msgs.room_id%TYPE,
        msg            in chat_msgs.msg%TYPE             default null,
        html_p         in chat_msgs.html_p%TYPE          default 'f',
        approved_p     in chat_msgs.approved_p%TYPE      default 't',
        creation_user  in chat_msgs.creation_user%TYPE,
        creation_ip    in chat_msgs.creation_ip%TYPE     default null,
        creation_date  in chat_msgs.creation_date%TYPE   default sysdate
    );

    function message_count (
        room_id        in chat_rooms.room_id%TYPE
    ) return integer;

    procedure delete_all_msgs (
        room_id        in chat_rooms.room_id%TYPE
    );

end chat_room;
/
show errors

create or replace package chat_transcript
as
    function new (
        transcript_id  in chat_transcripts.transcript_id%TYPE    default null,
        pretty_name    in chat_transcripts.pretty_name%TYPE,
        contents       in chat_transcripts.contents%TYPE,
        description    in chat_transcripts.description%TYPE,
        room_id        in chat_transcripts.room_id%TYPE,
        context_id     in acs_objects.context_id%TYPE            default null,
        creation_date  in acs_objects.creation_date%TYPE         default sysdate,
        creation_user  in acs_objects.creation_user%TYPE         default null,
        creation_ip    in acs_objects.creation_ip%TYPE           default null,
        object_type    in acs_objects.object_type%TYPE           default 'chat_transcript'
    ) return acs_objects.object_id%TYPE;        

    procedure del (
        transcript_id  in chat_transcripts.transcript_id%TYPE
    );

    procedure edit (
        transcript_id  in chat_transcripts.transcript_id%TYPE,
        pretty_name    in chat_transcripts.pretty_name%TYPE,
        contents       in chat_transcripts.contents%TYPE,
        description    in chat_transcripts.description%TYPE
    );    
end chat_transcript;
/
show errors

--
-- End package definition
--

--
-- Begin package body
--

create or replace package body chat_room
as
    function new (
        room_id        in chat_rooms.room_id%TYPE        default null,
        pretty_name    in chat_rooms.pretty_name%TYPE,
        description    in chat_rooms.description%TYPE    default null,
        moderated_p    in chat_rooms.moderated_p%TYPE    default 'f',
        active_p       in chat_rooms.active_p%TYPE       default 't',
        archive_p      in chat_rooms.archive_p%TYPE      default 'f',
	auto_flush_p   in chat_rooms.auto_flush_p%TYPE	 default 't',
	auto_transcript_p in chat_rooms.auto_transcript_p%TYPE default 'f',
	login_messages_p  in chat_rooms.login_messages_p%TYPE default  't',
	logout_messages_p in chat_rooms.logout_messages_p%TYPE default 't',	
        context_id     in acs_objects.context_id%TYPE    default null,
        creation_date  in acs_objects.creation_date%TYPE default sysdate,
        creation_user  in acs_objects.creation_user%TYPE default null,
        creation_ip    in acs_objects.creation_ip%TYPE   default null,
        object_type    in acs_objects.object_type%TYPE   default 'chat_room'
    ) return acs_objects.object_id%TYPE
    is
        v_room_id chat_rooms.room_id%TYPE;
    begin
        v_room_id := acs_object.new (
            object_type   => chat_room.new.object_type,
            creation_date => chat_room.new.creation_date,
            creation_user => chat_room.new.creation_user,
            creation_ip   => chat_room.new.creation_ip,
            context_id    => chat_room.new.context_id
        );

        insert into chat_rooms (
            room_id,   
            pretty_name, 
            description, 
            moderated_p, 
            active_p, 
            archive_p,
	    auto_flush_p,
	    auto_transcript_p,
	    login_messages_p,
	    logout_messages_p)
	values (
            v_room_id, 
            chat_room.new.pretty_name, 
            chat_room.new.description, 
            chat_room.new.moderated_p, 
            chat_room.new.active_p, 
            chat_room.new.archive_p,
	    chat_room.new.auto_flush_p,
	    chat_room.new.auto_transcript_p,
	    chat_room.new.login_messages_p,
	    chat_room.new.logout_messages_p);

        return v_room_id;
    end new;

    procedure del (
        room_id        in chat_rooms.room_id%TYPE
    )
    is
    begin
        -- First erase all the messages relate to this chat room.
        delete from chat_msgs where room_id = chat_room.del.room_id;

        -- Delete all privileges associate with this room
        delete from acs_permissions where object_id = chat_room.del.room_id;

        -- Now delete the chat room itself.
        delete from chat_rooms where room_id = chat_room.del.room_id;

        acs_object.del(room_id);
    end del;

    procedure edit (
        room_id        in chat_rooms.room_id%TYPE,
        pretty_name    in chat_rooms.pretty_name%TYPE,
        description    in chat_rooms.description%TYPE,
        moderated_p    in chat_rooms.moderated_p%TYPE,
        active_p       in chat_rooms.active_p%TYPE,
        archive_p      in chat_rooms.archive_p%TYPE,
	auto_flush_p   in chat_rooms.auto_flush_p%TYPE,
	auto_transcript_p	in chat_rooms.auto_transcript_p%TYPE
    ) 
    is
    begin
        update chat_rooms set
            pretty_name = chat_room.edit.pretty_name,
            description = chat_room.edit.description,
            moderated_p = chat_room.edit.moderated_p,
            active_p    = chat_room.edit.active_p,
            archive_p   = chat_room.edit.archive_p,
            auto_flush_p   = chat_room.edit.auto_flush_p,
            auto_transcript_p = chat_room.edit.auto_transcript_p
        where 
            room_id = chat_room.edit.room_id;
    end edit;        

    function name (
        room_id        in chat_rooms.room_id%TYPE
    ) return chat_rooms.pretty_name%TYPE
    is
        v_room_name chat_rooms.pretty_name%TYPE;
    begin
        select pretty_name into v_room_name 
        from chat_rooms
        where room_id = chat_room.name.room_id;

        return v_room_name;
    end name;

    procedure message_post (
        room_id        in chat_msgs.room_id%TYPE,
        msg            in chat_msgs.msg%TYPE             default null,
        html_p         in chat_msgs.html_p%TYPE          default 'f',
        approved_p     in chat_msgs.approved_p%TYPE      default 't',
        creation_user  in chat_msgs.creation_user%TYPE,
        creation_ip    in chat_msgs.creation_ip%TYPE     default null,
        creation_date  in chat_msgs.creation_date%TYPE   default sysdate
    )
    is
        v_msg_id chat_msgs.msg_id%TYPE;
        v_msg_archive_p chat_rooms.archive_p%TYPE;
        v_msg chat_msgs.msg%TYPE;
    begin
        -- Get msg id from the global acs_object sequence.
        select acs_object_id_seq.nextval into v_msg_id from dual;
        
        select archive_p into v_msg_archive_p
        from chat_rooms
        where room_id = chat_room.message_post.room_id;

        if v_msg_archive_p = 't' then
            v_msg := msg;
        else
            v_msg := null;
        end if;

        -- Insert into chat_msgs table.
        insert into chat_msgs (
            msg_id,   
            room_id, 
            msg, 
            msg_len, 
            html_p, 
            approved_p, 
            creation_user, 
            creation_ip, 
            creation_date)
        values (
            v_msg_id, 
            room_id, 
            v_msg, 
            nvl(length(msg), 0),
            html_p, 
            approved_p, 
            creation_user, 
            creation_ip, 
            creation_date) ;
    end message_post;


    function message_count (
        room_id        in chat_rooms.room_id%TYPE
    ) return integer
    is
        v_count integer;
    begin
        select count(*) into v_count 
        from chat_msgs
        where room_id = chat_room.message_count.room_id;
         
        return v_count;
    end message_count;

    procedure delete_all_msgs (
        room_id        in chat_rooms.room_id%TYPE
    )
    is
    begin
        delete from chat_msgs where room_id = chat_room.delete_all_msgs.room_id;
    end delete_all_msgs;

end chat_room;
/
show errors

create or replace package body chat_transcript
as
    function new (
        transcript_id     in chat_transcripts.transcript_id%TYPE    default null,
        pretty_name       in chat_transcripts.pretty_name%TYPE,
        contents          in chat_transcripts.contents%TYPE,
        description       in chat_transcripts.description%TYPE,
        room_id           in chat_transcripts.room_id%TYPE,
        context_id        in acs_objects.context_id%TYPE            default null,
        creation_date     in acs_objects.creation_date%TYPE         default sysdate,
        creation_user     in acs_objects.creation_user%TYPE         default null,
        creation_ip       in acs_objects.creation_ip%TYPE           default null,
        object_type       in acs_objects.object_type%TYPE           default 'chat_transcript'
    ) return acs_objects.object_id%TYPE
    is
        v_transcript_id chat_transcripts.transcript_id%TYPE;
    begin
        v_transcript_id := acs_object.new (
            object_type   => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip   => creation_ip,
            context_id    => context_id
            );
    
        insert into chat_transcripts (transcript_id,   pretty_name, contents, description, room_id)
                              values (v_transcript_id, pretty_name, empty_clob(), description, room_id);

        return v_transcript_id;
    end new;

    procedure del (
        transcript_id     in chat_transcripts.transcript_id%TYPE
    )
    is
    begin

        -- Delete all privileges associate with this transcript
        delete from acs_permissions where object_id = chat_transcript.del.transcript_id;

        delete from chat_transcripts 
        where transcript_id = chat_transcript.del.transcript_id;
        
        acs_object.del(transcript_id);
    end del;

    procedure edit (
        transcript_id     in chat_transcripts.transcript_id%TYPE,
        pretty_name       in chat_transcripts.pretty_name%TYPE,
        contents          in chat_transcripts.contents%TYPE,
        description       in chat_transcripts.description%TYPE
    ) 
    is
    begin
        update chat_transcripts    
        set pretty_name = chat_transcript.edit.pretty_name,
            contents    = chat_transcript.edit.contents,
            description = chat_transcript.edit.description
        where
            transcript_id = chat_transcript.edit.transcript_id;

        end edit;

end chat_transcript;
/
show errors










