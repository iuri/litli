<?xml version="1.0"?>

<queryset>
    <fullquery name="survey::notification::get_url.get_package_id">
	<querytext>
	    select package_id from surveys
	    where survey_id=:object_id
	</querytext>
    </fullquery>
</queryset>