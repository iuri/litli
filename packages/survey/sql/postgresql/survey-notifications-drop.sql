-- Survey
--
-- @author dave@thedesignexperience.org, ben@openforce.biz
-- @creation-date 2002-08-03
--
-- integration with Notifications


--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
        impl_id integer;
        v_foo   integer;
BEGIN


      v_foo := acs_sc_impl_alias__delete (
		    'NotificationType',
                    'survey_response_notif_type',
                    'GetURL'
                 );

      v_foo := acs_sc_impl_alias__delete (
                    'NotificationType',
                    'survey_response_notif_type',
                    'ProcessReply'
                 );

      v_foo := acs_sc_binding__delete (
                    'NotificationType',
                    'survey_response_notif_type'
                 );

       SELECT type_id from notification_types where short_name = 'survey_response_notif'
       INTO v_foo;

       v_foo := notification_type__delete(v_foo);

       v_foo := acs_sc_impl__delete (
                     'NotificationType',
                     'survey_response_notif_type'
                  );

return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();


