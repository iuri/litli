<master>
<property name="context">@context;literal@</property>
<property name="doc(title)">@title;literal@</property>

<if @halt_p@ not nil and @unapproved:rowcount@ gt 0>
  <h3>#news.Error#</h3>
  #news.The_action# <span style="color:red">@action@</span> #news.lt_cannot_be_applied_to_#
  <ul> 
    <multiple name=unapproved>
     <li><strong>@unapproved.publish_title@</strong> - @unapproved.creation_date_pretty@
            contributed by @unapproved.item_creator@
	 [ <a href="item?item_id=@unapproved.item_id@"><strong>#news.manage#</strong></a> ]
    </multiple>
  </ul>
  <br>
  #news.lt_Manage_the_items_indi#
</if>	
<else>
  <strong>#news.lt_Do_you_really_want_to# <span style="color:red">@action_pretty@</span><br> #news.lt_on_the_following_news#</strong>

  <listtemplate name="news_items"></listtemplate>

  <form method=post action=process-2>	
    @hidden_vars;noquote@
    <div><input type="submit" value="#news.Yes#"></div>
  </form>
</else>
