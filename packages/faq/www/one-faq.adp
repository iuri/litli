<master>
<property name="context">@context;literal@</property>
<property name="doc(title)">@faq_info.faq_name;literal@</property>
<property name="displayed_object_id">@faq_id;literal@</property>

<h1>@faq_info.faq_name@</h1>

<p><include src="/packages/notifications/lib/notification-widget" type="one_faq_qa_notif"
	 object_id="@faq_id;literal@"
	 pretty_name="@faq_info.faq_name@"
	 url="@return_url;literal@" >
	 
<table width="70%" border="0">
<tr><td align="left" valign="top">
<if @one_question:rowcount@ eq 0>
  <em>#faq.lt_no_questions#</em>
</if>
<else>
  <ol>
<multiple name="one_question">
<if @faq_info.separate_p;literal@ true>
    <li>
      <a href="one-question?entry_id=@one_question.entry_id@" title="#faq.View_QA#">@one_question.question;noquote@</a>
    </li>
</if>
<if @faq_info.separate_p;literal@ false>
    <li>
      <a href="#@one_question.entry_id@" title="#faq.Jump_to_Answer#">@one_question.question;noquote@</a>
<if @use_categories_p;literal@ true>
      <a href="categories/categorize?object_id=@one_question.entry_id@&amp;faq_id=@faq_id@" title="#faq.Categorize_Q#">Categorize</a>
</if>
    </li>
</if>
</multiple>
  </ol>

<if @faq_info.separate_p;literal@ false>
  <hr>
  <ol>
<multiple name="one_question">
    <li>
      <a name="@one_question.entry_id@" title="#faq.View_QA#"></a>
      <p>
      <strong>#faq.Q#</strong> <em>@one_question.question;noquote@</em>
      </p>
      <p>
      <strong>#faq.A#</strong> @one_question.answer;noquote@
      </p>
    </li>
</multiple>
  </ol>
</if>
</else>
</td><td align="right" valign="top">
<if @use_categories_p;literal@ true>
  <multiple name="categories">
           <h2>@categories.tree_name@</h2>
           <group column="tree_id">
             <a href="@package_url@cat@categories.category_id@?faq_id=@faq_id@&amp;category_id=@categories.category_id@" title="#faq.View_in_Category# @categories.category_name@">@categories.category_name@</a><br>
           </group>
  </multiple>
<br><a href="@package_url@one-faq?faq_id=@faq_id@" title="#faq.All_QA#">#faq.All_QA#</a>
</if>
</td></tr>
</table>

<if @gc_comments@ not nil>
  <p>#faq.lt_Comments_on_this_faq#
    <ul>
      @gc_comments;noquote@
    </ul>
  </p>
</if>
<if @gc_link@ not nil>
  <p>@gc_link;noquote@</p>
</if>
