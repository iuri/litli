-- /packages/news/sql/news-sc-drop.sql
--
-- @author Robert Locke (rlocke@infiniteinfo.com)
-- @created 2001-10-23
-- @cvs-id $Id: news-sc-drop.sql,v 1.3 2006/08/08 21:27:04 donb Exp $
--
-- Removes search support from news module.
--

select acs_sc_impl__delete(
	   'FtsContentProvider',		-- impl_contract_name
           'news'				-- impl_name
);
