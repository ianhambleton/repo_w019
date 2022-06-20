** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			        analysis_010_ss_paper_tables.do
    //  project:		                SCD Spleeen size
    //  analysts:				        Ian HAMBLETON
    // 	date last modified	    	    26-APR-2022
    //  algorithm task			        Initial analysis

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
    log using "`logpath'\analysis_010_ss_paper_tables", replace
** HEADER -----------------------------------------------------

** ---------------------------------------------------
** LOAD ANALYSIS FILE
**	 File created in
**	 read_data_001.do: 
**			spleen_aa_old
**			spleen_ss_old
**			spleen_sc_old
**			spleen_athal
**	 read_data_002.do: 
**			spleen_aa_new
**	 read_data_003.do: 
**			spleen_ss_new
**	 read_data_004.do: 
**			spleen_ss_new (repeat)
**			spleen_sc_new
**			JOIN the four files
**			aa_new / ss_new / sc_new / athal
** ---------------------------------------------------
use "`datapath'\spleen_all_20jun2022", clear



** ------------------------------------------------------
** DESCRIPTIVE TABLES BY GENOTYPE and BY AGE
** ------------------------------------------------------

** A. Collapse -aaexam- into summary groups : by 
	** 2-year age groups
	** genotype
	** sex
keep if aaexam >=6
gen agroups = .
replace agroups = 1 if aaexam >=6 & aaexam<8
replace agroups = 2 if aaexam >=8 & aaexam<10
replace agroups = 3 if aaexam >=10 & aaexam<12
replace agroups = 4 if aaexam >=12 & aaexam<14
replace agroups = 5 if aaexam >=14 & aaexam<16
replace agroups = 6 if aaexam >=16 & aaexam<18
replace agroups = 7 if aaexam >=18 & aaexam<20
replace agroups = 8 if aaexam >=20 & aaexam<22
replace agroups = 9 if aaexam >=22 & aaexam<24
replace agroups = 10 if aaexam >=24
label define agroups_ 1 "6-8" 2 "8-10" 3 "10-12" 4 "12-14" 5 "14-16" 6 "16-18" 7 "18-20" 8 "20-22" 9 "22-24" 10 "24+", modify
label values agroups agroups_ 

** B. Count the number of observations (nobs) and number of individuals (nparts)
gen nobs = 1
sort pid agroups
egen npart1 = group(pid agroups)
gen npart = npart1 - npart1[_n-1]
replace npart = 1 if _n==1
drop npart1
** Count the number of observations for which the spleen was scannable
gen navail = 1 if sheight<.

#delimit ; 
		collapse 	(sum) sheight_obs=nobs
					(sum) sheight_par=npart
					(sum) sheight_av=navail
					(mean) sheight_m=sheight 
					(sd) sheight_sd=sheight 
					(p50) sheight_p50=sheight 
					(p25) sheight_p25=sheight 
					(p75) sheight_p75=sheight 
					(p5) sheight_p5=sheight 
					(p95) sheight_p95=sheight 
					, by(geno sex agroups);
#delimit cr

** Fillin age groups with no observations
fillin geno sex agroup


** ----------------------------------------------------
** B. Word document
** ----------------------------------------------------


** ----------------------------------------------------
** SS table
** ----------------------------------------------------
preserve
	keep if geno==2
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_par Participants
	rename sheight_obs Scanned
	rename sheight_av Available
	rename sheight_m Mean
	rename sheight_sd SD
	rename sheight_p50 Median
	rename sheight_p5 p5
	rename sheight_p95 p95
	format Mean %5.1fc 
	format SD %5.1fc 

	** Begin Table 
	putdocx begin , font(calibri light, 10)
	putdocx paragraph 
		putdocx text ("Table "), bold
		putdocx text ("Spleen length among SS participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Participants Scanned Available Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Available"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,10) = ("95th percentile"),  font(calibri light,10, "000000")
		///putdocx table ss(2,1) = ("Female"),  font(calibri light,10, "000000")
		putdocx table ss(3,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(4,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(5,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(6,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(7,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(8,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(9,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(10,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(11,1) = (" "),  font(calibri light,10, "000000")
		///putdocx table ss(12,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(13,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(14,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(15,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(16,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(17,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(18,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(19,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(20,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(21,1) = (" "),  font(calibri light,10, "000000")

	** Save the Table
	putdocx save "`outputpath'/genotype_tables", replace 
restore


** ----------------------------------------------------
** SC table
** ----------------------------------------------------
preserve
	keep if geno==3
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_par Participants
	rename sheight_obs Scanned
	rename sheight_av Available
	rename sheight_m Mean
	rename sheight_sd SD
	rename sheight_p50 Median
	rename sheight_p5 p5
	rename sheight_p95 p95
	format Mean %5.1fc 
	format SD %5.1fc 

	** Begin Table 
	putdocx begin , font(calibri light, 10)
	putdocx paragraph 
		putdocx text ("Table "), bold
		putdocx text ("Spleen length among SC participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Participants Scanned Available Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Available"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,10) = ("95th percentile"),  font(calibri light,10, "000000")
		///putdocx table ss(2,1) = ("Female"),  font(calibri light,10, "000000")
		putdocx table ss(3,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(4,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(5,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(6,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(7,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(8,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(9,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(10,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(11,1) = (" "),  font(calibri light,10, "000000")
		///putdocx table ss(12,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(13,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(14,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(15,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(16,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(17,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(18,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(19,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(20,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(21,1) = (" "),  font(calibri light,10, "000000")

		putdocx save tsc , replace
restore


** ----------------------------------------------------
** Alpha-thal + table
** ----------------------------------------------------
preserve
	keep if geno==4
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_par Participants
	rename sheight_obs Scanned
	rename sheight_av Available
	rename sheight_m Mean
	rename sheight_sd SD
	rename sheight_p50 Median
	rename sheight_p5 p5
	rename sheight_p95 p95
	format Mean %5.1fc 
	format SD %5.1fc 

	** Begin Table 
	putdocx begin , font(calibri light, 10)
	putdocx paragraph 
		putdocx text ("Table "), bold
		putdocx text ("Spleen length among Beta-thal + participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Participants Scanned Available Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Available"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,10) = ("95th percentile"),  font(calibri light,10, "000000")
		///putdocx table ss(2,1) = ("Female"),  font(calibri light,10, "000000")
		putdocx table ss(3,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(4,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(5,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(6,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(7,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(8,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(9,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(10,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(11,1) = (" "),  font(calibri light,10, "000000")
		///putdocx table ss(12,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(13,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(14,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(15,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(16,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(17,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(18,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(19,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(20,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(21,1) = (" "),  font(calibri light,10, "000000")
		putdocx save tatp , replace
restore

** ----------------------------------------------------
** Alpha-thal 0 table
** ----------------------------------------------------
preserve
	keep if geno==5
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_par Participants
	rename sheight_obs Scanned
	rename sheight_av Available
	rename sheight_m Mean
	rename sheight_sd SD
	rename sheight_p50 Median
	rename sheight_p5 p5
	rename sheight_p95 p95
	format Mean %5.1fc 
	format SD %5.1fc 

	** Begin Table 
	putdocx begin , font(calibri light, 10)
	putdocx paragraph 
		putdocx text ("Table "), bold
		putdocx text ("Spleen length among Beta-thal 0 participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Participants Scanned Available Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Available"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,10) = ("95th percentile"),  font(calibri light,10, "000000")
		///putdocx table ss(2,1) = ("Female"),  font(calibri light,10, "000000")
		putdocx table ss(3,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(4,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(5,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(6,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(7,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(8,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(9,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(10,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(11,1) = (" "),  font(calibri light,10, "000000")
		///putdocx table ss(12,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(13,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(14,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(15,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(16,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(17,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(18,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(19,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(20,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(21,1) = (" "),  font(calibri light,10, "000000")

		putdocx save tat0 , replace
restore

** ----------------------------------------------------
** AA table
** ----------------------------------------------------
preserve
	keep if geno==1
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_par Participants
	rename sheight_obs Scanned
	rename sheight_av Available
	rename sheight_m Mean
	rename sheight_sd SD
	rename sheight_p50 Median
	rename sheight_p5 p5
	rename sheight_p95 p95
	format Mean %5.1fc 
	format SD %5.1fc 

	** Begin Table 
	putdocx begin , font(calibri light, 10)
	putdocx paragraph 
		putdocx text ("Table "), bold
		putdocx text ("Spleen length among AA participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Participants Scanned Available Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Available"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,10) = ("95th percentile"),  font(calibri light,10, "000000")
		///putdocx table ss(2,1) = ("Female"),  font(calibri light,10, "000000")
		putdocx table ss(3,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(4,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(5,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(6,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(7,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(8,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(9,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(10,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(11,1) = (" "),  font(calibri light,10, "000000")
		///putdocx table ss(12,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(13,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(14,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(15,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(16,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(17,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(18,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(19,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(20,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(21,1) = (" "),  font(calibri light,10, "000000")

		putdocx save taa , replace
restore


** Append the TABLES
putdocx append "`outputpath'/genotype_tables" taa tsc tatp tat0


