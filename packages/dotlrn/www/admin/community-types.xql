<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/dotlrn/www/admin/community-types.xql -->
<!-- @author Roel Canicula (roelmc@aristoi.biz) -->
<!-- @creation-date 2004-06-26 -->
<!-- @arch-tag: 4e729d57-1511-466a-a3a1-67a6f77feb41 -->
<!-- @cvs-id $Id: community-types.xql,v 1.1 2004/07/28 07:23:44 roelc Exp $ -->

<queryset>
  
  <fullquery name="select_community_types">
    <querytext>
      select
        community_type,
        supertype,
        pretty_name,
        description
      from
        dotlrn_community_types
      order by
        community_type
    </querytext>
  </fullquery>

</queryset>
