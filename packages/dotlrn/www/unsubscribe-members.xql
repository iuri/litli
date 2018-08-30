<?xml version="1.0"?>

<queryset>

    <fullquery name="update_autosubscribe_p">
        <querytext>
            update forums_forums
            set autosubscribe_p = 'f'
            where forum_id = :forum_id
        </querytext>
    </fullquery>

</queryset>
