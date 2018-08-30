--
-- bulk_mail model drop
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-drop.sql,v 1.2 2003/09/30 12:10:04 mohanp Exp $
--

begin
    for row in (select bulk_mail_id from bulk_mail_messages) loop
        bulk_mail.del(row.bulk_mail_id);
    end loop;
end;
/
show errors

begin
    acs_object_type.drop_type('bulk_mail_message', 'f');
end;
/
show errors

@@ bulk-mail-package-drop.sql
@@ bulk-mail-views-drop.sql

drop table bulk_mail_messages;
