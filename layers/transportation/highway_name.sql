CREATE OR REPLACE FUNCTION transportation_name_tags(geometry geometry, tags hstore, name text, name_en text, name_ar text) RETURNS hstore AS
$$
SELECT hstore(string_agg(nullif(slice_language_tags(tags ||
                     hstore(ARRAY [
                       'name',    CASE WHEN length(name) > 15    THEN osml10n_street_abbrev_all(name)   ELSE NULLIF(name, '') END,
                       'name:en', CASE WHEN length(name_en) > 15 THEN osml10n_street_abbrev_en(name_en) ELSE NULLIF(name_en, '') END,
                       'name:ar', CASE WHEN length(name_ar) > 15 THEN osml10n_street_abbrev_de(name_ar) ELSE NULLIF(name_ar, '') END
                     ]))::text,
                     ''), ','));
$$ LANGUAGE SQL IMMUTABLE
                PARALLEL SAFE;
