<?xml version="1.0"?>

<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_clubs">
        <querytext>
        select dotlrn_clubs_full.*, v.n_members
        from dotlrn_clubs_full,
             (select dotlrn_clubs_full.club_id, count(1) as n_members
             from dotlrn_clubs_full, dotlrn_member_rels_approved
             where dotlrn_member_rels_approved.community_id = dotlrn_clubs_full.club_id
             group by dotlrn_clubs_full.club_id) v
        where dotlrn_clubs_full.club_id = v.club_id(+)
	    [template::list::page_where_clause -and -name "clubs" -key "dotlrn_clubs_full.club_id"]
	    [template::list::orderby_clause -orderby -name "clubs"]
        </querytext>
    </fullquery>

    <fullquery name="clubs_pagination">
        <querytext>
            select dotlrn_clubs_full.*, v.n_members 
            from dotlrn_clubs_full,
             (select dotlrn_clubs_full.club_id, count(1) as n_members
             from dotlrn_clubs_full, dotlrn_member_rels_approved
             where dotlrn_member_rels_approved.community_id = dotlrn_clubs_full.club_id
             group by dotlrn_clubs_full.club_id) v
        where dotlrn_clubs_full.club_id = v.club_id(+)
            [template::list::orderby_clause -orderby -name "clubs"]
        </querytext>
    </fullquery>

</queryset>
