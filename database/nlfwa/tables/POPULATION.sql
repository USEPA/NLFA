--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table POPULATION
--------------------------------------------------------

  CREATE TABLE "NLFWA"."POPULATION" 
   (	"POPULATION" CHAR(4 BYTE), 
	"ID" NUMBER(10,0), 
	"POPTEXT" VARCHAR2(255 BYTE)
   ) ;

   COMMENT ON COLUMN "NLFWA"."POPULATION"."POPULATION" IS 'Population abbreviation';
   COMMENT ON COLUMN "NLFWA"."POPULATION"."ID" IS 'Population ID';
   COMMENT ON COLUMN "NLFWA"."POPULATION"."POPTEXT" IS 'Population full text';
   COMMENT ON TABLE "NLFWA"."POPULATION"  IS 'Human population and consumption level';
  GRANT SELECT ON "NLFWA"."POPULATION" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."POPULATION" TO "NLFWA_WEB";
REM INSERTING into NLFWA.POPULATION
SET DEFINE OFF;
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('CFB ',1,'Commercial Fishing Ban');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('IHA ',2,'Informational Health Advisory');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('NCGP',3,'No Consumption - General Population');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('NCSP',4,'No Consumption - Subpopulation(s)');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('NKZ ',5,'No-Kill Zones');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('RGP ',6,'Restricted Consumption - General Population');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('RSP ',7,'Restricted Consumption - Subpopulation(s)');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('UC  ',8,'Unlimited Consumption');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('PFB ',9,'Public Fishing Ban');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('NR  ',10,'No Restriction');
Insert into NLFWA.POPULATION (POPULATION,ID,POPTEXT) values ('SEG ',999,'Safe Eating Guidelines');
--------------------------------------------------------
--  DDL for Index POPULATION_POPULATION_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."POPULATION_POPULATION_ID_PK" ON "NLFWA"."POPULATION" ("ID") 
  ;
--------------------------------------------------------
--  Constraints for Table POPULATION
--------------------------------------------------------

  ALTER TABLE "NLFWA"."POPULATION" ADD CONSTRAINT "POPULATION_POPULATION_ID_PK" PRIMARY KEY ("ID")
  USING INDEX "NLFWA"."POPULATION_POPULATION_ID_PK"  ENABLE;
