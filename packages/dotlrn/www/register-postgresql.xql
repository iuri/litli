<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="bulk_mail_query">
        <querytext>

            select parties.email,
                   case acs_objects.object_type
                   when 'user' then 
                      (select first_names
                      from persons
                      where person_id = parties.party_id)
                   when 'group' then 
                     (select group_name
                      from groups
                      where group_id = parties.party_id)
                   when 'rel_segment' then
                     (select segment_name
                      from rel_segments
                      where segment_id = parties.party_id)
                   else ''
                   end as first_names,
                   case acs_objects.object_type
                   when 'user' then 
                     (select last_name
                      from persons
                      where person_id = parties.party_id)
                   else ''
                   end  as last_name
            from   party_approved_member_map,
                   parties,
                   acs_objects
            where  party_approved_member_map.party_id = $segment_id
            and    party_approved_member_map.member_id <> $segment_id
            and    party_approved_member_map.member_id = parties.party_id
            and    parties.party_id = acs_objects.object_id

        </querytext>
    </partialquery>

</queryset>
