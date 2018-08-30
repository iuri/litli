<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="user_contributions">
        <querytext>
    select acs_object_types.pretty_name,
           acs_object_types.pretty_plural,
           acs_objects.creation_date,
           acs_object__name(acs_objects.object_id) as object_name
    from acs_objects,
         acs_object_types
    where acs_objects.creation_user = :user_id
    and acs_objects.object_type in ('acs_message')
    and acs_objects.object_type = acs_object_types.object_type
    order by object_name,
             creation_date
        </querytext>
    </fullquery>

</queryset>
