<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="focus">new_quest_answ.question</property>

<formtemplate id="new_quest_answ"></formtemplate>
<if @use_categories_p@ and @category_container@ eq "package_id">
    <a href="@category_map_url@" class="action_link">#categories.Site_wide_categories#</a>
</if>
