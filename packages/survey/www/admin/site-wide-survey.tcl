ad_page_contract {
    Shows list of all surveys
    in all mounted survey packages
} {

}

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id 0 -privilege admin

db_multirow surveys get_surveys {
	select s.survey_id, s.name, s.editable_p, s.single_response_p,
       	  s.package_id,
          acs_object.name(apm_package.parent_id(s.package_id)) as parent_name,
      		(select site_node.url(site_nodes.node_id)
	          from site_nodes
	          where site_nodes.object_id = s.package_id) as url
	 from surveys s
	 where enabled_p='t'
	 order by
parent_name,
upper(s.name)
}

ad_return_template