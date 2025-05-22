--------------------------------------------------------
--  File created - Wednesday-May-21-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table COMADV
--------------------------------------------------------

  CREATE TABLE "NLFWA"."COMADV" 
   (	"STATE" CHAR(2 BYTE), 
	"COMMADVICE" CHAR(1 BYTE), 
	"ST_COMMENTS" VARCHAR2(255 BYTE)
   ) ;

   COMMENT ON COLUMN "NLFWA"."COMADV"."STATE" IS 'State';
   COMMENT ON COLUMN "NLFWA"."COMADV"."COMMADVICE" IS 'Whether commercial advice is issued by state';
   COMMENT ON COLUMN "NLFWA"."COMADV"."ST_COMMENTS" IS 'Additional state comments';
   COMMENT ON TABLE "NLFWA"."COMADV"  IS 'State issued commercial advice';
  GRANT SELECT ON "NLFWA"."COMADV" TO "NLFWA_MAP";
  GRANT SELECT ON "NLFWA"."COMADV" TO "NLFWA_WEB";
REM INSERTING into NLFWA.COMADV
SET DEFINE OFF;
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('AK','N','Alaska has commercial advisories for harvesting, but not for consumption and only includes harvest areas within the state.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('AL','N','This has not happened to date, but would if individuals were put at risk from consumption of commercial fish.  ');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('AR','N','The Arkansas Department of Health would issue a consumer advisory if needed.  There has not been any reason for this type of advisory to date.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('AZ','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('CA','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('CO','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('CT','Y','Young children, pregnant women, and women planning to become pregnant should not eat shark or swordfish, and restrict consumption of fish from stores (including canned tuna) to 1 to 2 meals/week.  Others limit shark and swordfish to 1 or 2 meals/month');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('DC','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('DE','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('FL','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('GA','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('HI','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('IA','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('ID','N','In 2008 provided safe eating guidelines for women who are pregnant, planning to become pregnant, or are breastfeeding, and for children age 7 and under to limit consumption of commercial fish in combination with Idaho sport fish');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('IL','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('IN','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('KS','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('KY','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('LA','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MA','Y','Massachusetts has commercial advisories and interpretes this to mean recreationally-caught and those sold in stores, fish markets, and supermarkets.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MD','N','No current commercial advisories are in effect.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('ME','Y','Pregnant and nursing women, women who may become pregnant, and children under 8 should restrict and/or avoid consumption of the species listed above.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MI','Y','1998 to present.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MN','Y','1994 to present. Advisory issued for mercury in canned tuna, shark, and swordfish for pregnant or nursing women, women planning to become pregnant, and children under the age of 6 years.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MO','N','Missouri does not issue any fish advisories for commercially-caught fish marketed in Missiouri whether they are caught in or out of state.  Missouri advisories are only for sportfish.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MS','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('MT','Y','Issued 2001.  For women who are or may become pregnant, nursing mothers, and children under 6.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NC','Y','2004 to present.  Do Not Eat advice for some species for special populations (women of childbearing age, pregnant and nursing women, and children under 15), and separate recommendations for the general population.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('ND','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NE','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NH','Y','Additional advice for saltwater fish, shell fish and commercially available fish for pregnant and nursing women, women who may become pregnant, and young children');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NJ','Y','1994 to present. ');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NM','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NV','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('NY','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('OH','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('OK','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('OR','N','Issued in 2008 for women who are pregnant, planing to be pregnant, or are breastfeeding and for children under age 6');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('PA','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('RI','Y','Issued in 2002 for women of childbearing age, pregnant women, and children.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('SC','N','Not at the present time.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('SD','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('TN','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('TX','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('UT','N','Utah has no health advisories for commercial fish that might be purchased by consumers.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('VA','N','Shellfish contamination is monitored by Virginia Department of Health, Shellfish Sanitation Division.  There are no current shellfish advisories for chemical contamination.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('VT','Y','1999 to present');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('WA','Y','Issued in 2001 for women who are or may become pregnant and children under 6 years of age.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('WI','Y','Advice for women of childbearing age, children under 15, and the general population.');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('WV','N','No additional state comments');
Insert into NLFWA.COMADV (STATE,COMMADVICE,ST_COMMENTS) values ('WY','N','2008. Advice for ocean fish and farm-raised freshwater fish due to mercury (women of childbearing age, pregnant women, nursing mothers and children under 15 years; all other people)');
--------------------------------------------------------
--  DDL for Index COMADV_STATE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "NLFWA"."COMADV_STATE_PK" ON "NLFWA"."COMADV" ("STATE") 
  ;
--------------------------------------------------------
--  Constraints for Table COMADV
--------------------------------------------------------

  ALTER TABLE "NLFWA"."COMADV" MODIFY ("STATE" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."COMADV" MODIFY ("COMMADVICE" NOT NULL ENABLE);
  ALTER TABLE "NLFWA"."COMADV" ADD CONSTRAINT "COMADV_STATE_PK" PRIMARY KEY ("STATE")
  USING INDEX "NLFWA"."COMADV_STATE_PK"  ENABLE;
  ALTER TABLE "NLFWA"."COMADV" ADD CONSTRAINT "COMADV_COMMADVICE_CK" CHECK ( commadvice IN('Y','N')) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table COMADV
--------------------------------------------------------

  ALTER TABLE "NLFWA"."COMADV" ADD CONSTRAINT "COMADV_STATE_FK" FOREIGN KEY ("STATE")
	  REFERENCES "NLFWA"."STATES" ("STATE") ENABLE;
