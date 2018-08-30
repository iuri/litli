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

<include src="@scope_fs_url;literal@" &="folder_id" &="root_folder_id" viewing_user_id="@user_id;literal@"
	 &="n_past_days" fs_url="@url;literal@">

<p><include src="/packages/notifications/lib/notification-widget" type="fs_fs_notif"
	 object_id="@folder_id;literal@"
	 pretty_name="@folder_name@"
	 url="@folder_url;literal@" >

<if @webdav_url@ not nil>
      <p>#file-storage.Folder_available_via_WebDAV_at#</p>
</if>
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>
