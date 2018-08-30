-- PL/SQL to set up permissions/privileges for photo-album
--
-- author: Tom Baginski, bags@arsdigita.com
-- creation date: 12/12/2000
--
-- $Id: permissions.sql,v 1.3 2017/05/26 18:05:36 gustafn Exp $

-- uses standard read, write, delete, and admin 
-- for most permission checks.
--
-- Added custom create privileges so that creation
-- of folders, albums, and photos can be controlled
-- independently.  Allows one user to control folder
-- structure while other users add albums and photos

begin
  acs_privilege.create_privilege('pa_create_album');
  acs_privilege.create_privilege('pa_create_folder');
  acs_privilege.create_privilege('pa_create_photo');

  acs_privilege.add_child('create', 'pa_create_photo');
  acs_privilege.add_child('create', 'pa_create_album');
  acs_privilege.add_child('create', 'pa_create_folder');
end;
/
show errors;

