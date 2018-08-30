<?xml version="1.0"?>

<queryset>

    <fullquery name="dotlrn::portal_navbar.list_page_nums_select">
        <querytext>
            select pretty_name,
                   sort_key
            from portal_pages
            where portal_id = :portal_id
	     and hidden_p = 'f'	
            order by sort_key
        </querytext>
    </fullquery>

</queryset>
