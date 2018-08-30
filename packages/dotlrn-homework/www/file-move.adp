<master src="master">
<property name="doc(title)">#dotlrn-homework.Move#</property>
<property name="context_bar">@context_bar;literal@</property>

<P>#dotlrn-homework.lt_Select_the_folder_tha_1#

<form method=GET action="file-move-2">
<input type="hidden" name="file_id" value="@file_id@">

<include src="/packages/file-storage/www/folder-list" file_id="@file_id;literal@" base_url="file-move-2">
<p>
<input type="submit" value="#dotlrn-homework.Move#">
</form>

