<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context_list;literal@</property>
<image src="images/@path@" height=@height@ width=@width@>
<p>

<formtemplate id=edit_photo>
  <table>
    <tr bgcolor="#F0F0F0">
      <td>&nbsp;</td>
      <td align="center">
	<input type="radio" name="d.@photo_id@" value="0" checked>
      </td>
      <td>&nbsp;</td>
      <td rowspan="3">
	<table>
          <tr>
	    <td>
	      #photo-album.Hide#: <input @checked_string@ type="checkbox" name="hide" value="1">
	    </td>
	  </tr>
          <tr>
	    <td>
	      #photo-album.Title#: <formwidget id=title></formwidget>
	    </td>
	  </tr>
          <tr>
	    <td>
	      #photo-album.Caption#: <formwidget id=caption></formwidget>
	    </td>
	  </tr>
          <tr>
	    <td>
	      #photo-album.Descriptio#: <formwidget id=description></formwidget>
	    </td>
	  </tr>
          <tr>
	    <td>
	      #photo-album.Story#:<formwidget id=story></formwidget>
	    </td>
	  </tr>
	</table>
      </td>
    </tr>
    <tr bgcolor="#F0F0F0">
      <td>
	<input type="radio" name="d.@photo_id@" value="90">
      </td>
      <td align="center">
	<img src="images/@thumb_path@" width="@thumb_width@" height="@thumb_height@">
      </td>
      <td>
	<input type="radio" name="d.@photo_id@" value="270">
      </td>
    </tr>
    <tr bgcolor="#F0F0F0">
      <td>
	&nbsp;
      </td>
      <td align="center">
	<input type="radio" name="d.@photo_id@" value="180">
      </td>
      <td>
	&nbsp;
      </td>
    </tr>
  </table>
  <formwidget id="photo_id"></formwidget>
  <formwidget id="revision_id"></formwidget>
  <formwidget id="previous_revision"></formwidget>  
  <formwidget id="submit_b"></formwidget>  
</formtemplate>
