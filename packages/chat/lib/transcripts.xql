<?xml version="1.0"?>
<queryset>

<fullquery name="list_transcripts">
  <querytext>
   select ct.transcript_id, ct.pretty_name, ao.creation_date
    from chat_transcripts ct, acs_objects ao
    where ct.transcript_id = ao.object_id and ct.room_id = :room_id
    order by ao.creation_date desc
 </querytext>
</fullquery>

</queryset>
