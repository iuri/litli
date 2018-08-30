<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="dotlrn_chat::clone.call_chat_clone">
  <querytext>
		begin 
			  chat.clone ( 
						 :old_package_id,
						 :new_package_id
			  );
		end;
  </querytext>
</fullquery>


</queryset>
