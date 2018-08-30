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
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License foreign key more
--  details.
--

--
-- The New Portal Package
--
-- @author arjun@openforce.net
-- @version $Id: portal-core-create.sql,v 1.6.8.2 2016/05/14 17:08:09 gustafn Exp $
--

select acs_privilege__create_privilege('portal_create_portal');
select acs_privilege__create_privilege('portal_delete_portal');
select acs_privilege__create_privilege('portal_read_portal');
select acs_privilege__create_privilege('portal_edit_portal');
select acs_privilege__create_privilege('portal_admin_portal');
select acs_privilege__add_child('read','portal_read_portal');
select acs_privilege__add_child('portal_edit_portal','portal_read_portal');
select acs_privilege__add_child('portal_admin_portal','portal_edit_portal');
select acs_privilege__add_child('create','portal_create_portal');
select acs_privilege__add_child('delete','portal_delete_portal');
select acs_privilege__add_child('admin','portal_admin_portal');

create table portal_datasources (
    datasource_id                   integer
                                    constraint p_datasources_datasource_id_fk
                                    references acs_objects (object_id)
                                    constraint p_datasources_datasource_id_pk
                                    primary key,
    description                     varchar(200),
    name                            varchar(200)
                                    constraint p_datasources_name_nn
                                    not null,
    pretty_name                     varchar(200),
    css_dir                         varchar(200)
);

-- A default configuration for a ds will be stored here, to be copied
-- to the portal_element_parameters table at PE creation (DS binding) time
--
-- Config semantics:
-- true: cfg_req, cfg_p - A static config is given for all PEs, can
--     be changed later
-- true: cfg_req false: cfg_p - PE must be configured before use
-- false: cfg_req true: cfg_p - An optional default cfg given
-- both false: Configuration optional w. no default suggested
create table portal_datasource_def_params (
    parameter_id                    integer
                                    constraint p_ds_def_prms_prm_id_pk
                                    primary key,
    datasource_id                   integer
                                    constraint p_ds_def_prms_element_id_fk
                                    references portal_datasources (datasource_id)
                                    on delete cascade
                                    constraint p_ds_def_prms_element_id_nn
                                    not null,
    config_required_p               boolean
                                    default false
                                    constraint p_ds_def_prms_cfg_req_p_nn
                                    not null,
    configured_p                    boolean
                                    default false
                                    constraint p_ds_def_prms_configured_p_nn
                                    not null,
    key                             varchar(200)
                                    not null,
    value                           varchar(200)
);

-- Layouts are the template for the portal page. i.e. 2 cols, 3 cols,
-- etc. They are globally available. No secret layouts!
create table portal_layouts (
    layout_id                       integer
                                    constraint p_layouts_layout_id_fk
                                    references acs_objects (object_id)
                                    constraint p_layouts_layout_id_pk
                                    primary key,
    name                            varchar(200)
                                    constraint p_layouts_name_un
                                    unique
                                    constraint p_layouts_name_nn
                                    not null,
    description                     varchar(200),
    filename                        varchar(200),
    resource_dir                    varchar(200)
);

create table portal_supported_regions (
    layout_id                       integer
                                    constraint p_spprtd_rgns_layout_id_fk
                                    references portal_layouts (layout_id)
                                    on delete cascade
                                    constraint p_spprtd_rgns_layout_id_nn
                                    not null,
    region                          varchar(20)
                                    constraint p_spprtd_rgns_immtble_p_nn
                                    not null,
    immutable_p                     boolean
                                    constraint p_spprtd_rgns_immtble_p_nn
                                    not null,
    constraint portal_supported_regions_pk
    primary key (layout_id, region)
);

-- Themes are templates with decoration for PEs, nothing more.
-- At this point they will just be bits of ADPs  in the filesystem
create table portal_element_themes (
    theme_id                        integer
                                    constraint p_e_themes_theme_id_fk
                                    references acs_objects (object_id)
                                    constraint p_e_themes_theme_id_pk
                                    primary key,
    name                            varchar(200)
                                    constraint p_e_themes_name_un
                                    unique
                                    constraint p_e_themes_name_nn
                                    not null,
    description                     varchar(200),
    filename                        varchar(200),
    resource_dir                    varchar(200)
);

-- Portals are essentially "containers" for PEs that bind to DSs.
-- Parties have, optionally have portals
-- Restrict to party check?
-- Roles and perms issues?
create table portals (
    portal_id                       integer
                                    constraint portal_portal_id_fk
                                    references acs_objects (object_id)
                                    constraint p_portal_id_pk
                                    primary key,
    name                            varchar(200)
                                    default 'Untitled'
                                    constraint portal_name_nn
                                    not null,
    theme_id                        integer
                                    constraint portal_theme_id_fk
                                    references portal_element_themes (theme_id)
                                    constraint portal_theme_id_nn
                                    not null,
    template_id                     integer
                                    constraint portal_template_id_fk
                                    references portals (portal_id)
);
create index portals_template_id_idx on portals(template_id);

-- Support for multi-page portals (think my.yahoo.com)
create table portal_pages (
    page_id                         integer
                                    constraint portal_pages_page_id_fk
                                    references acs_objects (object_id)
                                    constraint portal_pages_page_id_pk
                                    primary key,
    pretty_name                     varchar(200)
                                    default 'Untitled Page'
                                    constraint portal_pages_pretty_name_nn
                                    not null,
    accesskey                       varchar(200)
                                    default null,
    portal_id                       integer
                                    constraint portal_pages_portal_id_fk
                                    references portals (portal_id)
                                    constraint portal_pages_portal_id_nn
                                    not null,
    layout_id                       integer
                                    constraint portal_pages_layout_id_fk
                                    references portal_layouts (layout_id)
                                    constraint portal_pages_layout_id_nn
                                    not null,
    sort_key                        integer
                                    constraint portal_pages_sort_key_nn
                                    not null,
    hidden_p                        boolean
                                    default false
                                    constraint portal_pages_hidden_p_nn
                                    not null,
    constraint portal_pages_srt_key_un
    unique (portal_id, sort_key)
);

create index portal_pages_prtl_page_idx on portal_pages (portal_id, page_id);


-- PE are fully owned by one and only one portal. They are not
-- "objects" that live on after their portal is gone. One way to think
-- of them is a map b/w a portal and a DS, with satellite data of a
-- theme, a config, a region, etc.
--
-- No securtiy checks are done here. If you can view and bind to a DS you have
-- a PE for it.

create sequence portal_element_map_sk_seq;

create table portal_element_map (
    element_id                      integer
                                    constraint portal_element_map_pk
                                    primary key,
    name                            varchar(200)
                                    constraint p_element_map_name_nn
                                    not null,
    pretty_name                     varchar(200)
                                    constraint p_element_map_pretty_name_nn
                                    not null,
    page_id                         integer
                                    constraint p_element_map_page_id_fk
                                    references portal_pages
                                    on delete cascade
                                    constraint p_element_map_page_id_nn
                                    not null,
    datasource_id                   integer
                                    constraint p_element_map_datasource_id_fk
                                    references portal_datasources (datasource_id)
                                    on delete cascade
                                    constraint p_element_map_datasource_id_nn
                                    not null,
    region                          varchar(20)
                                    constraint p_element_map_region_nn
                                    not null,
    sort_key                        integer
                                    constraint p_element_map_sort_key_nn
                                    not null,
    state                           varchar(6)
                                    default 'full'
                                    constraint p_element_map_state_ck
                                    check (state in ('full', 'shaded', 'hidden', 'pinned')),
    constraint p_element_map_pid_name_un
    unique (page_id, pretty_name)
);

create table portal_element_parameters (
    parameter_id                    integer
                                    constraint portal_element_parameters_pk
                                    primary key,
    element_id                      integer
                                    constraint p_element_prms_element_id_fk
                                    references portal_element_map (element_id)
                                    on delete cascade
                                    constraint p_element_prms_element_id_nn
                                    not null,
    config_required_p               boolean
                                    default false
                                    constraint p_element_prms_cfg_req_p_nn
                                    not null,
    configured_p                    boolean
                                    default false
                                    constraint p_element_prms_configured_p_nn
                                    not null,
    key                             varchar(50)
                                    constraint p_element_prms_key_nn
                                    not null,
    value                           varchar(200)
);

create index p_element_prms_element_key_idx on portal_element_parameters (element_id, key);

-- This table maps the datasources that are available for portals to
-- bind to (i.e. creating a PE). This table is required since some DSs
-- will not make sense for every portal. A "current time" DS will make
-- sense for every portal, but a bboard DS may not, and we don't want
-- to confuse everyone with DSs that don't make sense for the given
-- portal
create table portal_datasource_avail_map (
    portal_datasource_id            integer
                                    constraint portal_datasource_avail_map_pk
                                    primary key,
    portal_id                       integer
                                    constraint p_ds_a_map_portal_id_fk
                                    references portals (portal_id)
                                    on delete cascade
                                    constraint p_ds_a_map_portal_id_nn
                                    not null,
    datasource_id                   integer
                                    constraint p_ds_a_map_datasource_id_fk
                                    references portal_datasources (datasource_id)
                                    on delete cascade
                                    constraint p_ds_a_map_datasource_id_nn
                                    not null,
    constraint p_ds_a_map_pid_ds_un unique (portal_id, datasource_id)
);
