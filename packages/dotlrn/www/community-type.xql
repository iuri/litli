<?xml version="1.0"?>

<queryset>

    <fullquery name="select_community_type_info">
        <querytext>
            select pretty_name,
                   description,
                   supertype
            from dotlrn_community_types
            where community_type = :community_type
        </querytext>
    </fullquery>

</queryset>
