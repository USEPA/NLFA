--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table MEAL_ADVICE
--------------------------------------------------------

  CREATE TABLE "NLFWA"."MEAL_ADVICE" 
   (	"MEAL_ADVICE_ID" NUMBER(10,0), 
	"ADVICE_ABBREV" VARCHAR2(10 BYTE), 
	"MEAL_ADVICE" VARCHAR2(30 BYTE), 
	"COMMENT" VARCHAR2(255 BYTE), 
	"DAYS_BETWEEN_MEALS" NUMBER(10,1)
   ) ;

   COMMENT ON COLUMN "NLFWA"."MEAL_ADVICE"."MEAL_ADVICE_ID" IS 'System assigned id for meal advice';
   COMMENT ON COLUMN "NLFWA"."MEAL_ADVICE"."ADVICE_ABBREV" IS 'Short description of meal advice';
   COMMENT ON COLUMN "NLFWA"."MEAL_ADVICE"."MEAL_ADVICE" IS 'Description of meal advice';
   COMMENT ON COLUMN "NLFWA"."MEAL_ADVICE"."COMMENT" IS 'Additional explanation for meal advice';
   COMMENT ON COLUMN "NLFWA"."MEAL_ADVICE"."DAYS_BETWEEN_MEALS" IS 'Adviced days between fish comsuptions';
   COMMENT ON TABLE "NLFWA"."MEAL_ADVICE"  IS 'Types of meal advices';
  GRANT SELECT ON "NLFWA"."MEAL_ADVICE" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."MEAL_ADVICE" TO "NLFWA_WEB";
REM INSERTING into NLFWA.MEAL_ADVICE
SET DEFINE OFF;
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (10,'4week','4 meals/week','Population type must be RGP or RSP',1.8);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (11,'>4week','more than 4 meals/week','Population type must be RGP or RSP',1.4);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (1,'1month','1 meal/month','Population type must be RGP or RSP',30);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (2,'1week','1 meal/week','Population type must be RGP or RSP',7);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (3,'1yr','1 meal/year','Population type must be RGP or RSP',365);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (4,'2month','2 meals/month','Population type must be RGP or RSP',15);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (5,'2week','2 meals/week','Population type must be RGP or RSP',3.5);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (6,'2yr','2 meals/year','Population type must be RGP or RSP',182.5);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (7,'3month','3 meals/month','Population type must be RGP or RSP',10);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (8,'3week','3 meals/week','Population type must be RGP or RSP',2.3);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (9,'3yr','3 meals/year','Population type must be RGP or RSP',121.7);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (12,'4yr','4 meals/year','Population type must be RGP or RSP',91.2);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (13,'5yr','5 meals/year','Population type must be RGP or RSP',73);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (14,'6yr','6 meals/year','Population type must be RGP or RSP',60.8);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (15,'7yr','7 meals/year','Population type must be RGP or RSP',52.1);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (16,'8yr','8 meals/year','Population type must be RGP or RSP',45.6);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (17,'9yr','9 meals/year','Population type must be RGP or RSP',40.6);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (18,'10yr','10 meals/year','Population type must be RGP or RSP',36.5);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (19,'11yr','11 meals/year','Population type must be RGP or RSP',33.2);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (20,'No','No consumption','Population type must be NCGP or NCSP',99999999);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (21,'NR','No restriction','Population type must be NR',0);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (22,'VarSub','Varies by subpopulation','Population type must be RSP',0.1);
Insert into NLFWA.MEAL_ADVICE (MEAL_ADVICE_ID,ADVICE_ABBREV,MEAL_ADVICE,"COMMENT",DAYS_BETWEEN_MEALS) values (23,'unspec','Restricted but unspecified',null,0.2);
--------------------------------------------------------
--  DDL for Index PK_MEAL_ADVICE
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."PK_MEAL_ADVICE" ON "NLFWA"."MEAL_ADVICE" ("MEAL_ADVICE_ID") 
  ;
--------------------------------------------------------
--  Constraints for Table MEAL_ADVICE
--------------------------------------------------------

  ALTER TABLE "NLFWA"."MEAL_ADVICE" MODIFY ("MEAL_ADVICE_ID" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."MEAL_ADVICE" MODIFY ("ADVICE_ABBREV" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."MEAL_ADVICE" MODIFY ("MEAL_ADVICE" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."MEAL_ADVICE" MODIFY ("DAYS_BETWEEN_MEALS" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."MEAL_ADVICE" ADD CONSTRAINT "PK_MEAL_ADVICE" PRIMARY KEY ("MEAL_ADVICE_ID")
  USING INDEX "NLFWA"."PK_MEAL_ADVICE"  ENABLE;
