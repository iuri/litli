-- 
-- packages/assessment/sql/postgresql/upgrade/upgrade-0.16-0.17.sql
-- 
-- @author Roel Canicula (roel@solutiongrove.com)
-- @creation-date 2006-01-25
-- @arch-tag: 63dc39c9-c94d-454b-ac93-b81135ebb6ae
-- @cvs-id $Id: upgrade-0.16-0.17.sql,v 1.2 2006/06/12 02:49:50 daveb Exp $
--

alter table as_items add validate_block text;
