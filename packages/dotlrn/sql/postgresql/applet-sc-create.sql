--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- The DotLRN applet service contract
--
-- ben@openforce.net, arjun@openforce.net
-- ported to PG by Yon and Ben
-- @author dan chak (chak@openforce.net)
--
-- started October 1st, 2001
-- we remember September 11th
-- 

--
-- This is the service contract for dotLRN applets. A dotlrn applet MUST
-- have AT LEAST the procs (with the proper arguments) defined below to work
-- as a dotlrn applet.
--
-- **** SEE THE ORACLE VERSION FOR FULL DESCRIPTIONS ****
--

CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN

    perform acs_sc_contract__new (
        'dotlrn_applet',
        'dotLRN Applet contract'
    );

    -- Get a pretty name
    perform acs_sc_msg_type__new (
        'dotlrn_applet.GetPrettyName.InputType',
        ''
    );

    perform acs_sc_msg_type__new (
        'dotlrn_applet.GetPrettyName.OutputType',
        'pretty_name:string'
    );

    perform acs_sc_operation__new (
        'dotlrn_applet',
        'GetPrettyName',
        'Get the pretty name of the applet',
        't',
        0,
        'dotlrn_applet.GetPrettyName.InputType',
        'dotlrn_applet.GetPrettyName.OutputType'
    );

    -- Add the applet to dotlrn (used for one-time initialization)
    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddApplet.InputType',
        ''
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddApplet.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'AddApplet',
        'Add the Applet to dotlrn - used for one-time initialization',
        'f',
        0,
        'dotlrn_applet.AddApplet.InputType',
        'dotlrn_applet.AddApplet.OutputType'
    );

    -- RemoveApplet: Removes the applet from dotlrn (used for one-time destroy)
    -- ** Not yet implemented **
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveApplet.InputType',
        ''
    );
  
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveApplet.OutputType',
        'success_p:boolean,error_message:string'
    );
    
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'RemoveApplet',
        'Remove the applet',
        'f',
        0,
        'dotlrn_applet.RemoveApplet.InputType',
        'dotlrn_applet.RemoveApplet.OutputType'
    );

    -- Add the applet to a community
    -- Called at community creation time. Adding applets after creation time
    -- is ** not implemented yet **
    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddAppletToCommunity.InputType',
        'community_id:integer'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddAppletToCommunity.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'AddAppletToCommunity',
        'Add the Applet to a specific dotlrn community',
        'f',
        1,
        'dotlrn_applet.AddAppletToCommunity.InputType',
        'dotlrn_applet.AddAppletToCommunity.OutputType'
    );

    -- RemoveAppletFromCommunity: Removes the appletl from a community
    -- Called at community delete time. Deleting applets before that time
    -- ** not implemented yet **
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveAppletFromCommunity.InputType',
        'community_id:integer'
    );
  
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveAppletFromCommunity.OutputType',
        'success_p:boolean,error_message:string'
    );
    
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'RemoveAppletFromCommunity',
        'Remove the applet from a given community',
        'f',
        1,
        'dotlrn_applet.RemoveAppletFromCommunity.InputType',
        'dotlrn_applet.RemoveAppletFromCommunity.OutputType'
    );
  
    -- add a user to dotlrn (used for user-specific one time stuff)
    -- Called when a user is added as a dotlrn user. An example:        
    -- dotlrn-calendar will create a personal calendar for the new user.
    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddUser.InputType',
        'user_id:integer'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddUser.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'AddUser',
        'Add a user to dotlrn, used for user-specific one-time init',
        'f',
        1,
        'dotlrn_applet.AddUser.InputType',
        'dotlrn_applet.AddUser.OutputType'
    );

    -- RemoveUser: used for user-specific one time stuff
    -- Just like AddUser above, but when we delete a dotlrn user
    -- Example: dotlrn-calendar would delete the user's personal calendar
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveUser.InputType',
        'user_id:integer'
    );
  
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveUser.OutputType',
        'success_p:boolean,error_message:string'
    );
    
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'RemoveUser',
        'Remove a user from dotlrn',
        'f',
        1,
        'dotlrn_applet.RemoveUser.InputType',
        'dotlrn_applet.RemoveUser.OutputType'
    );
  
    -- AddUserToCommunity: Adds a user to the a specific dotlrn community. 
    -- An example of this is to make the community's calendar items 
    -- visible on user's personal calendar
    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddUserToCommunity.InputType',
        'community_id:integer,user_id:integer'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddUserToCommunity.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'AddUserToCommunity',
        'Add a user to a community',
        'f',
        2,
        'dotlrn_applet.AddUserToCommunity.InputType',
        'dotlrn_applet.AddUserToCommunity.OutputType'
    );

    -- RemoveUserFromCommunity: Removes a user from a specific dotlrn
    -- community. Just like above, but removal.
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveUserFromCommunity.InputType',
        'community_id:integer,user_id:integer'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemoveUserFromCommunity.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'RemoveUserFromCommunity',
        'Remove a user from a community, applet does appropriate cleanup',
        'f',
        2,
        'dotlrn_applet.RemoveUserFromCommunity.InputType',
        'dotlrn_applet.RemoveUserFromCommunity.OutputType'
    );

    -- AddPortlet: Adds the underlying portlet to the given portal
    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddPortlet.InputType',
        'portal_id:integer'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.AddPortlet.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'AddPortlet',
        'Adds the underlying portlet to the portal specified',
        'f',
        1,
        'dotlrn_applet.AddPortlet.InputType',
        'dotlrn_applet.AddPortlet.OutputType'
    );

    -- RemovePortlet: the remove corollary of above
    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemovePortlet.InputType',
        'portal_id:integer,args:string'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.RemovePortlet.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'RemovePortlet',
        'Removes the underlying portlet from the given portal',
        'f',
        2,
        'dotlrn_applet.RemovePortlet.InputType',
        'dotlrn_applet.RemovePortlet.OutputType'
    );

    -- Clone: Attack of the Clones! 
    perform acs_sc_msg_type__new(
        'dotlrn_applet.Clone.InputType',
        'old_community_id:integer,new_community_id:integer'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.Clone.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'Clone',
        'Clone this applets content from the old to the new community',
        'f',
        2,
        'dotlrn_applet.Clone.InputType',
        'dotlrn_applet.Clone.OutputType'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.ChangeEventHandler.InputType',
        'community_id:integer,event:string,old_value:string,new_value:string'
    );

    perform acs_sc_msg_type__new(
        'dotlrn_applet.ChangeEventHandler.OutputType',
        'success_p:boolean,error_message:string'
    );
        
    perform acs_sc_operation__new (
        'dotlrn_applet',
        'ChangeEventHandler',
        'Handles changes to communities',
        'f',
        4,
        'dotlrn_applet.ChangeEventHandler.InputType',
        'dotlrn_applet.ChangeEventHandler.OutputType'
    );

    return 0;

END;

$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();
