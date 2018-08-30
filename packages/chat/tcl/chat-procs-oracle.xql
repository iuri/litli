<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="chat_room_new.create_room">
      <querytext>

            begin
	        :1 := chat_room.new (
	            pretty_name       => :pretty_name,
	            moderated_p       => :moderated_p,
                    description       => :description,
	            active_p          => :active_p,
	            login_messages_p  => :login_messages_p,
	            logout_messages_p => :logout_messages_p,
                    archive_p         => :archive_p,
	            context_id        => :context_id,
	            creation_user     => :creation_user,
	            creation_ip       => :creation_ip
	        );
	    end;

      </querytext>
</fullquery>

<fullquery name="chat_room_new.grant_permission">
      <querytext>

        begin
        -- Automatic grant room privilege to creator of the room (must not be null).
                if :creation_user <> ''
                then
	            acs_permission.grant_permission(:room_id, :creation_user, 'chat_room_edit');
	            acs_permission.grant_permission(:room_id, :creation_user, 'chat_room_view');
	            acs_permission.grant_permission(:room_id, :creation_user, 'chat_room_delete');
	            acs_permission.grant_permission(:room_id, :creation_user, 'chat_transcript_create');
                end if;

        end;

      </querytext>
</fullquery>




<fullquery name="chat_room_name.get_room_name">
      <querytext>
          select pretty_name from chat_rooms where room_id = :room_id

      </querytext>
</fullquery>

<fullquery name="chat_user_grant.grant_user">
      <querytext>
       begin
          acs_permission.grant_permission(:room_id, :party_id, 'chat_write');
	  acs_permission.grant_permission(:room_id, :party_id, 'chat_read');
	end;
      </querytext>
</fullquery>

<fullquery name="chat_user_revoke.revoke_user">
      <querytext>
       begin
	    acs_permission.revoke_permission(:room_id, :party_id, 'chat_write');
	    acs_permission.revoke_permission(:room_id, :party_id, 'chat_read');
       end;
      </querytext>
</fullquery>

<fullquery name="chat_user_ban.ban_user">
      <querytext>
      begin
	acs_permission.grant_permission(:room_id, :party_id, 'chat_ban');
      end;
      </querytext>
</fullquery>

<fullquery name="chat_user_unban.ban_user">
      <querytext>
        begin
	   acs_permission.revoke_permission(:room_id, :party_id, 'chat_ban');
	end;
      </querytext>
</fullquery>

<fullquery name="chat_moderator_grant.grant_moderator">
      <querytext>
        begin
	    acs_permission.grant_permission(:room_id, :party_id, 'chat_room_moderate');
	end;
      </querytext>
</fullquery>


<fullquery name="chat_moderator_revoke.revoke_moderator">
      <querytext>
        begin
	    acs_permission.revoke_permission(:room_id, :party_id, 'chat_room_moderate');
	end;
     </querytext>
</fullquery>


<fullquery name="chat_room_edit.edit_room">
      <querytext>
         begin
	    chat_room.edit (
	        room_id           => :room_id,
	        pretty_name       => :pretty_name,
                description       => :description,
	        moderated_p       => :moderated_p,
	        active_p          => :active_p,
                archive_p         => :archive_p,
		auto_flush_p      => :auto_flush_p,
            	auto_transcript_p => :auto_transcript_p,
	        login_messages_p  => :login_messages_p,
	        logout_messages_p => :logout_messages_p
	    );
	end;
     </querytext>
</fullquery>


<fullquery name="chat_message_count.message_count">
      <querytext>
         begin
	    :1 := chat_room.message_count(:room_id);
        end;
     </querytext>
</fullquery>


<fullquery name="chat_room_message_delete.delete_message">
      <querytext>
          begin
	    chat_room.delete_all_msgs(:room_id);
	end;
     </querytext>
</fullquery>


<fullquery name="chat_transcript_new.create_transcript">
      <querytext>
          begin
	        :1 := chat_transcript.new (
	            pretty_name   => :pretty_name,
	            contents      => empty_clob(),
                    description   => :description,
	            room_id       => :room_id,
	            context_id    => :context_id,
	            creation_user => :creation_user,
	            creation_ip   => :creation_ip
	        );

	    end;
     </querytext>
</fullquery>



<fullquery name="chat_transcript_new.grant_permission">
      <querytext>
        begin
           -- Automatic grant transcript privilege to creator of the transcript (must not be null).
                if :creation_user is not null
                then
	           acs_permission.grant_permission(:transcript_id, :creation_user, 'chat_transcript_edit');
	           acs_permission.grant_permission(:transcript_id, :creation_user, 'chat_transcript_view');
	           acs_permission.grant_permission(:transcript_id, :creation_user, 'chat_transcript_delete');
                end if;
        end;
      </querytext>
</fullquery>

<fullquery name="chat_transcript_delete.delete_transcript">
      <querytext>
        begin
	    chat_transcript.del(:transcript_id);
	end;
      </querytext>
</fullquery>


<fullquery name="chat_post_message_to_db.post_message">
      <querytext>
         begin
	    chat_room.message_post (
	        room_id       => :room_id,
                msg           => :msg,
                creation_user => :creation_user,
                creation_ip   => :creation_ip
	    );
	end;

      </querytext>
</fullquery>


 <fullquery name="chat_room_delete.delete_room">
      <querytext>
           begin
	    chat_room.del(:room_id);
	end;
      </querytext>
</fullquery>


<fullquery name="chat_transcript_edit.edit_transcript">
      <querytext>
           begin
	    chat_transcript.edit(
	        transcript_id => :transcript_id,
	        pretty_name   => :pretty_name,
		contents      => empty_clob(),
                description   => :description);
	    end;
      </querytext>
</fullquery>

</queryset>
