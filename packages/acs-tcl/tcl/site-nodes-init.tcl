ad_library {

  @author rhs@mit.edu
  @creation-date 2000-09-07
  @cvs-id $Id: site-nodes-init.tcl,v 1.5.10.1 2015/09/10 08:21:59 gustafn Exp $

}

nsv_set site_nodes_mutex mutex [ns_mutex create oacs:site_nodes]

site_node::init_cache

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
