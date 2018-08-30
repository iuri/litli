<?xml version="1.0"?>

<queryset>

    <fullquery name="dotlrn_community::membership_approve.select_rel_info">
        <querytext>
            select *
            from dotlrn_member_rels_full
            where user_id = :user_id
            and community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::membership_reject.select_rel_info">
        <querytext>
            select *
            from dotlrn_member_rels_full
            where user_id = :user_id
            and community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_type_package_id.update_package_id">
        <querytext>
            update dotlrn_community_types set package_id= :package_id where community_type= :community_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_package_id.update_package_id">
        <querytext>
            update dotlrn_communities_all set package_id= :package_id where community_id= :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_package_id.update_application_group_package_id">
        <querytext>
            update application_groups set package_id= :package_id where group_id= :community_id
        </querytext>
    </fullquery>
    
    <fullquery name="dotlrn_community::get_parent_id_not_cached.select_parent_id">
        <querytext>
            select dotlrn_communities.parent_community_id
            from dotlrn_communities
            where dotlrn_communities.community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::generate_key.existing_community_keys">
        <querytext>
            select community_key 
            from   dotlrn_communities_all
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::check_community_key_valid_p.collision_check_with_parent">
        <querytext>
            select count(*)
            from dotlrn_communities_all
            where :parent_community_id in (select dc.parent_community_id
                                           from dotlrn_communities_all dc
                                           where dc.community_key = :community_key)
        </querytext>
    </fullquery>


    <fullquery name="dotlrn_community::check_community_key_valid_p.collision_check_simple">
        <querytext>
            select count(*) from dotlrn_communities_all where community_key = :community_key
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_type_node_id.select_node_id">
        <querytext>
            select node_id
            from site_nodes
            where object_id = (select package_id
                               from dotlrn_community_types
                               where community_type = :community_type)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_node_id.select_node_id">
        <querytext>
            select node_id
            from site_nodes
            where object_id = (select package_id
                               from dotlrn_communities
                               where community_id = :community_id)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::new.update_portal_ids">
        <querytext>
            update dotlrn_communities_all
            set portal_id = :portal_id,
                non_member_portal_id = :non_member_portal_id,
                admin_portal_id = :admin_portal_id
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_default_roles_not_cached.select_role_data">
        <querytext>
            select acs_rel_types.rel_type,
                   acs_rel_roles.role,
                   acs_rel_roles.pretty_name,
                   acs_rel_roles.pretty_plural
            from acs_rel_types,
                 acs_rel_roles
            where acs_rel_types.object_type_one = :community_type
            and acs_rel_types.role_two = acs_rel_roles.role
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_all_roles_not_cached.select_all_roles">
        <querytext>
            select acs_rel_types.rel_type,
                   acs_rel_roles.role,
                   acs_rel_roles.pretty_name,
                   acs_rel_roles.pretty_plural
            from acs_rel_types,
                 acs_rel_roles
            where acs_rel_types.object_type_one in (select dotlrn_community_types.community_type
                                                    from dotlrn_community_types
                                                    where dotlrn_community_types.supertype is null
                                                    or dotlrn_community_types.supertype = 'dotlrn_community')
            and acs_rel_types.role_two = acs_rel_roles.role
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_rel_segment_id.select_rel_segment_id">
        <querytext>
            select segment_id
            from rel_segments
            where group_id = :community_id
            and rel_type= :rel_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_users_not_cached.select_users">
        <querytext>
            select dotlrn_member_rels_approved.rel_id,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   dotlrn_member_rels_approved.user_id,
                   acs_users_all.first_names,
                   acs_users_all.last_name,
                   acs_users_all.email,
                   (select count(*) from acs_rels where rel_type = 'user_portrait_rel' and object_id_one = dotlrn_member_rels_approved.user_id) as portrait_p,
                   (select count(*) from acs_attribute_values where object_id = dotlrn_member_rels_approved.user_id and attribute_id = 
:bio_attribute_id and attr_value is not null) as bio_p
            from acs_users_all,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
            order by dotlrn_member_rels_approved.rel_type, acs_users_all.last_name
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_possible_subcomm_users.select_possible_users">
        <querytext>
            select dotlrn_member_rels_approved.rel_id,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   dotlrn_member_rels_approved.user_id,
                   acs_users_all.first_names,
                   acs_users_all.last_name,
                   acs_users_all.email
            from acs_users_all,
                 dotlrn_member_rels_approved, 
                 dotlrn_communities
            where dotlrn_communities.community_id = :subcomm_id
            and dotlrn_communities.parent_community_id = dotlrn_member_rels_approved.community_id
            and acs_users_all.user_id = dotlrn_member_rels_approved.user_id
            and acs_users_all.user_id not in (select dm.user_id
                                                 from dotlrn_member_rels_full dm
                                                 where dm.community_id = :subcomm_id)
            order by last_name
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_users_in_role.select_users_in_role">
        <querytext>
            select dotlrn_member_rels_approved.rel_id,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   dotlrn_member_rels_approved.user_id,
                   acs_users_all.first_names,
                   acs_users_all.last_name,
                   acs_users_all.email
            from acs_users_all,
                dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
            and dotlrn_member_rels_approved.rel_type = :rel_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::member_p.select_count_membership">
        <querytext>
            select count(*)
            from dual
            where exists (select 1
                          from dotlrn_member_rels_approved
                          where community_id = :community_id
                          and user_id = :user_id)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::member_pending_p.is_pending_membership">
        <querytext>
            select count(*)
            from dual
            where exists (select 1
                          from dotlrn_member_rels_full
                          where community_id = :community_id
                          and user_id = :user_id
                          and member_state = 'needs approval')
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::remove_user.select_rel_info">
        <querytext>
            select rel_id, rel_type
            from dotlrn_member_rels_full
            where community_id = :community_id
            and user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_all_communities_by_user.select_communities_by_user">
        <querytext>
            select dotlrn_communities_full.*
            from dotlrn_communities_full,
                 dotlrn_member_rels_approved
            where dotlrn_communities_full.community_id = dotlrn_member_rels_approved.community_id
            and dotlrn_member_rels_approved.user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_communities_by_user.select_communities">
        <querytext>
            select dotlrn_communities.*
            from dotlrn_communities,
                 dotlrn_member_rels_full
            where dotlrn_communities.community_type = :community_type
            and dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_communities.community_id = dotlrn_member_rels_full.community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_all_communities.select_all_communities">
        <querytext>
            select dotlrn_communities.*
            from dotlrn_communities
            where community_type = :community_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_type_not_cached.select_community_type">
        <querytext>
            select community_type
            from dotlrn_community_types
            where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_type_from_community_id_not_cached.select_community_type">
        <querytext>
            select community_type
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::has_subcommunity_p_not_cached.select_subcomm_check">
        <querytext>
            select 1
            from dual
            where exists (select 1
                          from dotlrn_communities
                          where parent_community_id = :community_id)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_subcomm_list.select_subcomms">
        <querytext>
            select community_id as subcomm_id
            from dotlrn_communities
            where parent_community_id = :community_id
	    order by pretty_name 
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_type_package_id.select_package_id">
        <querytext>
            select package_id
            from dotlrn_community_types
            where community_type = :community_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_package_id_not_cached.select_package_id">
        <querytext>
            select package_id
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_applet_package_id.select_package_id">
        <querytext>
            select dotlrn_community_applets.package_id
            from dotlrn_community_applets,
                 dotlrn_applets
            where dotlrn_community_applets.community_id = :community_id
            and dotlrn_community_applets.applet_id = dotlrn_applets.applet_id
            and dotlrn_applets.applet_key = :applet_key
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_type_name.select_community_type_name">
        <querytext>
            select pretty_name
            from dotlrn_community_types
            where community_type = :community_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_community_name.update_community_name">
        <querytext>
            update dotlrn_communities_all
            set pretty_name = :pretty_name
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_name_not_cached.select_community_name">
        <querytext>
            select pretty_name
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_description.select_community_description">
        <querytext>
            select description
            from dotlrn_communities
            where community_id = :community_id
        </querytext>
    </fullquery>
 
    <fullquery name="dotlrn_community::set_community_description.update_community_description">
        <querytext>
            update dotlrn_communities_all
            set description = :description
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_community_key.select_community_key">
        <querytext>
            select community_key
            from dotlrn_communities
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::not_closed_p.check_community_not_closed">
        <querytext>
            select 1
            from dotlrn_communities_not_closed
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::open_p.check_community_open">
        <querytext>
            select 1
            from dotlrn_communities_not_closed
            where community_id = :community_id
            and join_policy = 'open'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::needs_approval_p.check_community_needs_approval">
        <querytext>
            select 1
            from dotlrn_communities_not_closed
            where community_id = :community_id
            and join_policy = 'needs approval'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::remove_applet_from_community.delete_applet_from_community">
        <querytext>
            delete
            from dotlrn_community_applets 
            where community_id = :community_id
            and applet_id = :applet_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::clone.update_portal_ids">
        <querytext>
            update dotlrn_communities_all
            set portal_id = :portal_id,
                non_member_portal_id = :non_member_portal_id,
                admin_portal_id = :admin_portal_id
            where community_id = :clone_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::clone.delete_default_acs_attribute_values">
        <querytext>
            delete
            from acs_attribute_values
            where object_id = :clone_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::clone.copy_customizations_if_any">
        <querytext>
            insert into acs_attribute_values
            (object_id,attribute_id,attr_value)
            select :clone_id, attribute_id, attr_value
            from acs_attribute_values where object_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::archive.update_archive_p">
      <querytext>
        update dotlrn_communities_all set archived_p = 't' where community_id = :community_id
      </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::unarchive.update_archive_p">
      <querytext>
        update dotlrn_communities_all set archived_p = 'f' where community_id = :community_id
      </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_portal_id_not_cached.select_portal_id">
        <querytext>
            select portal_id
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_non_member_portal_id_not_cached.select_non_member_portal_id">
        <querytext>
            select non_member_portal_id
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_admin_portal_id_not_cached.select_admin_portal_id">
        <querytext>
            select admin_portal_id
            from dotlrn_communities
            where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::register_applet.insert">
        <querytext>
            insert into dotlrn_community_applets
            (community_id, applet_id, package_id, active_p)
            values
            (:community_id, :applet_id, :package_id, :active_p)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::remove_applet.delete_applet_from_community">
        <querytext>
            delete
            from dotlrn_community_applets 
            where community_id = :community_id
            and applet_id = :applet_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_applets.select_all_applets">
        <querytext>
            select impl_name
            from acs_sc_impls,
                 acs_sc_bindings,
                 acs_sc_contracts
            where acs_sc_impls.impl_id = acs_sc_bindings.impl_id
            and acs_sc_contracts.contract_id = acs_sc_bindings.contract_id
            and acs_sc_contracts.contract_name = 'dotlrn_applet'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_applets.select_community_applets">
        <querytext>
            select dotlrn_applets.applet_key
            from dotlrn_community_applets,
                 dotlrn_applets
            where dotlrn_community_applets.community_id = :community_id
            and dotlrn_community_applets.applet_id = dotlrn_applets.applet_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_active_applets.select_all_active_applets">
        <querytext>
            select applet_key
            from dotlrn_applets
            where active_p = 't'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::list_active_applets.select_community_active_applets">
        <querytext>
            select dotlrn_applets.applet_key
            from dotlrn_community_applets,
                 dotlrn_applets
            where dotlrn_community_applets.community_id = :community_id
            and dotlrn_community_applets.active_p = 't'
            and dotlrn_community_applets.applet_id = dotlrn_applets.applet_id
            and dotlrn_applets.active_p = 't'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::applet_active_p.select_active_applet_p">
        <querytext>
            select 1 
            from dotlrn_community_applets,
                 dotlrn_applets
            where dotlrn_community_applets.community_id = :community_id
            and dotlrn_community_applets.applet_id = dotlrn_applets.applet_id
            and dotlrn_applets.applet_key = :applet_key
            and dotlrn_community_applets.active_p = 't'
            and dotlrn_applets.active_p = 't'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::is_supertype.is_supertype">
        <querytext>
            select count(*)
            from dotlrn_community_types
            where supertype = :community_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_available_attributes_not_cached.select_available_attributes">
        <querytext>
            select attribute_id,
                   attribute_name
            from acs_attributes
            where object_type = 'dotlrn_community'
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_attributes_not_cached.select_attributes">
        <querytext>
            select acs_attributes.attribute_name,
                   acs_attribute_values.attr_value
            from acs_attributes,
                 acs_attribute_values
            where acs_attribute_values.object_id = :community_id
            and acs_attribute_values.attribute_id = acs_attributes.attribute_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_attribute.insert_attribute">
        <querytext>
            insert
            into acs_attribute_values
            (object_id, attribute_id, attr_value)
            values
            (:community_id, :attribute_id, :attribute_value)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_attribute.update_attribute_value">
        <querytext>
            update acs_attribute_values
            set attr_value = :attribute_value
            where attribute_id = :attribute_id
            and object_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::unset_attribute.delete_attribute_value">
        <querytext>
            delete from acs_attribute_values
            where attribute_id = :attribute_id
            and object_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::unset_attributes.delete_attributes">
        <querytext>
            delete from acs_attribute_values
            where object_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::get_type_package_id.select_package_id">
        <querytext>
            select package_id
              from dotlrn_community_types
              where community_type = :community_type
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_site_template_id.update_site_template">
      <querytext>
        update dotlrn_communities_all
        set site_template_id = :site_template_id
        where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::set_site_template_id.select_portal_theme">
      <querytext>
        select portal_theme_id
        from dotlrn_site_templates
        where site_template_id = :site_template_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::assign_default_sitetemplate.select_portal_theme">
      <querytext>
        select portal_theme_id
        from dotlrn_site_templates
        where site_template_id = :site_template_id
        </querytext>
    </fullquery>


   <fullquery name="dotlrn_community::set_site_template_id.update_portal_theme">
      <querytext>
        update portals
        set theme_id = :new_theme_id
        where portal_id = :portal_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::assign_default_sitetemplate.update_portal_themes">
      <querytext>
        update portals
        set theme_id = :new_theme_id
        where portal_id in (select portal_id from dotlrn_communities_all )
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_community::assign_default_sitetemplate.update_portal_admin_themes">
      <querytext>
        update portals
        set theme_id = :new_theme_id
        where portal_id in (select admin_portal_id from dotlrn_communities_all )
        </querytext>
    </fullquery>


    <fullquery name="dotlrn_community::get_site_template_id_not_cached.select_site_template_id">
        <querytext>
            select site_template_id
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

   <fullquery name="dotlrn_community::get_dotlrn_master_not_cached.select_dotlrn_master">
        <querytext>
            select dst.site_master
            from dotlrn_site_templates dst, dotlrn_communities_all dca
            where dca.community_id = :community_id
            and dca.site_template_id = dst.site_template_id
        </querytext>
   </fullquery>

</queryset>
