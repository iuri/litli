<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/dotlrn/www/community-edit.xql -->
<!-- @author Roel Canicula (roelmc@aristoi.biz) -->
<!-- @creation-date 2004-06-26 -->
<!-- @arch-tag: 4862cc84-c9e4-47b5-ba74-b2e068ae0912 -->
<!-- @cvs-id $Id: community-edit.xql,v 1.1 2004/07/29 05:27:36 roelc Exp $ -->

<queryset>

  <fullquery name="community_types">
    <querytext>
      select
        community_type,
        community_type
      from
        dotlrn_community_types
      order by
        community_type
    </querytext>
  </fullquery>

</queryset>
