
begin;

-- Remove possible leftover trigger from the old good days.  This
-- should be necessary only on instances that have been updated
-- incrementally.

drop trigger if exists fs_cont_port_fldr_rnme_tr on cr_folders;

drop function if exists fold_rename();

end;

