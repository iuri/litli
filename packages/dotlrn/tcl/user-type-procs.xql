<?xml version="1.0"?>

<queryset>

    <fullquery name="dotlrn::user::type::get_not_cached.select_dotlrn_user_type_info">
        <querytext>
            select *
            from dotlrn_user_types
            where type = :type
        </querytext>
    </fullquery>

</queryset>
