--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View ACTIVE_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ACTIVE_ADVISORIES" ("ADVNUM", "ADVISORY", "SYMBOLOGY") AS 
  SELECT to_char(advnum) advnum, advisory, cast(max(sym) as number(1)) symbology
FROM (
SELECT a.advnum, advisory, '1' AS sym
FROM advisory a
WHERE (a.advisory_type_id NOT IN (3,9,11) OR (a.advisory_type_id = 3 AND a.advisory_extent NOT LIKE 'Statewide%')) AND region != 'CN'
AND advisory_status = 'ACTIVE'
UNION ALL
SELECT DISTINCT a.advnum, advisory, '3'
FROM advisory a, details d
WHERE a.advnum = d.advnum AND d.population_id IN (8,10)
AND NOT EXISTS (SELECT 1 FROM details z WHERE z.advnum = a.advnum AND z.population_id NOT IN (8,10))
AND country != 'CN'
AND (a.advisory_type_id NOT IN (3,9,11) OR (a.advisory_type_id = 3 AND a.advisory_extent NOT LIKE 'Statewide%'))
AND advisory_status = 'ACTIVE'
UNION ALL
SELECT DISTINCT a.advnum, advisory, '2'
FROM advisory a, details d
WHERE a.advnum = d.advnum AND d.population_id IN (8,10)
AND EXISTS (SELECT 1 FROM details z WHERE z.advnum = a.advnum AND z.population_id NOT IN (8,10))
AND country != 'CN'
AND (a.advisory_type_id NOT IN (3,9,11) OR (a.advisory_type_id = 3 AND a.advisory_extent NOT LIKE 'Statewide%'))
AND advisory_status = 'ACTIVE'
) GROUP BY advnum, advisory
 
;
  GRANT SELECT ON "NLFWA"."ACTIVE_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ACTIVE_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ACTIVE_ADVISORIES_BY_POP
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ACTIVE_ADVISORIES_BY_POP" ("ADVNUM", "SYMBOLOGY") AS 
  SELECT
    TO_CHAR(advnum) advnum,
    cast(MIN(symbology) as number(1)) symbology
  FROM
    (
      SELECT
        a.advnum,
        CASE
          WHEN population_id IN (3,6)
          THEN 1
          WHEN population_id IN (4,7)
          THEN 2
          WHEN population_id IN (1,2,5,9)
          THEN 3
          WHEN population_id IN (8,10)
          THEN 4
        END symbology
      FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
    )
  GROUP BY
    advnum
 
;
  GRANT SELECT ON "NLFWA"."ACTIVE_ADVISORIES_BY_POP" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ACTIVE_ADVISORIES_BY_POP" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ACTIVE_REGIONAL_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ACTIVE_REGIONAL_ADVISORIES" ("STATE", "ADVNUM", "ADVISORY_STATUS") AS 
  SELECT
    state,
    TO_CHAR(a.advnum) advnum,
    a.advisory_status
  FROM
    advisory a
  WHERE
    a.advisory_type_id = 9
    AND a.advisory_status = 'ACTIVE'
  AND region!          = 'CN'
 
;
  GRANT SELECT ON "NLFWA"."ACTIVE_REGIONAL_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ACTIVE_REGIONAL_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ACTIVE_STATEWIDE_SYMBOLOGY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ACTIVE_STATEWIDE_SYMBOLOGY" ("STATE", "SYMBOLOGY") AS 
  SELECT
    state,
    cast(MIN(sym) as number(1)) symbology
  FROM
    (
      SELECT
        state,
        2 sym
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state                      = s.state
          AND advisory_type_id         = 11
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        state,
        3
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 3
          AND UPPER(advisory) LIKE '%STATEWIDE%'
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        state,
        1
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 3
          AND UPPER(advisory) LIKE '%STATEWIDE%'
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state                      = s.state
          AND advisory_type_id         = 11
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
    )
  GROUP BY
    state
 
;
  GRANT SELECT ON "NLFWA"."ACTIVE_STATEWIDE_SYMBOLOGY" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ACTIVE_STATEWIDE_SYMBOLOGY" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ADVDET_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ADVDET_V" ("DETAILS_ID", "ADVNUM", "ADVISORY", "STATE", "ADVISORY_EXTENT", "ISSUER", "ADVISORY_TYPE_ID", "ADVISORY_TYPE", "ADVISORY_SIZE", "ADVISORY_SIZE_UNIT", "COUNTRY", "DATE_UPDATED", "REGION", "POLLUTANT_ID", "POLLUTANT", "SPECIES_ID", "SPECIES", "SPECIES_SIZE", "POPULATION_ID", "POPULATION", "MEAL_ADVICE_ID", "MEAL_ADVICE", "STATUS", "DATE_RESCINDED", "YEAR", "NAME", "PHONE_NUMB", "STATEURL", "STATEURLTEXT") AS 
  SELECT
    details.details_id,
    advisory.advNum,
    advisory.advisory,
    advisory.State,
    advisory.advisory_extent,
    advisory.issuer,
    advisory.advisory_type_id,
    adv_types.adv_type AS advisory_type,
    advisory.advisory_size,
    advisory.advisory_size_unit,
    advisory.country,
    advisory.date_updated,
    advisory.region,
    details.pollutant_id,
    pollutant.pollutant,
    details.species_id,
    species.species,
    details.species_size,
    details.population_id,
    population.population,
    details.meal_advice_id,
    meal_advice.meal_advice,
    details.status,
    details.date_rescinded,
    details.year,
    c.name,
    c.phone_numb,
    c.stateurl,
    c.stateurltext
  FROM
    advisory,
    method c,
    details,
    pollutant,
    species,
    population,
    meal_advice,
    adv_types
  WHERE
    advisory.state           = c.state
  AND details.pollutant_id   = pollutant.id
  AND details.species_id     = species.id
  AND details.population_id  = population.id
  AND details.meal_advice_id = meal_advice.meal_advice_id(+)
  AND advisory.advnum        = details.advnum
  AND adv_types.id           = advisory.advisory_type_id
  AND c.is_default           = 'Y'
;
  GRANT SELECT ON "NLFWA"."ADVDET_V" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ADVDET_V" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ADVDET2_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ADVDET2_V" ("DETAILS_ID", "ADVNUM", "ADVISORY", "STATE", "ADVISORY_EXTENT", "ISSUER", "ADVISORY_TYPE_ID", "ADVISORY_TYPE", "ADVISORY_SIZE", "COUNTRY", "DATE_UPDATED", "REGION", "POLLUTANT_ID", "POLLUTANT", "SPECIES_ID", "SPECIES", "SPECIES_SIZE", "POPULATION_ID", "POPULATION", "STATUS", "DATE_RESCINDED", "YEAR") AS 
  SELECT
    Details.Details_ID,
    Advisory.AdvNum,
    Advisory.Advisory,
    Advisory.State,
    Advisory.Advisory_extent,
    Advisory.Issuer,
    advisory.advisory_type_id,
    adv_types.adv_type AS Advisory_type,
    advisory.advisory_size,
    Advisory.Country,
    Advisory.Date_updated,
    Advisory.Region,
    Details.Pollutant_ID,
    Pollutant.Pollutant,
    Details.Species_ID,
    Species.Species,
    Details.Species_size,
    Details.Population_ID,
    Population.Population,
    Details.Status,
    Details.Date_Rescinded,
    Details.Year
  FROM
    Advisory,
    Details,
    Pollutant,
    Species,
    Population,
    adv_types
  WHERE
    Details.Pollutant_ID    = Pollutant.ID
  AND Details.Species_ID    = Species.ID
  AND Details.Population_ID = Population.ID
  AND Advisory.AdvNum       = Details.AdvNum
  AND adv_types.id          = advisory.advisory_type_id
 
;
  GRANT SELECT ON "NLFWA"."ADVDET2_V" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ADVDET2_V" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ADVISORY_INFO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ADVISORY_INFO" ("ADVISORY_NUMBER", "ADVISORY_NAME", "ADVISORY_EXTENT", "STATE_ABBR", "STATE", "ISSUER", "CURR_DATE", "URL", "ADV_TYPE", "ADVISORY_STATUS") AS 
  SELECT
    advnum advisory_number,
    advisory advisory_name,
    advisory_extent,
    s.state state_abbr,
    s.name state,
    issuer,
    TO_CHAR(a.date_updated,'mm/dd/yyyy') AS "CURR_DATE",
    stateurl url,
    CASE
      WHEN advisory_type_id = 3
        AND UPPER(advisory) LIKE '%STATEWIDE%'
      THEN 'Statewide Coastal'
      ELSE adv_type
    END adv_type,
    a.advisory_status
  FROM
    advisory a,
    states s,
    method c,
    adv_types t
  WHERE
    a.state              = s.state
  AND c.state            = s.state
  AND a.advisory_type_id = t.id
  AND c.is_default       = 'Y'
;
  GRANT SELECT ON "NLFWA"."ADVISORY_INFO" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ADVISORY_INFO" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ALL_FISH_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ALL_FISH_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND species_id = 30
 
;
  GRANT SELECT ON "NLFWA"."ALL_FISH_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ALL_FISH_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ALL_REGIONAL_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ALL_REGIONAL_ADVISORIES" ("STATE", "ADVNUM", "ADVISORY_STATUS") AS 
  SELECT
    state,
    TO_CHAR(a.advnum) advnum,
    a.advisory_status
  FROM
    advisory a
  WHERE
    a.advisory_type_id = 9
    --AND a.advisory_status = 'ACTIVE'
  AND region! = 'CN'
 
;
  GRANT SELECT ON "NLFWA"."ALL_REGIONAL_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ALL_REGIONAL_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ALL_STATEWIDE_SYMBOLOGY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ALL_STATEWIDE_SYMBOLOGY" ("STATE", "SYMBOLOGY") AS 
  SELECT
    state,
    cast(MIN(sym)as number(1)) symbology
  FROM
    (
      SELECT
        state,
        2 sym
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 11
            --AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        state,
        3
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 3
          AND UPPER(advisory) LIKE '%STATEWIDE%'
            --AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        state,
        1
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 3
          AND UPPER(advisory) LIKE '%STATEWIDE%'
            --AND advisory.advisory_status = 'ACTIVE'
        )
      AND EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 11
            --AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
    )
  GROUP BY
    state
 
;
  GRANT SELECT ON "NLFWA"."ALL_STATEWIDE_SYMBOLOGY" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ALL_STATEWIDE_SYMBOLOGY" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View ALL_TISSUE_STATIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."ALL_TISSUE_STATIONS" ("STATION_ID", "STATE", "SITENAME", "LOCATION", "MOST_RECENT_SAMPLE_DATE") AS 
  SELECT
    STATIONS.STATION_ID,
    STATIONS.STATE,
    STATIONS.SITENAME,
    STATIONS.LOCATION,
    TO_CHAR(MAX(sampledate),'mm/dd/yyyy') most_recent_sample_date
  FROM
    STATIONS,
    SAMPLES
  WHERE STATIONS.STATION_ID = SAMPLES.STATION_ID
  group by STATIONS.STATION_ID,
    STATIONS.STATE,
    STATIONS.SITENAME,
    STATIONS.LOCATION
 
;
  GRANT SELECT ON "NLFWA"."ALL_TISSUE_STATIONS" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ALL_TISSUE_STATIONS" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View BLUEGILL_SUNFISH_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."BLUEGILL_SUNFISH_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND species_id = 361
 
;
  GRANT SELECT ON "NLFWA"."BLUEGILL_SUNFISH_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."BLUEGILL_SUNFISH_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View CHLORDANE_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."CHLORDANE_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND pollutant_id = 6
 
;
  GRANT SELECT ON "NLFWA"."CHLORDANE_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."CHLORDANE_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View DDT_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."DDT_ADVISORIES" ("ADVNUM") AS 
  SELECT
     to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND pollutant_id = 14
 
;
  GRANT SELECT ON "NLFWA"."DDT_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."DDT_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View DETAILS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."DETAILS_V" ("DETAILS_ID", "ADVNUM", "POLLUTANT_ID", "POLLUTANT", "SPECIES_ID", "SPECIES", "SPECIES_SIZE", "POPULATION_ID", "POPULATION", "MEAL_ADVICE_ID", "MEAL_ADVICE", "STATUS", "DATE_RESCINDED", "YEAR") AS 
  SELECT details.details_id,
       details.advnum,
       details.pollutant_id,
       pollutant.pollutant,
       details.species_id,
       species.species,
       details.species_size,
       details.population_id,
       population.population,
       details.meal_advice_id,
       meal_advice.meal_advice,
       details.status,
       details.date_rescinded,
       details.year
FROM details, pollutant, species, population, meal_advice
WHERE details.pollutant_id = pollutant.id
AND   details.species_id = species.id
AND   details.population_id = population.id
AND   details.meal_advice_id = meal_advice.meal_advice_id
 
;
  GRANT SELECT ON "NLFWA"."DETAILS_V" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."DETAILS_V" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View DIOXIN_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."DIOXIN_ADVISORIES" ("ADVNUM") AS 
  SELECT
      to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND pollutant_id = 17
 
;
  GRANT SELECT ON "NLFWA"."DIOXIN_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."DIOXIN_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View LAKE_TROUT_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."LAKE_TROUT_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
      FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND species_id = 1860
 
;
  GRANT SELECT ON "NLFWA"."LAKE_TROUT_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."LAKE_TROUT_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View LARGEMOUTH_BASS_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."LARGEMOUTH_BASS_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND species_id = 78
 
;
  GRANT SELECT ON "NLFWA"."LARGEMOUTH_BASS_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."LARGEMOUTH_BASS_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View MERCURY_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."MERCURY_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND pollutant_id = 28
 
;
  GRANT SELECT ON "NLFWA"."MERCURY_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."MERCURY_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View PCB_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."PCB_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND pollutant_id = 36
 
;
  GRANT SELECT ON "NLFWA"."PCB_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."PCB_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View REGIONAL_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."REGIONAL_ADVISORIES" ("STATE", "ADVNUM", "ADVISORY_STATUS", "NAME") AS 
  SELECT
    a.state,
    TO_CHAR(a.advnum) advnum,
    a.advisory_status, s.name
  FROM
    advisory a, states s
  WHERE
  a.state = s.state AND
    a.advisory_type_id = 9
  AND a.region!          = 'CN'
 
;
  GRANT SELECT ON "NLFWA"."REGIONAL_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."REGIONAL_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View SMALLMOUTH_BASS_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."SMALLMOUTH_BASS_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
     FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND species_id = 202
 
;
  GRANT SELECT ON "NLFWA"."SMALLMOUTH_BASS_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."SMALLMOUTH_BASS_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View STATEWIDE_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."STATEWIDE_ADVISORIES" ("STATE", "ADVNUM", "ADVISORY_STATUS") AS 
  SELECT state,
    TO_CHAR(a.advnum) advnum,
    a.advisory_status
  FROM advisory a
  WHERE advisory_type_id in (3,11)
  AND UPPER(advisory) LIKE '%STATEWIDE%'
  AND region!            = 'CN'
 
;
  GRANT SELECT ON "NLFWA"."STATEWIDE_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."STATEWIDE_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View STATEWIDE_SYMBOLOGY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."STATEWIDE_SYMBOLOGY" ("STATE", "SYMBOLOGY") AS 
  SELECT
    state,
    cast(MIN(sym) as number(1)) symbology
  FROM
    (
      SELECT
        state,
        2 sym
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state                      = s.state
          AND advisory_type_id         = 11
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        state,
        3
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 3
          AND UPPER(advisory) LIKE '%STATEWIDE%'
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        state,
        1
      FROM
        states s
      WHERE
        EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state              = s.state
          AND advisory_type_id = 3
          AND UPPER(advisory) LIKE '%STATEWIDE%'
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND EXISTS
        (
          SELECT
            1
          FROM
            advisory
          WHERE
            state                      = s.state
          AND advisory_type_id         = 11
          AND advisory.advisory_status = 'ACTIVE'
        )
      AND region != 'CN'
    )
  GROUP BY
    state
 
;
  GRANT SELECT ON "NLFWA"."STATEWIDE_SYMBOLOGY" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."STATEWIDE_SYMBOLOGY" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View TECHNICAL_MAP_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."TECHNICAL_MAP_ADVISORIES" ("ADVNUM", "SYMBOLOGY") AS 
  SELECT
    TO_CHAR(advnum) advnum,
    cast(MAX(sym) as number(1)) symbology
  FROM
    (
      SELECT
        a.advnum,
        '4' AS sym
      FROM
        advisory a
      WHERE a.advisory_status != 'ACTIVE'
      AND  (
          a.advisory_type_id NOT IN (3,9,11)
        OR
          (
            a.advisory_type_id = 3
          AND a.advisory_extent NOT LIKE 'Statewide%'
          )
        )
      AND region != 'CN'
      UNION ALL
      SELECT
        a.advnum,
        '1' AS sym
      FROM
        advisory a
      WHERE a.advisory_status = 'ACTIVE'
      AND  (
          a.advisory_type_id NOT IN (3,9,11)
        OR
          (
            a.advisory_type_id = 3
          AND a.advisory_extent NOT LIKE 'Statewide%'
          )
        )
      AND region != 'CN'
      UNION ALL
      SELECT DISTINCT
        a.advnum,
        '3'
      FROM
        advisory a,
        details d
      WHERE
        a.advnum           = d.advnum
      AND d.population_id IN (8,10)
      AND NOT EXISTS
        (
          SELECT
            1
          FROM
            details z
          WHERE
            z.advnum               = a.advnum
          AND z.population_id NOT IN (8,10)
        )
      AND country != 'CN'
      AND
        (
          a.advisory_type_id NOT IN (3,9,11)
        OR
          (
            a.advisory_type_id = 3
          AND a.advisory_extent NOT LIKE 'Statewide%'
          )
        )
      UNION ALL
      SELECT DISTINCT
        a.advnum,
        '2'
      FROM
        advisory a,
        details d
      WHERE
        a.advnum           = d.advnum
      AND d.population_id IN (8,10)
      AND EXISTS
        (
          SELECT
            1
          FROM
            details z
          WHERE
            z.advnum               = a.advnum
          AND z.population_id NOT IN (8,10)
        )
      AND country != 'CN'
      AND
        (
          a.advisory_type_id NOT IN (3,9,11)
        OR
          (
            a.advisory_type_id = 3
          AND a.advisory_extent NOT LIKE 'Statewide%'
          )
        )
    )
  GROUP BY
    advnum
 
;
  GRANT SELECT ON "NLFWA"."TECHNICAL_MAP_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."TECHNICAL_MAP_ADVISORIES" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View TISSUE_STATION_SYMBOLOGY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."TISSUE_STATION_SYMBOLOGY" ("STATION_ID", "DECADE") AS 
  SELECT station_id, nvl(to_char(d),'Unknown') decade
FROM
(SELECT st.station_id, 
    to_char((MAX(trunc(sampledate, 'YYYY'))), 'YYYY') sd
  FROM stations st, samples sm
  WHERE st.station_id = sm.station_id(+)
  GROUP BY st.station_id) s,
(SELECT decade d, decade+9 d2 
  FROM (
    SELECT to_char(trunc(SYSDATE, 'YYYY'), 'YYYY') - 
    MOD(to_char(trunc(SYSDATE, 'Y'), 'YYYY'), 10) + 10 - LEVEL * 10 AS decade
    FROM dual CONNECT BY LEVEL < round((to_char(trunc(SYSDATE, 'YYYY'), 'YYYY') - 1940) / 10))) d
WHERE sd BETWEEN d(+) AND d2(+)
 
;
  GRANT SELECT ON "NLFWA"."TISSUE_STATION_SYMBOLOGY" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."TISSUE_STATION_SYMBOLOGY" TO "NLFWA_WEB";
--------------------------------------------------------
--  DDL for View TISSUE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."TISSUE_V" ("STATION_ID", "STATE", "SITENAME", "LOCATION", "ADVNUM", "COUNTY", "SAMPLE_ID", "SAMPLEDATE", "LENGTH", "LENGTHUNIT", "WEIGHT", "WEIGHTUNIT", "LIPIDPCNT", "NUM_FISH", "SPECIES_ID", "SPECIES", "SMPL_TYPE", "PARAMETER", "DL_INFO", "RESULTNUM", "RESULTUNIT", "PARM_ID", "ADVISORY", "REGION") AS 
  SELECT STATIONS.STATION_ID,
    STATIONS.STATE,
    STATIONS.SITENAME,
    STATIONS.LOCATION,
    STATIONS.ADVNUM,
    STATIONS.COUNTY,
    SAMPLES.SAMPLE_ID,
    SAMPLES.SAMPLEDATE,
    SAMPLES.LENGTH,
    SAMPLES.LENGTHUNIT,
    SAMPLES.WEIGHT,
    SAMPLES.WEIGHTUNIT,
    SAMPLES.LIPIDPCNT,
    SAMPLES.NUM_FISH,
    samples.species_id,
    SPECIES.SPECIES,
    SMPL_TYPES.SMPL_TYPE,
    TISSUE_PARMS.PARM_TEXT as parameter,
    RESULTS.DL_INFO,
    RESULTS.RESULTNUM,
    RESULTS.RESULTUNIT,
    results.parm_id,
    ADVISORY.Advisory,
    states.region
FROM STATIONS, SAMPLES, RESULTS, SMPL_TYPES, species, tissue_parms, advisory, states
WHERE SAMPLES.SAMPLE_ID = RESULTS.SAMPLE_ID
AND STATIONS.STATION_ID = SAMPLES.STATION_ID
AND advisory.advnum(+) = stations.advnum
AND smpl_types.id = samples.smpl_type_id
AND species.id = samples.species_id
AND tissue_parms.id = results.parm_id
AND stations.state = states.state
ORDER BY stations.state,
         stations.sitename,
         stations.location,
         species.species,
         smpl_types.smpl_type,
         samples.sampledate desc,
         results.resultnum desc
 
;
  GRANT SELECT ON "NLFWA"."TISSUE_V" TO "NLFWA_WEB";
  GRANT SELECT ON "NLFWA"."TISSUE_V" TO "NLFWA_MAP";
--------------------------------------------------------
--  DDL for View WALLEYE_ADVISORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "NLFWA"."WALLEYE_ADVISORIES" ("ADVNUM") AS 
  SELECT
        to_char(a.advnum) advnum       
      FROM details d, advisory a
      WHERE d.advnum = a.advnum AND a.advisory_type_id NOT IN (3,11)
      AND a.advisory_extent NOT LIKE 'Statewide%'
      AND status = 'ACTIVE' AND region!= 'CN'
      AND species_id = 2013
 
;
  GRANT SELECT ON "NLFWA"."WALLEYE_ADVISORIES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."WALLEYE_ADVISORIES" TO "NLFWA_WEB";
