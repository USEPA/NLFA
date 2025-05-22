--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table POLLUTANT
--------------------------------------------------------

  CREATE TABLE "NLFWA"."POLLUTANT" 
   (	"POLLUTANT" VARCHAR2(25 BYTE), 
	"ID" NUMBER(10,0)
   ) ;

   COMMENT ON COLUMN "NLFWA"."POLLUTANT"."POLLUTANT" IS 'Pollutant text';
   COMMENT ON COLUMN "NLFWA"."POLLUTANT"."ID" IS 'Pollutant Id';
   COMMENT ON TABLE "NLFWA"."POLLUTANT"  IS 'Pollutants advisories can issued for';
  GRANT SELECT ON "NLFWA"."POLLUTANT" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."POLLUTANT" TO "NLFWA_WEB";
REM INSERTING into NLFWA.POLLUTANT
SET DEFINE OFF;
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Aldrin',3);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Arsenic',4);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Cadmium',5);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Chlordane',6);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Chlorinated benzenes',7);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Chlorinated pesticides',8);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Chromium',9);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Copper',10);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Creosote',11);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('DDD',12);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('DDE',13);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('DDT',14);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Dichloroethane',15);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Dieldrin',16);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Diethylphthalates',57);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Dioxin',17);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Furan',19);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Gasoline',20);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Heptachlor Epoxide',21);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Hexachlorobenzene',22);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Hexachlorobutadiene',23);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Indust./mun. discharge',24);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Kepone',25);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Lead',26);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Lindane',27);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Mercury',28);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Metals',29);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Mirex',30);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Multiple',31);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Not specified',55);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Organo-metallics',33);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('PAHs',34);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('PBBs',35);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('PCBTEQs',60);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('PCBs (Total)',36);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('PFOSs',61);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Pentachlorobenzene',37);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Pentachlorophenol',38);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Perchlorate',58);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Perchloroethylene',39);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Perfluorooctane sulfonate',59);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Pesticides',56);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Photomirex',41);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Phthalate esters',42);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Selenium',43);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Tetrachlorobenzene',45);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Tetrachloroethane',46);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Tetrachloroethylene',54);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Toxaphene',47);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Tributyltin',48);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Trichloroethane',49);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Trichloromethane',50);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('VOCs',52);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Vinyl chloride',51);
Insert into NLFWA.POLLUTANT (POLLUTANT,ID) values ('Zinc',53);
--------------------------------------------------------
--  DDL for Index POLLUTANT_POLLUTANT_ID_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."POLLUTANT_POLLUTANT_ID_PK" ON "NLFWA"."POLLUTANT" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index UK_POLLUTANT_POLLUTANT
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."UK_POLLUTANT_POLLUTANT" ON "NLFWA"."POLLUTANT" ("POLLUTANT") 
  ;
--------------------------------------------------------
--  Constraints for Table POLLUTANT
--------------------------------------------------------

  ALTER TABLE "NLFWA"."POLLUTANT" MODIFY ("POLLUTANT" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."POLLUTANT" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."POLLUTANT" ADD CONSTRAINT "POLLUTANT_POLLUTANT_ID_PK" PRIMARY KEY ("ID")
  USING INDEX "NLFWA"."POLLUTANT_POLLUTANT_ID_PK"  ENABLE;
  ALTER TABLE "NLFWA"."POLLUTANT" ADD CONSTRAINT "UK_POLLUTANT_POLLUTANT" UNIQUE ("POLLUTANT")
  USING INDEX "NLFWA"."UK_POLLUTANT_POLLUTANT"  ENABLE;
