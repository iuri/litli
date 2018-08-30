<? xml version="1.0" ?>
<queryset>

    <fullquery name="member_email">
        <querytext>
            select from_addr,
                   subject,
                   email
            from dotlrn_member_emails
	    where community_id = :community_id 
	    and type = :type
        </querytext>
    </fullquery>

</queryset>