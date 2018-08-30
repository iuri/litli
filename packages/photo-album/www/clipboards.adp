  <master>
    <property name="doc(title)">#photo-album.Your_clipboards#</property>
    <property name="context">#photo-album.Clipboards#</property>
    <if @user_id@ eq 0> 
      #photo-album.You_will_have_to# <a href="/register/">#photo-album.log_in#</a> #photo-album.or#
      <a href="/register/">#photo-album.register#</a>
      #photo-album.lt_in_order_to_manage_cl#
    </if>
    <else>
      <if @clipboards:rowcount@ eq 0>
        #photo-album.lt_You_do_not_currently_# <a href="./">#photo-album.photos#</a> #photo-album.lt_and_add_them_to_a_cli#
      </if>
      <else> 
        <ul>
          <multiple name="clipboards">
            <li> <a href="clipboard-view?collection_id=@clipboards.collection_id@">@clipboards.title@</a>
              #photo-album.lt_clipboardsphotos_phot# <a href="clipboard-ae?collection_id=@clipboards.collection_id@">#photo-album.lt_edit________________n#</a> | <a href="clipboard-delete?collection_id=@clipboards.collection_id@">#photo-album.delete_clipboard#</a> ]</li>
          </multiple>
        </ul>
      </else>
    </else>
