ad_page_contract {
   
    @param element_id
    @param pretty_name

    @author Rodrigo Proenca (roop@terra.com.br)
    
} {
    element_id:notnull,naturalnum
    pretty_name:optional,trim,html
} 


dotlrn::require_user_admin_community \
    -user_id [ad_conn user_id] \
    -community_id [dotlrn_community::get_community_id]


template::form create element_rename

if {[template::form is_valid element_rename]} {
       ns_log notice "-element_id $element_id  -pretty_name $pretty_name"
       portal::set_pretty_name -element_id $element_id  -pretty_name $pretty_name
       ad_returnredirect "element-list"
}


template::element create element_rename element_id -widget hidden \
	                                          -datatype integer \
	                                          -value $element_id
 
    db_0or1row element_select {
    select portal_element_map.element_id,
           portal_element_map.pretty_name
    from   portal_element_map
    where  portal_element_map.element_id = :element_id
	
    }
    
    template::element create element_rename pretty_name -label "Name" \
                                                -widget text \
	                                        -datatype text \
	                                        -value $pretty_name \
                                                -html { size 30 }





# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
