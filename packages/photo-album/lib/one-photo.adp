<contract>
  Display one photo.

  @author Jeff Davis davis@xarg.net
  @cvs-id $Id: one-photo.adp,v 1.2 2008/03/12 21:19:02 emmar Exp $

  @param photo array of values as returned from photo_album::photo::get
  @param style string (either "feed" or "display" -- default is display)
  @param base_url url to the package (ok for this to be empty if in the package, trailing / expected)
</contract>
<if @style@ not nil and @style@ eq "feed">
<h1>@photo.title@</h1>
<p>@photo.description@</p>
<img src="@base@images/@photo.thumb_image_id@" width="@photo.thumb_width@" height="@photo.thumb_height@">
<p>@photo.caption@</p>
<p>@photo.story@</p>
<p>by @photo.username@</p>
</if>
<else>
<p>@photo.description@</p>
<div style="text-align: center"><div class="image"><a href="@base@photo?photo_id=@photo.photo_id@"><img src="@base@images/@photo.viewer_image_id@" width="@photo.viewer_width@" height="@photo.viewer_height@"></a></div><p>@photo.caption@</p></div>
<p>@photo.story@</p>
<p>by @photo.username@</p>
</else>
