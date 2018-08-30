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

<master>
<property name="doc(title)">@title;literal@</property>
<property name="link_control_panel">0</property>
<property name="context">@context;literal@</property>

<div class="portlet-wrapper">
  <div class="portlet-header">
	<div class="portlet-title-no-controls">
      <h1>@portlet_title@</h1>
    </div> <!-- portlet-title -->
  </div>
  <div class="portlet">
    <include src="/packages/dotlrn/www/dotlrn-main-portlet" show_buttons_p="0" show_archived_p=0 title="Groups" referer="@referer;literal@" community_filter="communities">
   </div> <!-- portlet -->
</div>
