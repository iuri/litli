--      
-- packages/chat/sql/chat-drop.sql
--
-- @author ddao@arsdigita.com
-- @creation-date November 09, 2000
-- @cvs-id $Id: chat-drop.sql,v 1.3 2007/11/19 01:14:15 donb Exp $
--

--
-- Drop chat_room object type
--
begin
    acs_object_type.drop_type('chat_room');
    acs_object_type.drop_type('chat_transcript');
end;
/
show errors


drop package chat_room;
drop package chat_transcript;

drop table chat_msgs;
drop table chat_transcripts;
drop table chat_rooms;

-- 
-- Drop all chat privileges
--
begin

    -- Drop child privileges for regular chat user.
    acs_privilege.remove_child('chat_user', 'chat_read');
    acs_privilege.remove_child('chat_user', 'chat_write');

    -- Drop child privileges for chat moderator.
    acs_privilege.remove_child('chat_moderator', 'chat_room_moderate');
    acs_privilege.remove_child('chat_moderator', 'chat_user_ban');
    acs_privilege.remove_child('chat_moderator', 'chat_user_unban');
    acs_privilege.remove_child('chat_moderator', 'chat_user_grant');
    acs_privilege.remove_child('chat_moderator', 'chat_user_revoke');
    acs_privilege.remove_child('chat_moderator', 'chat_transcript_create');
    acs_privilege.remove_child('chat_moderator', 'chat_transcript_view');    
    acs_privilege.remove_child('chat_moderator', 'chat_transcript_edit');
    acs_privilege.remove_child('chat_moderator', 'chat_transcript_delete');
    acs_privilege.remove_child('chat_moderator', 'chat_user');

    -- Drop child privileges for chat administrator.
    acs_privilege.remove_child('chat_room_admin', 'chat_room_create');
    acs_privilege.remove_child('chat_room_admin', 'chat_room_delete');
    acs_privilege.remove_child('chat_room_admin', 'chat_room_edit');
    acs_privilege.remove_child('chat_room_admin', 'chat_room_view');
    acs_privilege.remove_child('chat_room_admin', 'chat_moderator_grant');
    acs_privilege.remove_child('chat_room_admin', 'chat_moderator_revoke');
    acs_privilege.remove_child('chat_room_admin', 'chat_moderator');

    acs_privilege.remove_child('admin', 'chat_room_admin');        

    acs_privilege.drop_privilege('chat_room_create');
    acs_privilege.drop_privilege('chat_room_view');
    acs_privilege.drop_privilege('chat_room_edit');
    acs_privilege.drop_privilege('chat_room_delete');
    acs_privilege.drop_privilege('chat_transcript_create');
    acs_privilege.drop_privilege('chat_transcript_view');
    acs_privilege.drop_privilege('chat_transcript_edit');
    acs_privilege.drop_privilege('chat_transcript_delete');
    acs_privilege.drop_privilege('chat_room_moderate');
    acs_privilege.drop_privilege('chat_moderator_grant');
    acs_privilege.drop_privilege('chat_moderator_revoke');
    acs_privilege.drop_privilege('chat_user_grant');
    acs_privilege.drop_privilege('chat_user_revoke');
    acs_privilege.drop_privilege('chat_user_ban');
    acs_privilege.drop_privilege('chat_user_unban');
    acs_privilege.drop_privilege('chat_ban');
    acs_privilege.drop_privilege('chat_read');
    acs_privilege.drop_privilege('chat_write');
    acs_privilege.drop_privilege('chat_room_admin');
    acs_privilege.drop_privilege('chat_moderator');
    acs_privilege.drop_privilege('chat_user');
end;
/
show errors









