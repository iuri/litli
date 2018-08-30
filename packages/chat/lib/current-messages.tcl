
set sql {
    select to_char(creation_date, 'DD.MM.YYYY hh24:mi:ss') as creation_date, creation_user, msg 
    from chat_msgs 
    where room_id  = :room_id 
    order by creation_date
}

db_multirow -extend { person_name } messages select_msg_itens $sql {
    if { [catch { set person_name [chat_user_name $creation_user] }] } {
        set person_name "Unknown"
    }
}
