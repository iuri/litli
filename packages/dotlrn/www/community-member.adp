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
<property name="doc(title)">@user.first_names@ @user.last_name@</property>
<property name="context">@context;literal@</property>

<if @portrait_p;literal@ true>
  <div style="float: right;">
    <a href="@portrait_url@" title="#acs-subsite.See_full_size#">
      <img src="@img_src@" alt="#acs-subsite.lt_Portrait_of_first_last#">
    </a>
  </div>
</if>

<div>
<h1>#dotlrn.Personal_info#</h1>

<if @user.member_state@ eq "deleted">
  <p><strong>#dotlrn.this_user_is_deleted#</strong></p>
</if>
<else>
  <if @user.member_state@ eq "banned">
    <p><strong>#dotlrn.lt_this_user_is_deleted_#</strong></p>
  </if>
</else>

  <ul>
    <li>#dotlrn.First_names_# @first_names@</li>
    <li>#dotlrn.Last_name_# @last_name@</li>
    <li>#dotlrn.Email_# @pretty_email;noquote@</li>
    <li>#dotlrn.Registration_date# @pretty_creation_date@</li>

    <if @user.url@ not nil>
      <li>#dotlrn.Personal_home_page# <a href="@user.url@">@user.url@</a></li>
    </if>
  </ul>

<if @user.bio@ not nil>
  <h1>#acs-subsite.Biography#</h1>
  @user.bio;noquote@
</if>

</div>
