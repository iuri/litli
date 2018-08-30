--
-- Survey
--
-- -- @author dave@thedesignexperience.org, ben@openforce.biz
-- @creation-date 2002-08-03
--
-- integration with Notifications
declare
        impl_id integer;
        v_foo   integer;
begin
        -- the notification type impl
       impl_id := acs_sc_impl.new (
                     impl_contract_name => 'NotificationType',
                     impl_name => 'survey_response_notif_type',
		     impl_pretty_name => 'Survey Responce Notification',
                     impl_owner_name => 'survey'
                  );

        v_foo := acs_sc_impl.new_alias (
		    'NotificationType',
                    'survey_response_notif_type',
                    'GetURL',
                    'survey::notification::get_url',
                    'TCL'
                 );

	v_foo := acs_sc_impl.new_alias (
                    'NotificationType',
                    'survey_response_notif_type',
                    'ProcessReply',
                    'survey::notification::process_reply',
                    'TCL'
                 );

        acs_sc_binding.new (
                    contract_name => 'NotificationType',
                    impl_name => 'survey_response_notif_type'
                 );

        v_foo:= notification_type.new (
                short_name => 'survey_response_notif',
                sc_impl_id => impl_id,
                pretty_name => 'Survey Response',
                description => 'Notifications for Survey',
                creation_user => NULL,
                creation_ip => NULL
                );

        -- enable the various intervals and delivery methods
        insert into notification_types_intervals
        (type_id, interval_id)
        select v_foo, interval_id
        from notification_intervals where name in ('instant','hourly','daily');

        insert into notification_types_del_methods
        (type_id, delivery_method_id)
        select v_foo, delivery_method_id
        from notification_delivery_methods where short_name in ('email');

end;
/
show errors
