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
-- started October 1st, 2001
-- we remember September 11th
--

--
-- This is the service contract for dotLRN applets. A dotlrn applet MUST
-- have AT LEAST the procs (with the proper arguments) defined below to work
-- as a dotlrn applet. See the short explanation of what the proc is about
-- below.
--

declare
    sc_dotlrn_contract              integer;
    foo                             integer;
begin

    sc_dotlrn_contract := acs_sc_contract.new(
        contract_name => 'dotlrn_applet',
        contract_desc => 'dotLRN Applet contract'
    );

    -- GetPrettyName: A simple proc to return the pretty name of the applet
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.GetPrettyName.InputType',
        msg_type_spec => ''
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.GetPrettyName.OutputType',
        msg_type_spec => 'pretty_name:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'GetPrettyName',
        operation_desc => 'Get the pretty name of the applet',
        operation_iscachable_p => 't',
        operation_nargs => 0,
        operation_inputtype => 'dotlrn_applet.GetPrettyName.InputType',
        operation_outputtype => 'dotlrn_applet.GetPrettyName.OutputType'
    );

    -- AddApplet: Adds the applet to dotlrn(used for one-time initialization)
    -- Call in the the dotlrn-init sequence
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddApplet.InputType',
        msg_type_spec => ''
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddApplet.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddApplet',
        operation_desc => 'Add the Applet to dotlrn - used for one-time initialization',
        operation_iscachable_p => 'f',
        operation_nargs => 0,
        operation_inputtype => 'dotlrn_applet.AddApplet.InputType',
        operation_outputtype => 'dotlrn_applet.AddApplet.OutputType'
    );

    -- RemoveApplet: Removes the applet from dotlrn(used for one-time destroy)
    -- ** Not yet implemented **
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveApplet.InputType',
        msg_type_spec => ''
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveApplet.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveApplet',
        operation_desc => 'Remove the applet',
        operation_iscachable_p => 'f',
        operation_nargs => 0,
        operation_inputtype => 'dotlrn_applet.RemoveApplet.InputType',
        operation_outputtype => 'dotlrn_applet.RemoveApplet.OutputType'
    );

    -- AddAppletToCommunity: Adds the applet to a community
    -- Called at community creation time. Adding applets after creation time
    -- is ** not implemented yet **
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddAppletToCommunity.InputType',
        msg_type_spec => 'community_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddAppletToCommunity.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddAppletToCommunity',
        operation_desc => 'Add the Applet to a specific dotlrn community',
        operation_iscachable_p => 'f',
        operation_nargs => 1,
        operation_inputtype => 'dotlrn_applet.AddAppletToCommunity.InputType',
        operation_outputtype => 'dotlrn_applet.AddAppletToCommunity.OutputType'
    );

    -- RemoveAppletFromCommunity: Removes the applet from a community
    -- Called at community delete time. Deleting applets before that time
    -- ** not implemented yet **
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveAppletFromCommunity.InputType',
        msg_type_spec => 'community_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveAppletFromCommunity.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveAppletFromCommunity',
        operation_desc => 'Remove the applet from a given community',
        operation_iscachable_p => 'f',
        operation_nargs => 1,
        operation_inputtype => 'dotlrn_applet.RemoveAppletFromCommunity.InputType',
        operation_outputtype => 'dotlrn_applet.RemoveAppletFromCommunity.OutputType'
    );

    -- AddUser: used for user-specific one time stuff
    -- Called when a user is added as a dotlrn user. An example:
    -- dotlrn-calendar will create a personal calendar for the new user.
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddUser.InputType',
        msg_type_spec => 'user_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddUser.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddUser',
        operation_desc => 'Add a user to dotlrn, used for user-specific one-time init',
        operation_iscachable_p => 'f',
        operation_nargs => 1,
        operation_inputtype => 'dotlrn_applet.AddUser.InputType',
        operation_outputtype => 'dotlrn_applet.AddUser.OutputType'
    );

    -- RemoveUser: used for user-specific one time stuff
    -- Just like AddUser above, but when we delete a dotlrn user
    -- Example: dotlrn-calendar would delete the user's personal calendar
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveUser.InputType',
        msg_type_spec => 'user_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveUser.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveUser',
        operation_desc => 'Remove a user from dotlrn',
        operation_iscachable_p => 'f',
        operation_nargs => 1,
        operation_inputtype => 'dotlrn_applet.RemoveUser.InputType',
        operation_outputtype => 'dotlrn_applet.RemoveUser.OutputType'
    );

    -- AddUserToCommunity: Adds a user to the a specific dotlrn community.
    -- An example of this is to make the community's calendar items
    -- visible on user's personal calendar
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddUserToCommunity.InputType',
        msg_type_spec => 'community_id:integer,user_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddUserToCommunity.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddUserToCommunity',
        operation_desc => 'Add a user to a community',
        operation_iscachable_p => 'f',
        operation_nargs => 2,
        operation_inputtype => 'dotlrn_applet.AddUserToCommunity.InputType',
        operation_outputtype => 'dotlrn_applet.AddUserToCommunity.OutputType'
    );

    -- RemoveUserFromCommunity: Removes a user from a specific dotlrn
    -- community. Just like above, but removal.
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveUserFromCommunity.InputType',
        msg_type_spec => 'community_id:integer,user_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemoveUserFromCommunity.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveUserFromCommunity',
        operation_desc => 'Remove a user from a community, applet does appropriate cleanup',
        operation_iscachable_p => 'f',
        operation_nargs => 2,
        operation_inputtype => 'dotlrn_applet.RemoveUserFromCommunity.InputType',
        operation_outputtype => 'dotlrn_applet.RemoveUserFromCommunity.OutputType'
    );

    -- AddPortlet: Adds the underlying portlet to the given portal
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddPortlet.InputType',
        msg_type_spec => 'portal_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.AddPortlet.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddPortlet',
        operation_desc => 'Adds the underlying portlet to the portal specified',
        operation_iscachable_p => 'f',
        operation_nargs => 1,
        operation_inputtype => 'dotlrn_applet.AddPortlet.InputType',
        operation_outputtype => 'dotlrn_applet.AddPortlet.OutputType'
    );

    -- RemovePortlet: the remove corollary of above
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemovePortlet.InputType',
        msg_type_spec => 'portal_id:integer,args:string'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.RemovePortlet.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemovePortlet',
        operation_desc => 'Removes the underlying portlet from the given portal',
        operation_iscachable_p => 'f',
        operation_nargs => 2,
        operation_inputtype => 'dotlrn_applet.RemovePortlet.InputType',
        operation_outputtype => 'dotlrn_applet.RemovePortlet.OutputType'
    );

    -- Clone: Attack of the Clones!
    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.Clone.InputType',
        msg_type_spec => 'old_community_id:integer,new_community_id:integer'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.Clone.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'Clone',
        operation_desc => 'Clone this applets content from the old to the new community',
        operation_iscachable_p => 'f',
        operation_nargs => 2,
        operation_inputtype => 'dotlrn_applet.Clone.InputType',
        operation_outputtype => 'dotlrn_applet.Clone.OutputType'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.ChangeEventHandler.InputType',
        msg_type_spec => 'community_id:integer,event:string,old_value:string,new_value:string'
    );

    foo := acs_sc_msg_type.new(
        msg_type_name => 'dotlrn_applet.ChangeEventHandler.OutputType',
        msg_type_spec => 'success_p:boolean,error_message:string'
    );

    foo := acs_sc_operation.new(
        contract_name => 'dotlrn_applet',
        operation_name => 'ChangeEventHandler',
        operation_desc => 'Handles changes to communities',
        operation_iscachable_p => 'f',
        operation_nargs => 4,
        operation_inputtype => 'dotlrn_applet.ChangeEventHandler.InputType',
        operation_outputtype => 'dotlrn_applet.ChangeEventHandler.OutputType'
    );

end;
/
show errors
