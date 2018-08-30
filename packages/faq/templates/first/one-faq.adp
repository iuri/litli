<master src="master">
<property name="context_bar">@context_bar;literal@</property>
<property name="doc(title)">@faq_name;literal@</property>

<if @one_question:rowcount@ eq 0>
 <em>#faq.lt_no_questions#</em><p>
</if>

<else>
<table>
 <tr valign="top">
 <td width="30%">
 <ol>
  <multiple name="one_question">
   <if @separate_p;literal@ true>
   
   <li>
	<a href="one-question?entry_id=@one_question.entry_id@">@one_question.question@</a>

    </li>
	</if>
    <if @separate_p;literal@ false>

   <li>
      <a href="#@one_question.entry_id@">@one_question.question@</a>

    </li>
   </if>
  </multiple>
 </ol>
</td>
<if @separate_p;literal@ false>
<td>
 <ol>
  <multiple name="one_question">
   <li>
    <a name="@one_question.entry_id@"></a>
     <strong>#faq.Q#</strong> @one_question.question@
     <P>
     <strong>#faq.A#</strong> @one_question.answer@
     <p>

   </li>
  </multiple>
 </ol>

</if>
</td>
</tr>
</table>
</else>


