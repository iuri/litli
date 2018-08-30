<?xml version="1.0"?>
<queryset>
    <fullquery name="dotlrn_forums::add_user_to_community.select_forums">
        <querytext>
            select forum_id
            from forums_forums
            where package_id = :package_id
              and autosubscribe_p = 't'
        </querytext>
    </fullquery>
</queryset>
