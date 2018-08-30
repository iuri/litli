<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="clipboards">      
      <querytext>

  SELECT c.collection_id, title, 
         sum(case when m.photo_id is not null then 1 else 0 end) as photos
    FROM pa_collections as c left outer join pa_collection_photo_map as m 
      on (m.collection_id = c.collection_id) 
   WHERE c.owner_id = :user_id
   GROUP BY c.collection_id, title
   ORDER BY title

      </querytext>
</fullquery>
 
</queryset>
