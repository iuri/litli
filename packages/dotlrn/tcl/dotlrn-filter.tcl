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

ad_library {

    Procs for basic dotLRN filters

    @author ben@openforce.net
    @creation-date 2001-08-20

}

ad_proc -private dotlrn_filter {conn arg why} {
    A filter for dotLRN
} {
    ns_log Notice "dotLRN filter activated!!! Data as follows:
package_id: [ad_conn package_id]
url: [ad_conn url]
node_id: [ad_conn node_id]
package_key: [ad_conn package_key]
path_info: [ad_conn path_info]
"

return filter_ok
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
