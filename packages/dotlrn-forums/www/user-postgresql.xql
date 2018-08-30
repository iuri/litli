<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2.1</version></rdbms>

    <fullquery name="select_messages">
        <querytext>
            select forums_messages.message_id,
                   forums_messages.subject,
                   to_char(forums_messages.posting_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date_ansi,
                   forums_forums.forum_id,
                   forums_forums.package_id,
                   forums_forums.name as forum_name,
                   (select site_node__url(node_id)
                    from site_nodes
                    where object_id = forums_forums.package_id) as url
            from forums_messages,
                 forums_forums
            where forums_messages.user_id = :user_id
            and forums_messages.forum_id = forums_forums.forum_id
            order by forums_messages.posting_date desc
        </querytext>
    </fullquery>

    <fullquery name="select_messages_by_forum">
        <querytext>
            select forums_messages.message_id,
                   forums_messages.subject,
                   to_char(forums_messages.posting_date, 'YYYY-MM-DD HH24:MI:SS') as posting_date_ansi,
                   forums_forums.forum_id,
                   forums_forums.package_id,
                   forums_forums.name as forum_name,
                   (select site_node__url(node_id)
                    from site_nodes
                    where object_id = forums_forums.package_id) as url
            from forums_messages,
                 forums_forums
            where forums_messages.user_id = :user_id
            and forums_messages.forum_id = forums_forums.forum_id
            order by forum_name,
                     forums_messages.posting_date desc
        </querytext>
    </fullquery>

</queryset>
