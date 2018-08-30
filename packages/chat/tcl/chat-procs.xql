<?xml version="1.0"?>
<queryset>

  <fullquery name="chat_room_new.insert_room">
    <querytext>
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
            logout_messages_p,
	    messages_time_window
        ) values (
            :room_id,
            :pretty_name,
            :description,
            :moderated_p,
            :active_p,
            :archive_p,
            :auto_flush_p,
            :auto_transcript_p,
            :login_messages_p,
            :logout_messages_p,
	    :messages_time_window	    
        )
    </querytext>
  </fullquery>

  <fullquery name="chat_room_edit.update_room">
    <querytext>
      update chat_rooms set
         pretty_name          = :pretty_name,
         description          = :description,
         moderated_p          = :moderated_p,
         active_p             = :active_p,
         archive_p            = :archive_p,
         auto_flush_p         = :auto_flush_p,
         auto_transcript_p    = :auto_transcript_p,
         login_messages_p     = :login_messages_p,
         logout_messages_p    = :logout_messages_p,
	 messages_time_window = :messages_time_window
      where room_id = :room_id
    </querytext>
  </fullquery>

  <fullquery name="chat_transcript_new.insert_transcript">
    <querytext>
      insert into chat_transcripts (
              transcript_id
             ,pretty_name
	     ,contents
	     ,description
	     ,room_id
	   ) values (
	      :transcript_id
	     ,:pretty_name
	     ,:contents
	     ,:description
	     ,:room_id
	   )
    </querytext>
  </fullquery>

  <fullquery name="chat_transcript_edit.update_transcript">
    <querytext>
      update chat_transcripts set
         pretty_name = :pretty_name,
         contents    = :contents,
         description = :description
      where transcript_id = :transcript_id;
    </querytext>
  </fullquery>

  <fullquery name="chat_flush_rooms.get_rooms">
    <querytext>
            select room_id
            from chat_rooms
            where archive_p = 't' and auto_flush_p = 't'
    </querytext>
  </fullquery>

  <fullquery name="chat_room_flush.get_archives_messages">
    <querytext>
      select msg, creation_user, to_char(creation_date, 'DD.MM.YYYY hh24:mi:ss') as creation_date
      from chat_msgs
      where room_id = :room_id
          and msg is not null
      order by creation_date
    </querytext>
  </fullquery>

</queryset>
