--
-- Create the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-create.sql,v 1.1 2002/03/29 16:56:10 ben Exp $
--

create table user_profile_rels (
    rel_id                      integer
				constraint up_rels_rel_id_fk
                                references membership_rels (rel_id)
                                constraint user_profile_rels_pk
                                primary key
);

\i user-profile-provider-create.sql
\i user-profile-init.sql
\i user-profile-package-create.sql
