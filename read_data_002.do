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
import excel using "`datapath'/Spleen length AA masterlist CORRECT IRH.xlsx", first sheet("Sheet1") clear

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
* rename dtstatus dostat

* participant date of / age at spleen examination
rename dtexam doexam
rename Ageexam aaexam

* spleen volume
rename spleen sheight 
* rename splcm senlarge

* participant weight and height
rename Wtkg weight
rename Htm height

order sex dob geno weight height stat doexam aaexam sheight, after(cid) 
drop cid Name Sx gt Alpha status

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
save "`datapath'\spleen_aa_new", replace



** Join the datasets
use "`datapath'\spleen_aa_new", clear
append using "`datapath'\spleen_ss"
append using "`datapath'\spleen_sc"
append using "`datapath'\spleen_athal"
label data "Spleen size: SCD cohort study Jamaica - AA, SS, SC, S-beta-thal participants" 
save "`datapath'\spleen_all", replace







