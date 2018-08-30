<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="dotlrn_community::get_community_id_not_cached.select_community">
        <querytext>
            select community_id
            from dotlrn_communities_all
            where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::new_type.create_community_type">
        <querytext>
                select dotlrn_community_type__new(
                    :community_type_key,
                    :parent_type,
                    :pretty_name,
                    :pretty_name,
                    :description
                );
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::delete_type.delete_community_type">
        <querytext>
                select dotlrn_community_type__delete(
                    :community_type_key
                );
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::new.create_community">
        <querytext>
                select dotlrn_community__new(
                    :community_type,
                    :name
                    :pretty_name,
                    :pretty_name,
                    :description
                );
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_active_dates.set_active_dates">
        <querytext>
                select dotlrn_community__set_active_dates(
                    :community_id,
                    to_date(:start_date, :date_format),
                    to_date(:end_date, :date_format)
                );
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_url.select_node_url">
        <querytext>
            select site_node__url(node_id)
            from site_nodes
            where parent_id = :current_node_id
            and object_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_type_from_community_id.select_community_type">
        <querytext>
            select community_type
            from dotlrn_communities
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_toplevel_community_type_from_community_id.select_community_type">
        <querytext>
            select dotlrn_community_types.community_type
            from dotlrn_community_types
            where dotlrn_community_types.tree_sortkey = (select tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)
                                                         from dotlrn_communities
                                                         where dotlrn_communities.community_id = :community_id)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_toplevel_community_type.select_community_type">
        <querytext>
            select dotlrn_community_types.community_type
            from dotlrn_community_types
            where dotlrn_community_types.tree_sortkey = (select tree_ancestor_key(dct.tree_sortkey, 1)
                                                         from dotlrn_community_types dct
                                                         where dct.community_type = :community_type)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_subcomm_info_list.select_subcomms_info">
        <querytext>
            select community_id, 
                   community_key, 
                   pretty_name,   
                   archived_p,
                   dotlrn_community__url(community_id) as url
            from dotlrn_communities_all 
            where parent_community_id = :community_id 
            and archived_p = 'f'
            order by pretty_name
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::send_member_email.member_email">
        <querytext>
            select from_addr,
	           subject,
                   email
            from dotlrn_member_emails
            where (enabled_p or :override_enabled_p = 1)
	          and community_id = :community_id
	          and type = :type
		</querytext>
	</fullquery>

</queryset>
