--IRA Tables joined with TERM_HST tables 

select 
hstd.IR_STUDENT_ID,
hstd.IR_SCHOLAR_ID as EMPLID,
hstd.IR_TERM_DATE,hstd.IR_TERM_CODE,
hstd.IR_COLLEGE_ID,hstd.IR_INSTITUTION_CODE,
hstd.IR_ACAD_CAR_CODE,
hstd.IR_DEGREE_STATUS_CODE,
hstd.IR_DEGREE_STATUS_DESCR,
hstd.IR_FULL_PART_TYPE_CODE,
hstd.IR_FULL_PART_TYPE_DESCR,
hstd.IR_CLASS_STANDING_CODE,
hstd.IR_CLASS_STANDING_DESCR,
hstd.IR_CLASS_LEVEL_CODE,
hstd.IR_CLASS_LEVEL_DESCR,
hstd.IR_SPECIAL_INDICATOR_CODE,
hstd.IR_SPECIAL_INDICATOR_DESCR,
hstd.IR_OTHR_SPECIAL_PRG_CODE,
hstd.IR_OTHR_SPECIAL_PRG_DESCR,
hstd.IR_ADMISSION_TYPE_CODE,
hstd.IR_ADMISSION_TYPE_DESCR,
hstd.IR_NEW_STUDENT_CODE,
hstd.IR_NEW_STUDENT_DESCR,
hstd.IR_HIGH_SCHOOL_STUDENT_CODE,
hstd.IR_HIGH_SCHOOL_STUDENT_DESCR,
hstd.IR_DEGREE_PURSUED_LEVEL_CODE, 
hstd.IR_DEGREE_PURSUED_LEVEL_DESCR, 
hstd.IR_ZIPCODE,
schd.IR_BIRTH_DT,
(SYSDATE - schd.IR_BIRTH_DT) / 365.25 as AGE_CURRENT, --age as of today
demo.AGE, --age as of start of term
schd.IR_GENDER_CODE, --most current gender value
schd.IR_GENDER_DESCR,
ethd.IR_IMPUTED_ETHNICITY_CODE,
ethd.IR_IMPUTED_ETHNICITY_DESCR,  
ethd.IR_IPEDS_ETHNIC_GRP_CODE,
ethd.IR_IPEDS_ETHNIC_GRP_DESCR,   
demo.IR_GENDER_RAW_CODE, --gender value from semester show-reg
demo.IR_GENDER_RAW_DESCR,
appd.IR_HS_DEGREE_DT,
appd.IR_HS_CAS_SCHL_TYPE_CODE,
appd.IR_HS_CAS_SCHL_TYPE_DESCR,
appd.IR_SATN_TOTAL_SCORE,
inst.IR_COLLEGE_NAME,
inst.IR_COLLEGE_TYPE_1_CODE,
inst.IR_COLLEGE_TYPE_1_DESCR,
hstf.IR_HEADCOUNT_HST

from irdb_dw.WC_IRA_TERM_ENRLMT_HST_F hstf
inner join irdb_dw.WC_IRA_TERM_ENRLMT_HST_D hstd  /*this fact(_f) and dimension(_d) pair should always be used together*/
 on hstf.IR_STUDENT_ID    = hstd.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = hstd.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = hstd.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = hstd.IR_ACAD_CAR_CODE      

inner join irdb_dw.WC_IRA_SCHOLAR_HST_D schd
on hstd.IR_STUDENT_ID = schd.IR_STUDENT_ID

inner join irdb_dw.WC_IRA_TERM_ETHNICITY_HST_D ethd  
 on hstf.IR_STUDENT_ID    = ethd.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = ethd.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = ethd.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = ethd.IR_ACAD_CAR_CODE 

inner join irdb_dw.WC_IRA_TERM_DEMOG_HST_D demo  
 on hstf.IR_STUDENT_ID    = demo.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = demo.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = demo.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = demo.IR_ACAD_CAR_CODE 

inner join irdb_dw.WC_IRA_ADM_APPLICANT_HST_D appd  
 on hstf.IR_STUDENT_ID    = appd.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = appd.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = appd.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = appd.IR_ACAD_CAR_CODE

inner join irdb_dw.WC_IRA_SKAT_INITIAL_HST_D skat  
 on hstf.IR_STUDENT_ID    = skat.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = skat.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = skat.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = skat.IR_ACAD_CAR_CODE

/*join this table if you need class level data - note that this will change the structure*/
/*of the data set to repeat for each class a student takes in a given term               */
inner join irdb_dw.WC_IRA_CLASS_PERF_HST_D clsd
 on hstf.IR_STUDENT_ID    = clsd.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = clsd.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = clsd.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = clsd.IR_ACAD_CAR_CODE

/*join this table if you need major level data - note that this will change the structure              */
/*of the data set to repeat for each major (as of end of term?) a student has declared in a given term */
inner join irdb_dw.WC_IRA_ACAD_MAJ_PLAN_HST_D majd  
 on hstf.IR_STUDENT_ID    = majd.IR_STUDENT_ID  
and hstf.IR_TERM_DATE     = majd.IR_TERM_DATE
and hstf.IR_COLLEGE_ID    = majd.IR_COLLEGE_ID
and hstf.IR_ACAD_CAR_CODE = majd.IR_ACAD_CAR_CODE      

*/Join look up tables using a left outer join*/

left outer join irdb_dw.WC_IRA_INSTITUTION_D inst
 on hstf.IR_COLLEGE_ID      = inst.IR_COLLEGE_ID
and hstf.IR_TERM_CODE betweem inst.IR_BEGIN_TERM_CODE and inst.IR_END_TERM_CODE

where 
hstf.IR_TERM_DATE in (date '2020-09-01', date '2021-09-01') --select terms by term date
and hstf.IR_HEADCOUNT_HST = 1  -- select only students include in the headcount (if you are computing FTE's, do not limit on this field*/
and hstd.IR_NEW_STUDENT_CODE    = '1'  --first-time freshmen
and hstd.IR_FULL_PART_TYPE_CODE = '1'  --full-time students
and hstd.IR_DEGREE_PURSUED_LEVEL_CODE in ('2','3') --students enrolled in associate (2) and bachelor's (3) programs
;
