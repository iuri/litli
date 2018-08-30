<master src="master">
<property name="doc(title)">#dotlrn-homework.Delete_title#</property>
<property name="context_bar">@context_bar;literal@</property>

<if @blocked_p;literal@ true>

<p>#dotlrn-homework.lt_This_file_has_version#

</if>
<else>

<form method=POST action=file-delete>
<input type="hidden" name="file_id" value="@file_id@">
<input type="hidden" name="confirmed_p" value="t">

<p>#dotlrn-homework.lt_Are_you_sure_you_want#

<p>
<center>
<input type="submit" value="#dotlrn-homework.lt_Yes_delete_it#">
</center>
</form>

</else>

