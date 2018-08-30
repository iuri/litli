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
<property name="&doc">doc</property>
<property name="context">@context;literal@</property>

<ul>
  <li>#dotlrn.Header_Icon_Alt_Text#: @header_alt_text@
</ul>


<p>
      #dotlrn.lt_this_is_what_the_header#
      <img src="@header_url@" alt="@header_alt_text@">
</p>

    <formtemplate id="header_form"></formtemplate>
