<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_current_members">
        <querytext>
            select dotlrn_member_rels_approved.rel_id,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   dotlrn_member_rels_approved.user_id,
                   acs_users_all.first_names,
                   acs_users_all.last_name,
                   acs_users_all.email,
                   (select count(*) from acs_rels where rel_type = 'user_portrait_rel' and object_id_one = dotlrn_member_rels_approved.user_id) as portrait_p,
                   (select count(*) from acs_attribute_values where object_id = dotlrn_member_rels_approved.user_id and attribute_id = 
:bio_attribute_id and attr_value is not null) as bio_p
            from acs_users_all,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
            order by (
                CASE 
                    WHEN role = 'instructor'
                    THEN 1
                    WHEN role = 'admin'
                    THEN 2
                    WHEN role = 'teaching_assistant'
                    THEN 3
                    WHEN role = 'course_assistant'
                    THEN 4
                    WHEN role = 'student'
                    THEN 6
                    WHEN role = 'member'
                    THEN 7
                END
            ) asc, $order_by
        </querytext>
    </fullquery>

</queryset>
