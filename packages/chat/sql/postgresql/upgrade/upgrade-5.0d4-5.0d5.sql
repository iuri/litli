
alter table chat_rooms add column auto_flush_p boolean;
alter table chat_rooms alter column auto_flush_p set default 't';

alter table chat_rooms add column auto_transcript_p boolean;
alter table chat_rooms alter column auto_transcript_p set default 'f';

update chat_rooms set auto_flush_p = 't', auto_transcript_p = 'f';

alter table chat_msgs add column creation_date2 timestamptz;
update chat_msgs set creation_date2 = creation_date;
alter table chat_msgs drop column creation_date;
alter table chat_msgs rename column creation_date2 to creation_date;



-- added
select define_function_args('chat_room__edit','room_id,pretty_name,description,moderated_p,active_p,archive_p,auto_flush_p,auto_transcript_p');

--
-- procedure chat_room__edit/8
--
CREATE OR REPLACE FUNCTION chat_room__edit(
   p_room_id integer,
   p_pretty_name varchar,
   p_description varchar,
   p_moderated_p boolean,
   p_active_p boolean,
   p_archive_p boolean,
   p_auto_flush_p boolean,
   p_auto_transcript_p boolean
) RETURNS integer AS $$
DECLARE
BEGIN

        update chat_rooms set
            pretty_name = p_pretty_name,
            description = p_description,
            moderated_p = p_moderated_p,
            active_p    = p_active_p,
            archive_p   = p_archive_p,
            auto_flush_p   = p_auto_flush_p,
            auto_transcript_p   = p_auto_transcript_p
        where
            room_id = p_room_id;
        return 0;
END;
$$ LANGUAGE plpgsql;



-- added
select define_function_args('chat_room__new','room_id,pretty_name,description,moderated_p,active_p,archive_p,auto_flush_p,auto_transcript_p,context_id,creation_date,creation_user,creation_ip,object_type');

--
-- procedure chat_room__new/13
--
CREATE OR REPLACE FUNCTION chat_room__new(
   p_room_id integer,
   p_pretty_name varchar,
   p_description varchar,
   p_moderated_p boolean,
   p_active_p boolean,
   p_archive_p boolean,
   p_auto_flush_p boolean,
   p_auto_transcript_p boolean,
   p_context_id integer,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_object_type varchar
) RETURNS integer AS $$
DECLARE
   v_room_id        chat_rooms.room_id%TYPE;
BEGIN
   v_room_id := acs_object__new (
     null,
     'chat_room',
     now(),
     p_creation_user,
     p_creation_ip,
     p_context_id
   );

   insert into chat_rooms
       (room_id, pretty_name, description, moderated_p, active_p, archive_p, auto_flush_p, auto_transcript_p)
   values
       (v_room_id, p_pretty_name, p_description, p_moderated_p, p_active_p, p_archive_p, p_auto_flush_p, p_auto_transcript_p);

return v_room_id;

END;
$$ LANGUAGE plpgsql;

