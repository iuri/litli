<if @shaded_p;literal@ true>
  <br>
</if>
<else>
  <include src="folder-chunk" admin_actions_p="@admin_actions_p;literal@" show_upload_url_p="@show_upload_url_p;literal@" show_header_p="0"
           admin_p="@admin_p;literal@" min_level="@min_level;literal@" max_level="@max_level;literal@" list_of_folder_ids="@list_of_folder_ids;literal@" package_id="@package_id;literal@">
</else>
