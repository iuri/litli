<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/dotlrn/www/member-add-3.xql -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2007-11-06 -->
<!-- @cvs-id $Id: member-add-3.xql,v 1.2 2008/11/09 23:29:23 donb Exp $ -->
<queryset>
  <fullquery name="get_rel_info">
    <querytext>
      select rel_id, rel_type as old_rel_type
      from dotlrn_member_rels_full
      where community_id = :community_id
      and user_id = :member_id
    </querytext>
  </fullquery>
</queryset>