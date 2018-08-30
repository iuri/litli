--
-- Alter caveman style booleans (type character(1)) to real SQL boolean types.
--
drop view if exists forums_forums_enabled;

ALTER TABLE forums_forums
      DROP constraint IF EXISTS forums_autosubscribe_p_ck,
      ALTER COLUMN autosubscribe_p DROP DEFAULT,
      ALTER COLUMN autosubscribe_p TYPE boolean
      USING autosubscribe_p::boolean,
      ALTER COLUMN autosubscribe_p SET DEFAULT false;

create view forums_forums_enabled
as
    select *
    from forums_forums
    where enabled_p = true;

