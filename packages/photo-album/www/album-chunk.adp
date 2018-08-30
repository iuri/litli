<table border="1" cellpadding="2" cellspacing="2">
 <tr>
  <td style="background-color:#cccccc">#photo-album.Name#</td>
  <td style="background-color:#cccccc">#photo-album.Description#</td>
 </tr>

<multiple name="child">
 <tr>
  <if @child.type@ eq "Folder">
   <td align="center"><a href="@url@?folder_id=@child.item_id@"><img src="@url@graphics/folder.gif" alt="@child.name@" style="border:0"></a></td>
  </if><else>
   <td align="center"><if @child.iconic@ not nil><a href="@url@album?album_id=@child.item_id@"><img src="@url@images/@child.iconic@" alt="@child.name@" style="border:0"></if><else><img src="@url@graphics/album.gif" alt="@child.name@"></else></a></td>
  </else>
  <td>
<if @child.type@ eq "Folder"><a href="@url@?folder_id=@child.item_id@"></if><else><a href="@url@album?album_id=@child.item_id@"></else>
@child.name@</a><if @child.description@ not nil><br>@child.description@</if></td>
 </tr>
</multiple>
</table>

