ad_library {

    dotLRN Homework Applet Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date 2003-06-10
    @author Don Baccus <dhogaza@pacifier.com>
    @cvs-id $Id: apm-callback-procs.tcl,v 1.5.14.1 2015/09/11 11:40:57 gustafn Exp $
}

namespace eval dotlrn_homework::apm_callbacks {}

ad_proc -private dotlrn_homework::apm_callbacks::package_install {} {

    Define dotLRN Homework applet, portlet and notifications.

    @author Don Baccus (dhogaza@pacifier.com)

} {
    db_transaction {


	# Define homework_correction relation
	db_dml create_relation {
	    insert into cr_type_relations 
	    (content_type,target_type,relation_tag) 
	    values ('file_storage_object','file_storage_object','homework_correction')
	}

        # Define notifications for homework and correction file uploads

        set impl_id \
            [acs_sc::impl::new_from_spec -spec {
                name homework_file_upload
                contract_name NotificationType
                owner dotlrn-homework
                aliases {
                    GetURL dotlrn_homework::notification::get_url
                    ProcessReply dotlrn_homework::notification::process_reply
                }
            }]

        set type_id [notification::type::new \
                     -sc_impl_id $impl_id \
                     -short_name homework_upload \
                     -pretty_name Homework \
                     -description "Notification of Homework File Upload"]

        notification::type::interval_enable \
            -type_id $type_id \
            -interval_id [notification::interval::get_id_from_name -name instant]

        notification::type::delivery_method_enable \
            -type_id $type_id \
            -delivery_method_id [notification::delivery::get_id -short_name email]

        set impl_id \
            [acs_sc::impl::new_from_spec -spec {
                name correction_file_upload
                contract_name NotificationType
                owner dotlrn-homework
                aliases {
                    GetURL dotlrn_homework::notification::get_url
                    ProcessReply dotlrn_homework::notification::process_reply
                }
            }]

        set type_id [notification::type::new \
                     -sc_impl_id $impl_id \
                     -short_name correction_upload \
                     -pretty_name "Comment File" \
                     -description "Notification of Comment File Upload"]

        notification::type::interval_enable \
            -type_id $type_id \
            -interval_id [notification::interval::get_id_from_name -name instant]

        notification::type::delivery_method_enable \
            -type_id $type_id \
            -delivery_method_id [notification::delivery::get_id -short_name email]

        # Define the dotLRN Homework Applet

        acs_sc::impl::new_from_spec -spec {
            name dotlrn_homework_applet
            contract_name dotlrn_applet
            owner dotlrn_homework
            aliases {
                GetPrettyName dotlrn_homework_applet::get_pretty_name
                AddApplet dotlrn_homework_applet::add_applet
                RemoveApplet dotlrn_homework_applet::remove_applet
                AddAppletToCommunity dotlrn_homework_applet::add_applet_to_community
                RemoveAppletFromCommunity dotlrn_homework_applet::remove_applet_from_community
                AddUser dotlrn_homework_applet::add_user
                RemoveUser dotlrn_homework_applet::remove_user
                AddUserToCommunity dotlrn_homework_applet::add_user_to_community
                RemoveUserFromCommunity dotlrn_homework_applet::remove_user_from_community
                AddPortlet dotlrn_homework_applet::add_portlet
                RemovePortlet dotlrn_homework_applet::remove_portlet
                ChangeEventHandler dotlrn_homework_applet::change_event_handler
                Clone dotlrn_homework_applet::clone
            }
        }

        # Define the user portlet

        portal::datasource::new_from_spec -spec {
            name dotlrn_homework_portlet
            description "Homework Portlet"
            owner dotlrn_homework
            params {
                shadeable_p:config_required,configured t
                shaded_p:config_required,configured f
                hideable_p:config_required,configured t
                user_editable_p:config_required,configured f
                link_hideable_p:config_required,configured t
                folder_id:config_required {}
                package_id:config_required {}
             }
             aliases {
                 GetMyName dotlrn_homework_portlet::get_my_name
                 GetPrettyName dotlrn_homework_portlet::get_pretty_name
                 Link dotlrn_homework_portlet::link
                 AddSelfToPage dotlrn_homework_portlet::add_self_to_page
                 Show dotlrn_homework_portlet::show
                 Edit dotlrn_homework_portlet::edit
                 RemoveSelfFromPage dotlrn_homework_portlet::remove_self_from_page
            }
        }

        # Define the admin portlet

        portal::datasource::new_from_spec -spec {
            name dotlrn_homework_admin_portlet
            description "Homework Administration Portlet"
            owner dotlrn_homework
            params {
                shadeable_p:config_required,configured t
                shaded_p:config_required,configured f
                hideable_p:config_required,configured t
                user_editable_p:config_required,configured f
                link_hideable_p:config_required,configured t
                folder_id:config_required {}
                package_id:config_required {}
             }
             aliases {
                 GetMyName dotlrn_homework_admin_portlet::get_my_name
                 GetPrettyName dotlrn_homework_admin_portlet::get_pretty_name
                 Link dotlrn_homework_admin_portlet::link
                 AddSelfToPage dotlrn_homework_admin_portlet::add_self_to_page
                 Show dotlrn_homework_admin_portlet::show
                 Edit dotlrn_homework_admin_portlet::edit
                 RemoveSelfFromPage dotlrn_homework_admin_portlet::remove_self_from_page
            }
        }
    }
}

ad_proc -private dotlrn_homework::apm_callbacks::package_uninstall {} {

    Delete dotLRN stuff defined in package_install above

    @author Don Baccus (dhogaza@pacifier.com)

} {
    db_transaction {
        notification::type::delete -short_name homework_upload
        acs_sc::impl::delete -contract_name NotificationType -impl_name homework_file_upload
        notification::type::delete -short_name correction_upload
        acs_sc::impl::delete -contract_name NotificationType -impl_name correction_file_upload
        acs_sc::impl::delete -contract_name dotlrn_applet -impl_name dotlrn_homework_applet
        portal::datasource::delete -name dotlrn_homework_portlet
        portal::datasource::delete -name dotlrn_homework_admin_portlet

	db_dml delete_relation { 
	      delete from cr_type_relations 
	      where content_type = 'file-storage-object' and
	      target_type = 'file-storage-object' and
	     relation_tag = 'homework_correction'
	}

    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
