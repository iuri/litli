<?xml version="1.0"?>

<queryset>

    <fullquery name="dotlrn_department::new.insert_department">
        <querytext>
            insert into dotlrn_departments
            (department_key, external_url)
            values
            (:department_key, :external_url)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_department::check_department_key_valid_p.check">
        <querytext>
            select 1
            from dotlrn_departments
            where department_key = :department_key
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_department::select_as_list.select_departments">
        <querytext>
            select pretty_name,
                   department_key
            from dotlrn_departments_full
            order by pretty_name
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_department::count_classes.select_count_classes">
        <querytext>
            select count(*) from dotlrn_classes where department_key = :department_key
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_department::delete.delete_department">
        <querytext>
            delete from dotlrn_departments where department_key = :department_key
        </querytext>
    </fullquery>

</queryset>
