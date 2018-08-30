--
-- Profile Provider interface definition
--
-- ported to PG by Ben.
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: profile-provider-contract-create.sql,v 1.1 2002/03/29 16:53:02 ben Exp $
--

    -- create the interface
    select acs_sc_contract__new(
        'profile_provider',
        'profile provider interface definition'
    );

    -- create the methods of this interface

    -- name method
    select acs_sc_msg_type__new(
        'profile_provider.name.InputType',
        ''
    );

    select acs_sc_msg_type__new(
        'profile_provider.name.OutputType',
        'name:string'
    );

    select acs_sc_operation__new(
        'profile_provider',
        'name',
        'return the name of the profile provider',
        't',
        0,
        'profile_provider.name.InputType',
        'profile_provider.name.OutputType'
    );

    -- prettyName method
    select acs_sc_msg_type__new(
        'profile_provider.prettyName.InputType',
        ''
    );

    select acs_sc_msg_type__new(
        'profile_provider.prettyName.OutputType',
        'prettyName:string'
    );

    select acs_sc_operation__new(
        'profile_provider',
        'prettyName',
        'return the pretty name of the profile provider',
        't',
        0,
        'profile_provider.prettyName.InputType',
        'profile_provider.prettyName.OutputType'
    );

    -- render method
    select acs_sc_msg_type__new(
        'profile_provider.render.InputType',
        ''
    );

    select acs_sc_msg_type__new(
        'profile_provider.render.OutputType',
        'output:string'
    );

    select acs_sc_operation__new(
        'profile_provider',
        'render',
        'output the HTML from this profile provider',
        't',
        0,
        'profile_provider.render.InputType',
        'profile_provider.render.OutputType'
    );
