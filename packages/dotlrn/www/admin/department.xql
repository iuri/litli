<?xml version="1.0"?>

<queryset>

    <fullquery name="select_departments_info">
        <querytext>
            select pretty_name,
                   description,
                   external_url
            from dotlrn_departments_full
            where department_key = :department_key
        </querytext>
    </fullquery>

</queryset>
