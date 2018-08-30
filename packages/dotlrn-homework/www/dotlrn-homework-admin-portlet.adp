<if @shaded_p;literal@ true>
  <br>
</if>
<else>
  <ul>
    <li>
      <if @subscribe_p;literal@ false>
        <strong>#dotlrn-homework.Alert#</strong> | <a href="@toggle_url@" title="#dotlrn-homework.Do_not_alert#">#dotlrn-homework.Do_not_alert#</a>
      </if>
      <else>
        <a href="@toggle_url@" title="#dotlrn-homework.Alert#">#dotlrn-homework.Alert#</a> | <strong>#dotlrn-homework.Do_not_alert#</strong>
      </else>
      #dotlrn-homework.lt_me_when_homework_file#
    </li>
    <li><a href="dotlrn-homework/admin/upload-size-limit?<%=[export_vars -url {return_url}]%>" title="#dotlrn-homework.edit_upload_size_limit#">#dotlrn-homework.edit_upload_size_limit#</a></li>
  </ul>
</else>

