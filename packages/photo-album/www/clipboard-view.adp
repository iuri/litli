  <master>
    <property name="doc(title)">@title;literal@</property>
    <property name="context">@context;literal@</property>


    <p>
      #photo-album.Clipboard# <strong>@title@</strong> <if @owner_id@ ne
        @user_id@>(<a href="/shared/community-member?user_id=@owner_id@">@owner_name@</a>)</if>
    </p>

    <p>

    <if @shutterfly_p;literal@ true>
    <form action="http://www.shutterfly.com/c4p/UpdateCart.jsp" method="POST">
      <input type="hidden" name="addim" value="1">
      <input type="hidden" name="protocol" value="SFP,100">
      <input type="hidden" name="pid" value="C4PP">
      <input type="hidden" name="psid" value="TEST">
      <input type="hidden" name="imnum" value="@images:rowcount@">
      <multiple name="images"> 
        <input type="hidden" name="imsel-@images.rownum@" value="1">
        <input type="hidden" name="imraw-@images.rownum@" value="@base_url@@images.base_id@">
        <input type="hidden" name="imrawheight-@images.rownum@" value="@images.base_height@">
        <input type="hidden" name="imrawwidth-@images.rownum@" value="@images.base_width@">
        <input type="hidden" name="imthumb-@images.rownum@" value="@base_url@@images.image_id@">
        <input type="hidden" name="imthumbheight-@images.rownum@" value="@images.height@">
        <input type="hidden" name="imthumbwidth-@images.rownum@" value="@images.width@">
      </multiple>
      <input type="hidden" name="returl" value="@returnurl@">
      <input type="submit" value="Order prints">
    </form>
    </if>

    </p>
    <if @images:rowcount@ lt 1> 
      <p><em>#photo-album.lt_No_photos_in_the_clip#</em></p>
    </if>
    <else>
      <multiple name="images"> 
        <div class="image" style="display: inline; margin: 10px;">
          <a href="photo?photo_id=@images.photo_id@"><img src="images/@images.image_id@" width="@images.width@" height="@images.height@" alt="@images.caption@ @images.taken@"></a>
        </div>
      </multiple>
    </else> 




