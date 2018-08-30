<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="chat_message_count.message_count">
    <querytext>
      select count(*) from chat_msgs
       where room_id = :room_id
    </querytext>
  </fullquery>

  <fullquery name="chat_room_message_delete.delete_message">
    <querytext>
      select chat_room__delete_all_msgs(:room_id)
    </querytext>
  </fullquery>

  <fullquery name="chat_transcript_delete.delete_transcript">
    <querytext>
      select chat_transcript__del(:transcript_id)
    </querytext>
  </fullquery>

  <fullquery name="chat_post_message_to_db.post_message">
    <querytext>
      select chat_room__message_post(:room_id, :msg, :creation_user, :creation_ip)
    </querytext>
  </fullquery>

  <fullquery name="chat_room_delete.delete_room">
    <querytext>
      select chat_room__del(:room_id)
    </querytext>
  </fullquery>

</queryset>
