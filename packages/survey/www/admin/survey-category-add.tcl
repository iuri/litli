# /www/survsimp/admin/one-respondent.tcl
ad_page_contract {

    Inserts a category into the central categories table
    and maps it to this survey.

    @param  section_id  which survey we'll assign category to
    @param  category   name of a category to be created and assigned to survey

    @cvs-id survey-category-add.tcl,v 1.4.2.4 2000/07/21 04:04:22 ron Exp
} {

    section_id:naturalnum,notnull
    category:notnull

}




db_transaction {

  set category_id [db_string category_id_next_sequence "select 
  category_id_sequence.nextval from dual"]

  db_dml category_insert "insert into categories 
  (category_id, category,category_type)
  values (:category_id, :category, 'survsimp')" 

  set one_line_item_desc "Survey: [db_string survey_name "
  select name from survey_sections where section_id = :section_id" ]"

  db_dml category_map_insert "insert into site_wide_category_map 
  (map_id, category_id,
  on_which_table, on_what_id, mapping_date, one_line_item_desc) 
  values (site_wide_cat_map_id_seq.nextval, :category_id, 'survey_sections',
  :section_id, sysdate, :one_line_item_desc)" 

}

get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)
ad_returnredirect [export_vars -base one {survey_id}]

