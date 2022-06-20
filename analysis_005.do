** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			        analysis_004.do
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
    log using "`logpath'\analysis_004", replace
** HEADER -----------------------------------------------------

** ---------------------------------------------------
** LOAD ANALYSIS FILE
** ---------------------------------------------------
use "`datapath'\spleen_all", clear

** Spleen lengths used for different purposes

** Spleen size adjusted for height in metres
gen saheight = sheight / height
order saheight , after(sheight)
label var saheight "Spleen length divided by height (m)"

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

** Tempfile
tempfile regress
save `regress', replace


** THE REGRESSION HAS A FEW COMPLICATIONS


** Regression for spleen volume by age
use `regress', clear
keep if geno==1 | geno==2 | geno==3
sort pid doexam 
bysort pid : ipolate height doexam , epolate gen(height_ip)

** Outcome variable
gen saheight_ip = sheight_ip / height_ip 
** Censort variable = 1 if sheight_ip == 45
gen lcensor = 0 
replace lcensor = 1 if sheight_ip == 45 
gen lcensor_val = 45 / height_ip 


** Spleen length = 45 unadjusted for height if the spleen is unmeasurable
** We need to adjust this down so that a sensible lower bound exists for adjusted spleen length
** and which then allows for an adjusted figure to be used
gen ayear = int(aaexam)
table (geno ayear), stat(mean height)
bysort geno ayear : egen mht = mean(height)
order geno ayear mht, after(height)

** Add AA and SC to outcome
replace sheight_ip = sheight if geno==1 | geno==3
gen saheight_reg = sheight_ip / height_ip
order height_ip saheight_ip lcensor lcensor_val saheight_reg, after(sheight_ip) 

** AA, SS, SC observed means
table agroups if geno==1 & agroups>=3 & agroups<=8, stat(mean saheight_reg)
table agroups if geno==2 & agroups>=3 & agroups<=8, stat(mean saheight_reg)
table agroups if geno==3 & agroups>=3 & agroups<=8, stat(mean saheight_reg)

sort pid doexam
xtset pid 


** TABLE FOR SS PAPER
drop if geno==3 

** XTREG. No height adjustment
xtreg saheight_reg c.aaexam##geno if geno<=2 & aaexam>=12 & aaexam<=22 
 	* genotype difference
 	margins geno, at(aaexam=(12(2)22)) vsquish
 	marginsplot, x(aaexam) name(xtreg)  ylab(0(20)80)
 	** Test of genotype differences at various ages
 	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

** FINAL TOBIT MODEL
** TOBIT: Adjusted for height
* Relative to AA
xttobit saheight_reg c.aaexam##geno if aaexam>=12 & aaexam<=22 , ll(lcensor_val)
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(tobit)  ylab(0(20)80)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish



** Effect of athal and HbF in SS
** hbf and alpha for SS only
xtreg saheight_reg c.aaexam hbf i.alpha if geno==2 & aaexam>=12 & aaexam<=22 
 	* genotype difference
 	margins alpha, at(aaexam=(12(2)22)) vsquish
 	marginsplot, x(aaexam) name(xtreg_ss)  ylab(0(20)80)
 	** Test of genotype differences at various ages
 	margins, dydx(alpha) at(aaexam=(12(2)22)) vsquish




** EFFECT OF HBF and ALPHA-THAL AMONG SS PARTICIPANTS
** hbf and alpha for SS only
xttobit saheight_reg c.aaexam hbf i.alpha if geno==2 & aaexam>=12 & aaexam<=22 , ll(lcensor_val)
margins alpha, at(aaexam=(12(2)22)) vsquish
marginsplot, x(aaexam) name(tobit_ss)  ylab(0(20)80)
** Test of genotype differences at various ages
margins, dydx(alpha) at(aaexam=(12(2)22)) vsquish







/*


** EVIDENCE FOR TWO POPULATIONS AMONG SC DISEASE?
keep if geno==3
sort pid doexam
collapse (mean) saheight saheight_reg, by(pid ayear)
xtset pid ayear

xtdescribe 
xtsum

tempfile long
save `long', replace

** Collapse to cross-sectional
collapse (mean) saheight saheight_reg, by(pid)
cluster kmeans saheight_reg, k(2) name(pd1)
gen pd2 = pd1 - 1
if pd2 == 0 {
    gen cluster = pd1
    }
else if pd2 == 1 {
    gen cluster = pd1
    recode cluster 1=2 2=1
}


table cluster, stat(mean saheight)
keep pid cluster
merge 1:m pid using `long'
drop _merge
sort pid ayear 

** minor smooth of the indiviual profiles
	bysort pid : asrol saheight_reg 	, stat(median) perc(.25) window(ayear 3) gen(sm_p25)
	bysort pid : asrol saheight_reg 	, stat(median) window(ayear 3) gen(sm_p50)
	bysort pid : asrol saheight_reg 	, stat(median) perc(.75) window(ayear 3) gen(sm_p75)

** Cluster summaries
    bysort cluster ayear : egen cl_p50 = median(saheight_reg)
    bysort cluster ayear : egen cl_p25 = pctile(saheight_reg), p(25)
    bysort cluster ayear : egen cl_p75 = pctile(saheight_reg), p(75)

** Join
sort cluster pid ayear


** Color scheme
colorpalette d3, 20 n(20) nograph
local list r(p) 
** Blue 
local blu1 `r(p1)'
local blu2 `r(p2)'
** Red
local red1 `r(p7)'
local red2 `r(p8)'
** Gray
local gry1 `r(p15)'
local gry2 `r(p16)'
** Orange
local ora1 `r(p3)'
local ora2 `r(p4)'
** Purple
local pur1 `r(p9)'
local pur2 `r(p10)'

#delimit ;
	gr twoway
        /// Cluster 2
        (line sm_p50 ayear if pid==2001, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2002, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2003, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2004, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2005, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2006, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2008, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2009, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2013, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2014, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2016, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2020, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2021, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2022, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2023, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2026, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2027, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2028, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2029, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2030, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2034, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2035, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2036, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2037, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2039, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2042, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2043, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2044, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2045, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2048, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2049, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2050, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2051, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2053, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2055, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2056, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2057, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2058, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2059, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2060, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2064, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2065, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2066, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2081, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2086, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2092, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2096, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2100, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2102, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2103, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2106, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2107, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2113, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2118, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2127, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2129, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2130, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2131, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2135, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2137, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2138, lc("`ora1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2140, lc("`ora1'%20") lw(0.1) lp(l) )
        
        /// Cluster 1
        (line sm_p50 ayear if pid==2007, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2010, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2011, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2012, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2015, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2017, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2018, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2019, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2024, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2025, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2031, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2032, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2033, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2038, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2040, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2041, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2046, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2047, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2052, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2054, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2061, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2062, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2063, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2067, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2068, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2069, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2070, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2071, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2078, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2079, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2097, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2099, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2101, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2104, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2111, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2115, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2125, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2126, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2133, lc("`pur1'%20") lw(0.1) lp(l) )
        (line sm_p50 ayear if pid==2136, lc("`pur1'%20") lw(0.1) lp(l) )


        /// Higher
        (line cl_p50 ayear          if cluster==1, sort lc("`ora1'%80") lw(0.2) lp(l) )
		(rarea cl_p25 cl_p75 ayear  if cluster==1 , sort fc("`ora2'%60") lw(none) )

        /// Lower
        (line cl_p50 ayear          if cluster==2, sort lc("`pur1'%80") lw(0.2) lp(l) )
		(rarea cl_p25 cl_p75 ayear  if cluster==2 , sort fc("`pur2'%60") lw(none) )

		,
            
            plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            ysize(16) xsize(16)

			xlab(5(5)25
			,
			valuelabel labgap(1) labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			xscale( lw(vthin))
			xtitle("Age (years)", size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
            xmtick(5(1)25)

			ylab(20(20)120
			,
			valuelabel labgap(1) labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) )
			ytitle("Spleen length (mm) / Height (m)", size(2.5) margin(l=2 r=2 t=2 b=2))
            ymtick(20(10)120)

			/// text(-0.3 25.5 "{bf: WHO Progress Indicator}",  size(2.5) color(gs0) just(center))
			/// text(35 55 "WHO" "Progress" "Score",  size(2.5) color(gs10) just(center))

			legend(off size(4) position(11) ring(0) bm(t=1 b=1 l=1 r=0) colf cols(3)
			region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
			order(1 2 3)
			lab(1 "SC")
			lab(2 "SS")
			lab(3 "AA")
            )
			name(cluster)
            ;
		graph export "`outputpath'/sc_clusters.png", replace width(4000);
#delimit cr


** ------------------------------------------------------
** PDF REGIONAL REPORT (COUNTS OF CONFIRMED CASES)
** ------------------------------------------------------
    putpdf begin, pagesize(letter) font("Times New Roman", 11) margin(top,0.5cm) margin(bottom,0.25cm) margin(left,0.5cm) margin(right,0.25cm)
** PAGE 1. INTRODUCTION
    putpdf paragraph ,  font("Times New Roman", 11)
    putpdf text ("Figure. ") , bold
    putpdf text ("Two clusters of SC participants. Larger spleen cluster (orange, n=55), smaller spleen cluster (purple, n=47)")
** PAGE 1. FIGURE OF DAILY COVID-19 COUNT
    putpdf table f1 = (1,1), width(85%) border(all,nil) halign(center)
    putpdf table f1(1,1)=image("`outputpath'/sc_clusters.png")


** Save the PDF
    local c_date = c(current_date)
    local date_string = subinstr("`c_date'", " ", "", .)
    putpdf save "`outputpath'/SC_clusters_`date_string'", replace


