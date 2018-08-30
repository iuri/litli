DELETE FROM dotlrn_community_applets WHERE package_id IN
(SELECT package_id FROM dotlrn_community_applets EXCEPT SELECT package_id FROM apm_packages);

ALTER TABLE dotlrn_community_applets ADD CONSTRAINT dotlrn_ca_package_id_fk FOREIGN KEY (package_id) REFERENCES apm_packages (package_id);
