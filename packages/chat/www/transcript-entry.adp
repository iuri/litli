<!--
    Create/edit form for chat transcript.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 17, 2000
    @cvs-id $Id: transcript-entry.adp,v 1.9.4.2 2017/01/18 18:24:23 gustafn Exp $
-->
<master>
<property name="context">@context;literal@</property>
<property name="doc(title)">@title;literal@</property>

<form action="@action@" method="post" class="margin-form">
    <div>
    <input type="hidden" name="transcript_id" value="@transcript_id@">
    <input type="hidden" name="room_id" value="@room_id@">
    <input type="hidden" name="contents" value="@contents@">
    </div>
    <div class="form-item-wrapper">
        <div class="form-label">
          <label for="transcript_name">#chat.Transcript_name#</label>
        </div>
        <div class="form-widget">
          <input size="50" name="transcript_name" id="transcript_name" value="@transcript_name@">
        </div>
      </div>
      <div class="form-item-wrapper">
        <div class="form-label">
          <label for="delete_messages">#chat.Delete_messages#</label>
        </div>
        <div class="form-widget">
          <input type="checkbox" name="delete_messages" id="delete_messages">
        </div>
        <div class="form-help-text">
            <img src="/shared/images/info.gif" alt="Help text" height="9" width="12">
            #chat.delete_messages_after_transcript#
        </div>
      </div>
      <if @active_p;literal@ true>
        <div class="form-item-wrapper">
          <div class="form-label">
            <label for="deactivate_room">#chat.Room_deactivate#</label>
          </div>
          <div class="form-widget">
            <input type="checkbox" name="deactivate_room" id="deactivate_room">
          </div>
          <div class="form-help-text">
            <img src="/shared/images/info.gif" alt="Help text" height="9" width="12">
            #chat.deactivate_room_after_transcript#
          </div>
        </div>
      </if>
      <div class="form-item-wrapper">
        <div class="form-label">
          <label for="description">#chat.Description#</label>
        </div>
        <div class="form-widget">
          <textarea name="description" id="description" rows=6 cols=65>@description@</textarea>
        </div>
      </div>
      <div class="form-item-wrapper">
        <div class="form-label">#chat.Contents#</div>
        <div class="form-widget">
    	  <div style="border: 1px solid #222; padding: 3px">@contents;noquote@</div>
        </div>
      </div>
      <div class="form-button">
        <input type="submit" value="@submit_label@">
      </div>
</form>
