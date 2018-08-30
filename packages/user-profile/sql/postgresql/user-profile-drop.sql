--
-- Drop the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-drop.sql,v 1.1 2002/03/29 16:56:10 ben Exp $
--

\i user-profile-package-drop.sql
\i user-profile-sanitize.sql
\i user-profile-provider-drop.sql

drop table user_profile_rels;
