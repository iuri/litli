<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="list_parties">
  <querytext>
     select party_id, acs_object__name(party_id) as name
     from parties
  </querytext>
</fullquery>

</queryset>
