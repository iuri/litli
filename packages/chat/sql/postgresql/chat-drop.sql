--
-- packages/chat/sql/chat-drop.sql
--
-- @author ddao@arsdigita.com
-- @creation-date November 09, 2000
-- @cvs-id $Id: chat-drop.sql,v 1.4.6.2 2016/11/23 19:51:16 antoniop Exp $
--

      --drop objects



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
	object_rec		record;
BEGIN

        for object_rec in select object_id from acs_objects where object_type='chat_transcript'
	loop
		PERFORM acs_object__delete( object_rec.object_id );
	end loop;

	for object_rec in select object_id from acs_objects where object_type='chat_room'
	loop
		PERFORM acs_object__delete( object_rec.object_id );
	end loop;


  return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0 ();
drop function inline_0 ();


--
-- Drop chat_room object type
--




select acs_object_type__drop_type('chat_room','t');
select acs_object_type__drop_type('chat_transcript','t');

drop   function chat_transcript__del (integer);

drop   function chat_room__message_post (integer, varchar, integer, varchar);
drop   function chat_room__delete_all_msgs (integer);
drop   function chat_room__del (integer);

drop table chat_msgs;
drop table chat_transcripts;
drop table chat_rooms;


--
-- Drop all chat privileges
--

CREATE OR REPLACE FUNCTION inline_0 () RETURNS integer AS $$
BEGIN

  -- Drop child privileges for regular chat user.
 PERFORM acs_privilege__remove_child('chat_user', 'chat_read');
 PERFORM acs_privilege__remove_child('chat_user', 'chat_write');

 -- Drop child privileges for chat moderator.
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_room_moderate');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_user_ban');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_user_unban');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_user_grant');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_user_revoke');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_transcript_create');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_transcript_view');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_transcript_edit');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_transcript_delete');
 PERFORM acs_privilege__remove_child('chat_moderator', 'chat_user');

  -- Drop child privileges for chat administrator.
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_room_create');
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_room_delete');
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_room_edit');
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_room_view');
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_moderator_grant');
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_moderator_revoke');
 PERFORM acs_privilege__remove_child('chat_room_admin', 'chat_moderator');

 -- remove Site wite admin also administrator of the chat room
 PERFORM acs_privilege__remove_child('admin', 'chat_room_admin');



 PERFORM acs_privilege__drop_privilege('chat_room_create');
 PERFORM acs_privilege__drop_privilege('chat_room_view');
 PERFORM acs_privilege__drop_privilege('chat_room_edit');
 PERFORM acs_privilege__drop_privilege('chat_room_delete');
 PERFORM acs_privilege__drop_privilege('chat_transcript_create');
 PERFORM acs_privilege__drop_privilege('chat_transcript_view');
 PERFORM acs_privilege__drop_privilege('chat_transcript_edit');
 PERFORM acs_privilege__drop_privilege('chat_transcript_delete');
 PERFORM acs_privilege__drop_privilege('chat_room_moderate');
 PERFORM acs_privilege__drop_privilege('chat_moderator_grant');
 PERFORM acs_privilege__drop_privilege('chat_moderator_revoke');
 PERFORM acs_privilege__drop_privilege('chat_user_grant');
 PERFORM acs_privilege__drop_privilege('chat_user_revoke');
 PERFORM acs_privilege__drop_privilege('chat_user_ban');
 PERFORM acs_privilege__drop_privilege('chat_user_unban');
 PERFORM acs_privilege__drop_privilege('chat_ban');
 PERFORM acs_privilege__drop_privilege('chat_read');
 PERFORM acs_privilege__drop_privilege('chat_write');
 PERFORM acs_privilege__drop_privilege('chat_room_admin');
 PERFORM acs_privilege__drop_privilege('chat_moderator');
 PERFORM acs_privilege__drop_privilege('chat_user');


  return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0 ();
drop function inline_0 ();
