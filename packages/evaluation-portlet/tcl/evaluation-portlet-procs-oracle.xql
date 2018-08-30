<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="evaluation_assignments_portlet::uninstall.delete_assignments_ds">      
      <querytext>
	begin
		portal_datasource.del(datasource_id => :ds_id);
    end;
      </querytext>
</fullquery>

<fullquery name="evaluation_evaluations_portlet::uninstall.delete_evaluations_ds">      
      <querytext>
	begin
		portal_datasource.del(datasource_id => :ds_id);
    end;
      </querytext>
</fullquery>

<fullquery name="evaluation_admin_portlet::uninstall.delete_admin_ds">      
      <querytext>
	begin
		portal_datasource.del(datasource_id => :ds_id);
    end;
      </querytext>
</fullquery>
 
<fullquery name="evaluation_evaluations_portlet::get_package_id_from_key.get_package_id">      
      <querytext>
	select dca.package_id 
	from dotlrn_community_applets dca,apm_packages ap 
	where community_id=:community_id 
	and ap.package_id=dca.package_id and ap.package_key=:package_key
      </querytext>
</fullquery>

</queryset>
