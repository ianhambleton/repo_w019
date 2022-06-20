** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			        read_data_003.do
    //  project:		                SCD Spleeen size
    //  analysts:				        Ian HAMBLETON
    // 	date last modified	    	    26-APR-2022
    //  algorithm task			        Load dataset

    ** General algorithm set-up
    version 17
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export

    ** DO file path
    local dopath "X:\OneDrive - The University of the West Indies\repo_ianhambleton\repo_w019\"

    ** DATASETS to encrypted SharePoint folder
    local datapath "X:\OneDrive - The University of the West Indies\Writing\w019\data"

    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath "X:\OneDrive - The University of the West Indies\Writing\w019\tech-docs"

    ** REPORTS and Other outputs
    local outputpath "X:\OneDrive - The University of the West Indies\Writing\w019\outputs"

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\read_data_003", replace
** HEADER -----------------------------------------------------

** ---------------------------------------------------
** LOAD AND PREPARE SS FILE
** ---------------------------------------------------
import excel using "`datapath'/Spleen length including 1103 measrements and 1035 'ns' Total 2138.xlsx", first sheet("Sheet1") clear

** Variable organization
rename Pt pid
rename Coh cid
order pid cid 
drop if pid==. 

* participant gender
gen sex = .
replace sex = 1 if Sx=="F" 
replace sex = 2 if Sx=="M" 
label define sex_ 1 "female" 2 "male",modify
label values sex sex_ 

* participant Date of Birth
rename DoB dob

* participant genotype
gen geno = 2
label define geno_ 1 "aa" 2 "ss" 3 "sc" 4 "sb+" 5 "sb0",modify
label values geno geno_

* participant status
replace status = trim(status)
gen stat = 1 if status=="live"
replace stat = 2 if status=="dead" | status=="died"
replace stat = 3 if status=="emig"
label define stat_ 1 "alive" 2 "died" 3 "emigration",modify
label values stat stat_

* participant date of status
rename dtstatus dostat

* participant date of / age at spleen examination
** 31-MAY-2022 : Two new errors
rename dtexam doexam
rename ageex aaexam
replace doexam = d(01feb1998) if pid==43 & doexam==d(01feb2098)
replace doexam = d(01feb1998) if pid==75 & doexam==d(01feb2098)
gen aaexam2 = (doexam - dob)/365.25
order aaexam2, after(aaexam)
drop aaexam
rename aaexam2 aaexam

* spleen length
rename clinispl senlarge
gen t1 = spleenmm
replace t1 = "" if spleenmm=="Not seen"
gen sheight_orig = real(t1) 
gen sheight = sheight_orig 
replace sheight = . if sheight_orig==. 
**replace sheight = . if sheight_orig<40 

* participant weight and height
/// rename Wtkg weight
/// rename Htm height

** 31 MAY 2022 : TWO NEW ERRORS
** ID 33 Ian CAMPBELL
replace pid = 33 if Name == "CAMPBELL Ian"
replace cid = 104 if Name == "CAMPBELL Ian"
replace dob = d(12aug1975) if Name == "CAMPBELL Ian"
replace dostat = d(28aug2021) if Name == "CAMPBELL Ian"
** ID 64 Sophia CAMPBELL
replace pid = 35 if Name == "CAMPBELL Sophia"
replace cid = 64 if Name == "CAMPBELL Sophia"
replace dob = d(02dec1974) if Name == "CAMPBELL Sophia"
replace dostat = d(25aug2021) if Name == "CAMPBELL Sophia"

order sex dob geno weight height stat dostat doexam aaexam sheight senlarge, after(cid) 
drop cid Sx gt status Obs senlarge dostat spleenmm t1 sheight_orig Seen Notseen

rename Alpha alpha
gen hbf = real(HbF10y)
order hbf, after(alpha)
drop HbF10y

rename weight w1
gen weight = real(w1)
rename height h1
gen height = real(h1) 
drop w1 h1

label var pid "Participant ID"
label var sex "Participant sex"
label var dob "Date of birth"
label var geno "Participant genotype"
label var weight "Participant weight (kg)"
label var height "Participant height (m)"
label var stat "Participant status"
label var doexam "Date of participant spleen examination"
label var aaexam "Age (Yrs)"
label var sheight "Spleen length (mm)" 
label var alpha "Alpha thal status (SS only)"
label var hbf "Fetal hemoglobin (SS only)"

** ---------------------------------------------------------------------
** Create several groups according to spleen measurement behavior
** ---------------------------------------------------------------------
/// The entire dataset of 2138 observations contained 1,035 observations listed as ‘not seen’.  The dataset was divided as follows.
/// 					                                    Patients        Measurements        ‘Not seen’
/// (GROUP A): All scans had measurements	                58	            520	                0
/// (GROUP B): Single measurement; rest ‘not seen’	        15	            149	                134
/// (GROUP C): Multiple measurements & ‘not seen’      	    56	            671	                312
///     (group c1): NOT SEEN flanked by measurements
///     (group c2): Repeated measures followed by repeated NS
///     (group c3): late appearance of first numerical figure
///     (group c4): multiple values with several ‘NS’ apparently randomly distributed
/// (GROUP D): Multiple measurements; single ‘not seen’	    21	            230	                21
/// (GROUP E): All scans listed as ‘not seen’	            56	            568	                568
///                                               TOTALS	206	            2,138	            1,035
** ---------------------------------------------------------------------

bysort pid : gen mid = _n 
order mid , after(pid) 

** nvisits:     total number of ultrasound visits
** measured:    does the visit have a measurement (yes/no)
** avail:       number of visits with ultrasound value    
** missing:     does the visit have a missing measurement?

bysort pid : gen nvisits = _N 
gen measured = 0
    bysort pid : replace measured = 1 if sheight<.
    label var measured "Is spleen size available? yes (1) / no (0)" 
    label define measured_ 0 "no" 1 "yes" 
    label values measured measured_ 
bysort pid : egen avail = sum(measured)
bysort pid : egen missingt = count(measured) if measured==0 
replace missingt = 0 if missingt == .
bysort pid : egen missing = max(missingt) 
drop missingt 
label var nvisits "Number of visits by each participant" 
label var measured "Has an individual visit resulted in a spleen measurement (yes/no?)"
label var avail "Number of available measurments for an individual"
label var missing "Number of missing measurments for an individual"

** GROUP A
bysort pid : egen minA = min(measured) 
gen groupA = 0
replace groupA = 1 if avail==nvisits
tab groupA measured if mid==1
drop minA 
label var groupA "Is participant in GroupA"

** GROUP B
gen groupB = 0 
replace groupB = 1 if avail==1 & missing>=1 
tab groupB measured if mid==1
label var groupB "Is participant in GroupB"

** Group C
gen groupC = 0 
replace groupC = 1 if avail>1 & missing>1
tab groupC measured if mid==1
label var groupC "Is participant in GroupC"

** Group D
gen groupD = 0 
replace groupD = 1 if avail>1 & missing==1 
tab groupD measured if mid==1
label var groupD "Is participant in GroupD"

** Group E = 0
gen groupE = 0 
replace groupE = 1 if missing==nvisits 
tab groupE measured if mid==1
label var groupE "Is participant in GroupE"

notes groupA : (GROUP A): All scans had measurements
notes groupB : (GROUP B): Single measurement; rest ‘not seen’
notes groupC : (GROUP C): Multiple measurements & ‘not seen’
notes groupD : (GROUP D): Multiple measurements; single ‘not seen’
notes groupE : (GROUP E): All scans listed as ‘not seen’	

/// ** GROUP C3 (n=7)
/// ** late appearance of first numerical figure
         /// Janice GORDON 
         /// Nadine GRANT
         /// Kenmar NELSON
         /// Sherona SMITH
         /// LisaGay TAYLOR
         /// Dawn THAMES
         /// Martin WALKER
///         gen groupC3=0
///         replace groupC3 = 1 if pid==74
///         replace groupC3 = 1 if pid==76
///         replace groupC3 = 1 if pid==144
///         replace groupC3 = 1 if pid==176
///         replace groupC3 = 1 if pid==185
///         replace groupC3 = 1 if pid==187
///         replace groupC3 = 1 if pid==193
/// 
/// ** GROUP C4 (n=3)
/// ** multiple values with several ‘NS’ apparently randomly distributed
         /// Natasha HAWES 
         /// Coralin MORGAN
         /// Suzette SUCKARIE
///         gen groupC4=0
///         replace groupC4 = 1 if pid==91
///         replace groupC4 = 1 if pid==136
///         replace groupC4 = 1 if pid==181


** -------------------------------------------------------------
** DECISIONS ON THE GROUPS
** -------------------------------------------------------------
** GROUP A : Complete data. Included as is
**
** GROUP B : Single measurement. Included as is
**
** GROUP C/D :  Linear ipolation of missing values flanked by values. 
**              Leave start of series missing data as missing
**              Replace end-of-series data with minimum spleen size (45) 
**
** GROUP E :    No data. Included as is
** -------------------------------------------------------------

** GROUP C/D Ipolate intermittant missing
bysort pid : ipolate sheight doexam , gen(sheight_ip)
replace sheight_ip = 45 if sheight_ip==. & sheight_ip[_n-1]<. & pid==pid[_n-1]
order sheight_ip, after(sheight) 
** GROUP E - all missing - repace with atrophy value
replace sheight_ip = 45 if avail==0 
** ANY values <45 replace with 45
replace sheight_ip = 45 if sheight<45
label var sheight_ip "Spleen length (mm) with small breath / atrophy interpolation (SS and SC only)" 

label data "Spleen size: SCD cohort study Jamaica - SS participants" 
save "`datapath'\spleen_ss_new", replace




** ---------------------------------------------------
** LOAD AND PREPARE SC FILE
** ---------------------------------------------------
import excel using "`datapath'/Spleen length HbSC masterlist n = 1449", first sheet("Sheet1") clear

** Error in ID number - fixing
egen pid = group(Name)
order pid, before(Pt)
drop Pt 
** Variable organization
rename Coh cid
order pid cid 
drop if pid==. 
replace pid = pid+2000

* participant gender
gen sex = .
replace sex = 1 if Sx=="F" 
replace sex = 2 if Sx=="M" 
label define sex_ 1 "female" 2 "male",modify
label values sex sex_ 

* participant Date of Birth
rename Dob dob

* participant genotype
gen geno = 3
label define geno_ 1 "aa" 2 "ss" 3 "sc" 4 "sb+" 5 "sb0",modify
label values geno geno_

* participant status
replace status = trim(status)
gen stat = 1 if status=="live"
replace stat = 2 if status=="dead" | status=="died"
replace stat = 3 if status=="emig"
label define stat_ 1 "alive" 2 "died" 3 "emigration",modify
label values stat stat_

* participant date of status
rename Dtstatus dostat

* participant date of / age at spleen examination
rename Dtexam doexam
rename ageex aaexam

* spleen length
rename splclin senlarge

* spleen length
gen t1 = spleen
replace t1 = "" if spleen=="na"
gen sheight_orig = real(t1) 
gen sheight = sheight_orig 
replace sheight = . if sheight_orig==. 

* participant weight and height
rename Wtkg weight
rename Htm height

rename weight w1
gen weight = real(w1)
drop w1

order sex dob geno weight height stat dostat doexam aaexam sheight senlarge, after(cid) 
drop cid Name Sx gt alpha HbF status totalobs senlarge dostat spleen sheight_orig t1

label var pid "Participant ID"
label var sex "Participant sex"
label var dob "Date of birth"
label var geno "Participant genotype"
label var weight "Participant weight (kg)"
label var height "Participant height (m)"
label var stat "Participant status"
label var doexam "Date of participant spleen examination"
label var aaexam "Age (Yrs)"
label var sheight "Spleen length (mm)" 

** ---------------------------------------------------------------------
** Create several groups according to spleen measurement behavior
** ---------------------------------------------------------------------
/// The entire dataset of 2138 observations contained 1,035 observations listed as ‘not seen’.  The dataset was divided as follows.
/// 					                                    Patients        Measurements        ‘Not seen’
/// (GROUP A): All scans had measurements	                58	            520	                0
/// (GROUP B): Single measurement; rest ‘not seen’	        15	            149	                134
/// (GROUP C): Multiple measurements & ‘not seen’      	    56	            671	                312
///     (group c1): NOT SEEN flanked by measurements
///     (group c2): Repeated measures followed by repeated NS
///     (group c3): late appearance of first numerical figure
///     (group c4): multiple values with several ‘NS’ apparently randomly distributed
/// (GROUP D): Multiple measurements; single ‘not seen’	    21	            230	                21
/// (GROUP E): All scans listed as ‘not seen’	            56	            568	                568
///                                               TOTALS	206	            2,138	            1,035
** ---------------------------------------------------------------------

bysort pid : gen mid = _n 
order mid , after(pid) 

** nvisits:     total number of ultrasound visits
** measured:    does the visit have a measurement (yes/no)
** avail:       number of visits with ultrasound value    
** missing:     does the visit have a missing measurement?

bysort pid : gen nvisits = _N 
gen measured = 0
    bysort pid : replace measured = 1 if sheight<.
    label var measured "Is spleen size available? yes (1) / no (0)" 
    label define measured_ 0 "no" 1 "yes" 
    label values measured measured_ 
bysort pid : egen avail = sum(measured)
bysort pid : egen missingt = count(measured) if measured==0 
replace missingt = 0 if missingt == .
bysort pid : egen missing = max(missingt) 
drop missingt 

** GROUP A
bysort pid : egen minA = min(measured) 
gen groupA = 0
replace groupA = 1 if avail==nvisits
drop minA 
tab groupA measured if mid==1

** GROUP B
gen groupB = 0 
replace groupB = 1 if avail==1 & missing>=1 
tab groupB measured if mid==1

** Group C
gen groupC = 0 
replace groupC = 1 if avail>1 & missing>1
tab groupC measured if mid==1

** Group D
gen groupD = 0 
replace groupD = 1 if avail>1 & missing==1 
tab groupD measured if mid==1

** Group E = 0
gen groupE = 0 
replace groupE = 1 if missing==nvisits 
tab groupE measured if mid==1

** -------------------------------------------------------------
** DECISIONS ON THE GROUPS
** -------------------------------------------------------------
** GROUP A : Complete data. Included as is
**
** GROUP B : Single measurement. Included as is
**
** GROUP C/D :  Linear ipolation of missing values flanked by values. 
**              Leave start of series missing data as missing
**              Replace end-of-series data with minimum spleen size (45) 
**
** GROUP E :    No data. Included as is
** -------------------------------------------------------------

** GROUP C/D Ipolate intermittant missing
bysort pid : ipolate sheight doexam , gen(sheight_ip)
replace sheight_ip = 45 if sheight_ip==. & sheight_ip[_n-1]<. & pid==pid[_n-1]
order sheight_ip, after(sheight) 
** GROUP E - all missing - repace with atrophy value
replace sheight_ip = 45 if avail==0 
** ANY values <45 replace with 45
replace sheight_ip = 45 if sheight<45

label data "Spleen size: SCD cohort study Jamaica - SC participants" 
save "`datapath'\spleen_sc_new", replace

** FINAL DATASET JOIN

** Join the datasets
use "`datapath'\spleen_aa_new", clear
append using "`datapath'\spleen_ss_new"
append using "`datapath'\spleen_sc_new"
append using "`datapath'\spleen_athal"
label data "Spleen size: SCD cohort study Jamaica - AA, SS, SC, S-beta-thal participants" 
** Clean up the dataset - not needed right now 
drop mid Name 
save "`datapath'\spleen_all", replace


** Spleen size adjusted for height in metres
** -saheight- 
gen saheight = sheight / height
order saheight , after(sheight_ip)
label var saheight "Spleen length (mm) / height (m) (no interpolation)"





** Clean up the dataset - not needed right now 
label data "Spleen size: SCD cohort study Jamaica - AA, SS, SC, S-beta-thal participants" 
save "`datapath'\spleen_all_20jun2022", replace
