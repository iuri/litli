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
-- drop the dotLRN classes model
--
-- @author Ben Adida (ben@openforce.net)
-- @author yon (yon@openforce.net)
-- @author dan chak (chak@openforce.net)
-- @creation-date 2001-08-18
-- ported to pg 2002-07-01
-- @version $Id: classes-drop.sql,v 1.3 2006/08/08 21:26:22 donb Exp $
--

select drop_package('dotlrn_class_instance');
select drop_package('dotlrn_class');
select drop_package('dotlrn_department');
drop view dotlrn_class_instances_not_old;
drop view dotlrn_class_instances_current;
drop view dotlrn_class_instances_full;
drop table dotlrn_class_instances;
drop view dotlrn_classes_full;
drop table dotlrn_classes;
drop table dotlrn_terms;
drop view dotlrn_departments_full;
drop table dotlrn_departments;
