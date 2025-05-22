--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table LUT_DATAQUALIFIERS
--------------------------------------------------------

  CREATE TABLE "NLFWA"."LUT_DATAQUALIFIERS" 
   (	"DQCODE" VARCHAR2(2 BYTE), 
	"ORIGINALCODE" VARCHAR2(50 BYTE), 
	"DQDESCRIPTION" VARCHAR2(255 BYTE)
   ) ;

   COMMENT ON COLUMN "NLFWA"."LUT_DATAQUALIFIERS"."DQCODE" IS 'Code for sampling data qualifier';
   COMMENT ON COLUMN "NLFWA"."LUT_DATAQUALIFIERS"."ORIGINALCODE" IS 'Prior code for sampling data qualifier';
   COMMENT ON COLUMN "NLFWA"."LUT_DATAQUALIFIERS"."DQDESCRIPTION" IS 'Description for sampling data qualifier';
   COMMENT ON TABLE "NLFWA"."LUT_DATAQUALIFIERS"  IS 'List of sampling data qualifiers';
  GRANT SELECT ON "NLFWA"."LUT_DATAQUALIFIERS" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."LUT_DATAQUALIFIERS" TO "NLFWA_WEB";
REM INSERTING into NLFWA.LUT_DATAQUALIFIERS
SET DEFINE OFF;
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('A','A','average of 2 or more determinations (samples)');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('B','B','analyte found in blank');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('C','**','common laboratory contaminant');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('C2','C','calculated');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('D','D','measurement was made in the field (in situ)');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('G','>','Greater than some level');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('H','H','value based on field kit determination; results may not be accurate');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('J','J','estimated value; analyte was positively identified and the associated numerical result is an estimate;');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('J1','UJ','detected, but quantity is estimated');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('J2','^','quantity approximate due to matrix effects');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('J3','*','these compounds are of known instability and quantitation should be considered approximate');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('JK','JK','The identification of the analyte is acceptable and  the reported value is an estimate and may be biased high, The actual value is expected to be less than the reported value.');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('L','L','actual value is known to be greater than value reported');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('M','M','presence of the pollutant was verified but not quantified.  Only use if the estimated value is greater than detection limit.');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('NA','NA','Not analyzed');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('ND','T; ND','less than detection limit.');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('NJ','NJ','There is evidence that the analyte is present and the associated numerical result is an estimate;');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('NQ','NQ','analyte could not be quantified due to interference');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('O','O','analysis was lost or not performed.');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('P','PS','sample was received past acceptable holding time, so value is estimated');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('Q','Q','sample held beyond accepted holding time');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('Q2','QL; PQL; ***; ^^; #','Less than quantitation limit');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('R','RL; LRL;<; RDL','Less than reporting limit; less than laboratory reporting limit;');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('R1','R','rejected');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('R2','R','significant rain in past 48 hours may contribute to a lower than normal value');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('U','U','compound was analyzed but not detected; The analyte was not detected at or above the reported result');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('U1','UJ','The analyte was not detected at or above the reported estimated result;');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('V','V','analyte detected in sample and method blank.');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('Y','Y','sample was improperly preserved.');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('N','N','evidence of pollutant''s presence.  May be appropriate if presence is indicated, but there may have been interference or the sample may not have met QC requirements');
Insert into NLFWA.LUT_DATAQUALIFIERS (DQCODE,ORIGINALCODE,DQDESCRIPTION) values ('K','K','actual value is known to be less than value reported (this does not mean it''s less than detection limit)');
--------------------------------------------------------
--  DDL for Index LUT_DATAQUALIFIERS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."LUT_DATAQUALIFIERS_PK" ON "NLFWA"."LUT_DATAQUALIFIERS" ("DQCODE") 
  ;
--------------------------------------------------------
--  Constraints for Table LUT_DATAQUALIFIERS
--------------------------------------------------------

  ALTER TABLE "NLFWA"."LUT_DATAQUALIFIERS" MODIFY ("DQCODE" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."LUT_DATAQUALIFIERS" MODIFY ("ORIGINALCODE" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."LUT_DATAQUALIFIERS" MODIFY ("DQDESCRIPTION" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."LUT_DATAQUALIFIERS" ADD CONSTRAINT "LUT_DATAQUALIFIERS_PK" PRIMARY KEY ("DQCODE")
  USING INDEX "NLFWA"."LUT_DATAQUALIFIERS_PK"  ENABLE;
