<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_next_object_id">      
      <querytext>
      select acs_object_id_seq.nextval from dual
      </querytext>
</fullquery>

 
</queryset>
