<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluation_relationship_new">      
      <querytext>

				select acs_rel__new (
									 null,
									 'evaluation_task_group_rel',
									 :new_evaluation_group_id,
									 :new_member_id,
									 :package_id,
									 :creation_user_id,
									 :creation_ip
									 );
	
      </querytext>
</fullquery>

</queryset>
