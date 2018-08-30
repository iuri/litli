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


<ul>
  <li><a href="file-storage/admin/upload-size-limit?<%=[export_vars -url {return_url}]%>" title="#fs-portlet.edit_upload_size_limit#">#fs-portlet.edit_upload_size_limit#</a>
  <if @show_fs_url_p;literal@ true><li><a href="@fs_url@" title="#fs-portlet.edit_fs_parameters#">#fs-portlet.edit_fs_parameters#</a></li></if>
</ul>
