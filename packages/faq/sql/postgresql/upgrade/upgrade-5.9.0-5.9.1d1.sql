--
-- Alter caveman style booleans (type character(1)) to real SQL boolean types.
--

ALTER TABLE faqs
      DROP constraint IF EXISTS faqs_disabled_p_check,
      DROP constraint IF EXISTS faqs_separate_p_check,
      DROP constraint IF EXISTS faqs_disabled_p_ck,
      DROP constraint IF EXISTS faqs_separate_p_ck,
      DROP constraint IF EXISTS faqs_disabled_p,
      DROP constraint IF EXISTS faqs_separate_p,
      ALTER COLUMN disabled_p DROP DEFAULT,
      ALTER COLUMN disabled_p TYPE boolean
      USING disabled_p::boolean,
      ALTER COLUMN disabled_p SET DEFAULT false;

