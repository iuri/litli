<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="static_portal_content::new.new_content_item">
        <querytext>
            declare
            begin
                :1 := static_portal_content_item.new(
                    package_id => :package_id,
                    content => :content,
                    format => :format,
                    pretty_name => :pretty_name
                );
            end;
        </querytext>
    </fullquery>

</queryset>
