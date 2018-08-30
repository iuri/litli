ad_library {

    Xinha integration with the richtext widget of acs-templating.

    This script defines the following two procs:

       ::richtext-xinha::initialize_widget
       ::richtext-xinha::render_widgets    
    
    @author Gustaf Neumann
    @creation-date 1 Jan 2016
    @cvs-id $Id: richtext-procs.tcl,v 1.1.2.6 2016/11/15 10:44:15 gustafn Exp $
}

namespace eval ::richtext::xinha {
    
    ad_proc initialize_widget {
        -form_id
        -text_id
        {-options {}}
    } {
        
        Initialize an Xinha richtext editor widget.
        This proc defines finally the global variables

        ::acs_blank_master(xinha.options)
        ::acs_blank_master(xinha.plugins)
        
    } {
        ns_log debug "initialize XINHA instance with <$options>"

        # The richtext widget might be specified by "options {editor
        # xinha}" or via the package parameter "RichTextEditor" of
        # acs-templating.
        #
        # The following options can be specified in the widget spec of
        # the richtext widget:
        #
        #      editor plugins width height folder_id fs_package_id
        #
        if {[dict exists $options plugins]} {
            set plugins [dict get $options plugins]
        } else {
            set plugins [parameter::get \
                             -package_id [apm_package_id_from_key "richtext-xinha"] \
                             -parameter "XinhaDefaultPlugins" \
                             -default ""]
            set pluginsLegacy [parameter::get \
                                   -package_id [apm_package_id_from_key "acs-templating"] \
                                   -parameter "XinhaDefaultPlugins" \
                                   -default ""]
            
            if {$pluginsLegacy ne ""} {
                if {$plugins eq ""} {
                    #
                    # We have no per-package config, but got a legacy
                    # config.
                    #
                    set plugins $pluginsLegacy
                    ns_log warning "richtext-xinha uses legacy parameters from acs-templating;\
                    	XinhaDefaultPlugins should be set in the package parameters of richtext-xinha, not in acs-templating."
                } else {
                    #
                    # Config for this package and legacy config in
                    # acs-templating is set, ignore config from
                    # acs-templating.
                    #
                    ns_log warning "richtext-xinha ignores legacy parameters from acs-templating;\
                    	XinhaDefaultPlugins should be set in the package parameters of richtext-xinha, not in acs-templating;\
			when done, empty parameter setting for XinhaDefaultPlugins in acs-templating."
                }
            }
        }

        set quoted [list]
        foreach e $plugins {lappend quoted '$e'}
        set ::acs_blank_master(xinha.plugins) [join $quoted ", "]
        
        set xinha_options ""
        foreach e {width height folder_id fs_package_id script_dir file_types attach_parent_id wiki_p} {
            if {[dict exists $options $e]} {
                append xinha_options "xinha_config.$e = '[dict get $options $e]';\n"
            }
        }
        #
        # Pass as well the actual package_id to xinha (for e.g. plugins)
        #
        append xinha_options "xinha_config.package_id = '[ad_conn package_id]';\n"

        # DAVEB find out if there is a key datatype in the form
        if {[info exists ::af_key_name($form_id)]} {
            set key [template::element get_value $form_id $::af_key_name($form_id)]
            append xinha_options "xinha_config.key = '$key';\n"
        }
        
        if {[dict exists $options javascript]} {
            append xinha_options [dict get $options javascript] \n
        }

        #ns_log notice "final ::acs_blank_master(xinha.options):\n$xinha_options"
        set ::acs_blank_master(xinha.options) $xinha_options

        #
        # add required directives for content security policies
        #
        security::csp::require script-src 'unsafe-eval'
        security::csp::require script-src 'unsafe-inline'

        
        return ""
    }


    ad_proc render_widgets {} {

        Render the xinha rich-text widgets. This function is created
        at a time when all rich-text widgets of this page are already
        initialized. The function is controlled via the global variables

           ::acs_blank_master(xinha)
           ::acs_blank_master(xinha.options)
           ::acs_blank_master(xinha.plugins)
           ::acs_blank_master(xinha.params)
           ::acs_blank_master__htmlareas
        
    } {
        #
        # In case no xinha instances are created, or we are on a
        # mobile browser, which is not supported via xinha, nothing
        # has to be done (i.e. the plain text area will be shown)
        #
        if {![info exists ::acs_blank_master(xinha)] || [ad_conn mobile_p]} {
            return
        }
        set ::xinha_dir /resources/richtext-xinha/xinha-nightly/
        set ::xinha_lang [lang::conn::language]
        #
        # Xinha localization covers 33 languages, removing
        # the following restriction should be fine.
        #
        #if {$::xinha_lang ne "en" && $::xinha_lang ne "de"} {
        #  set ::xinha_lang en
        #}

        # We could add site wide Xinha configurations (.js code) into xinha_params
        set xinha_params ""
        if {[info exists ::acs_blank_master(xinha.params)]} {
            set xinha_params $::acs_blank_master(xinha.params)
        }

        # Per call configuration
        set xinha_plugins $::acs_blank_master(xinha.plugins)
        set xinha_options $::acs_blank_master(xinha.options)

        # HTML ids of the textareas used for Xinha
        set htmlarea_ids '[join $::acs_blank_master__htmlareas "','"]'
        
        template::head::add_script -type text/javascript -script "
         xinha_editors = null;
         xinha_init = null;
         xinha_config = null;
         xinha_plugins = null;
         xinha_init = xinha_init ? xinha_init : function() {
            xinha_plugins = xinha_plugins ? xinha_plugins : 
              \[$xinha_plugins\];

            // THIS BIT OF JAVASCRIPT LOADS THE PLUGINS, NO TOUCHING  
            if(!Xinha.loadPlugins(xinha_plugins, xinha_init)) return;

            xinha_editors = xinha_editors ? xinha_editors :\[ $htmlarea_ids \];
            xinha_config = xinha_config ? xinha_config() : new Xinha.Config();
            $xinha_params
            $xinha_options
            xinha_editors = 
                 Xinha.makeEditors(xinha_editors, xinha_config, xinha_plugins);
            Xinha.startEditors(xinha_editors);
         }
         //window.onload = xinha_init;
      "
        template::add_body_script -src ${::xinha_dir}XinhaCore.js
        template::add_body_script -script "xinha_init();"
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
