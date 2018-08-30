<?xml version="1.0"?>

<queryset>

    <fullquery name="select_class_info">
        <querytext>
            select pretty_name,
                   description
            from dotlrn_classes_full
            where class_key = :class_key
        </querytext>
    </fullquery>

    <fullquery name="update_community_info">
      <querytext>
        update dotlrn_communities_all
        set active_start_date = to_date(:active_start_date, 'YYYY-MM-DD HH24:MI:SS'),
          active_end_date = to_date(:active_end_date, 'YYYY-MM-DD HH24:MI:SS')
        where community_id = :class_instance_id
      </querytext>
    </fullquery>

</queryset>
