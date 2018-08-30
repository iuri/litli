-- Fixing all those objects (faq and faq_q_and_as) with missing package_id

update acs_objects set package_id = context_id where context_id in
( select package_id from apm_packages where package_key = 'faq') 
and package_id is null ;

UPDATE acs_objects o1 SET package_id = o2.package_id
FROM acs_objects o2, faq_q_and_as f
WHERE f.entry_id = o1.object_id
AND   f.faq_id = o2.object_id
AND   o1.package_id is null;
