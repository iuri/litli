<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>
<property name="header_suppress">1</property>
<property name="displayed_object_id">@photo_id;literal@</property>
@photo_nav_html;noquote@
<div style="text-align: center">
<img src="images/@path@/@title@" height="@height@" width="@width@" alt="@title@">
<if @caption@ not nil><p>@caption@</p></if>
</div>
<if @description@ not nil>
<p>@description@</p>
</if>
<if @story@ not nil>
<p>#photo-album.Story_story#</p>
</if>
@photo_nav_html;noquote@
<div style="text-align: center">
<a href="album?album_id=@album_id@&amp;page=@page_num@">#photo-album.lt_Imagenbspthumbnailnbs#</a> 
| <a href="photo?photo_id=@photo_id@">#photo-album.Smallernbspimage#</a></div>
