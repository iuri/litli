  <if @toolbar:rowcount@ gt 0>
       <small>[
         <multiple name="toolbar">
           <if @toolbar.rownum@ ne 1>
             |
           </if>
           <a href="@toolbar.target@">@toolbar.label@</a>
         </multiple>
       ]</small>
     <br><br>
  </if>

  <if @folders:rowcount@ eq 0>
     <em>#dotlrn-homework.Folder_is_empty#</em>
  </if>
  <else>
    <if @admin_p@ true and @show_header_p@ true>

      <%
         # This wording was provided by Sloan/MIT.  Other users will probably want to modify
         # it.
      %>

      <p>#dotlrn-homework.lt_There_are_two_ways_to#</p>
      <p>#dotlrn-homework.lt_TAs_and_professors_ca#</p>
      <p>#dotlrn-homework.lt_For_more_information_#</p>
      <p>
    </if>
    <table border="0" class="table-display" cellpadding="5" cellspacing="0" width="85%">
      <if @show_header_p;literal@ true>
        <tr class="table-header">
          <td>&nbsp;</td>
          <td>#dotlrn-homework.Title#</td>
          <if @show_users_p;literal@ true>
            <td>#dotlrn-homework.Student#</td>
          </if>
	<else>
	<td></td>
	</else>
          <td>#dotlrn-homework.Action#</td>
        </tr>
      </if>
      <multiple name="folders">
        <if @folders.rownum@ odd>
          <tr class="z_dark">
        </if>
        <else>
          <tr class="z_light">
        </else>
      <if @folders.content_type@ eq "content_folder">
          <td align="left">@folders.spaces;noquote@<img style="border:0" src="@file_storage_url@/graphics/folder.gif" alt="#file-storage.Folder#"></td>
          <td colspan="3"><a href="@folders.contents_url@">@folders.name@</a></td>
      </if>
      <else>
          <td align="left">@folders.spaces;noquote@<a href="@folders.download_url@"><img style="border:0" src="@file_storage_url@/graphics/file.gif"></a></td>
          <td><a href="@folders.download_url@">@folders.name@</a><br><if @folders.name@ ne @folders.title@><span style="color: \#999;">@folders.title@</span></if></td>
          <td>
            <if @show_users_p;literal@ true>
              @folders.file_owner_name@
            </if>
          </td>
          <td><small>
             <a href="@folders.view_details_url@">#dotlrn-homework.New_Comments#</a> 
             <if @folders.upload_correction_url@ not nil>
               | <a href="@folders.upload_correction_url@">#dotlrn-homework.View#</a>
             </if>
             <if @folders.view_correction_details_url@ not nil>
               | <a href="@folders.view_correction_details_url@">#dotlrn-homework.View_1#<if @admin_p;literal@ true>#dotlrn-homework.lt_or_edit#</if> #dotlrn-homework.Comments#</a>
             </if>
          </small></td>
      </else>
        </tr>
      </multiple>
    </table>
  </else>

