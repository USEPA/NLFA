--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body WEB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "NLFWA"."WEB" AS

FUNCTION contacts RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    select state, name, agency, phone_numb, address || chr(10)||chr(13) || city || ' ' || zip as address,
    email, stateurl, affiliation, fax
    from method
    where affiliation != 'Canadian'
    order by affiliation, state;
  RETURN l_results;
END;

FUNCTION advisory_details(p_advnum IN NUMBER) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT pollutant, species, species_size, poptext population, status
  FROM details d, pollutant p, species s, population o
  WHERE d.pollutant_id = p.id
  AND d.species_id = s.id
  AND d.population_id = o.id
  AND d.advnum = p_advnum
  ORDER BY status;
  RETURN l_results;
END;

FUNCTION advisory_details2(p_advnum IN NUMBER) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT advisory_extent, issuer, c.name, c.email, c.stateurl
  FROM advisory a, method c
  WHERE a.advnum = p_advnum
  AND a.state = c.state
  AND c.is_default = 'Y';
  RETURN l_results;
END;

FUNCTION advisory_details3(p_advnum IN NUMBER) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT state, advnum, advisory, advisory_status, year_issued,
    advisory_extent, adv_type, issuer, stateurl, name, email,
    nvl(safe_eating,'No') as safe_eating, advisory_size, advisory_size_unit
  FROM (
  SELECT s.name as state, a.advnum, a.advisory, a.advisory_status, year_issued,
    advisory_extent, adv_type, issuer, c.stateurl, c.name, c.email,
    (select 'Yes' from dual where exists (select 1 from details where advnum = p_advnum and population_id in (8,10))) as safe_eating,
    advisory_size, advisory_size_unit
  FROM advisory a, method c, adv_types at, states s
  WHERE a.advnum = p_advnum
  AND a.state = s.state
  AND a.advisory_type_id = at.id
  AND a.state = c.state
  AND c.is_default = 'Y');
 RETURN l_results;
END;


FUNCTION advisory_list(
  p_session_id IN web_sessions.session_id%TYPE,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE
  ) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN

  UPDATE web_sessions SET last_session_activity = SYSDATE
  WHERE session_id = p_session_id;

  IF sql%rowcount = 0 THEN
    INSERT INTO web_sessions (session_id, session_start) VALUES (p_session_id, sysdate);
  END IF;

  DELETE FROM web_session_results WHERE session_id = p_session_id;

  INSERT INTO web_session_results (session_id, advnum, state) (
    SELECT p_session_id, advnum, s.state
    FROM advisory a, method c, adv_types t, states s
    WHERE a.state = c.state
      AND a.advisory_type_id = t.id AND a.state = s.state
      AND (s.region = p_region OR p_region IS NULL)
      AND (a.state = p_state OR p_state IS NULL)
      AND (advisory = p_waterbody OR p_waterbody IS NULL)
      AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
      AND (advisory_status = p_status OR p_status IS NULL)
      AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
      AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
        ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
        ((species_id = p_species) OR p_species IS NULL) AND
        (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
      AND a.region != 'CN'
    	AND c.is_default = 'Y');
  COMMIT;
  OPEN l_results FOR
  SELECT advnum, advisory, advisory_status, s.name state, year_issued, date_rescinded,
    date_updated current_as_of,
    stateurl, advisory_extent, adv_type, advisory_size,
    advisory_size_unit, issuer, c.name contact_name, c.email email
  FROM advisory a, method c, adv_types t, states s
  WHERE a.state = c.state
    AND a.advisory_type_id = t.id AND a.state = s.state
    AND a.advnum IN (SELECT w.advnum FROM web_session_results w WHERE session_id = p_session_id)
    AND c.is_default = 'Y'
    ORDER BY s.name;
  RETURN l_results;
END;

FUNCTION advisory_pollutants(p_advnum IN NUMBER) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT DISTINCT pollutant
  FROM details d, pollutant p
  WHERE d.pollutant_id = p.id AND d.advnum = p_advnum;
  RETURN l_results;
END;

FUNCTION advisory_species(p_advnum IN NUMBER) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT DISTINCT species, species_size
  FROM details d, species p
  WHERE d.species_id = p.id AND d.advnum = p_advnum;
  RETURN l_results;
END;

FUNCTION advisory_population(p_advnum IN NUMBER) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT DISTINCT population
  FROM details d, population p
  WHERE d.population_id = p.id AND d.advnum = p_advnum;
  RETURN l_results;
END;

FUNCTION advisory_type_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  IF p_region IS NULL AND p_state IS NULL AND p_waterbody IS NULL AND p_species IS NULL
    AND p_pollutant_id IS NULL AND p_population_id IS NULL
    AND p_status IS NULL AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
  SELECT DISTINCT ID AS advisory_type_id, adv_type
  FROM adv_types t ORDER BY 2;
  ELSE

  OPEN l_results FOR
  SELECT DISTINCT advisory_type_id, adv_type
  FROM advisory a, adv_types t
  WHERE a.advisory_type_id = t.id
    AND (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    ORDER BY 2;
    END IF;
  RETURN l_results;
END;

FUNCTION epa_region_list(
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_state IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_pollutant_id IS NULL
  AND p_population_id IS NULL
  AND p_status IS NULL
  AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
  SELECT DISTINCT REGION
  FROM states s
  WHERE region != 'CN'
  AND state NOT IN ('T1','T2','T3','T4','T5','AF','US') ORDER BY 1;
  ELSE
  OPEN l_results FOR
  SELECT DISTINCT region
  FROM advisory a
  WHERE (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    AND region != 'CN'
    ORDER BY 1;
    END IF;
  RETURN l_results;
END;

FUNCTION export_tissue_count(
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN NUMBER IS
l_results NUMBER;
BEGIN
    SELECT count(*)
    INTO l_results
    FROM stations st, tissue_waterbodies w, states s, samples sm, results r, smpl_types t,
      lut_dataqualifiers d, tissue_parms p, species f
    WHERE st.station_id=sm.station_id
    AND st.state = s.state
    AND sm.sample_id = r.sample_id
    AND sm.smpl_type_id = t.id
    AND r.dqcode = d.dqcode(+)
    AND st.station_id = w.source_featureid(+)
    AND r.parm_id = p.id
    AND sm.species_id= f.id
    AND (st.state = p_state OR p_state IS NULL)
    AND (region = p_region OR p_region IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND r.sample_id = sm.sample_id
    AND r.parm_id = p.id
    AND (f.id = p_species_id OR p_species_id IS NULL)
    AND (parm_id = p_parm_id OR p_parm_id IS NULL)
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL));
  RETURN l_results;
END;

FUNCTION export_tissue(
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT s.state, st.station_id, st.sitename, st.location,
      st.lat_dd, st.long_dd, sm.sample_id, sampledate, num_fish,
      sm.species_id, f.species, r.parm_id, p.parm_text, r.resultnum,
      r.resultunit, r.dl_info, r.dqcode, d.dqdescription,
      t.smpl_type, sm.length, sm.lengthunit, sm.weight, sm.weightunit
    FROM stations st, tissue_waterbodies w, states s, samples sm, results r, smpl_types t,
      lut_dataqualifiers d, tissue_parms p, species f
    WHERE st.station_id=sm.station_id
    AND st.state = s.state
    AND sm.sample_id = r.sample_id
    AND sm.smpl_type_id = t.id
    AND r.dqcode = d.dqcode(+)
    AND st.station_id = w.source_featureid(+)
    AND r.parm_id = p.id
    AND sm.species_id= f.id
    AND (st.state = p_state OR p_state IS NULL)
    AND (region = p_region OR p_region IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND r.sample_id = sm.sample_id
    AND r.parm_id = p.id
    AND (f.id = p_species_id OR p_species_id IS NULL)
    AND (parm_id = p_parm_id OR p_parm_id IS NULL)
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL));
    --AND ROWNUM <= 30000;
  RETURN l_results;
END;

FUNCTION export_advisory_list (
p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT a.advnum, advisory, advisory_status, s.name state, year_issued, a.date_rescinded,
    date_updated current_as_of,
    stateurl, advisory_extent, adv_type, advisory_size,
    advisory_size_unit, issuer, c.name contact_name, c.email email,
    pollutant, species, species_size, poptext population, dp.status detail_status,
    dp.date_rescinded detail_date_rescinded
  FROM advisory a, method c, adv_types t, states s, details dp, pollutant p, species sp, population pp
  WHERE a.state = c.state
    AND a.advisory_type_id = t.id AND a.state = s.state
    AND dp.advnum = a.advnum AND dp.pollutant_id = p.id AND dp.species_id = sp.id
    AND dp.population_id = pp.id
    AND (s.region = p_region OR p_region IS NULL)
    AND (a.state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    AND a.region != 'CN'
    AND c.is_default = 'Y'
    ORDER BY s.name;
  RETURN l_results;
END;

PROCEDURE cleanup(p_session_id IN web_sessions.session_id%TYPE) IS
BEGIN
    DELETE FROM web_sessions
    WHERE session_id = p_session_id
      OR last_session_activity < SYSDATE - 1
      OR (session_start < SYSDATE -1
        AND last_session_activity IS NULL);
END;

FUNCTION tissue_state_list(
  p_region IN states.region%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN

  IF p_region IS NULL AND p_waterbody IS NULL AND p_species IS NULL
    AND p_pollutant_id IS NULL AND p_startyear IS NULL AND p_endyear IS NULL THEN

  OPEN l_results FOR
  SELECT state,name
  FROM states s
  WHERE region != 'CN'
  AND EXISTS (SELECT 1 FROM stations WHERE state = s.state)
  ORDER BY 2;

  ELSE
    OPEN l_results FOR
  SELECT state,name
  FROM states s
  WHERE (region = p_region OR p_region IS NULL)
  AND region != 'CN'
  AND state NOT IN ('T1','T2','T3','T4','T5','AF','US')
  AND EXISTS (
    SELECT /*+ INDEX(sm samples_station_id_idx) */ 1
    FROM stations st, samples sm, results r, tissue_waterbodies w
    WHERE st.station_id = sm.station_id
    AND st.state = s.state
    AND st.station_id = w.source_featureid(+)
    AND r.sample_id = sm.sample_id
    AND (sm.species_id = p_species OR p_species IS NULL)
    AND (parm_id = p_pollutant_id OR p_pollutant_id IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    )
  ORDER BY 2;
  END IF;
RETURN l_results;
END;

FUNCTION tissue_waterbody_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  IF p_species IS NULL AND p_pollutant_id IS NULL
    AND p_region IS NULL AND p_state IS NULL AND p_startyear IS NULL AND p_endyear IS NULL THEN
    OPEN l_results FOR
    SELECT DISTINCT w.gnis_name waterbody
    FROM tissue_waterbodies w order by 1;
  ELSE
  OPEN l_results FOR
    SELECT /*+ INDEX(sm samples_station_id_idx) */ DISTINCT w.gnis_name waterbody
    FROM stations st, samples sm, results r, tissue_waterbodies w, states s
    WHERE st.station_id = sm.station_id
    AND st.state = s.state
    AND (region = p_region OR p_region IS NULL)
    AND (st.state = p_state OR p_state IS NULL)
    AND st.station_id = w.source_featureid(+)
    AND r.sample_id = sm.sample_id
    AND (sm.species_id = p_species OR p_species IS NULL)
    AND (parm_id = p_pollutant_id OR p_pollutant_id IS NULL)
    AND gnis_name IS NOT NULL
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    ORDER BY 1;
    end if;
  RETURN l_results;
END;

FUNCTION tissue_species_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  IF p_waterbody IS NULL AND p_pollutant_id IS NULL
    AND p_region IS NULL AND p_state IS NULL AND p_startyear IS NULL AND p_endyear IS NULL THEN
    OPEN l_results FOR
    SELECT DISTINCT sp.id, sp.species
    FROM species sp
    WHERE EXISTS (SELECT 1 FROM samples WHERE species_id = sp.id)
    ORDER BY UPPER(SPECIES);
  ELSE
  OPEN l_results FOR
    SELECT /*+ INDEX(sm samples_station_id_idx) */ DISTINCT sp.id, sp.species
    FROM stations st, samples sm, results r,
      tissue_waterbodies w, species sp, states s
    WHERE st.station_id = sm.station_id
    AND st.state = s.state
    AND sm.species_id = sp.id
    AND (st.state = p_state OR p_state IS NULL)
    AND st.station_id = w.source_featureid(+)
    AND r.sample_id = sm.sample_id
    AND (parm_id = p_pollutant_id OR p_pollutant_id IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND (region = p_region OR p_region IS NULL)
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    ORDER BY 2;
    END IF;
RETURN l_results;
END;

FUNCTION tissue_pollutant_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  IF p_waterbody IS NULL AND p_species IS NULL
    AND p_region IS NULL AND p_state IS NULL AND p_startyear IS NULL AND p_endyear IS NULL THEN
    OPEN l_results FOR
    SELECT DISTINCT p.id, p.parm_text
    FROM tissue_parms p
    WHERE EXISTS (SELECT 1 FROM results WHERE parm_id = p.id)
    ORDER BY upper(parm_text);
  ELSE

  OPEN l_results FOR
    SELECT /*+ INDEX(sm samples_station_id_idx) */ DISTINCT p.id, p.parm_text
    FROM stations st, samples sm, results r, tissue_parms p,
      tissue_waterbodies w, states s
    WHERE st.station_id = sm.station_id
    AND st.state = s.state
    AND r.parm_id = p.id
    AND (st.state = p_state OR p_state IS NULL)
    AND st.station_id = w.source_featureid(+)
    AND r.sample_id = sm.sample_id
    AND (sm.species_id = p_species OR p_species IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND (region = p_region OR p_region IS NULL)
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    ORDER BY upper(parm_text);
    END IF;
  RETURN l_results;
END;

FUNCTION tissue_region_list(
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  IF p_waterbody IS NULL AND p_species IS NULL
    AND p_pollutant_id IS NULL AND p_state IS NULL AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
    SELECT DISTINCT REGION
  FROM states s
  WHERE region != 'CN'
  AND state NOT IN ('T1','T2','T3','T4','T5','AF','US') ORDER BY 1;

   ELSE

  OPEN l_results FOR
    SELECT DISTINCT s.region
    FROM stations st, samples sm, results r,
      tissue_waterbodies w, states s
    WHERE st.station_id = sm.station_id
    AND st.station_id = w.source_featureid(+)
    AND r.sample_id = sm.sample_id
    AND st.state = s.state
    AND (st.state = p_state OR p_state IS NULL)
    AND (parm_id = p_pollutant_id OR p_pollutant_id IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND (sm.species_id = p_species OR p_species IS NULL)
    AND  (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    ORDER BY 1;
    END IF;
RETURN l_results;
END;

FUNCTION tissue_year_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
   

  OPEN l_results FOR
    SELECT /*+ INDEX(sm samples_station_id_idx) */
      DISTINCT TO_CHAR(TRUNC(sampledate,'YEAR'),'YYYY') year
    FROM stations st, samples sm, results r,
      tissue_waterbodies w, states s
    WHERE st.station_id = sm.station_id
    AND st.station_id = w.source_featureid(+)
    AND r.sample_id = sm.sample_id
    AND st.state = s.state
    AND (region = p_region OR p_region IS NULL)
    AND (st.state = p_state OR p_state IS NULL)
    AND (parm_id = p_pollutant_id OR p_pollutant_id IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND (sm.species_id = p_species OR p_species IS NULL)
    AND sampledate IS NOT NULL
    ORDER BY 1;
  
  RETURN l_results;
END;

FUNCTION state_list(
  p_region IN states.region%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_pollutant_id IS NULL
  AND p_population_id IS NULL
  AND p_status = 'ACTIVE'
  AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
  SELECT state,name
  FROM states s
  WHERE region != 'CN'
  AND state NOT IN ('T1','T2','T3','T4','T5','AF','US')
  AND EXISTS (SELECT 1 FROM ADVISORY WHERE STATE = S.STATE)
  ORDER BY 2;
  ELSE
  OPEN l_results FOR
  SELECT DISTINCT s.state, s.name
  FROM advisory a, states s
  WHERE a.state = s.state
    AND (s.region = p_region OR p_region IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    AND s.region != 'CN'
    AND s.state NOT IN ('T3','T4','T5','AF')
    ORDER BY 2;
    END IF;
  RETURN l_results;
END;

FUNCTION all_states RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT s.state || '~' || stateurl as state, s.name
    FROM states s, method c
    WHERE s.region != 'CN'
    AND s.state = c.state
    AND s.state NOT IN ('T1','T2','T3','T4','T5','AF','US')
    AND c.is_default = 'Y'
    ORDER BY 2;
  RETURN l_results;
END;

FUNCTION waterbody_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_state IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_pollutant_id IS NULL
  AND p_population_id IS NULL
  AND p_status IS NULL
  AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR

  SELECT DISTINCT advisory
  FROM advisory a WHERE region != 'CN'
  AND advisory_status = 'ACTIVE'
  ORDER BY upper(advisory);

  ELSE
  OPEN l_results FOR
  SELECT DISTINCT advisory
  FROM advisory a
  WHERE (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    AND region != 'CN'
    ORDER BY 1;
    END IF;
  RETURN l_results;
END;

FUNCTION fish_species_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_state IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_pollutant_id IS NULL
  AND p_population_id IS NULL
  AND p_status = 'ACTIVE'
  AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
    SELECT DISTINCT S.ID AS species_id, s.species
  FROM advisory a, details d, species s
  WHERE a.advnum = d.advnum AND d.species_id = s.id
  AND advisory_status = 'ACTIVE'
  ORDER BY 2;
  ELSE
  OPEN l_results FOR
  SELECT DISTINCT d.species_id, s.species
  FROM advisory a, details d, species s
  WHERE a.advnum = d.advnum AND d.species_id = s.id
    AND (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id AND pollutant_id = d.pollutant_id) OR p_pollutant_id IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR (population_id = p_population_id AND population_id = d.population_id) OR p_population_id IS NULL)))))
    ORDER BY 2;
    END IF;
  RETURN l_results;
END;

FUNCTION tissue_parm_list RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT id, parm_text
    FROM tissue_parms
    ORDER BY upper(parm_text);
  RETURN l_results;
END;

FUNCTION tissue_report(
  p_session_id IN web_sessions.session_id%TYPE,
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear VARCHAR2,
  p_endyear VARCHAR2) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  UPDATE web_sessions SET last_session_activity = SYSDATE
  WHERE session_id = p_session_id;

  IF sql%rowcount = 0 THEN
    INSERT INTO web_sessions (session_id, session_start) VALUES (p_session_id, sysdate);
  END IF;

  DELETE FROM web_session_results WHERE session_id = p_session_id;

  INSERT INTO web_session_results (session_id, advnum, state) (
    SELECT p_session_id, st.station_id, s.state
    FROM stations st, tissue_waterbodies w, states s
    WHERE st.state = s.state
    AND st.station_id = w.source_featureid(+)
    AND (st.state = p_state OR p_state IS NULL)
    AND (region = p_region OR p_region IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND EXISTS (
      SELECT 1 FROM samples sm, results r, tissue_parms p
      WHERE st.station_id = sm.station_id
        AND r.sample_id = sm.sample_id
        AND r.parm_id = p.id
        AND (sm.species_id = p_species_id OR p_species_id IS NULL)
        AND (parm_id = p_parm_id OR p_parm_id IS NULL)
        AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))));
  COMMIT;
  OPEN l_results FOR
    SELECT state, station_id, sitename, location, lat_dd, long_dd
    FROM stations WHERE station_id IN (
      SELECT advnum FROM web_session_results WHERE session_id = p_session_id);
  RETURN l_results;
END;

FUNCTION tissue_details(p_station_id IN VARCHAR2) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT st.station_id, s.sample_id, sampledate, num_fish, f.id as species_id, species, p.id as parm_id, parm_text,
      r.resultnum, r.resultunit, dl_info, r.dqcode, dqdescription, smpl_type,
      length, lengthunit, weight, weightunit
    FROM stations st, samples s, results r, smpl_types t,
      lut_dataqualifiers d, tissue_parms p, species f
    WHERE st.station_id=s.station_id
    AND s.sample_id = r.sample_id
    AND s.smpl_type_id = t.id
    AND r.dqcode = d.dqcode(+)
    AND r.parm_id = p.id
    AND s.species_id= f.id
    AND st.station_id = p_station_id;
  RETURN l_results;
END;

FUNCTION tissue_details(p_station_id IN VARCHAR2, p_startyear VARCHAR2, p_endyear VARCHAR2) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT st.station_id, s.sample_id, sampledate, num_fish, f.id as species_id, species, p.id as parm_id, parm_text,
      r.resultnum, r.resultunit, dl_info, r.dqcode, dqdescription, smpl_type,
      length, lengthunit, weight, weightunit
    FROM stations st, samples s, results r, smpl_types t,
      lut_dataqualifiers d, tissue_parms p, species f
    WHERE st.station_id=s.station_id
    AND s.sample_id = r.sample_id
    AND s.smpl_type_id = t.id
    AND r.dqcode = d.dqcode(+)
    AND r.parm_id = p.id
    AND s.species_id= f.id
    AND st.station_id = p_station_id
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL));
  RETURN l_results;
END;

FUNCTION tissue_details(p_station_id IN VARCHAR2,
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear VARCHAR2,
  p_endyear VARCHAR2
  ) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT st.station_id, sm.sample_id, sampledate, num_fish, f.id as species_id, species, p.id as parm_id, parm_text,
      r.resultnum, r.resultunit, dl_info, r.dqcode, dqdescription, smpl_type,
      length, lengthunit, weight, weightunit
    FROM stations st, tissue_waterbodies w, states s, samples sm, results r, smpl_types t,
      lut_dataqualifiers d, tissue_parms p, species f
    WHERE st.station_id=sm.station_id
    AND st.state = s.state
    AND sm.sample_id = r.sample_id
    AND sm.smpl_type_id = t.id
    AND r.dqcode = d.dqcode(+)
    AND st.station_id = w.source_featureid(+)
    AND r.parm_id = p.id
    AND sm.species_id= f.id
    AND st.station_id = p_station_id
    AND (st.state = p_state OR p_state IS NULL)
    AND (region = p_region OR p_region IS NULL)
    AND (gnis_name = p_waterbody OR p_waterbody IS NULL)
    AND r.sample_id = sm.sample_id
    AND r.parm_id = p.id
    AND (f.id = p_species_id OR p_species_id IS NULL)
    AND (parm_id = p_parm_id OR p_parm_id IS NULL)
    AND (
      (to_char(sampledate,'YYYY') BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND to_char(sampledate,'YYYY') BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND to_char(sampledate,'YYYY') BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL));
  RETURN l_results;
END;

FUNCTION tissue_details2(p_station_id IN VARCHAR2) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
    SELECT s.name as state, station_id, sitename,location, lat_dd, long_dd,
      (SELECT max(sampledate) FROM samples WHERE station_id = st.station_id) AS sampledate
    FROM stations st, states s
    WHERE  st.station_id = p_station_id
    AND s.state = st.state;
  RETURN l_results;
END;

FUNCTION pollutant_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_state IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_population_id IS NULL
  AND p_status = 'ACTIVE'
  AND p_startyear IS NULL AND p_endyear IS NULL THEN

  OPEN l_results FOR
  SELECT DISTINCT S.ID AS pollutant_id, s.pollutant
  FROM advisory a, details d, pollutant s
  WHERE a.advnum = d.advnum AND d.pollutant_id = s.id
  AND advisory_status = 'ACTIVE'
  ORDER BY 2;

  ELSE
  OPEN l_results FOR
  SELECT DISTINCT d.pollutant_id, s.pollutant
  FROM advisory a, details d, pollutant s
  WHERE a.advnum = d.advnum AND d.pollutant_id = s.id
    AND (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((species_id = p_species AND species_id = d.species_id) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR (population_id = p_population_id AND population_id = d.population_id) OR p_population_id IS NULL)))))
    ORDER BY 2;
    END IF;
  RETURN l_results;
END;

FUNCTION population_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_state IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_pollutant_id IS NULL
  AND p_status = 'ACTIVE'
  AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
   SELECT DISTINCT a.id as population_id, poptext
  FROM population a, population_mapping b
  WHERE a.id = b.toid
  ORDER BY 2;
  ELSE
  OPEN l_results FOR
  SELECT DISTINCT a.id as population_id, poptext
  FROM population a, population_mapping b
  WHERE a.id = b.toid AND b.fromid IN (
    SELECT DISTINCT d.population_id
    FROM advisory a, details d
    WHERE a.advnum = d.advnum
    AND (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((species_id = p_species AND species_id = d.species_id) OR p_species IS NULL) AND
      (population_id = d.population_id) AND
      ((pollutant_id = p_pollutant_id AND pollutant_id =  d.pollutant_id) OR p_pollutant_id IS NULL))))
    ORDER BY 2;
    END IF;
  RETURN l_results;
END;

FUNCTION status_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_state IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_pollutant_id IS NULL
  AND p_population_id IS NULL

  AND p_startyear IS NULL AND p_endyear IS NULL THEN
  OPEN l_results FOR
  SELECT DISTINCT advisory_status
  FROM advisory ORDER BY 1;
  ELSE

  OPEN l_results FOR
  SELECT DISTINCT a.advisory_status
  FROM advisory a
  WHERE (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (
      (year_issued BETWEEN p_startyear AND p_endyear) OR
      (p_startyear IS NULL AND p_endyear IS NOT NULL AND year_issued BETWEEN '1900' AND p_endyear) OR
      (p_startyear IS NOT NULL AND p_endyear IS NULL AND year_issued BETWEEN p_startyear AND to_char(sysdate,'YYYY')) OR
      (p_startyear IS NULL AND p_endyear IS NULL))
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    ORDER BY 1;
    END IF;
  RETURN l_results;
END;

FUNCTION year_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
IF p_region IS NULL
  AND p_state IS NULL
  AND p_waterbody IS NULL
  AND p_advisory_type_id IS NULL
  AND p_species IS NULL
  AND p_pollutant_id IS NULL
  AND p_population_id IS NULL
  AND p_status = 'ACTIVE'
 THEN
  OPEN l_results FOR
  SELECT DISTINCT a.year_issued
  FROM advisory a WHERE advisory_status = 'ACTIVE' ORDER BY 1;
  ELSE
  OPEN l_results FOR
  SELECT DISTINCT a.year_issued
  FROM advisory a
  WHERE (region = p_region OR p_region IS NULL)
    AND (state = p_state OR p_state IS NULL)
    AND (advisory = p_waterbody OR p_waterbody IS NULL)
    AND (advisory_type_id = p_advisory_type_id OR p_advisory_type_id IS NULL)
    AND (advisory_status = p_status OR p_status IS NULL)
    AND EXISTS (SELECT 1 FROM details WHERE advnum = a.advnum AND (
      ((pollutant_id = p_pollutant_id) OR p_pollutant_id IS NULL) AND
      ((species_id = p_species) OR p_species IS NULL) AND
      (((CASE WHEN p_population_id = 999 AND population_id IN (8, 10) THEN 1 END = 1
        OR population_id = p_population_id OR p_population_id IS NULL)))))
    ORDER BY 1;
    END IF;
  RETURN l_results;
END;

FUNCTION general_waterbody_list(
  p_state IN state_waterbodies.state%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT sw.gnis_name waterbody
  FROM state_waterbodies sw
  WHERE (sw.state = p_state)
    ORDER BY UPPER(sw.gnis_name);
  RETURN l_results;
END;

FUNCTION general_waterbody_mbr(
  p_state IN state_waterbodies.state%TYPE,
  p_waterbody IN state_waterbodies.gnis_name%TYPE) RETURN sys_refcursor IS
l_results sys_refcursor;
BEGIN
  OPEN l_results FOR
  SELECT SDO_GEOM.SDO_MIN_MBR_ORDINATE(sw.mbr,1) minx, SDO_GEOM.SDO_MIN_MBR_ORDINATE(sw.mbr,2) miny,
  SDO_GEOM.SDO_MAX_MBR_ORDINATE(sw.mbr,1) maxx, SDO_GEOM.SDO_MAX_MBR_ORDINATE(sw.mbr,2) maxy
  FROM state_waterbodies sw
  WHERE (sw.state = p_state)
  AND (sw.gnis_name = p_waterbody);
  RETURN l_results;
END;

END WEB;

/

  GRANT EXECUTE ON "NLFWA"."WEB" TO "NLFWA_WEB";
  GRANT EXECUTE ON "NLFWA"."WEB" TO "NLFWA_MAP";
