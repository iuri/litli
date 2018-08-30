<master>
<property name="context">@context;literal@</property>
<property name="doc(title)">#faq.FAQs#</property>

<h1>#faq.FAQs#</h1>

<p><include src="/packages/notifications/lib/notification-widget" type="all_faq_qa_notif"
	 object_id="@package_id;literal@"
	 pretty_name="FAQs">

<if @admin_p;literal@ true>
  <p><a href="./admin" class="button" title="#faq.administer#">#faq.administer#</a></p>
</if>

<if @faqs:rowcount@ eq 0>
 <p><em>#faq.lt_no_FAQs#</em></p>
</if>
<else>
 <ul>
  <multiple name=faqs>
   <li><a href="one-faq?faq_id=@faqs.faq_id@" title="#faq.View# @faqs.faq_name@">@faqs.faq_name@</a>
   </li>
  </multiple>
 </ul>
</else>





