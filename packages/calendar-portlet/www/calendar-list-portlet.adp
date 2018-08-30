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
  <include src="/packages/calendar/www/view-list-display" 
  start_date="@start_date;literal@" 
  end_date="@end_date;literal@" 
  date="@current_date;literal@" 
  period_days="@period_days;literal@"
  page_num="@page_num;literal@"
  calendar_id_list="@list_of_calendar_ids;literal@" 
  calendar_url="@calendar_url;literal@"
  return_url="@return_url;literal@"
  sort_by="@sort_by;literal@"> 
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>
