
-- Remove possible leftover trigger from the old good days.  This
-- should be necessary only on instances that have been updated
-- incrementally.

begin;

drop trigger fs_cont_port_fldr_rnme_tr on cr_folders;

-- ignore errors where trigger or function doesn not exist.
exception when others then null;

end;


begin;

drop function fold_rename;

-- ignore errors where trigger or function doesn not exist.
exception when others then null;

end;

