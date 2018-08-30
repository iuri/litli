<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="nuke_user">
        <querytext>
           select acs__remove_user(:user_id);
        </querytext>
    </fullquery>

</queryset>
