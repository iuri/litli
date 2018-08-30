<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="clipboards">      
      <querytext>

  SELECT c.collection_id, title, 
         sum(case when m.photo_id is not null then 1 else 0 end) as photos
    FROM pa_collections c, pa_collection_photo_map m 
   WHERE m.collection_id(+) = c.collection_id 
     AND c.owner_id = :user_id
   GROUP BY c.collection_id, title
   ORDER BY title

      </querytext>
</fullquery>
 
</queryset>
