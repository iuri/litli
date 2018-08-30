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
<if @config.shaded_p;literal@ false>

  <include src="/packages/calendar/www/navbar"
    date="@date;literal@"
    period_days="@period_days;literal@"
    base_url="@ad_conn_url;literal@"
    page_num="@page_num;literal@"
    view="@view;literal@">

  <table id="valign-hack" border="0" width="100%">
    <tr>
      <td valign="top" style="width: 200px">

	<include src="/packages/calendar/www/mini-calendar" 
          view="@view;literal@" 
          date="@date;literal@" 
          page_num="@page_num;literal@">
 
       <p>
		<if @create_p;literal@ true> 
			<a href="@add_item_url@" title="#calendar-portlet.Add_an_item#" class="button">#calendar-portlet.Add_an_item#</a>
		</if>
		<if @admin_p;literal@ true>
			<a href="calendar/calendar-item-types?calendar_id=@force_calendar_id@" title="#calendar-portlet.Manage_Item_Types#" class="button">#calendar-portlet.Manage_Item_Types#</a>
		</if>
       </p>
      </td>

      <td valign="top">


 <switch @view@>
   <case value="day">
     <include src="/packages/calendar/www/view-one-day-display" 
     date="@date;literal@" 
     start_display_hour=7 
     end_display_hour=22
     page_num="@page_num;literal@"
     calendar_id_list="@list_of_calendar_ids;literal@" 
     calendar_url="@calendar_url;literal@"
     return_url="@return_url;literal@">
   </case>

  <case value="list">
     <include src="/packages/calendar/www/view-list-display" 
     start_date="@start_date;literal@" 
     end_date="@end_date;literal@" 
     date="@current_date;literal@" 
     period_days="@period_days;literal@"
     calendar_id_list="@list_of_calendar_ids;literal@" 
     page_num="@page_num;literal@"
     calendar_url="@calendar_url;literal@"
     return_url="@return_url;literal@">
  </case>
  
  <case value="week">
     <include src="/packages/calendar/www/view-week-display" 
     date="@current_date;literal@"
     calendar_id_list="@list_of_calendar_ids;literal@" 
     page_num="@page_num;literal@"
     return_url="@return_url;literal@"
     calendar_url="@calendar_url;literal@"
     export="@export;literal@">
 </case>

  <case value="month">
     <include src="/packages/calendar/www/view-month-display"
     date="@current_date;literal@"
     calendar_id_list="@list_of_calendar_ids;literal@" 
     page_num="@page_num;literal@"
     show_calendar_name_p="@show_calendar_name_p;literal@"
     return_url="@return_url;literal@"
     calendar_url="@calendar_url;literal@"
     export="@export;literal@">
  </case>
 </switch>
      </td>
    </tr>
  </table>

</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>
