<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>
<h1>@title;noquote@</h1>
<listtemplate name="faqs"></listtemplate>

<ul class="action-links">
    <li><a href="faq-add-edit" title="#faq.Create_a_new_FAQ#">#faq.Create_a_new_FAQ#</a></li>
    <li><a href="configure?<%=[export_vars -url {return_url}]%>" title="#faq.Configure_FAQ_Preferences#">#faq.Configure#</a></li>
    <if @use_categories_p@ and @category_container@ eq "package_id">
        <li><a href="@category_map_url@" class="action_link" title="#faq.Site_wide_categories#">#faq.Site_wide_categories#</a></li>
    </if>
</ul>
