<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="new_album">      
      <querytext>
      
	    begin
	    :1 := pa_album.new (
	      name           => :name,
	      album_id       => :album_id,
	      parent_id	     => :parent_id,
      	  is_live	     => 't',
	      creation_user  => :user_id,
	      creation_ip    => :peeraddr,
	      title	     => :title,
	      description    => :description,
	      story	     => :story,
          photographer   => :photographer
	    );
	    end;
	
      </querytext>
</fullquery>

 
</queryset>
