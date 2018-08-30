--
-- Adding this attribute to dotlrn_community
--
-- There is one more thing to do. You MUST call 
-- "dotlrn_community::get_available_attributes_flush"
-- and you will need to restart your server, of course.
-- 
-- You have been warned.
--
-- arjun@openforce.net
--
declare
    foo integer;
begin

    foo := acs_attribute.create_attribute(
        object_type => 'dotlrn_community',
        attribute_name => 'header_logo_alt_text',
        datatype => 'integer',
        pretty_name => 'Header Logo Alt Text',
        pretty_plural => 'Header Logo Alt Text',
        min_n_values => 0,
        max_n_values => 1,
        storage => 'generic'
    );

end;
/
show errors
