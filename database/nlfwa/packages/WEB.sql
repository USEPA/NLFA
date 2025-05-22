--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package WEB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "NLFWA"."WEB" AS

FUNCTION contacts RETURN sys_refcursor;

FUNCTION all_states RETURN sys_refcursor;

PROCEDURE cleanup(p_session_id IN web_sessions.session_id%TYPE);

FUNCTION advisory_details2(p_advnum IN NUMBER) RETURN sys_refcursor;

FUNCTION advisory_details3(p_advnum IN NUMBER) RETURN sys_refcursor;

FUNCTION export_advisory_list (
p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION export_tissue_count(
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN NUMBER;
  
FUNCTION export_tissue(
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

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
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION advisory_pollutants(p_advnum IN NUMBER) RETURN sys_refcursor;

FUNCTION advisory_species(p_advnum IN NUMBER) RETURN sys_refcursor;

FUNCTION advisory_population(p_advnum IN NUMBER) RETURN sys_refcursor;

FUNCTION advisory_details(p_advnum IN NUMBER) RETURN sys_refcursor;

FUNCTION epa_region_list(
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION tissue_state_list(
  p_region IN states.region%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION tissue_waterbody_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION tissue_species_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION tissue_pollutant_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION tissue_region_list(
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION tissue_year_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE) RETURN sys_refcursor;

FUNCTION state_list(
  p_region IN states.region%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION waterbody_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION advisory_type_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,
  p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION fish_species_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION pollutant_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION population_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_status IN advisory.advisory_status%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION status_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_startyear IN advisory.year_issued%TYPE,   p_endyear IN advisory.year_issued%TYPE) RETURN sys_refcursor;

FUNCTION year_list(
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN advisory.advisory%TYPE,
  p_advisory_type_id IN advisory.advisory_type_id%TYPE,
  p_species IN details.species_id%TYPE,
  p_pollutant_id IN details.pollutant_id%TYPE,
  p_population_id IN details.population_id%TYPE,
  p_status IN advisory.advisory_status%TYPE) RETURN sys_refcursor;

FUNCTION tissue_parm_list RETURN sys_refcursor;

FUNCTION tissue_report(
  p_session_id IN web_sessions.session_id%TYPE,
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear VARCHAR2,
  p_endyear VARCHAR2) RETURN sys_refcursor;

FUNCTION tissue_details(p_station_id IN VARCHAR2) RETURN sys_refcursor;
FUNCTION tissue_details(p_station_id IN VARCHAR2, p_startyear VARCHAR2, p_endyear VARCHAR2) RETURN sys_refcursor;

FUNCTION tissue_details(p_station_id IN VARCHAR2,
  p_parm_id IN NUMBER,
  p_species_id IN NUMBER,
  p_region IN states.region%TYPE,
  p_state IN states.state%TYPE,
  p_waterbody IN VARCHAR2,
  p_startyear VARCHAR2,
  p_endyear VARCHAR2
  ) RETURN sys_refcursor;
  
FUNCTION tissue_details2(p_station_id IN VARCHAR2) RETURN sys_refcursor;

FUNCTION general_waterbody_list(p_state IN state_waterbodies.state%TYPE) RETURN sys_refcursor;

FUNCTION general_waterbody_mbr(p_state IN state_waterbodies.state%TYPE,
  p_waterbody IN state_waterbodies.gnis_name%TYPE) RETURN sys_refcursor;

END WEB;
 

/

  GRANT EXECUTE ON "NLFWA"."WEB" TO "NLFWA_WEB";
  GRANT EXECUTE ON "NLFWA"."WEB" TO "NLFWA_MAP";
