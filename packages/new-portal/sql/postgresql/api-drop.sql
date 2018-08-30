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
-- copyright 2001, MIT
-- distributed under the GNU GPL v2
--
-- @author Arjun Sanyal (arjun@openforce.net)
-- @version $Id: api-drop.sql,v 1.3 2002/08/09 20:56:28 yon Exp $
--

select drop_package('portal_page');
select drop_package('portal');
select drop_package('portal_element_theme');
select drop_package('portal_layout');
select drop_package('portal_datasource');
