<?xml version="1.0"?>

<queryset>

    <partialquery name="qualify_by_owner">
        <querytext>
            and (o.creation_user = :user_id or f.folder_id is not null) 
        </querytext>
    </partialquery>

</queryset>
