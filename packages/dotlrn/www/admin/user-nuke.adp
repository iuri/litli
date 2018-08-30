<master src="dotlrn-admin-master">
<property name="doc(title)">#dotlrn.lt_Nuke_first_names_last#</property>
<property name="context_bar">@context_bar;literal@</property>

<h3>#dotlrn.Confirmation#</h3>

<p>

#dotlrn.lt_Please_confirm_that_y#

</p>

<p>

#dotlrn.Last_Visit# <strong><if @last_visit@ eq "">#dotlrn.Never_visited#</if><else>@pretty_last_visit@</else></strong><br>
#dotlrn.Number_of_db_objects#: <strong>@n_objects@</strong>

</p>

<formtemplate id="confirm_delete"></formtemplate>