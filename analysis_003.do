** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			        analysis_001.do
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
    log using "`logpath'\analysis_001", replace
** HEADER -----------------------------------------------------

** ---------------------------------------------------
** LOAD ANALYSIS FILE
** ---------------------------------------------------
use "`datapath'\spleen_all", clear

** Spleen size adjusted for height in metres
gen saheight = sheight / height
order saheight , after(sheight)
label var saheight "Spleen length divided by height (m)"




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


** Color scheme 2
colorpalette d3, 20c n(20) nograph
local list r(p) 
** Blue 
local ss1 `r(p1)'
local ss2 `r(p2)'
local ss3 `r(p3)'
local ss4 `r(p4)'
** Red
local aa1 `r(p5)'
local aa2 `r(p6)'
local aa3 `r(p7)'
local aa4 `r(p8)'
** Green
local sc1 `r(p9)'
local sc2 `r(p10)'
local sc3 `r(p11)'
local sc4 `r(p12)'
/*
#delimit ;
	gr twoway
        /// AA
        (sc sheight aaexam if geno==3,  msize(2) m(o) mlc(gs10) mfc("`ora1'%60") mlw(0.1))
        (sc sheight aaexam if geno==2,  msize(2) m(o) mlc(gs10) mfc("`blu1'%20") mlw(0.1))
        (sc sheight aaexam if geno==1,  msize(2) m(o) mlc(gs10) mfc("`red1'%75") mlw(0.1))
        /// (sc saheight aaexam if geno==2,  msize(2) m(o) mlc(gs10) mfc("`blu1'%80") mlw(0.1))
        /// (sc saheight aaexam if geno==1,  msize(2) m(o) mlc(gs10) mfc("`red1'%95") mlw(0.1))
		,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            ysize(16) xsize(16)

			xlab(0(5)30
			,
			valuelabel labgap(1) labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			xscale( lw(vthin))
			xtitle("Age (years)", size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
            xmtick(0(1)30)

			ylab(0(50)200
			,
			valuelabel labgap(1) labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) range(1(1)9))
			ytitle("Spleen length (mm)", size(2.5) margin(l=2 r=2 t=2 b=2))
            ymtick(0(10)220)

			/// text(-0.3 25.5 "{bf: WHO Progress Indicator}",  size(2.5) color(gs0) just(center))
			/// text(35 55 "WHO" "Progress" "Score",  size(2.5) color(gs10) just(center))

			legend(size(4) position(11) ring(0) bm(t=1 b=1 l=1 r=0) colf cols(3)
			region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
			order(1 2 3)
			lab(1 "SC")
			lab(2 "SS")
			lab(3 "AA")
            )
			name(spleen_length_unadj)
            ;
#delimit cr



#delimit ;
	gr twoway
        /// AA
        /// (sc sheight aaexam if geno==2,  msize(2) m(o) mlc(gs10) mfc("`blu1'%10") mlw(0.1))
        /// (sc sheight aaexam if geno==1,  msize(2) m(o) mlc(gs10) mfc("`red1'%10") mlw(0.1))
        (sc saheight aaexam if geno==3,  msize(2) m(o) mlc(gs10) mfc("`ora1'%60") mlw(0.1))
        (sc saheight aaexam if geno==2,  msize(2) m(o) mlc(gs10) mfc("`blu1'%20") mlw(0.1))
        (sc saheight aaexam if geno==1,  msize(2) m(o) mlc(gs10) mfc("`red1'%75") mlw(0.1))

		,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            ysize(16) xsize(16)

			xlab(0(5)30
			,
			valuelabel labgap(1) labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			xscale( lw(vthin))
			xtitle("Age (years)", size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
            xmtick(0(1)30)

			ylab(0(50)200
			,
			valuelabel labgap(1) labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) range(1(1)9))
			ytitle("Spleen length (mm)", size(2.5) margin(l=2 r=2 t=2 b=2))
            ymtick(0(10)220)

			/// text(-0.3 25.5 "{bf: WHO Progress Indicator}",  size(2.5) color(gs0) just(center))
			/// text(35 55 "WHO" "Progress" "Score",  size(2.5) color(gs10) just(center))

			legend(size(4) position(11) ring(0) bm(t=1 b=1 l=1 r=0) colf cols(3)
			region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
			order(1 2 3)
			lab(1 "SC")
			lab(2 "SS")
			lab(3 "AA")
            )
			name(spleen_length_adj)
            ;
#delimit cr




** Age groups
** A. Collapse -aaexam- into summary groups : by 
	** 2-year age groups
	** genotype
	** sex
preserve
	keep if aaexam >=12 & aaexam<=24 
	gen agroups = .
	replace agroups = 1 if aaexam >=12 & aaexam<16
	replace agroups = 2 if aaexam >=16 & aaexam<20
	replace agroups = 3 if aaexam >=20 & aaexam<24
	label define agroups_ 1 "12-16" 2 "16-20" 3 "20-24", modify
	label values agroups agroups_ 

	** Box and Whisker - unadjusted
	** SS and AA only
	keep if geno==1 | geno==2 | geno==3
	egen gid = group(pid geno agroup) 
	keep gid sheight saheight geno agroup
	collapse (mean) sheight saheight, by(gid agroups geno) 
	reshape wide sheight saheight, i(gid geno) j(agroups)
	reshape wide sheight1 sheight2 sheight3   saheight1 saheight2 saheight3  , i(gid) j(geno)
	** 11 	12-16 (AA)
	** 21 	16-20 (AA)
	** 31 	20-24 (AA)
	** 12 	12-16 (AA)
	** 22 	16-20 (AA)
	** 32 	20-24 (AA)


	** Unadjusted spleen length
    #delimit ;
    gr hbox sheight12 sheight22 sheight32 sheight11 sheight21 sheight31 sheight13 sheight23 sheight33 
	    , 
		medtype(cline) medline(lc(gs16) lw(0.5) ) 

        box(1, lc("`blu1'") fc("`blu1'") )
        box(2, lc("`blu1'%75") fc("`blu1'%75") )
        box(3, lc("`blu2'") fc("`blu2'") )

        box(4, lc("`red1'") fc("`red1'") )
        box(5, lc("`red1'%75") fc("`red1'%75") )
        box(6, lc("`red2'") fc("`red2'") )
        box(7, lc("`ora1'") fc("`ora1'") )
        box(8, lc("`ora1'%75") fc("`ora1'%75") )
        box(9, lc("`ora2'") fc("`ora2'") )

        marker(1, mlc("`blu1'") mfc("`blu1'") m(o))
        marker(2, mlc("`blu1'%75") mfc("`blu1'%75")  m(o))
        marker(3, mlc("`blu2'") mfc("`blu2'")  m(o))
        marker(4, mlc("`red1'") mfc("`red1'")  m(o))
        marker(5, mlc("`red1'%75") mfc("`red1'%75")  m(o))
        marker(6, mlc("`red2'") mfc("`red2'")  m(o))
        marker(7, mlc("`ora1'") mfc("`ora1'")  m(o))
        marker(8, mlc("`ora1'%75") mfc("`ora1'%75")  m(o))
        marker(9, mlc("`ora2'") mfc("`ora2'")  m(o))

        plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
        graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
        ysize(8) xsize(12)

        ylab(,
                labc(gs8) labs(4) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0fc) labgap(1))    
        /// yscale(range(-2500(100)1010))
        ytitle(" ", size(5) color(gs8) margin(l=0 r=0 t=5 b=0)) 

        legend(order(1 2 3 4 5 6 7 8 9) 
        label(1 "SS (12-16 yrs)")  
        label(2 "SS (16-20)") 
        label(3 "SS (20-24)") 
        label(4 "AA (12-16 yrs)")  
        label(5 "AA (16-20)") 
        label(6 "AA (20-24)") 
        label(7 "SC (12-16 yrs)")    
        label(8 "SC (16-20)") 
        label(9 "SC (20-24)") 
        cols(3) position(6) margin(t=0) size(3.5) symxsize(6) symysize(4) color("gs8")
        )

        name(bw_unadj)
    ;
    #delimit cr


	** Adjusted spleen length (spleen length / participant height)
    #delimit ;
    gr hbox saheight12 saheight22 saheight32   saheight11 saheight21 saheight31  saheight13 saheight23 saheight33  
	    , 
		medtype(cline) medline(lc(gs16) lw(0.5) ) 

        box(1, lc("`blu1'") fc("`blu1'") )
        box(2, lc("`blu1'%75") fc("`blu1'%75") )
        box(3, lc("`blu2'") fc("`blu2'") )
        box(4, lc("`red1'") fc("`red1'") )
        box(5, lc("`red1'%75") fc("`red1'%75") )
        box(6, lc("`red2'") fc("`red2'") )
        box(7, lc("`ora1'") fc("`ora1'") )
        box(8, lc("`ora1'%75") fc("`ora1'%75") )
        box(9, lc("`ora2'") fc("`ora2'") )

        marker(1, mlc("`blu1'") mfc("`blu1'") m(o))
        marker(2, mlc("`blu1'%75") mfc("`blu1'%75")  m(o))
        marker(3, mlc("`blu2'") mfc("`blu2'")  m(o))
        marker(4, mlc("`red1'") mfc("`red1'")  m(o))
        marker(5, mlc("`red1'%75") mfc("`red1'%75")  m(o))
        marker(6, mlc("`red2'") mfc("`red2'")  m(o))
        marker(7, mlc("`ora1'") mfc("`ora1'")  m(o))
        marker(8, mlc("`ora1'%75") mfc("`ora1'%75")  m(o))
        marker(9, mlc("`ora2'") mfc("`ora2'")  m(o))

        plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
        graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
        ysize(8) xsize(12)

        ylab(,
                labc(gs8) labs(4) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0fc) labgap(1))    
        /// yscale(range(-2500(100)1010))
        ytitle(" ", size(5) color(gs8) margin(l=0 r=0 t=5 b=0)) 

        /// text(5 20 "Caribbean" , place(w) size(5) color("gs8") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(5 9 "Rest of the Americas" , place(w) size(5) color("gs8") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(5 58 "Caribbean" , place(w) size(5) color("gs8") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(5 47 "Rest of the Americas" , place(w) size(5) color("gs8") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(5 96 "Caribbean" , place(w) size(5) color("gs8") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(5 85 "Rest of the Americas" , place(w) size(5) color("gs8") just(left) margin(l=0 r=1 t=4 b=2))

        /// text(8700 97  "Guyana" , place(e) size(5) color("`cvd2'") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(10000 87  "Haiti" , place(e) size(5) color("`cvd2'") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(4100 46  "Uruguay" , place(e) size(5) color("`can2'") just(left) margin(l=0 r=1 t=4 b=2))
        /// text(2800 8  "Mexico" , place(e) size(5) color("`dia2'") just(left) margin(l=0 r=1 t=4 b=2))

        legend(order(1 2 3 4 5 6 7 8 9 ) 
        label(1 "SS (12-16 yrs)")  
        label(2 "SS (16-20)") 
        label(3 "SS (20-24)") 
        label(4 "AA (12-16 yrs)")  
        label(5 "AA (16-20)") 
        label(6 "AA (20-24)") 
        label(7 "SC (12-16 yrs)")  
        label(8 "SC (16-20)") 
        label(9 "SC (20-24)") 
        cols(3) position(6) margin(t=0) size(3.5) symxsize(6) symysize(4) color("gs8")
        )

        name(bw_adj)
    ;
    #delimit cr
	
restore

*/

** Figure 3 PROFILES

** FEMALES: Unadjusted spleen length
preserve
		** 2-year age groups
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
			replace agroups = 10 if aaexam >=24 & aaexam<27


		sort geno sex aaexam 

			#delimit ; 
			label define agroups_ 	1 "6-8" 
									2 "8-10" 
									3 "10-12"
									4 "12-14"
									5 "14-16"
									6 "16-18"
									7 "18-20"
									8 "20-22"
									9 "22-24"
									10 "24+"
									, modify;
			#delimit cr
			label values agroups agroups_ 

		** Collapse into 2 year windows - mostly because of AA limited numbers
		gen part = 1
		#delimit ; 
		collapse 		(mean) sh_m=sheight sah_m=saheight 
						(sum) sh_c = part 
						(sd) sh_sd=sheight sah_sd=saheight
						(p50) sh_p50=sheight sah_p50=saheight
						(p25) sh_p25=sheight sah_p25=saheight
						(p75) sh_p75=sheight sah_p75=saheight
						(p5) sh_p5=sheight sah_p5=saheight
						(p95) sh_p95=sheight sah_p95=saheight
						, by(geno sex agroups);
		#delimit cr
	
		* 95% CI
		gen sh_cil = sh_m - 1.96 * (sh_sd/sh_c)
		gen sh_ciu = sh_m + 1.96 * (sh_sd/sh_c)

		** Smoothed metrics
		bysort geno sex : asrol sh_m 	, stat(mean) window(agroups 3) gen(sm_mean)
		bysort geno sex : asrol sh_cil 	, stat(mean) window(agroups 3) gen(sm_cil)
		bysort geno sex : asrol sh_ciu 	, stat(mean) window(agroups 3) gen(sm_ciu)
		bysort geno sex : asrol sh_p5 	, stat(mean) window(agroups 3) gen(sm_p5)
		bysort geno sex : asrol sh_p25 	, stat(mean) window(agroups 3) gen(sm_p25)
		bysort geno sex : asrol sh_p50 	, stat(mean) window(agroups 3) gen(sm_p50)
		bysort geno sex : asrol sh_p75 	, stat(mean) window(agroups 3) gen(sm_p75)
		bysort geno sex : asrol sh_p95 	, stat(mean) window(agroups 3) gen(sm_p95)

		#delimit ;
			gr twoway
				/// SS female
				(line sm_p50 agroups if geno==2 & sex==1 			,  msize(2) m(o) mlc(gs10) mfc("`blu1'%60") mlw(0.1) lc("`blu1'%60") lp("l") )
				(rarea sm_p25 sm_p75 agroups if geno==2 & sex==1 	, fc("`blu2'%20") lw(none) )

				/// AA female
				(line sm_p50 agroups if geno==1 & sex==1 			,  msize(2) m(o) mlc(gs10) mfc("`red1'%60") mlw(0.1) lc("`red1'%60") lp("l") )
				(rarea sm_p25 sm_p75 agroups if geno==1 & sex==1 	, fc("`red2'%20") lw(none) )

				/// SC female
				(line sm_p50 agroups if geno==3 & sex==1 			,  msize(2) m(o) mlc(gs10) mfc("`ora1'%60") mlw(0.1) lc("`ora1'%60") lp("l") )
				(rarea sm_p25 sm_p75 agroups if geno==3 & sex==1 	, fc("`ora2'%20") lw(none) )

				,
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
					ysize(16) xsize(12)

					xlab(1(1)10
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(45) format(%9.0f))
					xscale( lw(vthin))
					xtitle("Age (years)", size(3) color(gs0) margin(l=2 r=2 t=2 b=2))

					ylab(40(20)160
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
					yscale( lw(vthin) )
					ytitle("Spleen length (mm)", size(3) margin(l=2 r=2 t=2 b=2))
					ymtick(40(10)160)

					legend(size(4) position(6) ring(0) bm(t=1 b=1 l=1 r=0) cols(3) rows(1) nocolf symy(3.5) symx(5)
					region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
					order(2 4 6)
					lab(2 "SS")
					lab(4 "AA")
					lab(6 "SC")

					)
					name(profile_unadj_female)
					;
		graph export "`outputpath'/profile_unadj_female.png", replace width(4000);
		#delimit cr
restore

** MALES: Unadjusted spleen length
preserve
		** 2-year age groups
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
			replace agroups = 10 if aaexam >=24 & aaexam<27


		sort geno sex aaexam 

			#delimit ; 
			label define agroups_ 	1 "6-8" 
									2 "8-10" 
									3 "10-12"
									4 "12-14"
									5 "14-16"
									6 "16-18"
									7 "18-20"
									8 "20-22"
									9 "22-24"
									10 "24+"
									, modify;
			#delimit cr
			label values agroups agroups_ 

		** Collapse into 2 year windows - mostly because of AA limited numbers
		gen part = 1
		#delimit ; 
		collapse 		(mean) sh_m=sheight sah_m=saheight 
						(sum) sh_c = part 
						(sd) sh_sd=sheight sah_sd=saheight
						(p50) sh_p50=sheight sah_p50=saheight
						(p25) sh_p25=sheight sah_p25=saheight
						(p75) sh_p75=sheight sah_p75=saheight
						(p5) sh_p5=sheight sah_p5=saheight
						(p95) sh_p95=sheight sah_p95=saheight
						, by(geno sex agroups);
		#delimit cr
	
		* 95% CI
		gen sh_cil = sh_m - 1.96 * (sh_sd/sh_c)
		gen sh_ciu = sh_m + 1.96 * (sh_sd/sh_c)

		** Smoothed metrics
		bysort geno sex : asrol sh_m 	, stat(mean) window(agroups 3) gen(sm_mean)
		bysort geno sex : asrol sh_cil 	, stat(mean) window(agroups 3) gen(sm_cil)
		bysort geno sex : asrol sh_ciu 	, stat(mean) window(agroups 3) gen(sm_ciu)
		bysort geno sex : asrol sh_p5 	, stat(mean) window(agroups 3) gen(sm_p5)
		bysort geno sex : asrol sh_p25 	, stat(mean) window(agroups 3) gen(sm_p25)
		bysort geno sex : asrol sh_p50 	, stat(mean) window(agroups 3) gen(sm_p50)
		bysort geno sex : asrol sh_p75 	, stat(mean) window(agroups 3) gen(sm_p75)
		bysort geno sex : asrol sh_p95 	, stat(mean) window(agroups 3) gen(sm_p95)

		#delimit ;
			gr twoway
				/// SS male
				(line sm_p50 agroups if geno==2 & sex==2 			,  msize(2) m(o) mlc(gs10) mfc("`blu1'%60") mlw(0.1) lc("`blu1'%60") lp("-") )
				(rarea sm_p25 sm_p75 agroups if geno==2 & sex==2 	, fc("`blu2'%20") lw(none) )

				/// AA male
				(line sm_p50 agroups if geno==1 & sex==2 			,  msize(2) m(o) mlc(gs10) mfc("`red1'%60") mlw(0.1) lc("`red1'%60") lp("-") )
				(rarea sm_p25 sm_p75 agroups if geno==1 & sex==2 	, fc("`red2'%20") lw(none) )

				/// SC male
				(line sm_p50 agroups if geno==3 & sex==2 			,  msize(2) m(o) mlc(gs10) mfc("`ora1'%60") mlw(0.1) lc("`ora1'%60") lp("-") )
				(rarea sm_p25 sm_p75 agroups if geno==3 & sex==2 	, fc("`ora2'%20") lw(none) )

				,
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
					ysize(16) xsize(12)

					xlab(1(1)10
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(45) format(%9.0f))
					xscale( lw(vthin))
					xtitle("Age (years)", size(3) color(gs0) margin(l=2 r=2 t=2 b=2))

					ylab(40(20)160
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
					yscale( lw(vthin) )
					ytitle("Spleen length (mm)", size(3) margin(l=2 r=2 t=2 b=2))
					ymtick(40(10)160)

					legend(size(4) position(6) ring(0) bm(t=1 b=1 l=1 r=0) cols(3) rows(1) nocolf symy(3.5) symx(5)
					region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
					order(2 4 6)
					lab(2 "SS")
					lab(4 "AA")
					lab(6 "SC")

					)
					name(profile_unadj_male)
					;
		graph export "`outputpath'/profile_unadj_male.png", replace width(4000);
		#delimit cr
restore


** FEMALES: Adjusted spleen length
preserve
		** 2-year age groups
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
			replace agroups = 10 if aaexam >=24 & aaexam<27


		sort geno sex aaexam 

			#delimit ; 
			label define agroups_ 	1 "6-8" 
									2 "8-10" 
									3 "10-12"
									4 "12-14"
									5 "14-16"
									6 "16-18"
									7 "18-20"
									8 "20-22"
									9 "22-24"
									10 "24+"
									, modify;
			#delimit cr
			label values agroups agroups_ 

		** Collapse into 2 year windows - mostly because of AA limited numbers
		gen part = 1
		#delimit ; 
		collapse 		(mean) sh_m=sheight sah_m=saheight 
						(sum) sh_c = part 
						(sd) sh_sd=sheight sah_sd=saheight
						(p50) sh_p50=sheight sah_p50=saheight
						(p25) sh_p25=sheight sah_p25=saheight
						(p75) sh_p75=sheight sah_p75=saheight
						(p5) sh_p5=sheight sah_p5=saheight
						(p95) sh_p95=sheight sah_p95=saheight
						, by(geno sex agroups);
		#delimit cr
	
		* 95% CI
		gen sah_cil = sah_m - 1.96 * (sah_sd/sh_c)
		gen sah_ciu = sah_m + 1.96 * (sah_sd/sh_c)

		** Smoothed metrics
		bysort geno sex : asrol sah_m 		, stat(mean) window(agroups 3) gen(sm_mean)
		bysort geno sex : asrol sah_cil 	, stat(mean) window(agroups 3) gen(sm_cil)
		bysort geno sex : asrol sah_ciu 	, stat(mean) window(agroups 3) gen(sm_ciu)
		bysort geno sex : asrol sah_p5 		, stat(mean) window(agroups 3) gen(sm_p5)
		bysort geno sex : asrol sah_p25 	, stat(mean) window(agroups 3) gen(sm_p25)
		bysort geno sex : asrol sah_p50 	, stat(mean) window(agroups 3) gen(sm_p50)
		bysort geno sex : asrol sah_p75 	, stat(mean) window(agroups 3) gen(sm_p75)
		bysort geno sex : asrol sah_p95 	, stat(mean) window(agroups 3) gen(sm_p95)

		#delimit ;
			gr twoway
				/// SS female
				(line sm_p50 agroups if geno==2 & sex==1 			,  msize(2) m(o) mlc(gs10) mfc("`blu1'%60") mlw(0.1) lc("`blu1'%60") lp("l") )
				(rarea sm_p25 sm_p75 agroups if geno==2 & sex==1 	, fc("`blu2'%20") lw(none) )

				/// AA female
				(line sm_p50 agroups if geno==1 & sex==1 			,  msize(2) m(o) mlc(gs10) mfc("`red1'%60") mlw(0.1) lc("`red1'%60") lp("l") )
				(rarea sm_p25 sm_p75 agroups if geno==1 & sex==1 	, fc("`red2'%20") lw(none) )

				/// SC female
				(line sm_p50 agroups if geno==3 & sex==1 			,  msize(2) m(o) mlc(gs10) mfc("`ora1'%60") mlw(0.1) lc("`ora1'%60") lp("l") )
				(rarea sm_p25 sm_p75 agroups if geno==3 & sex==1 	, fc("`ora2'%20") lw(none) )

				,
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
					ysize(16) xsize(12)

					xlab(1(1)10
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(45) format(%9.0f))
					xscale( lw(vthin))
					xtitle("Age (years)", size(3) color(gs0) margin(l=2 r=2 t=2 b=2))

					ylab(20(20)100
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
					yscale( lw(vthin) )
					ytitle("Spleen length (mm) / height (m)", size(3) margin(l=2 r=2 t=2 b=2))
					ymtick(20(10)100)

					legend(size(4) position(6) ring(0) bm(t=1 b=1 l=1 r=0) cols(3) rows(1) nocolf symy(3.5) symx(5)
					region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
					order(2 4 6)
					lab(2 "SS")
					lab(4 "AA")
					lab(6 "SC")

					)
					name(profile_adj_female)
					;
		graph export "`outputpath'/profile_adj_female.png", replace width(4000);
		#delimit cr
restore

** MALES: Adjusted spleen length
preserve
		** 2-year age groups
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
			replace agroups = 10 if aaexam >=24 & aaexam<27


		sort geno sex aaexam 

			#delimit ; 
			label define agroups_ 	1 "6-8" 
									2 "8-10" 
									3 "10-12"
									4 "12-14"
									5 "14-16"
									6 "16-18"
									7 "18-20"
									8 "20-22"
									9 "22-24"
									10 "24+"
									, modify;
			#delimit cr
			label values agroups agroups_ 

		** Collapse into 2 year windows - mostly because of AA limited numbers
		gen part = 1
		#delimit ; 
		collapse 		(mean) sh_m=sheight sah_m=saheight 
						(sum) sh_c = part 
						(sd) sh_sd=sheight sah_sd=saheight
						(p50) sh_p50=sheight sah_p50=saheight
						(p25) sh_p25=sheight sah_p25=saheight
						(p75) sh_p75=sheight sah_p75=saheight
						(p5) sh_p5=sheight sah_p5=saheight
						(p95) sh_p95=sheight sah_p95=saheight
						, by(geno sex agroups);
		#delimit cr
	
		* 95% CI
		gen sah_cil = sah_m - 1.96 * (sah_sd/sh_c)
		gen sah_ciu = sah_m + 1.96 * (sah_sd/sh_c)

		** Smoothed metrics
		bysort geno sex : asrol sah_m 		, stat(mean) window(agroups 3) gen(sm_mean)
		bysort geno sex : asrol sah_cil 	, stat(mean) window(agroups 3) gen(sm_cil)
		bysort geno sex : asrol sah_ciu 	, stat(mean) window(agroups 3) gen(sm_ciu)
		bysort geno sex : asrol sah_p5 		, stat(mean) window(agroups 3) gen(sm_p5)
		bysort geno sex : asrol sah_p25 	, stat(mean) window(agroups 3) gen(sm_p25)
		bysort geno sex : asrol sah_p50 	, stat(mean) window(agroups 3) gen(sm_p50)
		bysort geno sex : asrol sah_p75 	, stat(mean) window(agroups 3) gen(sm_p75)
		bysort geno sex : asrol sah_p95 	, stat(mean) window(agroups 3) gen(sm_p95)

		#delimit ;
			gr twoway
				/// SS male
				(line sm_p50 agroups if geno==2 & sex==2 			,  msize(2) m(o) mlc(gs10) mfc("`blu1'%60") mlw(0.1) lc("`blu1'%60") lp("-") )
				(rarea sm_p25 sm_p75 agroups if geno==2 & sex==2 	, fc("`blu2'%20") lw(none) )

				/// AA male
				(line sm_p50 agroups if geno==1 & sex==2 			,  msize(2) m(o) mlc(gs10) mfc("`red1'%60") mlw(0.1) lc("`red1'%60") lp("-") )
				(rarea sm_p25 sm_p75 agroups if geno==1 & sex==2 	, fc("`red2'%20") lw(none) )

				/// SC male
				(line sm_p50 agroups if geno==3 & sex==2 			,  msize(2) m(o) mlc(gs10) mfc("`ora1'%60") mlw(0.1) lc("`ora1'%60") lp("-") )
				(rarea sm_p25 sm_p75 agroups if geno==3 & sex==2 	, fc("`ora2'%20") lw(none) )

				,
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
					ysize(16) xsize(12)

					xlab(1(1)10
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(45) format(%9.0f))
					xscale( lw(vthin))
					xtitle("Age (years)", size(3) color(gs0) margin(l=2 r=2 t=2 b=2))

					ylab(20(20)100
					,
					valuelabel labgap(1) labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
					yscale( lw(vthin) )
					ytitle("Spleen length (mm) / height (m)", size(3) margin(l=2 r=2 t=2 b=2))
					ymtick(20(10)100)

					legend(size(4) position(6) ring(0) bm(t=1 b=1 l=1 r=0) cols(3) rows(1) nocolf symy(3.5) symx(5)
					region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
					order(2 4 6)
					lab(2 "SS")
					lab(4 "AA")
					lab(6 "SC")

					)
					name(profile_adj_male)
					;
		graph export "`outputpath'/profile_adj_male.png", replace width(4000);
		#delimit cr
restore





** PDF Page for Figure 1

** ------------------------------------------------------
** PDF REGIONAL REPORT (COUNTS OF CONFIRMED CASES)
** ------------------------------------------------------
    putpdf begin, pagesize(letter) font("Times New Roman", 11) margin(top,0.5cm) margin(bottom,0.25cm) margin(left,0.5cm) margin(right,0.25cm)
** PAGE 1. INTRODUCTION
    putpdf paragraph ,  font("Times New Roman", 11)
    putpdf text ("Figure 1. ") , bold
    putpdf text ("Median spleen lengths by genotype in males and females, with shaded areas representing 25th and 75th percentiles, before (A) and after (B) adjustment for height.")
** PAGE 1. FIGURE OF DAILY COVID-19 COUNT
    putpdf table f1 = (4,2), width(85%) border(all,nil) halign(center)
    putpdf table f1(1,1)=("(A) Female")
    putpdf table f1(1,2)=("(A) Male")
    putpdf table f1(3,1)=("(B) Female")
    putpdf table f1(3,2)=("(B) Male")
    putpdf table f1(2,1)=image("`outputpath'/profile_unadj_female.png")
    putpdf table f1(2,2)=image("`outputpath'/profile_unadj_male.png")
    putpdf table f1(4,1)=image("`outputpath'/profile_adj_female.png")
    putpdf table f1(4,2)=image("`outputpath'/profile_adj_male.png")


** Save the PDF
    local c_date = c(current_date)
    local date_string = subinstr("`c_date'", " ", "", .)
    putpdf save "`outputpath'/Figure_One_`date_string'", replace


/*

** Create Table of observed values by Genotype and Age
** Separate tables by Genotype


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


/*

** B. Count the number of observations and number of individuals
gen nobs = 1
sort pid agroups
egen npart1 = group(pid agroups)
gen npart = npart1 - npart1[_n-1]
replace npart = 1 if _n==1
drop npart1

#delimit ; 
		collapse 	(sum) sheight_obs=nobs
					(sum) sheight_par=npart
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




** B. Word document

** ----------------------------------------------------
** SS table
** ----------------------------------------------------
preserve
	keep if geno==2
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_obs Observations
	rename sheight_par Participants
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
		putdocx table ss = data("Sex Age Observations Participants Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("95th percentile"),  font(calibri light,10, "000000")
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
	rename sheight_obs Observations
	rename sheight_par Participants
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
		putdocx table ss = data("Sex Age Observations Participants Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("95th percentile"),  font(calibri light,10, "000000")
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
	rename sheight_obs Observations
	rename sheight_par Participants
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
		putdocx text ("Spleen length among Alpha-thal + participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Observations Participants Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("95th percentile"),  font(calibri light,10, "000000")
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
** Alpha-thal + table
** ----------------------------------------------------
preserve
	keep if geno==5
	sort sex agroups 
	rename sex Sex
	rename agroups Age
	rename sheight_obs Observations
	rename sheight_par Participants
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
		putdocx text ("Spleen length among Alpha-thal 0 participants"), 
		** Place data 
		putdocx table ss = data("Sex Age Observations Participants Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("95th percentile"),  font(calibri light,10, "000000")
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
	rename sheight_obs Observations
	rename sheight_par Participants
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
		putdocx table ss = data("Sex Age Observations Participants Mean SD Median p5 p95"), varnames 
		** Line colors + Shadng
		putdocx table ss(2/10,.), border(bottom, single, "e6e6e6")
		putdocx table ss(12/20,.), border(bottom, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1/2),  shading("e6e6e6")
		** Column and Row headers
		putdocx table ss(1,1) = ("Sex"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age Group"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("Observations"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("Participants"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("Mean"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("SD"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("Median"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("5th percentile"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("95th percentile"),  font(calibri light,10, "000000")
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





*/


** Regression for spleen volume by age
use `regress', clear
keep if geno==1 | geno==2 | geno==3
replace pid = pid+1000 if geno==3
xtset pid 
xtreg saheight c.aaexam geno if aaexam>=12 & aaexam<=22

/// ** AA and SS only
/// xtreg saheight c.aaexam##geno if aaexam>=12 & aaexam<=20 & geno<3
/// margins geno, at(aaexam=(12(2)20)) vsquish
/// marginsplot, x(aaexam)
/// ** Test of differences at various ages
/// margins, dydx(geno) at(aaexam=(12(2)20)) vsquish

** AA, SS, and SC
xtreg saheight c.aaexam##geno if aaexam>=12 & aaexam<=22 
* genotype difference
margins geno, at(aaexam=(12(2)22)) vsquish
marginsplot, x(aaexam)
** Test of genotype differences at various ages
margins, dydx(geno) at(aaexam=(12(2)22)) vsquish
** Test of age change for each genotype


** Baseline SC
xtreg saheight c.aaexam##ib3.geno if aaexam>=12 & aaexam<=22 
** Test of differences at various ages
margins, dydx(geno) at(aaexam=(12(2)22)) vsquish


/*
** AA, SS, and SC : Restrict to >1 measurement
bysort pid : gen counter = _n
xtreg saheight c.aaexam##geno if aaexam>=12 & aaexam<=22 & counter>1
margins geno, at(aaexam=(12(2)22)) vsquish
marginsplot, x(aaexam)
** Test of differences at various ages
margins, dydx(geno) at(aaexam=(12(2)22)) vsquish
** Baseline SC
xtreg saheight c.aaexam##ib3.geno if aaexam>=12 & aaexam<=22 
** Test of differences at various ages
margins, dydx(geno) at(aaexam=(12(2)22)) vsquish



