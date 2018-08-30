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
-- procedure dotlrn_community_types_in_tr/0
--
CREATE OR REPLACE FUNCTION dotlrn_community_types_in_tr(

) RETURNS trigger AS $$
DECLARE
    v_parent_sortkey                dotlrn_community_types.tree_sortkey%TYPE;
    v_max_child_sortkey             dotlrn_community_types.max_child_sortkey%TYPE;
BEGIN

    if new.supertype is null then
        -- if this is the root community_type we leave it's sortkey as null
        return new;
    else
        -- else get the max_child_sortkey of the parent community_type
        select coalesce(tree_sortkey, ''), max_child_sortkey
        into v_parent_sortkey, v_max_child_sortkey
        from dotlrn_community_types
        where community_type = new.supertype
        for update;
    end if;

    -- increment the sort_key
    v_max_child_sortkey := tree_increment_key(v_max_child_sortkey);

    update dotlrn_community_types
    set max_child_sortkey = v_max_child_sortkey
    where community_type = new.supertype;

    -- generate the sortkey for the current row
    new.tree_sortkey := v_parent_sortkey || v_max_child_sortkey;

    return new;
END;
$$ LANGUAGE plpgsql;

create trigger dotlrn_community_types_in_tr
before insert on dotlrn_community_types
for each row
execute procedure dotlrn_community_types_in_tr();




--
-- procedure dotlrn_communities_in_tr/0
--
CREATE OR REPLACE FUNCTION dotlrn_communities_in_tr(

) RETURNS trigger AS $$
DECLARE
    v_parent_sortkey                dotlrn_communities_all.tree_sortkey%TYPE;
    v_max_child_sortkey             dotlrn_communities_all.max_child_sortkey%TYPE;
BEGIN

    if new.parent_community_id is null then

        select coalesce(tree_sortkey, ''), max_child_sortkey
        into v_parent_sortkey, v_max_child_sortkey
        from dotlrn_community_types
        where community_type = new.community_type
        for update;

        v_max_child_sortkey := tree_increment_key(v_max_child_sortkey);

        update dotlrn_community_types
        set max_child_sortkey = v_max_child_sortkey
        where community_type = new.community_type;

    else

        select coalesce(tree_sortkey, ''), max_child_sortkey
        into v_parent_sortkey, v_max_child_sortkey
        from dotlrn_communities_all
        where community_id = new.parent_community_id
        for update;

        v_max_child_sortkey := tree_increment_key(v_max_child_sortkey);

        update dotlrn_communities_all
        set max_child_sortkey = v_max_child_sortkey
        where community_id = new.parent_community_id;

    end if;

    new.tree_sortkey := v_parent_sortkey || v_max_child_sortkey;

    return new;

END;
$$ LANGUAGE plpgsql;

create trigger dotlrn_communities_in_tr
before insert on dotlrn_communities_all
for each row
execute procedure dotlrn_communities_in_tr();
