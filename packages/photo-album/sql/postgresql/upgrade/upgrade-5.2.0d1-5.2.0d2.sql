-- add cascade to the foreign key constraints
-- @author Jeff Davis (davis@xarg.net)
-- @cvs-id $id$

alter table pa_package_root_folder_map drop constraint pa_pack_fldr_map_pack_id_fk;
alter table pa_package_root_folder_map add constraint pa_pack_fldr_map_pack_id_fk
      foreign key (package_id) references apm_packages on delete cascade;

alter table pa_package_root_folder_map drop constraint pa_pack_fldr_map_fldr_id_fk;
alter table pa_package_root_folder_map add constraint pa_pack_fldr_map_fldr_id_fk
      foreign key (folder_id) references cr_folders on delete cascade;
