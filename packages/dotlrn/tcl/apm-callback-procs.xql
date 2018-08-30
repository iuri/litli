<?xml version="1.0"?>

<queryset>

  <fullquery name="dotlrn::apm::after_instantiate.select_st_id">
    <querytext>
       select site_template_id
       from dotlrn_site_templates
       where pretty_name = :default_template_name
    </querytext>
  </fullquery>

  <fullquery name="dotlrn::apm::after_upgrade.get_default_values">
    <querytext>
      select default_value
      from apm_parameters
      where package_key = 'dotlrn'
        and parameter_name like '%_csv'
    </querytext>
  </fullquery>

  <fullquery name="dotlrn::apm::after_upgrade.set_accesskeys">
    <querytext>
      update portal_pages
      set accesskey = :accesskey
      where pretty_name = :title
    </querytext>
  </fullquery>

  <fullquery name="dotlrn::apm::after_upgrade.update_community_supertype">
    <querytext>
      update acs_object_types
      set supertype = 'application_group'
      where object_type = 'dotlrn_community'
    </querytext>
  </fullquery>

  <fullquery name="dotlrn::apm::after_upgrade.insert_application_group_rows">
    <querytext>
      insert into application_groups
        (group_id, package_id)
      select community_id, package_id
      from dotlrn_communities
    </querytext>
  </fullquery>

</queryset>
