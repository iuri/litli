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

<if @config.shaded_p@ ne "t">

  <if @has_subcomm_p;literal@ true>

    <ul>

      <li>@subcomm_pretty_plural@:
  
      <ul>

        @subcomm_data;noquote@
  
      </ul>

	</li>

    </ul>

  </if>
  <else>
    #dotlrn-portlet.lt_No_subcomm_pretty_plu#
  </else>

</if>
<else>
  <small>#new-portal.when_portlet_shaded#</small>
</else>



