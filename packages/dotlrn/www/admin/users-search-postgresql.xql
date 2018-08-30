<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/dotlrn/www/admin/users-search-postgresql.xql -->
<!-- @author Deds Castillo (deds@i-manila.com.ph) -->
<!-- @creation-date 2005-09-13 -->
<!-- @arch-tag: dff66e7e-e3d9-49f0-81e4-5979549a840c -->
<!-- @cvs-id $Id: users-search-postgresql.xql,v 1.2 2006/08/08 21:26:28 donb Exp $ -->

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>
  
  <partialquery name="last_visit_g">
    <querytext>
    (dotlrn_users.user_id = users.user_id and users.last_visit <= (current_timestamp - (:last_visit_greater || 'days') :: interval ))
    </querytext>
  </partialquery>
  
  <partialquery name="last_visit_l">
    <querytext>
    (dotlrn_users.user_id = users.user_id and users.last_visit >= (current_timestamp - (:last_visit_less || 'days') :: interval ))
    </querytext>
  </partialquery>
  
  
</queryset>