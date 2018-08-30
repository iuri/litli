<?xml version="1.0"?>
<queryset>

<fullquery name="dotlrn_homework_applet::get_package_id.select_package_id">      
   <querytext>
      
     select min(package_id)
     from apm_packages
     where package_key = 'dotlrn-homework'
        
   </querytext>
</fullquery>

 
</queryset>
