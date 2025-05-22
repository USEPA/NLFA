--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table COMADVDET
--------------------------------------------------------

  CREATE TABLE "NLFWA"."COMADVDET" 
   (	"STATE" CHAR(2 BYTE), 
	"POLLUTANT" VARCHAR2(50 BYTE), 
	"SPECIES" VARCHAR2(50 BYTE), 
	"POPULATION" VARCHAR2(255 BYTE), 
	"DATEISSUED" VARCHAR2(4 BYTE)
   ) ;

   COMMENT ON COLUMN "NLFWA"."COMADVDET"."STATE" IS 'State';
   COMMENT ON COLUMN "NLFWA"."COMADVDET"."POLLUTANT" IS 'Pollutant of concern';
   COMMENT ON COLUMN "NLFWA"."COMADVDET"."SPECIES" IS 'Species of Concern';
   COMMENT ON COLUMN "NLFWA"."COMADVDET"."POPULATION" IS 'Population of concern';
   COMMENT ON COLUMN "NLFWA"."COMADVDET"."DATEISSUED" IS 'Date commercial advice issued';
   COMMENT ON TABLE "NLFWA"."COMADVDET"  IS 'Details of state issued commercial advice';
  GRANT SELECT ON "NLFWA"."COMADVDET" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."COMADVDET" TO "NLFWA_WEB";
REM INSERTING into NLFWA.COMADVDET
SET DEFINE OFF;
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','farm-raised crayfish','Women of childbearing age, pregnant and nursing women, and children under 15 - 2 meals per weak; general population - 4 meals per week','2007');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','farm-raised trout','Women of childbearing age, pregnant and nursing women, and children under 15 - 2 meals per weak; general population - 4 meals per week','2007');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','king mackerel','Women of childbearing age, pregnant and nursing women, and children under 15 - Do Not Eat; general population - 1 meal per week','2004');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','shark','Women of childbearing age, pregnant and nursing women, and children under 15 - Do Not Eat; general population - 1 meal per week','2004');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','Spanish mackerel','Women of childbearing age, pregnant and nursing women, and children under 15 - Do Not Eat; general population - 1 meal per week','2004');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','swordfish','Women of childbearing age, pregnant and nursing women, and children under 15 - Do Not Eat; general population - 1 meal per week','2004');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','tilefish','Women of childbearing age, pregnant and nursing women, and children under 15 - Do Not Eat; general population - 1 meal per week','2004');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','tuna-canned white','Women of childbearing age, pregnant and nursing women, and children under 15 - Do Not Eat; general population - 1 meal per week','2004');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','halibut','Pregnant or nursing women, women who may become pregnant, and children under age 7 - limit to one meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','king mackerel','Pregnant or nursing women, women who may become pregnant, and children under age 7 - Do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','other ocean fish (including canned and shellfish)','Pregnant or nursing women, women who may become pregnant, and children under age 7 - No more than 2 meals per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','red snapper','Pregnant or nursing women, women who may become pregnant, and children under age 7 - limit to one meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','shark','Pregnant or nursing women, women who may become pregnant, and children under age 7 - Do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','swordfish','Pregnant or nursing women, women who may become pregnant, and children under age 7 - Do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','tilefish','Pregnant or nursing women, women who may become pregnant, and children under age 7 - Do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','tuna-canned','Children under age 7 - Limit to one-half can "white" or 1 can "light" per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','tuna-canned','Pregnant or nursing women, women who may become pregnant - limit to 1 can "white" or 2 cans "light" per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NH','mercury','tuna-steak','Pregnant or nursing women, women who may become pregnant, and children under age 7 - limit to one meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NJ','mercury','shark','general population, women of childbearing age, and children under 7 years of age','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NJ','mercury','swordfish','general population, women of childbearing age, and children under 7 years of age','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','anchovies','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','cod','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','flounder','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','haddock','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','halibut','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 1 meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','mackerel, canned','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','mackerel, king','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - Do not eat','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','mahi mahi','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 1 meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','ocean perch','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','salmon and steelhead','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','sardines','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','sea bass','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 1 meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','shark','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - Do not eat','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','shellfish (shrimp, crabs, clams, oysters, mussels)','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','sole','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','swordfish','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - Do not eat','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','tilapia','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','tilefish','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - Do not eat','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','trout','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','tuna, canned light','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 2 meals per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','tuna, canned white albacore','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 1 meal per week','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('OR','mercury','tuna, steaks','Women of childbearing age, pregnant women, nursing mothers and children under 6 years - 1 meal per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('RI','mercury','shark','Women planning a pregnancy, pregnant women, nursing women, and children under age 6 - do not eat','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('RI','mercury','swordfish','Women planning a pregnancy, pregnant women, nursing women, and children under age 6 - do not eat','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('RI','mercury','tuna-canned','Women planning a pregnancy, pregnant women, nursing women, and children under age 6 - no more than 6 ounces per week','2002');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('RI','PCBs','bluefish','Women planning a pregnancy, pregnant women, nursing women, and children under age 6 - do not eat','2002');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('RI','PCBs','striped bass','Women planning a pregnancy, pregnant women, nursing women, and children under age 6 - do not eat','1988');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('VT','mercury','canned tuna','pregnant women.','1999');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('VT','mercury','shark','pregnant women.','1999');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('VT','mercury','swordfish','pregnant women.','1999');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WA','mercury','king mackerel','Women of childbearing age and children under age 6 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WA','mercury','shark','Women of childbearing age and children under age 6 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WA','mercury','swordfish','Women of childbearing age and children under age 6 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WA','mercury','tilefish','Women of childbearing age and children under age 6 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WA','mercury','tuna-canned','Women of childbearing age limit to 1 can (6 ounces) per week.  Children under 6 years should eat less than 6 ounces per week.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WA','mercury','tuna-fresh or frozen','Women of childbearing age and children under age 6 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','cod','Women of childbearing age and children under age 15 - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','haddock','Women of childbearing age and children under age 15 - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','halibut','Women of childbearing age and children under age 15 - 1 meal per month; general population - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','king mackerel','Women of childbearing age and children under age 15 - Do Not Eat; general population - 1 meal per month','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','orange roughy','Women of childbearing age and children under age 15 - 1 meal per month; general population - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','pollock','Women of childbearing age and children under age 15 - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','salmon-canned and fresh','Women of childbearing age and children under age 15 - 2 to 3 meals per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','shark','Women of childbearing age and children under age 15 - Do Not Eat; general population - 1 meal per month','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','shellfish','Women of childbearing age and children under age 15 - 2 to 3 meals per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','swordfish','Women of childbearing age and children under age 15 - Do Not Eat; general population - 1 meal per month','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','tilefish','Women of childbearing age and children under age 15 - Do Not Eat; general population - 1 meal per month','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','tuna-canned','Women of childbearing age and children under age 15 - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WI','mercury','tuna-steak','Women of childbearing age and children under age 15 - 1 meal per month; general population - 1 meal per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','cod','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','crab','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','farm-raised catfish','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','farm-raised tilapia','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','flounder','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','frozen ready to cook fish','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','haddock','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','halibut','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','herring','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','king mackeral','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','lobster','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','mahi-mahi','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','marlin','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','ocean perch','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','orange roughy','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','oysters','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','salmon','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','shark','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','spanish mackerel','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','swordfish','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','tilefish','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','tuna-canned light','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - 2 meals per weak; suggest prudent consumption for all others','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','tuna-canned white','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('WY','mercury','tuna-fresh or frozen','Women of childbearing age, pregnant women, nursing mothers and children under 15 years - Do not eat; all other people - 1-2 meals per month','2008');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','all other store bought fish','pregnant women, women planning pregnancy within a year, and young children - 1 to 2 meals per week','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','shark','General population, limit to 1 or 2 meals per month','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','shark','pregnant women, women planning pregnancy within a year, and young children - do not eat','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','swordfish','General population, limit to 1 or 2 meals per month','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','swordfish','pregnant women, women planning pregnancy within a year, and young children - do not eat','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','tuna-canned','pregnant women, women planning pregnancy within a year, and young children - 1 to 2 meals per week','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('CT','mercury','tuna-fresh or frozen','pregnant women, women planning pregnancy within a year, and young children - 1 to 2 meals per week','2000');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','mercury','king mackerel','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','mercury','shark','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','mercury','swordfish','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','mercury','tilefish','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','mercury','tuna-steak','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','PCBs','bluefish','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat','1983');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','PCBs','flounder','pregnant/nursing women, women who may become pregnant, and children under 12 - SAFE to eat','1988');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','PCBs','lobster (tomalley) -statewide','general population - do not eat','1988');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','PCBs','lobsters','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat from Boston Harbor or New Bedford Harbor','1988');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MA','PCBs','soft-shell clams and other bivalves','pregnant/nursing women, women who may become pregnant, and children under 12 - do not eat from Boston Harbor or New Bedford Harbor','1988');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('ME','mercury','all other ocean fish & shellfish, including canned','Pregnant and nursing women, women who may become pregnant, and children under 8 - eat no more than 2 meals per week','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('ME','mercury','king mackerel','Pregnant and nursing women, women who may become pregnant, and children under 8 - do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('ME','mercury','shark','Pregnant and nursing women, women who may become pregnant, and children under 8 - do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('ME','mercury','swordfish','Pregnant and nursing women, women who may become pregnant, and children under 8 - do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('ME','mercury','tilefish','Pregnant and nursing women, women who may become pregnant, and children under 8 - do not eat.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('ME','mercury','tuna-canned','Pregnant and nursing women, women who may become pregnant, and children under 8 - restrict consumption to 1 can of "white" tuna or 2 cans of "light" tuna per week.','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MI','mercury','shark','pregnant or nursing women','1998');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MI','mercury','swordfish','pregnant or nursing women','1998');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MI','mercury','tuna','pregnant or nursing women','1998');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MN','mercury','shark','pregnant/nursing women, women planning to become pregnant, and children < 6 years.','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MN','mercury','swordfish','pregnant/nursing women, women planning to become pregnant, and children < 6 years.','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MN','mercury','tuna','pregnant/nursing women, women planning to become pregnant, and children < 6 years.','1994');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MT','mercury','king mackerel','Women who are or may become pregnant, nursing mothers, and children under 6 - Do Not Eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MT','mercury','shark','Women who are or may become pregnant, nursing mothers, and children under 6 - Do Not Eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MT','mercury','swordfish','Women who are or may become pregnant, nursing mothers, and children under 6 - Do Not Eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('MT','mercury','tilefish','Women who are or may become pregnant, nursing mothers, and children under 6 - Do Not Eat','2001');
Insert into NLFWA.COMADVDET (STATE,POLLUTANT,SPECIES,POPULATION,DATEISSUED) values ('NC','mercury','farm-raised catfish','Women of childbearing age, pregnant and nursing women, and children under 15 - 2 meals per weak; general population - 4 meals per week','2007');
--------------------------------------------------------
--  DDL for Index COMADVDET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."COMADVDET_PK" ON "NLFWA"."COMADVDET" ("STATE", "POLLUTANT", "SPECIES", "POPULATION") 
  ;
--------------------------------------------------------
--  Constraints for Table COMADVDET
--------------------------------------------------------

  ALTER TABLE "NLFWA"."COMADVDET" MODIFY ("STATE" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."COMADVDET" MODIFY ("POLLUTANT" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."COMADVDET" MODIFY ("SPECIES" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."COMADVDET" MODIFY ("POPULATION" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."COMADVDET" ADD CONSTRAINT "COMADVDET_PK" PRIMARY KEY ("STATE", "POLLUTANT", "SPECIES", "POPULATION")
  USING INDEX "NLFWA"."COMADVDET_PK"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table COMADVDET
--------------------------------------------------------

  ALTER TABLE "NLFWA"."COMADVDET" ADD CONSTRAINT "COMADVDET_STATE_FK" FOREIGN KEY ("STATE")
	  REFERENCES "NLFWA"."STATES" ("STATE") ENABLE;
