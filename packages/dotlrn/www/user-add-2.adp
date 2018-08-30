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
<property name="context_bar">@context_bar;literal@</property>

<h1></h1>

@first_names@ @last_name@ #dotlrn.has_been_added_to# @system_name@.
#dotlrn.edit_message_and_hit_send#

<p>#dotlrn.Add_A_User#</p>

<form method="post" action="user-add-3">
  @export_vars;noquote@
  #dotlrn.Message#

  <p></p>

  <textarea name="message" rows="10" cols="70" wrap="hard">
  #dotlrn.registered_user_welcome_email_body#
  </textarea>

  <p></p>

  <input type="submit" value="#dotlrn.send_email#">
</form>




