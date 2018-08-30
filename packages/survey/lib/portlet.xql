<queryset>

<fullquery name="ls"><querytext>
SELECT survey_id, name
FROM surveys
WHERE package_id = :package_id AND enabled_p = 't'
ORDER BY lower(name), name
</querytext></fullquery>

</queryset>