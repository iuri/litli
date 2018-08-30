<?xml version="1.0"?>

<queryset>

    <fullquery name="select_not_installed_applets">
        <querytext>
            select acs_sc_impls.impl_name
            from acs_sc_impls,
                 acs_sc_bindings,
                 acs_sc_contracts
            where acs_sc_contracts.contract_name = 'dotlrn_applet'
            and acs_sc_contracts.contract_id = acs_sc_bindings.contract_id
            and acs_sc_impls.impl_id = acs_sc_bindings.impl_id
        </querytext>
    </fullquery>

</queryset>
