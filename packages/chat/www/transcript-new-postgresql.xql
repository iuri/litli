<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_archives_messages">
  <querytext>
    select msg, creation_user, to_char(creation_date, 'DD.MM.YYYY hh24:mi:ss') as creation_date
    from chat_msgs
    where room_id = :room_id
          and msg is not null
    order by creation_date
  </querytext>
</fullquery>

</queryset>
