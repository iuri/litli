--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Create the Admin package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_admin_profile_rel
as
    function new (
        rel_id in dotlrn_admin_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_admin_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_admin_profile_rels.rel_id%TYPE
    );

end;
/
show errors

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- create the dotLRN classes model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @creation-date 2001-08-18
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_department
is
    function new (
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_departments.department_key%TYPE;

    procedure del (
        department_key in dotlrn_departments.department_key%TYPE
    );
end;
/
show errors

create or replace package dotlrn_class
is
    function new (
        class_key in dotlrn_classes.class_key%TYPE,
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_classes.class_key%TYPE;

    procedure del (
        class_key in dotlrn_classes.class_key%TYPE
    );
end;
/
show errors

create or replace package dotlrn_class_instance
is
    function new (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE default null,
        class_key in dotlrn_class_instances.class_key%TYPE,
        term_id in dotlrn_class_instances.term_id%TYPE,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_class_instances.class_instance_id%TYPE;

    procedure del (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE
    ); 
end;
/
show errors

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--


--
-- create dotLRN clubs model
--
-- @author yon (yon@openforce.net)
-- @creation-date August 18th, 2001
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_club
is
    function new (
        club_id in dotlrn_clubs.club_id%TYPE default null,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_clubs.club_id%TYPE;

    procedure del (
        club_id in dotlrn_clubs.club_id%TYPE
    );
end;
/
show errors

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

create or replace package dotlrn_community_type
is
    function new (
        community_type in dotlrn_community_types.community_type%TYPE,
        parent_type in dotlrn_community_types.supertype%TYPE default 'dotlrn_community',
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in dotlrn_community_types.pretty_name%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_community_types.community_type%TYPE;

    procedure del (
        community_type in dotlrn_community_types.community_type%TYPE
    );

    function name (
        community_type in dotlrn_community_types.community_type%TYPE
    ) return varchar;
end;
/
show errors

create or replace package dotlrn_community
is

    function new (
        community_id in dotlrn_communities_all.community_id%TYPE default null,
        parent_community_id in dotlrn_communities_all.parent_community_id%TYPE default null,
        community_type in dotlrn_communities_all.community_type%TYPE,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        archived_p in dotlrn_communities_all.archived_p%TYPE default 'f',
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_communities_all.community_id%TYPE;

    procedure set_active_dates (
        community_id in dotlrn_communities_all.community_id%TYPE,
        start_date in dotlrn_communities_all.active_start_date%TYPE,
        end_date in dotlrn_communities_all.active_end_date%TYPE
    );

    procedure del (
        community_id in dotlrn_communities_all.community_id%TYPE
    );

    function name (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return varchar; 

    function member_p (
        community_id in dotlrn_communities_all.community_id%TYPE,
        party_id in parties.party_id%TYPE
    ) return char;

    function admin_p (
        community_id in dotlrn_communities_all.community_id%TYPE,
        party_id in parties.party_id%TYPE
    ) return char;

    function url (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return varchar2;

    function has_subcomm_p (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return char;

end dotlrn_community;
/
show errors

create or replace package dotlrn_member_rel
is

    function new (
        rel_id in dotlrn_member_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_member_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_member_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_member_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package dotlrn_admin_rel
is

    function new (
        rel_id in dotlrn_admin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_admin_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_admin_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_admin_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package dotlrn_student_rel
is

    function new (
        rel_id in dotlrn_student_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_student_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_student_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package dotlrn_ta_rel
is

    function new (
        rel_id in dotlrn_ta_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ta_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ta_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_ta_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package dotlrn_ca_rel
is

    function new (
        rel_id in dotlrn_ca_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ca_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ca_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_ca_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package dotlrn_cadmin_rel
is

    function new (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_cadmin_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_cadmin_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package dotlrn_instructor_rel
is

    function new (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_instructor_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_instructor_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE
    );

end;
/
show errors;

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Create the External package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_external_profile_rel
as
    function new (
        rel_id in dotlrn_external_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_external_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_external_profile_rels.rel_id%TYPE
    );

end;
/
show errors

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Create the Professor package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_professor_profile_rel
as
    function new (
        rel_id in dotlrn_professor_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_professor_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_professor_profile_rels.rel_id%TYPE
    );

end;
/
show errors

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Create the Student package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_student_profile_rel
as
    function new (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE
    );

end;
/
show errors

--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Create the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: upgrade-1.0-2.0d1.sql,v 1.2 2006/08/08 21:26:22 donb Exp $
--

create or replace package dotlrn_user_profile_rel
as
    function new (
        rel_id in dotlrn_user_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_user_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_user_profile_rels.rel_id%TYPE
    );

end;
/
show errors

create or replace package body dotlrn_admin_profile_rel
as
    function new (
        rel_id in dotlrn_admin_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_admin_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_admin_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := dotlrn_user_profile_rel.new(
            rel_id => rel_id,
            user_id => user_id,
            portal_id => portal_id,
            theme_id => theme_id,
            id => id,
            rel_type => rel_type,
            group_id => v_group_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_admin_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_admin_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_admin_profile_rels
        where rel_id = dotlrn_admin_profile_rel.del.rel_id;

        dotlrn_user_profile_rel.del(rel_id);
    end;

end;
/
show errors

create or replace package body dotlrn_department
is
    function new (
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_departments.department_key%TYPE
    is
        v_department_key dotlrn_departments.department_key%TYPE;
    begin
        v_department_key := dotlrn_community_type.new (
            community_type => department_key,
            parent_type => 'dotlrn_class_instance',
            pretty_name => pretty_name,
            pretty_plural => pretty_plural,
            description => description,
            package_id => package_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_departments
        (department_key) values (v_department_key);

        return v_department_key;
    end;

    procedure del (
        department_key in dotlrn_departments.department_key%TYPE
    )
    is
    begin
        delete
        from dotlrn_departments
        where department_key = department_key;

        dotlrn_community_type.del(department_key);
    end;
end;
/
show errors

create or replace package body dotlrn_class
is
    function new (
        class_key in dotlrn_classes.class_key%TYPE,
        department_key in dotlrn_departments.department_key%TYPE,
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in acs_object_types.pretty_plural%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_classes.class_key%TYPE
    is
        v_class_key dotlrn_classes.class_key%TYPE;
    begin
        v_class_key := dotlrn_community_type.new (
            community_type => class_key,
            parent_type => department_key,
            pretty_name => pretty_name,
            pretty_plural => pretty_plural,
            description => description,
            package_id => package_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_classes
        (class_key, department_key) values (v_class_key, department_key);

        return v_class_key;
    end;

    procedure del (
        class_key in dotlrn_classes.class_key%TYPE
    )
    is
    begin
        delete
        from dotlrn_classes
        where class_key = class_key;

        dotlrn_community_type.del(class_key);
    end;
end;
/
show errors

create or replace package body dotlrn_class_instance
is
    function new (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE default null,
        class_key in dotlrn_class_instances.class_key%TYPE,
        term_id in dotlrn_class_instances.term_id%TYPE,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_class_instances.class_instance_id%TYPE
    is
        v_class_instance_id dotlrn_class_instances.class_instance_id%TYPE;
    begin
        v_class_instance_id := dotlrn_community.new (
            community_id => class_instance_id,
            community_type => class_key,
            community_key => community_key,
            pretty_name => pretty_name,
            description => description,
            package_id => package_id,
            portal_id => portal_id,
            non_member_portal_id => non_member_portal_id,
            join_policy => join_policy,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_class_instances
        (class_instance_id, class_key, term_id)
        values
        (v_class_instance_id, class_key, term_id);

        return v_class_instance_id;
    end;

    procedure del (
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_class_instances
        where class_instance_id= class_instance_id;

        dotlrn_community.del(community_id => class_instance_id);
    end;
end;
/
show errors

create or replace package body dotlrn_club
is
    function new (
        club_id in dotlrn_clubs.club_id%TYPE default null,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_clubs.club_id%TYPE
    is
        v_club_id integer;
    begin
        v_club_id := dotlrn_community.new(
            community_id => club_id,
            community_type => 'dotlrn_club',
            community_key => community_key,
            pretty_name => pretty_name,
            description => description,
            package_id => package_id,
            portal_id => portal_id,
            non_member_portal_id => non_member_portal_id,
            join_policy => join_policy,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            context_id => context_id
        );

        insert
        into dotlrn_clubs (club_id)
        values (v_club_id);

        return v_club_id;
    end;

    procedure del (
        club_id in dotlrn_clubs.club_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_clubs
        where club_id = dotlrn_club.del.club_id;

        dotlrn_community.del(community_id => club_id);
    end;
end;
/
show errors

create or replace package body dotlrn_community_type
is
    function new (
        community_type in dotlrn_community_types.community_type%TYPE,
        parent_type in dotlrn_community_types.supertype%TYPE default 'dotlrn_community', 
        pretty_name in dotlrn_community_types.pretty_name%TYPE,
        pretty_plural in dotlrn_community_types.pretty_name%TYPE default null,
        description in dotlrn_community_types.description%TYPE,
        package_id in dotlrn_community_types.package_id%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_community_types.community_type%TYPE
    is
        v_parent_object_type acs_object_types.object_type%TYPE;
        v_unique_name acs_objects.object_id%TYPE;
    begin
        if parent_type is null then
            v_parent_object_type:= 'group';
        else
            v_parent_object_type:= parent_type;
        end if;

        select acs_object_id_seq.nextval
        into v_unique_name
        from dual;

        acs_object_type.create_type (
            supertype => v_parent_object_type,
            object_type => dotlrn_community_type.new.community_type,
            pretty_name => dotlrn_community_type.new.community_type,
            pretty_plural => dotlrn_community_type.new.community_type,
            table_name => v_unique_name,
            id_column => v_unique_name,
            package_name => v_unique_name,
            name_method => 'acs_group.name'
        );

        insert
        into group_types
        (group_type, default_join_policy)
        values
        (dotlrn_community_type.new.community_type, 'closed');

        insert
        into dotlrn_community_types
        (community_type,
         pretty_name,
         description,
         package_id,
         supertype)
        values
        (dotlrn_community_type.new.community_type,
         dotlrn_community_type.new.pretty_name,
         dotlrn_community_type.new.description,
         dotlrn_community_type.new.package_id,
         dotlrn_community_type.new.parent_type);

        return community_type;
    end;

    procedure del (
        community_type in dotlrn_community_types.community_type%TYPE
    )
    is
    begin
        delete
        from dotlrn_community_types
        where community_type = dotlrn_community_type.del.community_type;

        delete
        from group_types
        where group_types.group_type = dotlrn_community_type.del.community_type;

        acs_object_type.drop_type(dotlrn_community_type.del.community_type);
    end;

    function name (
        community_type in dotlrn_community_types.community_type%TYPE
    ) return varchar
    is
        v_name dotlrn_community_types.pretty_name%TYPE;
    begin
        select dotlrn_community_types.pretty_name
        into v_name
        from dotlrn_community_types
        where dotlrn_community_types.community_type = dotlrn_community_type.name.community_type;

        return v_name;
    end;
end;
/
show errors

create or replace package body dotlrn_community
as

    function new (
        community_id in dotlrn_communities_all.community_id%TYPE default null,
        parent_community_id in dotlrn_communities_all.parent_community_id%TYPE default null,
        community_type in dotlrn_communities_all.community_type%TYPE,
        community_key in dotlrn_communities_all.community_key%TYPE,
        pretty_name in dotlrn_communities_all.pretty_name%TYPE,
        description in dotlrn_communities_all.description%TYPE,
        archived_p in dotlrn_communities_all.archived_p%TYPE default 'f',
        portal_id in dotlrn_communities_all.portal_id%TYPE default null,
        non_member_portal_id in dotlrn_communities_all.non_member_portal_id%TYPE default null,
        package_id in dotlrn_communities_all.package_id%TYPE default null,
        join_policy in groups.join_policy%TYPE default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return dotlrn_communities_all.community_id%TYPE
    is
        c_id integer;
    begin
        c_id := acs_group.new (
            context_id => dotlrn_community.new.context_id,
            group_id => dotlrn_community.new.community_id,
            object_type => dotlrn_community.new.community_type,
            creation_date => dotlrn_community.new.creation_date,
            creation_user => dotlrn_community.new.creation_user,
            creation_ip => dotlrn_community.new.creation_ip,
            group_name => dotlrn_community.new.community_key,
            join_policy => dotlrn_community.new.join_policy
        );

        insert into dotlrn_communities_all
          (community_id, 
           parent_community_id,
           community_type, 
           community_key, 
           pretty_name,  
           description, 
           package_id, 
           archived_p,
           portal_id, 
           non_member_portal_id)
        values
          (c_id, 
           dotlrn_community.new.parent_community_id, 
           dotlrn_community.new.community_type, 
           dotlrn_community.new.community_key, 
           dotlrn_community.new.pretty_name, 
           dotlrn_community.new.description,    
           dotlrn_community.new.package_id, 
           dotlrn_community.new.archived_p, 
           dotlrn_community.new.portal_id, 
           dotlrn_community.new.non_member_portal_id);

        return c_id;
    end;

    procedure set_active_dates (
        community_id in dotlrn_communities_all.community_id%TYPE,
        start_date in dotlrn_communities_all.active_start_date%TYPE,
        end_date in dotlrn_communities_all.active_end_date%TYPE
    )
    is
    begin
        update dotlrn_communities_all
        set active_start_date = dotlrn_community.set_active_dates.start_date,
            active_end_date = dotlrn_community.set_active_dates.end_date
        where dotlrn_communities_all.community_id = dotlrn_community.set_active_dates.community_id;
    end;

    procedure del (
        community_id in dotlrn_communities_all.community_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_communities_all
        where dotlrn_communities_all.community_id = dotlrn_community.del.community_id;

        acs_group.del(dotlrn_community.del.community_id);
    end;

    function name (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return varchar
    is
    begin
        return acs_group.name(dotlrn_community.name.community_id);
    end;

    function member_p (
        community_id in dotlrn_communities_all.community_id%TYPE,
        party_id in parties.party_id%TYPE
    ) return char
    is
        v_member_p              char(1);
    begin
        select decode(count(*), 0, 'f', 't')
        into v_member_p
        from dual
        where exists (select 1
                      from dotlrn_member_rels_approved
                      where dotlrn_member_rels_approved.user_id = dotlrn_community.member_p.party_id
                      and dotlrn_member_rels_approved.community_id = dotlrn_community.member_p.community_id);

        return v_member_p;
    end;

    function admin_p (
        community_id in dotlrn_communities_all.community_id%TYPE,
        party_id in parties.party_id%TYPE
    ) return char
    is
        v_rv char(1);
    begin
        select decode(
                   acs_permission.permission_p(dotlrn_community.admin_p.community_id, dotlrn_community.admin_p.party_id, 'dotlrn_admin_community'),
                   'f',
                   acs_permission.permission_p(dotlrn_community.admin_p.community_id, dotlrn_community.admin_p.party_id, 'admin'),
                   't'
               ) into v_rv
        from dual;

        return v_rv;
    end;

    function url (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return varchar2
    is
        v_node_id site_nodes.node_id%TYPE;
    begin
        select site_nodes.node_id into v_node_id
        from dotlrn_communities_all,
             site_nodes
        where dotlrn_communities_all.community_id = dotlrn_community.url.community_id
        and site_nodes.object_id = dotlrn_communities_all.package_id;

        return site_node.url(v_node_id);

        exception
            when no_data_found then
                return '';
    end;

    function has_subcomm_p (
        community_id in dotlrn_communities_all.community_id%TYPE
    ) return char
    is
        v_rv char(1);
    begin
        select decode(count(*), 0, 'f', 't')
        into v_rv
        from dual
        where exists (select 1
                      from dotlrn_communities_all
                      where dotlrn_communities_all.parent_community_id = dotlrn_community.has_subcomm_p.community_id);
        return v_rv;
    end;

end;
/
show errors


create or replace package body dotlrn_member_rel
is

    function new (
        rel_id in dotlrn_member_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_member_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_member_rels.rel_id%TYPE
    is
        v_rel_id                membership_rels.rel_id%TYPE;
    begin
        v_rel_id:= membership_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            object_id_one => community_id,
            object_id_two => user_id,
            member_state => dotlrn_member_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_member_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_member_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_member_rels
        where rel_id = dotlrn_member_rel.del.rel_id;

        membership_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_admin_rel
is

    function new (
        rel_id in dotlrn_admin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_admin_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_admin_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_admin_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_member_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => community_id,
            user_id => user_id,
            member_state => dotlrn_admin_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_admin_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_admin_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_admin_rels
        where rel_id = dotlrn_admin_rel.del.rel_id;

        dotlrn_member_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_student_rel
is

    function new (
        rel_id in dotlrn_student_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_student_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_student_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_member_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_student_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_student_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_student_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_student_rels
        where rel_id = dotlrn_student_rel.del.rel_id;

        dotlrn_member_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_ta_rel
is

    function new (
        rel_id in dotlrn_ta_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ta_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ta_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_ta_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_ta_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_ta_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_ta_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_ta_rels
        where rel_id = dotlrn_ta_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_ca_rel
is

    function new (
        rel_id in dotlrn_ca_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ca_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ca_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_ca_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_ca_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_ca_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_ca_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_ca_rels
        where rel_id = dotlrn_ca_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_cadmin_rel
is

    function new (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_cadmin_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_cadmin_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_cadmin_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_cadmin_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_cadmin_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_cadmin_rels
        where rel_id = dotlrn_cadmin_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_instructor_rel
is

    function new (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_instructor_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_instructor_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_instructor_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_instructor_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_instructor_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_instructor_rels
        where rel_id = dotlrn_instructor_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package body dotlrn_external_profile_rel
as
    function new (
        rel_id in dotlrn_external_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_external_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_external_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := dotlrn_user_profile_rel.new(
            rel_id => rel_id,
            user_id => user_id,
            portal_id => portal_id,
            theme_id => theme_id,
            id => id,
            rel_type => rel_type,
            group_id => v_group_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_external_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_external_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_external_profile_rels
        where rel_id = dotlrn_external_profile_rel.del.rel_id;

        dotlrn_user_profile_rel.del(rel_id);
    end;

end;
/
show errors

create or replace package body dotlrn_professor_profile_rel
as
    function new (
        rel_id in dotlrn_professor_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_professor_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_professor_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := dotlrn_user_profile_rel.new(
            rel_id => rel_id,
            user_id => user_id,
            portal_id => portal_id,
            theme_id => theme_id,
            id => id,
            rel_type => rel_type,
            group_id => v_group_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_professor_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_professor_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_professor_profile_rels
        where rel_id = dotlrn_professor_profile_rel.del.rel_id;

        dotlrn_user_profile_rel.del(rel_id);
    end;

end;
/
show errors

create or replace package body dotlrn_student_profile_rel
as
    function new (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_student_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := dotlrn_user_profile_rel.new(
            rel_id => rel_id,
            user_id => user_id,
            portal_id => portal_id,
            theme_id => theme_id,
            id => id,
            rel_type => rel_type,
            group_id => v_group_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_student_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_student_profile_rels
        where rel_id = dotlrn_student_profile_rel.del.rel_id;

        dotlrn_user_profile_rel.del(rel_id);
    end;

end;
/
show errors

create or replace package body dotlrn_user_profile_rel
as
    function new (
        rel_id in dotlrn_user_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_user_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE
    is
        v_rel_id                user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_user_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := user_profile_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            group_id => v_group_id,
            user_id => user_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_user_profile_rels
        (rel_id, portal_id, theme_id, id)
        values
        (v_rel_id, portal_id, theme_id, id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_user_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_user_profile_rels
        where rel_id = dotlrn_user_profile_rel.del.rel_id;

        user_profile_rel.del(rel_id);
    end;

end;
/
show errors
