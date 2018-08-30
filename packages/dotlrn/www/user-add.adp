<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<master>
<property name="doc(title)">#dotlrn.Add_A_User#</property>
<property name="context">@context;literal@</property>
<property name="focus">register.email</property>

<h1>#dotlrn.lt_Add_a_new_user_to_Slo#</h1>
<if @community_p;literal@ true>
<p>
 #dotlrn.lt_Note_use_this_feature#
</p>
<ol>
	<li>#dotlrn.lt_If_this_person_is_a_M#
	<li>#dotlrn.lt_Be_sure_that_the_pers#

<if @read_private_data_p;literal@ true>
	<li>#dotlrn.lt_Use_this_only_for_an_#

</if>
<else>
      <li>#dotlrn.lt_This_allows_you_to_gi#
      </li>
<ul>        
<li>#dotlrn.lt_Information_about_oth#
<li>#dotlrn.lt_If_you_wish_to_give_g#
</else>      
</ul>
</ol>
</if>

<include src="/packages/acs-subsite/lib/user-new" next_url="@next_url;literal@" self_register_p="0">
