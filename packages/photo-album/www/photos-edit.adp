<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context_list;literal@</property>

<p>#photo-album.Name#: @title@ 
<if @description@ not nil>
<p>#photo-album.lt_Description_descripti#
</if>
<if @story@ not nil>
<p>#photo-album.Story_story#
</if>
<ul>
<if @photo_p;literal@ true>
  <li><a href="photo-add?album_id=@album_id@">#photo-album.lt_Add_a_single_photo_to#</a>
</if>
<if @photo_p;literal@ true>
  <li><a href="photos-add?album_id=@album_id@">#photo-album.lt_Add_a_collection_of_p#</a>
</if>
<if @write_p;literal@ true>
  <li><a href="album-edit?album_id=@album_id@">#photo-album.lt_Edit_album_attributes#</a>
</if>
<if @move_p;literal@ true>
  <li><a href="album-move?album_id=@album_id@">#photo-album.lt_Move_album_to_another#</a>
</if>
<if @delete_p;literal@ true>
  <li><a href="album-delete?album_id=@album_id@">#photo-album.Delete_this_album#</a>
</if>
<if @admin_p;literal@ true>
  <li><a href="/permissions/one?object_id=@album_id@">#photo-album.lt_Modify_album_permissi#</a>
</if>
</ul>
<if @child_photo:rowcount@ gt 0>
   <form action="photos-edit-2">
      <input type="hidden" name="album_id" value="@album_id@">
      <input type="hidden" name="page" value="@page@">            
      <input type="submit" value="Submit">
        <table>
          <multiple name="child_photo">
                <if @child_photo.rownum@ odd><tr bgcolor="#F0F0F0"></if><else><tr bgcolor="#FFFFFF"></else>
              <td>&nbsp;</td>
              <td align="center"><input type="radio" name="d.@child_photo.photo_id@"
                                      value="0" checked></td>
              <td>&nbsp;</td>
              <td rowspan="3">
                    <table>
                      <tr><td>#photo-album.Hide_1#</td><td><if @child_photo.hide_p@ ne 0><input type="checkbox" name="hide.@child_photo.photo_id@" value="1"></if><else><input checked type="checkbox" name="hide.@child_photo.photo_id@" value="0"></else></td></tr>
                      <tr><td>#photo-album.Sequence#</td><td><input type="text" name="sequence.@child_photo.photo_id@" value="@child_photo.sequence@" size="4"></td></tr>
                      <tr><td>#photo-album.Caption_1#</td><td><input type="text" name="caption.@child_photo.photo_id@" value="@child_photo.caption@" size="60"></td></tr>
                      <tr><td>#photo-album.Title_1#</td><td><input type="text" name="photo_title.@child_photo.photo_id@" value="@child_photo.photo_title@" size="60"></td></tr>
                      <tr><td>#photo-album.Story_1#</td><td><textarea name="photo_story.@child_photo.photo_id@" cols="60" wrap="soft" rows="3">@child_photo.photo_story@</textarea></td></tr>
                      <tr><td>#photo-album.Description_1#</td><td><textarea name="photo_description.@child_photo.photo_id@" cols="60" wrap="soft" rows="3">@child_photo.photo_description@</textarea></td></tr>
	
                    <if @child_photo.datetaken@ not nil><tr><td colspan="2">#photo-album.lt_Taken_child_photodate# <if @child_photo.flash@>#photo-album.Flash#</if></td></tr></if>
                    </table>
              </td>
            </tr>
            <if @child_photo.rownum@ odd><tr bgcolor="#F0F0F0"></if><else><tr bgcolor="#FFFFFF"></else>
              <td><input type="radio" name="d.@child_photo.photo_id@" value="90"></td>
              <td align="center"><a
                                  href="photo?photo_id=@child_photo.photo_id@" onclick="javascript:w=window.open('images/@child_photo.viewer_path@','@child_photo.photo_id@','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=@child_photo.window_width@,height=@child_photo.window_height@');w.focus();return false;"><img src="images/@child_photo.thumb_path@" width="@child_photo.thumb_width@" height="@child_photo.thumb_height@"></a></td>
              <td><input type="radio" name="d.@child_photo.photo_id@" value="270"></td>
            </tr>
            <if @child_photo.rownum@ odd><tr bgcolor="#F0F0F0"></if><else><tr bgcolor="#FFFFFF"></else>
              <td>&nbsp;</td>
              <td align="center"><input type="radio" name="d.@child_photo.photo_id@" value="180"></td>
              <td>&nbsp;</td>
            </tr>
          </multiple>
        </table>
        <input type="submit" value="Submit">
    </form>
</if><else>
<p>#photo-album.lt_This_album_does_not_c#
</else>
<p>
@page_nav;noquote@

