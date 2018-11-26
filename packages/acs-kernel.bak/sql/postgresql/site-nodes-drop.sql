--
-- packages/acs-kernel/sql/site-nodes-drop.sql
--
-- @author rhs@mit.edu
-- @creation-date 2000-09-06
-- @cvs-id $Id: site-nodes-drop.sql,v 1.3 2011/07/07 10:46:02 gustafn Exp $
--

\t
select drop_package('site_node');
drop table site_nodes;

CREATE OR REPLACE FUNCTION inline_0 () RETURNS integer AS $$
BEGIN
  PERFORM acs_object_type__drop_type ('site_node');
  returns null;
END;
$$ LANGUAGE plpgsql;
select inline_0 ();
drop function inline_0 ();
\t
