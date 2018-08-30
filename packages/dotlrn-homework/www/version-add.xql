<?xml version="1.0"?>

<queryset>

<fullquery name="get_homework_info">      
      <querytext>
          select item_id as homework_file_id
          from cr_item_rels
          where related_object_id = :file_id
            and relation_tag = 'homework_correction'
      </querytext>
</fullquery>
 
</queryset>
