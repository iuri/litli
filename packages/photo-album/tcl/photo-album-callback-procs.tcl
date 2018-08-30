ad_library {
    Library of callbacks implementations for photo-album
}

#Callbacks for application-track

ad_proc -callback application-track::getApplicationName -impl album {} { 
        callback implementation 
} {
        return "album"
}    
      
ad_proc -callback application-track::getGeneralInfo -impl album {} { 
        callback implementation 
} {
	db_1row my_query {
		select  count(distinct p.pa_photo_id) as result
			from acs_objects ac,acs_objects ac2,acs_objects ac1,acs_objects ac3,dotlrn_communities_all d,pa_albums p1,pa_photos p
			where p1.pa_album_id = ac.object_id
			and ac.context_id = ac1.object_id
			and ac1.context_id = ac2.object_id
			and ac2.context_id = ac3.object_id
			and ac3.context_id = d.package_id
			and d.community_id = :comm_id
			and p1.pa_album_id IN
			(select distinct p2.pa_album_id
			from pa_albums p2,cr_revisions c,cr_revisions c2, cr_items c1
		    		where p.pa_photo_id = c.revision_id
		    		and c.item_id = c1.item_id
		    		and c2.revision_id = p2.pa_album_id
		    		and c2.item_id = c1.parent_id)	
	
	} 
	
	return "$result"
} 

                            
ad_proc -callback application-track::getSpecificInfo -impl album {} { 
        callback implementation 
} {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
	
		
		select distinct ac.title as name_album,p.user_filename as name,p.pa_photo_id as id,p.story as story,p1.photographer as photographer
			from acs_objects ac,acs_objects ac2,acs_objects ac1,acs_objects ac3,dotlrn_communities_all d,pa_albums p1,pa_photos p
			where p1.pa_album_id = ac.object_id
			and ac.context_id = ac1.object_id
			and ac1.context_id = ac2.object_id
			and ac2.context_id = ac3.object_id
			and ac3.context_id = d.package_id
			and d.community_id = :class_instance_id
			and p1.pa_album_id IN
			(select distinct p2.pa_album_id
			from pa_albums p2,cr_revisions c,cr_revisions c2, cr_items c1
		    		where p.pa_photo_id = c.revision_id
		    		and c.item_id = c1.item_id
		    		and c2.revision_id = p2.pa_album_id
		    		and c2.item_id = c1.parent_id)
		    		
				
	}
	set my_elements {
	
		album_name {
	            label "Album Name"
	            display_col name_album	                        
	 	    html {align center}	 	                
		}
		photo_name {
	            label "Photo name"
	            display_col name	                        
	 	    html {align center}	 	                
		}
		photo_id {
	            label "Photo_id"
	            display_col id	                        
	 	    html {align center}	 	                
		}
		p_story {
			label "Story"
			display_col story	                        
	 	    html {align center}	 	                
		}
		p_photographer {
			label "Photographer"
			display_col photographer	                        
	 	    html {align center}	 	                
		}
	          
	        
	}

	return "OK"
}

ad_proc -callback merge::MergePackageUser -impl photo_album {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the photo_album items of two users.
} {
    set msg "Merging photo album"
    set result [list $msg]
    ns_log Notice $msg
    
    db_transaction {
	db_dml upd_collections { *SQL* }
	lappend result "Photo album merge is done"
    } 
    return $result
}

