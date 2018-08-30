<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="dotlrn::install.add_role">
        <querytext>
            select acs_rel_type__create_role(
                :role_key,
                :pretty_name,
                :pretty_plural
            )
        </querytext>
    </fullquery>

    <fullquery name="dotlrn::install_classes.add_role">
        <querytext>
            select acs_rel_type__create_role(
                :role_key,
                :pretty_name,
                :pretty_plural
            )
        </querytext>
    </fullquery>

</queryset>
