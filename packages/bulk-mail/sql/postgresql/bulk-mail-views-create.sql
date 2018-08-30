--
-- bulk_mail views
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-views-create.sql,v 1.2 2003/08/28 09:41:52 lars Exp $
--

create view bulk_mail_messages_unsent
as
    select bulk_mail_messages.*
    from bulk_mail_messages
    where status = 'pending';

create view bulk_mail_messages_sent
as
    select bulk_mail_messages.*
    from bulk_mail_messages
    where status = 'sent';
