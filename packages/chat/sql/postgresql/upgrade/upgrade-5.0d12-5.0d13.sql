begin;

-- dropping unneded database functions: we now use plain db operations for this
drop   function chat_transcript__new (varchar, varchar, varchar, integer, integer, timestamptz, integer,  varchar, varchar);
drop   function chat_transcript__edit (integer, varchar, varchar, varchar );

drop   function chat_room__new (integer, varchar, varchar, boolean, boolean, boolean, boolean, boolean, boolean, boolean, integer, timestamptz, integer, varchar, varchar);
drop   function chat_room__name (integer);
drop   function chat_room__edit (integer, varchar, varchar, boolean, boolean, boolean, boolean, boolean, boolean, boolean);

drop   function chat_room__message_count (integer);


-- add the new column to specify how much in the past the users will see when entering a chat room
alter table chat_rooms add column messages_time_window integer default 600;


end;
