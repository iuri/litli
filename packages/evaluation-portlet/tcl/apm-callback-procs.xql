<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/evaluation-portlet/tcl/apm-callback-procs.xql -->
<!-- @author Emmanuelle Raffenne (eraffenne@dia.uned.es) -->
<!-- @creation-date 2007-03-27 -->
<!-- @arch-tag: cd15bed5-6d3e-43b6-80b7-c444bcf535df -->
<!-- @cvs-id $Id: apm-callback-procs.xql,v 1.2 2007/05/15 20:14:34 donb Exp $ -->

<queryset>
  <fullquery name="evaluation_portlet::after_upgrade.update_portal_datasources">
    <querytext>
      update portal_datasources
      set css_dir = '/resources/evaluation'
      where name like 'evaluation%'
    </querytext>
  </fullquery>
</queryset>