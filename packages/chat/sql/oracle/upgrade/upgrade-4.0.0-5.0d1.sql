--      
-- packages/chat/sql/chat-create.sql
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
        archive_p      in chat_rooms.archive_p%TYPE
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
            object_type   => object_type,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip   => creation_ip,
            context_id    => context_id
            );

        insert into chat_rooms (
            room_id,   
            pretty_name, 
            description, 
            moderated_p, 
            active_p, 
            archive_p)
        values (
            v_room_id, 
            pretty_name, 
            description, 
            moderated_p, 
            active_p, 
            archive_p);

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
        archive_p      in chat_rooms.archive_p%TYPE
    ) 
    is
    begin
        update chat_rooms set
            pretty_name = chat_room.edit.pretty_name,
            description = chat_room.edit.description,
            moderated_p = chat_room.edit.moderated_p,
            active_p    = chat_room.edit.active_p,
            archive_p   = chat_room.edit.archive_p
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










