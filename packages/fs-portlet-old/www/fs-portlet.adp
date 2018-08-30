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
<if @use_ajaxfs_p;literal@ true>
<include src="/packages/ajax-filestorage-ui/lib/ajaxfs-include" package_id="@file_storage_package_id;literal@"
	 &="folder_id" layoutdiv="fscontainer">
</if>

<div id="fscontainer">
<if @scoped_p;literal@ true>
<include src="@scope_fs_url;literal@" &="folder_id" root_folder_id="@root_folder_id;literal@"
	 viewing_user_id="@user_id;literal@" &="n_past_days" allow_bulk_actions="1"
	 fs_url="@url;literal@" &="page_num">
</if>

<else>

<if @write_p;literal@ true>
	<div class="list-button-bar-top">
		<a href="@url@folder-create?parent_id=@folder_id@" class="button" title="#fs-portlet.create_new_folder#">#fs-portlet.create_new_folder#</a>
		<a href="@url@file-add?folder_id=@folder_id@" class="button" title="#fs-portlet.upload_file#">#fs-portlet.upload_file#</a>
		<a href="@url@simple-add?folder_id=@folder_id@" class="button" title="#fs-portlet.create_url#">#fs-portlet.create_url#</a>
	</div>

</if>
  <listtemplate name="folders"></listtemplate>
</else>

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
</div>

