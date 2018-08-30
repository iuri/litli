<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>
<property name="header_suppress">1</property>
<property name="displayed_object_id">@album_id;literal@</property>
@page_nav;noquote@
@message;noquote@
<h2>@photographer@</h2>
<if @description@ not nil>
<p>@description@</p>
</if>
<if @story@ not nil>
<p>@story@</p>
</if>
<if @child_photo:rowcount@ gt 0>
<table align="center" cellspacing="5" cellpadding="5">
<grid name=child_photo cols=4 orientation=horizontal>
<if @child_photo.col@ eq 1>
<tr align="center" valign="top">
</if>
<if @child_photo.rownum@ le @child_photo:rowcount@>
<td><a href="photo?photo_id=@child_photo.photo_id@"><img src="images/@child_photo.thumb_path@" height="@child_photo.thumb_height@" width="@child_photo.thumb_width@" alt="@child_photo.caption@" style="border:0"></a><br>
<a href="photo?photo_id=@child_photo.photo_id@">@child_photo.caption@</a>
</td>
</if>
<else>
<td>&nbsp;</td>
</else>
<if @child_photo.col@ eq 4>
</tr>
</if>
</grid>
</table>
@page_nav;noquote@
</if><else>
<p>#photo-album.lt_This_album_does_not_c#</p>
</else>
<ul>
<if @photo_p;literal@ true>
  <li><a href="photo-add?album_id=@album_id@">#photo-album.lt_Add_a_single_photo_to#</a></li>
  <li><a href="photos-add?album_id=@album_id@">#photo-album.lt_Add_a_collection_of_p#</a></li>
  <li><a href="photos-edit?album_id=@album_id@&page=@page@">#photo-album.Edit_these_photos#</a></li>
</if>
<if @write_p;literal@ true>
  <li><a href="album-edit?album_id=@album_id@">#photo-album.lt_Edit_album_attributes#</a></li>
</if>
<if @move_p;literal@ true>
  <li><a href="album-move?album_id=@album_id@">#photo-album.lt_Move_this_album_to_an#</a></li>
</if>
<if @admin_p;literal@ true>
  <li><a href="/permissions/one?object_id=@album_id@">#photo-album.lt_Modify_this_albums_pe#</a></li>
</if>
<if @delete_p;literal@ true>
  <li><a href="album-delete?album_id=@album_id@">#photo-album.Delete_this_album#</a></li>
</if>
</ul>
<p style="color: #999999;">#photo-album.lt_Click_on_the_small_ph#
</p>
<if @collections@ gt 0>
<p><a href="clipboards">#photo-album.lt_View_all_of_your_clip#</a>.</p>
</if>

