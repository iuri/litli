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

<master src="dotlrn-admin-master">
<property name="doc(title)">#dotlrn.Users_Bulk_Upload#</property>
<property name="context_bar">@context_bar;literal@</property>

<p>#dotlrn.lt_Here_you_can_create_s#</p>

<p>
<strong>#dotlrn.Be_sure#</strong> #dotlrn.lt_to_use_vaild_email_ad#
</p>


<div style="font-size: large; font-weight: bold;">#dotlrn.CSV_File_Format#</div>

<div style="text-indent: 1em">
  
  <strong>#dotlrn.First_Line#</strong>

  <p style="text-indent: 2em">
    #dotlrn.first_line_of_file_must_be#
  </p>

    <div style="text-indent: 3em; font-family: monospace">
      first_names,last_name,email,username,password,type,access_level,guest,notify
    </div>

</div>

<p style="text-indent: 1em">
  <strong>#dotlrn.Fields#</strong>
</p>
  
  <ul>
    <li><kbd>first_names</kbd> - <em>#dotlrn.required#</em></li>
    <li><kbd>last_name</kbd> - <em>#dotlrn.required#</em></li>
    <li><kbd>email</kbd> - <em>#dotlrn.required#</em></li>
    <li><kbd>username</kbd> - <em>#dotlrn.optional_defaults_to# email</em></li>
    <li><kbd>password</kbd> - <em>#dotlrn.optional_defaults_to# random value</em></li>
    <li><kbd>type</kbd> - <em>#dotlrn.required#</em> #dotlrn.must_have_values# 
      <ul>
        <li>professor</li>
        <li>student</li>
        <li>admin</li>
        <li>external</li>
      </ul>
    </li>
    <li><kbd>access_level</kbd> - <em>#dotlrn.optional_defaults_to# full</em> - 
        <em>#dotlrn.must_have_values#</em> <kbd>full</kbd>, <kbd>limited</kbd></li>
    <li><kbd>guest</kbd> - <em>#dotlrn.optional_defaults_to# f</em> -
        <em>#dotlrn.must_have_values#</em> <kbd>t</kbd>, <kbd>f</kbd></li>
    <li><kbd>notify</kbd> - <em>#dotlrn.optional_defaults_to# f</em>    
        <em>#dotlrn.must_have_values#</em> <kbd>t</kbd>, <kbd>f</kbd></li>
  </ul>
  

<p style="text-indent: 1em">
  <strong>#dotlrn.Example_File#</strong>
</p>
  
  <pre>
    first_names,last_name,email,username,password,type,access_level,guest,notify
    Joe,Student,joe@_somewhere_.net,joestue,4jfe3,student,full,f,f
    Albert,Einstein,al@_school_.edu,al,emc2,professor,full,f,t
    Systems,Hacker,syshacker@_company_.com,syshack,,admin
    Intersted,Onlooker,onlooker@_somewhere_.net,,,external,limited,t,t
  </pre>
  
<p style="text-indent: 1em">
#dotlrn.lt_Note_you_will_have_th#
</p>

<div style="padding-left: 1em">

  <FORM enctype="multipart/form-data" method=post action="users-bulk-upload-2">
  <INPUT TYPE=file name=users_csv_file>
  <br>
  <br>
  <INPUT TYPE=submit value="#dotlrn.upload#">
  </FORM>
</div>




