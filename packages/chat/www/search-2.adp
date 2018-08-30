<master>
<property name="doc(title)">#chat.Add_user_to_room#</property>
<property name="context">@context;literal@</property>

<p>
  <if @search_type@ eq "keyword">
   #dotlrn.lt_The_results_of_your_s#<BR> 
   (#chat.What_search# @SQL_LIMIT@)
  </if>
  <else>
    <if @search_type@ eq "email">
      for email "@email@"
    </if>
   <else>
     for last name "@last_name@"
   </else>
  </else>
</p>

<ul>
<multiple name="user_search">
  <li>
    <a href="@user_search.url@">
       @user_search.first_names@ @user_search.last_name@ (@user_search.email@)
    </a>
  </li>
</multiple>

<if @user_search:rowcount@ eq 0>
  <li>No users found.</li>
</if>

</ul>

