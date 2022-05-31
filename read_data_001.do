** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			        read_data_001.do
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
    log using "`logpath'\read_data_001", replace
** HEADER -----------------------------------------------------

** ---------------------------------------------------
** LOAD AND PREPARE AA FILE
** ---------------------------------------------------
import excel using "`datapath'/Spleen length HbAA masterlist, n=128.xlsx", first sheet("Sheet1") clear

** Variable organization
rename Pt pid
replace pid = pid+500
rename Coh cid
order pid cid 

* participant gender
gen sex = .
replace sex = 1 if Sx=="F" 
replace sex = 2 if Sx=="M" 
label define sex_ 1 "female" 2 "male",modify
label values sex sex_ 

* participant Date of Birth
rename DoB dob

* participant genotype
gen geno = 1
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
rename dtexam doexam
rename ageex aaexam

* spleen volume
rename spleen sheight 
rename splcm senlarge

* participant weight and height
rename Wtkg weight
rename Htm height

order sex dob geno weight height stat dostat doexam aaexam sheight senlarge, after(cid) 
drop cid Name Sx gt Alpha HbF10y status totalobs R S T U senlarge dostat

label var pid "Participant ID"
label var sex "Participant sex"
label var dob "Date of birth"
label var geno "Participant genotype"
label var weight "Participant weight (kg)"
label var height "Participant height (m)"
label var stat "Participant status"
label var doexam "Date of participant spleen examination"
label var aaexam "Age at participant spleen examination (in years)"
label var sheight "Spleen length (cm)" 

label data "Spleen size: SCD cohort study Jamaica - AA controls" 
save "`datapath'\spleen_aa_old", replace





** ---------------------------------------------------
** LOAD AND PREPARE SS FILE
** ---------------------------------------------------
import excel using "`datapath'/Spleen length HbSS masterlist n = 1103.xlsx", first sheet("Sheet1") clear

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
rename dtexam doexam
rename ageex aaexam

* spleen length
rename spleen sheight 
rename splcm senlarge

* participant weight and height
rename Wtkg weight
rename Htm height

order sex dob geno weight height stat dostat doexam aaexam sheight senlarge, after(cid) 
drop cid Name Sx gt Alpha HbF10y status totalobs R S T U senlarge dostat

label var pid "Participant ID"
label var sex "Participant sex"
label var dob "Date of birth"
label var geno "Participant genotype"
label var weight "Participant weight (kg)"
label var height "Participant height (m)"
label var stat "Participant status"
label var doexam "Date of participant spleen examination"
label var aaexam "Age at participant spleen examination (in years)"
label var sheight "Spleen length (cm)" 

label data "Spleen size: SCD cohort study Jamaica - SS participants" 
save "`datapath'\spleen_ss_old", replace






** ---------------------------------------------------
** LOAD AND PREPARE SC FILE
** ---------------------------------------------------
import excel using "`datapath'/Spleen length HbSC masterlist n = 1379", first sheet("Sheet1") clear

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
rename spleen sheight 
rename splclin senlarge

* participant weight and height
rename Wtkg weight
rename Htm height

order sex dob geno weight height stat dostat doexam aaexam sheight senlarge, after(cid) 
drop cid Name Sx gt alpha HbF status totalobs senlarge dostat

label var pid "Participant ID"
label var sex "Participant sex"
label var dob "Date of birth"
label var geno "Participant genotype"
label var weight "Participant weight (kg)"
label var height "Participant height (m)"
label var stat "Participant status"
label var doexam "Date of participant spleen examination"
label var aaexam "Age at participant spleen examination (in years)"
label var sheight "Spleen length (cm)" 

label data "Spleen size: SCD cohort study Jamaica - SC participants" 
save "`datapath'\spleen_sc", replace




** ---------------------------------------------------
** LOAD AND PREPARE Alpha Thal FILE
** ---------------------------------------------------
import excel using "`datapath'/Spleen length HbSbeta thal masterlist n = 397", first sheet("Sheet1") clear

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
gen geno = 4 if gt=="Sb+"
replace geno = 5 if gt=="Sbo"
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
rename dtexam doexam
rename ageex aaexam

* spleen length
rename spleen sheight 
rename splcm senlarge

* participant weight and height
rename Wtkg weight
rename Htm height

order sex dob geno weight height stat dostat doexam aaexam sheight senlarge, after(cid) 
drop cid Name Sx gt alpha HbF status totalobs R-AA senlarge dostat

label var pid "Participant ID"
label var sex "Participant sex"
label var dob "Date of birth"
label var geno "Participant genotype"
label var weight "Participant weight (kg)"
label var height "Participant height (m)"
label var stat "Participant status"
label var doexam "Date of participant spleen examination"
label var aaexam "Age at participant spleen examination (in years)"
label var sheight "Spleen length (cm)" 

label data "Spleen size: SCD cohort study Jamaica - Alpha Thal participants" 
save "`datapath'\spleen_athal", replace



