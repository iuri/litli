
ad_page_contract {

    Displays a configuration page for COMMUNITY'S portal elements ONLY!
    This page is restricted to admins of the community.

    @author Rodrigo Proenca (roop@terra.com.br)
   
} -query {
    {referer "one-community-admin"}
}

dotlrn::require_user_admin_community \
    -user_id [ad_conn user_id] \
    -community_id [dotlrn_community::get_community_id]

set id_portal [dotlrn_community::get_portal_id]

template::list::create -name portal_elements -multirow portal_elements -elements {
    id {
        label "\#dotlrn.ID\#"
	display_template {
	    <a href=element-rename?element_id=@portal_elements.element_id@>@portal_elements.element_id@</a>
	}
    }
    name {
        label "\#dotlrn.Type\#"
    }
    pretty_name {
        label "\#dotlrn.Name\#"
    }
    sort_key {
        label "\#dotlrn.Page\#"
    }
}

db_multirow portal_elements itens {

select portal_element_map.element_id,
       portal_element_map.name,
       portal_element_map.pretty_name,
       portal_element_map.page_id,
       portal_element_map.state,  
       portal_pages.sort_key               
from   portal_element_map,
       portal_pages
       where portal_element_map.page_id = portal_pages.page_id
and    portal_pages.portal_id = :id_portal
order by portal_pages.sort_key



}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
