<?xml version="1.0"?>

<queryset>

  <fullquery name="calendar-portlet::after_upgrade.update_portal_datasources">
    <querytext>
      update portal_datasources
      set css_dir = '/resources/calendar'
      where name like '%calendar%'
    </querytext>
  </fullquery>

</queryset>
