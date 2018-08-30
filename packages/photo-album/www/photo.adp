  <master>
    <property name="doc(title)">@title;literal@</property>
    <property name="context">@context;literal@</property>
    <property name="header_suppress">1</property>
    <property name="displayed_object_id">@photo_id;literal@</property>

    @photo_nav_html;noquote@
    <div style="text-align: center; margin: 1em;">
      <if @show_base_link@ eq "t">
        <a href="base-photo?photo_id=@photo_id@"><img src="images/@path@/@title@" height="@height@" width="@width@" alt="@title@" style="border:0"></a>
      </if><else>
        <img src="images/@path@/@title@" height="@height@" width="@width@" alt="@title@">
      </else>
	<if @show_html_p;literal@ true>
          <ul style="text-align:left">
            <li>#photo-album.thumbnail_with_link# <code>&lt;a href="@photo_base_url@photo?photo_id=@photo_id@"&gt;&lt;img src="@photo_base_url@images/@path@/@thumb_image_id@" height="@thumb_height@" width="@thumb_width@" alt="@caption@"&gt;&lt;/a&gt;</code>
 
            <li>#photo-album.image_only# <code>&lt;img src="@photo_base_url@images/@path@/@title@" height="@height@" width="@width@" alt="@title@"&gt;</code>
 
            <li>#photo-album.image_with_link# <code>&lt;a href="@photo_base_url@photo?photo_id=@photo_id@"&gt;&lt;img src="@photo_base_url@images/@path@/@title@" height="@height@" width="@width@" alt="@title@"&gt;&lt;/a&gt;</code>
         </ul>
	</if>
      <if @caption@ not nil>
        <p>@caption@</p>
      </if>
    </div>
    <if @description@ not nil>
      <p>@description@</p>
    </if>
    <if @story@ not nil>
      <p>#photo-album.Story_story#</p>
    </if>
    <if @write_p@ eq 1 or @move_p@ eq 1 or @delete_p@ eq 1><ul>
	<if @show_html_p;literal@ true>
          <li><a href="photo.tcl?photo_id=@photo_id@&amp;show_html_p=0">#photo-album.hide_html#</a></li>  
	</if>
	<else>
          <li><a href="photo.tcl?photo_id=@photo_id@&amp;show_html_p=1">#photo-album.show_html#</a></li>  
	</else>
        <if @write_p;literal@ true>
          <li><a href="photo-iconic?photo_id=@photo_id@">#photo-album.lt_Make_this_photo_the_i#</a>
            <li><a href="photo-edit?photo_id=@photo_id@">#photo-album.lt_Edit_photo_attributes#</a>
        </if>
        <if @move_p@ eq 1 and @albums_list@ ne "">
          <li>
	    <formtemplate id="move_photo">
	      #photo-album._Move_photo_to_album#
	      <formwidget id="new_album_id">
		<if @formerror.new_album_id@ not nil>
		  @formerror.new_album_id@ 
		</if>
	      </formwidget>
	      <formwidget id="move_button"></formwidget>
	    </formtemplate>
        </if>
        <if @delete_p;literal@ true>
          <li><a href="photo-delete?photo_id=@photo_id@">#photo-album.Delete_this_photo#</a>
        </if>
      </ul>
    </if>



    @photo_nav_html;noquote@
    <div style="text-align: center">
      <a href="album?album_id=@album_id@&amp;page=@page_num@">#photo-album.lt_Image_thumbnail_index#</a>
    </div>
    <if @clipboards:rowcount@ eq 1>
      <multiple name="clipboards">
        <a href="clipboard-attach?photo_id=@photo_id@&amp;collection_id=@clipboards.collection_id@">#photo-album.lt_Save_this_photo_to_pr#</a>
      </multiple>
    </if>
    <if @clipboards:rowcount@ gt 1>
      <form class="inline" action="clipboard-attach">
        <if @collection_id@ gt 0>
          <strong>#photo-album.lt_Image_saved_to_clipbo#</strong>
        </if>
        <else> 
          <if @collection_id@ not nil>
            <strong>#photo-album.lt_Image_removed_from_cl#</strong>
          </if>
        </else>
        #photo-album.lt_Save_this_photo_to_pr_1# 
        <input type="hidden" name="photo_id" value="@photo_id@">
        <select name="collection_id">
          <multiple name="clipboards">
            <option value="@clipboards.collection_id@" @clipboards.selected@>@clipboards.title@</option>
          </multiple>
        </select>
        <input type="submit" value="#photo-album._Save#">
      </form>
    </if>
    <if @clipped:rowcount@ gt 0> 
      #photo-album.lt_This_photo_clipped_to# 
      <multiple name="clipped"> 
        <a href="clipboard-view?collection_id=@clipped.collection_id@">@clipped.title@</a>&nbsp;[<a href="clipboard-remove?collection_id=@clipped.collection_id@&amp;photo_id=@photo_id@">#photo-album.remove#</a>]&nbsp;
      </multiple>
    </if>
    <if @clipboards:rowcount@ gt 1>
      <br><a href="clipboards">#photo-album.lt_View_all_your_clipboa#</a>
    </if>
    
    
    

