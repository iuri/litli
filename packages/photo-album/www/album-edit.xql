<?xml version="1.0"?>
<queryset>

<fullquery name="get_album_info">      
      <querytext>
      
    select 
      cr.title,
      cr. description,
      pa.story,
      pa.iconic as iconic,
      pa.photographer,
      ci.live_revision as previous_revision
    from cr_items ci,
      cr_revisions cr,
      pa_albums pa
    where ci.live_revision = cr.revision_id
      and cr.revision_id = pa.pa_album_id
      and ci.item_id = :album_id

      </querytext>
</fullquery>

<fullquery name="insert_pa_albums">      
      <querytext>
	    insert into pa_albums (pa_album_id, story, iconic, photographer)
	    values 
	    (:revision_id, :new_story, :iconic, :new_photographer)
      </querytext>
</fullquery>

 
</queryset>
