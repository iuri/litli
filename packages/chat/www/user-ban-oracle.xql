<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>


<fullquery name="list_parties">
  <querytext>
    select party_id, acs_object.name(party_id) as name
    from parties
  </querytext>
</fullquery>


</queryset>
