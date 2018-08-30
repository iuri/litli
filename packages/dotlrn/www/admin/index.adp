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

<!--
  @author Ben Adida (ben@openforce.net)
  @author yon (yon@openforce.net)
  @version $Id: index.adp,v 1.33 2015/07/03 10:43:58 gustafn Exp $
-->

<master>
<property name="doc(title)">@admin_pretty_name;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

<div class="portlet-wrapper">
	<div class="portlet-header">
		<div class="portlet-title-no-controls">
			<h1>@admin_pretty_name@</h1>
		</div>
	</div>
	<div class="portlet">
      <include src="/packages/dotlrn/lib/admin-chunk">
    </div>
</div>
