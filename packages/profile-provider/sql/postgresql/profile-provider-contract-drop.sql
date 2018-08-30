--
-- Profile Provider interface definition
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: profile-provider-contract-drop.sql,v 1.1 2002/03/29 16:53:02 ben Exp $
--

begin

    -- drop the methods of this interface

    -- name method
    perform acs_sc_operation__delete(
        'profile_provider',
        'name'
    );

    perform acs_sc_msg_type__delete(
        'profile_provider.name.InputType'
    );

    perform acs_sc_msg_type__delete(
        'profile_provider.name.OutputType'
    );

    -- prettyName method
    perform acs_sc_operation__delete(
        'profile_provider',
        'prettyName'
    );

    perform acs_sc_msg_type__delete(
        'profile_provider.prettyName.InputType'
    );

    perform acs_sc_msg_type__delete(
        'profile_provider.prettyName.OutputType'
    );

    -- render method
    perform acs_sc_operation__delete(
        'profile_provider',
        'render'
    );

    perform acs_sc_msg_type__delete(
        'profile_provider.render.InputType'
    );

    perform acs_sc_msg_type__delete(
        'profile_provider.render.OutputType'
    );

    -- create the interface
    perform acs_sc_contract__delete(
        'profile_provider'
    );

end;
