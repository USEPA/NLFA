--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table ADV_TYPES
--------------------------------------------------------

  CREATE TABLE "NLFWA"."ADV_TYPES" 
   (	"ADV_TYPE" VARCHAR2(35 BYTE), 
	"ID" NUMBER(10,0)
   ) ;

   COMMENT ON COLUMN "NLFWA"."ADV_TYPES"."ADV_TYPE" IS 'Types of advisories address';
   COMMENT ON COLUMN "NLFWA"."ADV_TYPES"."ID" IS 'Types of advisories id';
   COMMENT ON TABLE "NLFWA"."ADV_TYPES"  IS 'Types of advisories';
  GRANT SELECT ON "NLFWA"."ADV_TYPES" TO "RAD_PROGRAMS" WITH GRANT OPTION;
  GRANT SELECT ON "NLFWA"."ADV_TYPES" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."ADV_TYPES" TO "NLFWA_WEB";
REM INSERTING into NLFWA.ADV_TYPES
SET DEFINE OFF;
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Bayou',1);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Canal',2);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Coastal',3);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Estuary',4);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Federal',5);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Great Lake',6);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Lake',7);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Multi-class',8);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Regional',9);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('River',10);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Statewide',11);
Insert into NLFWA.ADV_TYPES (ADV_TYPE,ID) values ('Wetland',12);
--------------------------------------------------------
--  DDL for Index ADV_TYPES_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."ADV_TYPES_ID_PK" ON "NLFWA"."ADV_TYPES" ("ID") 
  ;
--------------------------------------------------------
--  Constraints for Table ADV_TYPES
--------------------------------------------------------

  ALTER TABLE "NLFWA"."ADV_TYPES" ADD CONSTRAINT "ADV_TYPES_ID_PK" PRIMARY KEY ("ID")
  USING INDEX "NLFWA"."ADV_TYPES_ID_PK"  ENABLE;
