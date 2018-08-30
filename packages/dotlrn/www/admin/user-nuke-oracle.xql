<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="nuke_user">
        <querytext>
           begin 
             acs.remove_user(:user_id); 
           end; 
        </querytext>
    </fullquery>

</queryset>
