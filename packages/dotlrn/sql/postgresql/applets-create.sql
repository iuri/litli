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
-- create the dotLRN applets model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net
-- @author arjun (arjun@openforce.net)
-- @creation-date September 20th, 2001 (redone)
-- @version $Id: applets-create.sql,v 1.4.10.2 2017/02/23 19:04:15 gustafn Exp $
--

create table dotlrn_applets (
    applet_id                       integer
                                    constraint dotlrn_applets_pk
                                    primary key,
    applet_key                      varchar(100)
                                    constraint dotlrn_applets_applet_key_nn
                                    not null
                                    constraint dotlrn_applets_applet_key_un
                                    unique,
    package_key                     varchar(100)
                                    constraint dotlrn_applets_package_key_fk
                                    references apm_package_types (package_key),
    active_p                        boolean
                                    default true
                                    constraint dotlrn_applets_active_p_nn
                                    not null
);

create table dotlrn_community_applets (
    community_id                    integer
                                    constraint dotlrn_ca_community_id_fk
                                    references dotlrn_communities_all (community_id)
                                    constraint dotlrn_ca_community_id_nn
                                    not null,
    applet_id                       integer
                                    constraint dotlrn_ca_applet_key_fk
                                    references dotlrn_applets (applet_id)
                                    constraint dotlrn_ca_applet_key_nn
                                    not null,
    -- this is the package_id of the package this applet represents
    package_id                      integer
                                    constraint dotlrn_ca_package_id_fk
                                    references apm_packages (package_id),
    active_p                        boolean
                                    default true
                                    constraint dotlrn_ca_active_p_nn
                                    not null,
    constraint dotlrn_community_applets_pk
    primary key (community_id, applet_id)
);
