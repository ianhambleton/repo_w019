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
import excel using "`datapath'/Spleen length including 1103 measrements and 1036 'ns' Total 2139.xlsx", first sheet("Sheet1") clear

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
replace sheight = . if sheight_orig<40 

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
drop cid Name Sx gt Alpha HbF10y status Obs R senlarge dostat spleenmm t1 sheight_orig

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
save "`datapath'\spleen_ss_new", replace


** Join the datasets
use "`datapath'\spleen_aa_new", clear
append using "`datapath'\spleen_ss_new"
append using "`datapath'\spleen_sc"
append using "`datapath'\spleen_athal"
label data "Spleen size: SCD cohort study Jamaica - AA, SS, SC, S-beta-thal participants" 
save "`datapath'\spleen_all", replace





