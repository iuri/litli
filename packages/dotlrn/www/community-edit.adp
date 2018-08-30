<%

  # Copyright (C) 2001, 2002 MIT
  # 
  # This file is part of dotLRN.
  # 
  # dotLRN is free software; you can redistribute it and/or modify it under the
  # terms of the GNU General Public License as published by the Free Software
  # Foundation; either version 2 of the License, or (at your option) any later
  # version.
  # 
  # dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
  # WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  # FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  # details.

%>

<master>
<property name="&doc">doc</property>
<property name="context">@context;literal@</property>

<h1>#dotlrn.Community_info#</h1>
  <formtemplate id="edit_community_info"></formtemplate>

<h1>#dotlrn.Roles#</h1>
  <formtemplate id="edit_community_role_names"></formtemplate>

<!-- AKS: bypass form manager for the last form. But fake 
     the look and feel of it   -->

<h1>#dotlrn.header_logo#</h1>

    <form enctype="multipart/form-data" method="POST" action="community-edit-2" class="margin-form">

      <div class="form-item-wrapper">
        <label for="header_img">
          <span class="form-label">#dotlrn.header_logo_file#</span>
          <span class="form-widget">
            <input type="file" id="header_img" name="header_img" size="20">
          </span>
        </label>
      </div>

      <div class="form-item-wrapper">
        <label for="header_alt_text">
          <span class="form-label">#dotlrn.Header_Alternate_Text#</span>
          <span class="form-widget">
            <input type="text" id="header_alt_text" name="header_alt_text" value="@header_alt_text@" size="50">
          </span>
        </label>
      </div>

      <div class="form-item-wrapper">
        <span class="form-button">
          <input type="submit" name="preview_button" value="#dotlrn.Preview#">
        </span>
      </div>
    </form>
    
    <p>
      <a href="community-edit-revert.tcl?header_logo_only=1" class="button">
        #dotlrn.lt_Revert_ONLY_the_Heade#
      </a>
    </p>
