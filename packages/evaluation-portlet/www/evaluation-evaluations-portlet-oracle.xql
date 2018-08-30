<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_total_grade">      
      <querytext>

        select evaluation.class_total_grade($user_id,[lindex $list_of_package_ids 0]) from dual

      </querytext>
</fullquery>

</queryset>
