<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/dotlrn/www/member-email-toggle-oracle.xql -->
<!-- @author Roel Canicula (roelmc@pldtdsl.net) -->
<!-- @creation-date 2005-08-20 -->
<!-- @arch-tag: 2d9ab52d-3137-447a-8994-fe6b14b4e3ce -->
<!-- @cvs-id $Id: member-email-toggle-oracle.xql,v 1.2 2006/08/08 21:26:24 donb Exp $ -->

<queryset>
  
  <rdbms>
    <type>oracle</type>
    <version>8.1.6</version>
  </rdbms>
  
  <fullquery name="toggle_member_email">
    <querytext>
      update dotlrn_member_emails
      set enabled_p = case when enabled_p = 't' then 'f' else 't' end
      where community_id = :community_id
      and type = 'on join'
    </querytext>
  </fullquery>

</queryset>