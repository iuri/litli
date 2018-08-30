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

<if @config.shaded_p@ ne "t">

 <switch @view@>
   <case value="day">
     <include src="/packages/calendar/www/view-one-day-display" 
     return_url="@return_url;literal@"
     date="@date;literal@" 
     start_display_hour=7 
     end_display_hour=22
     page_num="@page_num;literal@"
     calendar_url="@calendar_url;literal@"
     calendar_id_list="@list_of_calendar_ids;literal@">
   </case>

    <case value="list">
      <include src="/packages/calendar/www/view-list-display" 
      return_url="@return_url;literal@"
      start_date="@start_date;literal@" 
      end_date="@end_date;literal@" 
      date="@current_date;literal@" 
      period_days="@period_days;literal@"
      item_template="@item_template;literal@"
      calendar_id_list="@list_of_calendar_ids;literal@" 
      page_num="@page_num;literal@"
      calendar_url="@calendar_url;literal@"
      sort_by="@sort_by;literal@"> 
    </case>
   
    <case value="week">
      <include src="/packages/calendar/www/view-week-display" 
      return_url="@return_url;literal@"
      date="@current_date;literal@"
      calendar_id_list="@list_of_calendar_ids;literal@" 
      calendar_url="@calendar_url;literal@"
      page_num="@page_num;literal@"
    </case>

    <case value="month">
      <include src="/packages/calendar/www/view-month-display"
      return_url="@return_url;literal@"
      date="@current_date;literal@"
      calendar_id_list="@list_of_calendar_ids;literal@" 
      page_num="@page_num;literal@"
      calendar_url="@calendar_url;literal@"
    </case>
  </switch>
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>
