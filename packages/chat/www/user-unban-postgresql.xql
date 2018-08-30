<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_party_name">
  <querytext>
      select acs_object__name(:party_id) from dual
  </querytext>
</fullquery>

</queryset>
