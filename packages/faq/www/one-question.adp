<master>
<property name="context">@context;literal@</property>
<property name="doc(title)">#faq.One_Question#</property>
<property name="displayed_object_id">@entry_id;literal@</property>

<h1>@faq_name;noquote@</h1>

<p>
<strong>#faq.Q#</strong> @question;noquote@
</p>
<p>
<strong>#faq.A#</strong> @answer;noquote@
</p>

<p>
<a href="one-faq?faq_id=@faq_id@" title="#faq.Back_to_current_FAQ# @faq_name;noquote@">#faq.Back_to_current_FAQ# @faq_name;noquote@</a>
<br>
<a href="index" title="#faq.Back_to_FAQs#">#faq.Back_to_FAQs#</a>
</p>

