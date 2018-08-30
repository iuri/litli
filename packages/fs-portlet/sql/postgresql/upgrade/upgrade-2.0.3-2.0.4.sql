--
-- Created by aegrumet@alum.mit.edu on 2002-06-24.
-- 
-- This is a temporary workaround to ensure that
-- fs_contents_portlets get renamed properly.
--



--
-- procedure fold_rename/0
--
CREATE OR REPLACE FUNCTION fold_rename(

) RETURNS trigger AS $$
DECLARE
  row_res record;
BEGIN

  if old.label <> new.label then
    for row_res in select m.element_id
                from portal_element_map m,
                portal_element_parameters p
  	        where p.key = 'folder_id'
                  and p.value = new.folder_id
                  and m.element_id = p.element_id
                  and m.name = 'fs_contents_portlet' loop
  
      update portal_element_map
      set pretty_name = new.label
      where element_id = row_res.element_id;
  
    end loop;
end if;
return new;
END; 
$$ LANGUAGE plpgsql;

create trigger fs_cont_port_fldr_rnme_tr
after update on cr_folders for each row
execute procedure fold_rename();

\i ../fs-admin-portlet-create.sql