<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="update_album_attributes">      
      <querytext>
	    select content_revision__new (
	      :new_title, -- title
	      :new_desc, -- description
	      current_timestamp, -- publish_date
	      null, -- mime_type
	      null, -- nls_language
	      null, -- text
	      :album_id, -- item_id
	      :revision_id, -- revision_id
	      current_timestamp, -- creation_date 
	      :user_id, -- creation_user 
	      :peeraddr -- creation_ip
	    )
      </querytext>
</fullquery>

<fullquery name="set_live_album">      
      <querytext>
      select content_item__set_live_revision (
      :revision_id, -- revision_id
      'ready' -- publish_status
      )
      </querytext>
</fullquery>

 
</queryset>
