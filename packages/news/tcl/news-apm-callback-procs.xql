<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/news/tcl/news-apm-callback-procs.xql -->
<!-- @author Stan Kaufman (skaufman@epimetrics.com) -->
<!-- @creation-date 2005-08-03 -->
<!-- @arch-tag: 5AB8567C-0484-11DA-9C6A-000A95C482A6 -->
<!-- @cvs-id $Id: news-apm-callback-procs.xql,v 1.1 2005/08/04 02:10:32 skaufman Exp $ -->

<queryset>

  <fullquery name="news::install::before_uninstantiate.dead_news">
    <querytext>
      select i.item_id
      from cr_items i, acs_objects o
      where o.package_id = :package_id
      and i.item_id = o.object_id
      </querytext>
  </fullquery>

</queryset>
