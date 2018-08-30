<master>
<property name="doc(title)">#chat.Add_user_to_room#</property>
<property name="context">@context;literal@</property>

<FORM METHOD=get ACTION=search-2>
  <div>
  <input type="hidden" name="room_id" value="@room_id@">
  <input type="hidden" name="target" value="one">
  <input type="hidden" name="type" value="@type@">
  </div>
  <p>
    <input type="text" size="15" name="keyword">
    <input type="submit" value="#acs-subsite.Search_For_Exist_User#">
  </p>
</FORM>

