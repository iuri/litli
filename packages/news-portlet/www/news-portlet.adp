<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

  <if @shaded_p@ ne "t">
    <if @inside_comm_p@ >
      <div style="padding-top:0.2em; padding-bottom:0.3em;">
        <div style="float:right;">
          <a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#" class="button">#news-portlet.Add_a_News_Item#</a>
        </div>
        <div>
<if @news_url@ not nil>
<include src="/packages/notifications/lib/notification-widget" type="one_news_item_notif"
     object_id="@package_id;literal@"
     pretty_name="News"
     url="@news_url;literal@" >
</if>    
          <if @rss_exists@ eq 1>
            <br>
              <a href="@rss_url@"><img src="/resources/xml.gif" alt="Subscribe via RSS" width="26" height="10" style="border:0; padding-right:3px">#rss-support.Syndication_Feed#</a>
          </if>
        </div>
      </div>
    </if>
    <if @news_items:rowcount@ gt 0>
      <if @news_items:rowcount@ eq 1>

        <multiple name="news_items">
          <include src="summary" 
            item_id="@news_items.item_id;literal@"
            url="@news_items.view_url;literal@">
        </multiple>
        
      </if>
      <else>

        <multiple name="news_items">
          <if @one_instance_p;literal@ false>
            <h3 class="portlet">@news_items.parent_name@</h3>
          </if>

          <ul>
            <group column="package_id">
              <li>
                <a href="@news_items.view_url@">@news_items.publish_title@</a>
                (<if @display_item_attribution_p;literal@ true>#news-portlet.Contributed_by# @news_items.item_creator@ - </if>@news_items.publish_date@)
                <if @display_item_lead_p;literal@ true> <br>@news_items.publish_lead@</if>
                <if @display_item_content_p;literal@ true> <br>@news_items.publish_body@</if>
              </li>
            </group>
          </ul>
        </multiple>

      </else>
    </if>
    <else>
      <small>#news-portlet.No_News#</small>
    </else>
  </if>
  <else>
    <small>
      #new-portal.when_portlet_shaded#
    </small>
  </else>
