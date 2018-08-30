--
-- bulk_mail logic
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-package-drop.sql,v 1.3 2003/05/17 10:19:23 jeffd Exp $
--

drop function bulk_mail__new (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, varchar, text, varchar, timestamptz, integer, varchar, integer);
drop function bulk_mail__delete (integer);
