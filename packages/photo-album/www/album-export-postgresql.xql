<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_file_name">
        <querytext>
            select content
            from cr_revisions
            where revision_id = :image_id
        </querytext>
    </fullquery>

    <fullquery name="select_object_content">
        <querytext>
            select lob
            from cr_revisions
            where revision_id = $live_revision
        </querytext>
    </fullquery>

</queryset>
