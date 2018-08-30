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
-- @version $Id: objects-create.sql,v 1.4 2007/05/15 20:14:47 donb Exp $

-- datasources
select acs_object_type__create_type (
    'portal_datasource',
    'Portal Data Source',
    'Portal Data Sources',
    'acs_object',
    'PORTAL_DATASOURCES',
    'DATASOURCE_ID',
    'portal_datasource',
    'f',
    null,
    null
);

-- datasource attributes
select acs_attribute__create_attribute (
    'portal_datasource',
    'NAME',
    'string',
    'Name',
    'Names',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_datasource',
    'DESCRIPTION',
    'string',
    'Description',
    'Descriptions',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_datasource',
    'CONTENT',
    'string',
    'Content',
    'Contents',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

-- portal_layouts
select  acs_object_type__create_type (
    'portal_layout',
    'Portal Layout',
    'Portal Layouts',
    'acs_object',
    'PORTAL_LAYOUTS',
    'LAYOUT_ID',
    'portal_layout',
    'f',
    null,
    null
);

-- and its attributes
select acs_attribute__create_attribute (
    'portal_layout',
    'NAME',
    'string',
    'Name',
    'Names',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_layout',
    'DESCRIPTION',
    'string',
    'Description',
    'Descriptions',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_layout',
    'TYPE',
    'string',
    'Type',
    'Types',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_layout',
    'FILENAME',
    'string',
    'Filename',
    'Filenames',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_layout',
    'resource_dir',
    'string',
    'Resource Directory',
    'Resource Directory',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

-- portal_element_themes
select  acs_object_type__create_type (
    'portal_element_theme',
    'Portal Element Theme',
    'Portal Element Themes',
    'acs_object',
    'PORTAL_ELEMENT_THEMES',
    'THEME_ID',
    'portal_element_theme',
    'f',
    null,
    null
);

-- and its attributes
select acs_attribute__create_attribute (
    'portal_element_theme',
    'NAME',
    'string',
    'Name',
    'Names',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_element_theme',
    'DESCRIPTION',
    'string',
    'Description',
    'Descriptions',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_element_theme',
    'TYPE',
    'string',
    'Type',
    'Types',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_element_theme',
    'FILENAME',
    'string',
    'Filename',
    'Filenames',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

select acs_attribute__create_attribute (
    'portal_element_theme',
    'resource_dir',
    'string',
    'Resource Directory',
    'Resource Directory',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

-- portal
select  acs_object_type__create_type (
    'portal',
    'Portal',
    'Portals',
    'acs_object',
    'PORTALS',
    'PORTAL_ID',
    'portal',
    'f',
    null,
    null
);

select acs_attribute__create_attribute (
    'portal',
    'NAME',
    'string',
    'Name',
    'Names',
    null,
    null,
    null,
    1,
    1,
    null,
    'type_specific',
    'f'
);

-- portal_page
select acs_object_type__create_type (
    'portal_page',
    'Portal Page',
    'Portal Pages',
    'acs_object',
    'PORTAL_PAGES',
    'page_id',
    'portal_page',
    'f',
    null,
    null
);
