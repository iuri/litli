<master>
<property name="doc(title)">@folder_name;literal@</property>
<property name="context">@context;literal@</property>

<if @folder_description@ not nil>
<p>@folder_description;noquote@</p>
</if>
<div style="float: right"><ul>
<if @subfolder_p;literal@ true>
  <li><a href="folder-add?parent_id=@folder_id@">#photo-album.Add_a_new_folder#</a></li>
</if>
<if @album_p;literal@ true>
  <li><a href="album-add?parent_id=@folder_id@">#photo-album.Add_a_new_album#</a></li>
</if>
<if @write_p;literal@ true>
  <li><a href="folder-edit?folder_id=@folder_id@">#photo-album.lt_Edit_folder_informati#</a></li>
</if>
<if @move_p;literal@ true>
  <li><a href="folder-move?folder_id=@folder_id@">#photo-album.lt_Move_this_folder_to_a#</a></li>
</if>
<if @delete_p;literal@ true>
  <li><a href="folder-delete?folder_id=@folder_id@">#photo-album.Delete_this_folder#</a></li>
</if>
<if @admin_p;literal@ true>
  <li><a href="/permissions/one?object_id=@folder_id@">#photo-album.lt_Modify_this_folders_p#</a></li>
  <li><a href="/shared/parameters?@parameter_url_vars@">#photo-album.Modify_this_pack#</a> </li>
</if>
</ul>
</div>
<if @child:rowcount@ gt 0>

<table border="0">
 <tr class="list-header">
  <td align="center">#photo-album.Name#</td>
  <td align="center">#photo-album.Description#</td>
 </tr>

<multiple name="child">
 <if @child.rownum@ odd><tr class="list-odd"></if><else><tr class="list-even"></else>
  <if @child.type@ eq "Folder">
   <td align="center"><a href="./?folder_id=@child.item_id@"><img src="graphics/folder.gif" alt="@child.name@" style="border:0"></a></td>
  </if><else>
   <td align="center"><if @child.iconic@ not nil><a href="album?album_id=@child.item_id@"><img src="images/@child.iconic@" alt="@child.name@" style="border:0"></if><else><img src="graphics/album.gif" alt="@child.name@"></else></a></td>
  </else>
  <td>
<if @child.type@ eq "Folder"><a href="./?folder_id=@child.item_id@"></if><else><a href="album?album_id=@child.item_id@"></else>
@child.name@</a><if @child.description@ not nil><br>@child.description@</if></td>
 </tr>
</multiple>
</table>

</if><else>
<p>#photo-album.lt_There_are_no_items_in#</p>
</else>

<if @collections@ gt 0>
<p><a href="clipboards">#photo-album.lt_View_all_of_your_clip#</a>.</p>
</if>

<if @shutterfly_p;literal@ true>
    <p class="hint">
      #photo-album.lt_To_order_prints_of_th#
      <a href="http://shutterfly.com">#photo-album.shutterflycom#</a> #photo-album.lt_for______printing_fro# <a href="clipboards">#photo-album.clipboard#</a> #photo-album.screen#
    </p>
</if>

