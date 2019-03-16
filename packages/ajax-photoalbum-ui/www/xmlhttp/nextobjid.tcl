ad_page_contract {

    Returns the next object_id in the object_id sequence

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2008-09-20

}

set object_id [db_nextval acs_object_id_seq]

ns_return 200 "text/html" $object_id