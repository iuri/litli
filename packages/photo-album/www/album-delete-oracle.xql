<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="album_delete">      
      <querytext>
      
    begin
        pa_album.del(:album_id);
    end;
      </querytext>
</fullquery>

 
<fullquery name="album_name">      
      <querytext>
      
    select content_item.get_title(:album_id,'t') from dual
      </querytext>
</fullquery>

 
</queryset>
