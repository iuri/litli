<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_user_info">
        <querytext>
            select dotlrn_users.id,
                   dotlrn_users.first_names,
                   dotlrn_users.last_name,
                   dotlrn_users.email,
                   dotlrn_users.type,
                   dotlrn_privacy.guest_p(:user_id) as guest_p
            from dotlrn_users
            where dotlrn_users.user_id = :user_id
        </querytext>
  </fullquery>

</queryset>
