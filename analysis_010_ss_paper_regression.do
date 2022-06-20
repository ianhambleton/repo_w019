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
label var agroups "Age in 2 year age bands"

** Keep SS, AA, and SC 
keep if geno==1 | geno==2 | geno==3
sort pid doexam 

** Interpolate height ready for regression
** This interpolation recognises that we have interpolated spleen-lebgth
** But that the regression uses spleen length adjusted for heiht
** And we have a few missing heights.
** Linear interpolation should suffice...
bysort pid : ipolate height doexam , epolate gen(height_ip)
order  agroups height height_ip, after(aaexam) 


** SPLEEN ADJUSTED FOR HEIGHT
** OUR MAIN OUTCOME VARIABLE
gen saheight_ip = sheight_ip / height_ip 
label var saheight_ip ""
label var saheight_ip "Adjusted spl length. With small breath / atrophy interpolation (SS and SC only)" 

** For a TOBIT regression we need a lower cut-point
** for censoring
** This lower ciutpoint will be height variable
** So will vary by age within participant
gen lcensor = 45 / height_ip 
label var lcensor "Lower bound for height varying censoring"
order saheight_ip lcensor, after(saheight) 

** Tabulating average height by genotype and age
	gen ayear = int(aaexam)
	order ayear, after(agroups) 
	table (geno ayear), stat(mean height)
	bysort geno ayear : egen mht = mean(height)
	order geno ayear mht, after(height)
	drop mht


** Add AA to ipolated spleen length variables
replace sheight_ip = sheight if geno==1

** Create new REGRESSION OUTCOME
** This is essentially saheight_ip + AA values
gen saheight_reg = sheight_ip / height_ip
order saheight_reg, after(saheight_ip) 
sort geno pid doexam 

** AA, SS, SC 
** Height-adjusted spleen lengths : observed means
	table agroups if geno==1 & agroups>=3 & agroups<=8, stat(mean saheight_reg)
	table agroups if geno==2 & agroups>=3 & agroups<=8, stat(mean saheight_reg)
	table agroups if geno==3 & agroups>=3 & agroups<=8, stat(mean saheight_reg)

** Small breath interpolation only
gen sheight_sb = sheight_ip
replace sheight_sb = . if sheight_ip==45
order sheight_sb, before(sheight_ip)
gen saheight_sb = sheight_sb / height_ip 
order saheight_sb, before(saheight_ip)

** Atrophy interpolation only
gen sheight_at = sheight
replace sheight_at = sheight_ip if sheight_at==. & sheight_ip==45
order sheight_at, after(sheight_sb)

** Remove atrophy measures for original outcome
gen saheight_ig = saheight 
replace saheight_ig = . if sheight<45
order saheight_ig, after(saheight) 

** Atrophy measure for adjusted spleen length
gen saheight_at = sheight_at / height_ip 
order saheight_at, after(saheight_sb)




rename saheight_reg saheight_re 
label var saheight_ig "Spleen length outcome : no estimation" 
label var saheight_sb "Spleen length outcome : small-breath estimation" 
label var saheight_re "Spleen length outcome : full estimation" 
** --------------------------------------------------------------
** We now perform 6 REGRESSIONS
** --------------------------------------------------------------
**		1. 	XTREG. Ignoring all unobserved variables
**			OUTCOME: saheight_ig
**
**		2. 	XTREG. Just including small-breath estimates
**			OUTCOME: saheight_sb
**
**		3. 	XTREG. Just including atrophy estimates
**			OUTCOME: saheight_at
**
**		4. 	XTREG. Including small-breath and atrophy estimates
**			OUTCOME: saheight_re
** --------------------------------------------------------------
**		5. 	TOBIT. Ignoring all unobserved variables
**			OUTCOME: saheight_ig
**
**		6. 	TOBIT. Just including small-breath estimates
**			OUTCOME: saheight_sb
**
**		7. 	TOBIT. Just including atrophy estimates
**			OUTCOME: saheight_at
**
**		8. 	TOBIT. Including small-breath and atrophy estimates
**			OUTCOME: saheight_re
** --------------------------------------------------------------
** SET as longitudinal dataset 
sort pid doexam
xtset pid 



** --------------------------------------------------------------
** A. 	XTREG. Models 1-4
** --------------------------------------------------------------
collect create MyModels

** Models 1-4 (using xtset) 
#delimit ; 
	qui: collect _r_b _r_ci _r_p , 
			name(MyModels) 
			tag(model[(1) No est])                
			: xtreg saheight_ig c.aaexam ib2.geno if aaexam>=12 & aaexam<=22, re;

	qui: collect _r_b _r_ci _r_p , 
			name(MyModels) 
			tag(model[(2) Breath est])                
			: xtreg saheight_sb c.aaexam ib2.geno if aaexam>=12 & aaexam<=22, re;

	qui: collect _r_b _r_ci _r_p , 
			name(MyModels) 
			tag(model[(3) Atrophy est])                
			: xtreg saheight_at c.aaexam ib2.geno if aaexam>=12 & aaexam<=22, re;

	qui: collect _r_b _r_ci _r_p , 
			name(MyModels) 
			tag(model[(4) Full est])                
			: xtreg saheight_re c.aaexam ib2.geno if aaexam>=12 & aaexam<=22, re;
#delimit cr

** turn off factor base levels
	collect style showbase off
** remove vertical line 
	collect style cell border_block, border(right, pattern(nil))
** Change row headers
	collect label levels result _r_b "Estimate", modify
	collect label levels result ci1 "95% CI", modify
	collect label levels result _r_p "p-val", modify
	collect label dim geno "Genotype", modify
	collect label levels geno 1 "AA vs SS", modify
	collect label levels geno 2 "SS", modify
	collect label levels geno 3 "SC vs SS", modify
** Formatting the estimates
	collect composite define ci1 = _r_ci, trim replace
	collect style cell result[_r_b], nformat(%5.2f) halign(center)
	collect style cell result[_r_p], nformat(%5.4f) halign(center)
	collect style cell result[ci1], nformat(%6.2f) sformat("(%s)") cidelimiter(",") halign(center)
** Preview table
	collect layout (colname[aaexam 1.geno 3.geno]#result[_r_b ci1 _r_p]) (model), name(MyModels)



** Models 5-8 (using xttobit) 
collect create MyModels2
#delimit ; 
	qui: collect _r_b _r_ci _r_p , 
			name(MyModels2) 
			tag(model[(1) No est])                
			: xttobit saheight_ig c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor);

	qui: collect _r_b _r_ci _r_p , 
			name(MyModels2) 
			tag(model[(2) Breath est])                
			: xttobit saheight_sb c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor);

	qui: collect _r_b _r_ci _r_p , 
			name(MyModels2) 
			tag(model[(3) Atrophy est])                
			: xttobit saheight_at c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor);

	qui: collect _r_b _r_ci _r_p , 
			name(MyModels2) 
			tag(model[(4) Full est])                
			: xttobit saheight_re c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor);
#delimit cr

** turn off factor base levels
	collect style showbase off
** remove vertical line 
	collect style cell border_block, border(right, pattern(nil))
** Change row headers
	collect label levels result _r_b "Estimate", modify
	collect label levels result ci2 "95% CI", modify
	collect label levels result _r_p "p-val", modify
	collect label dim geno "Genotype", modify
	collect label levels geno 1 "AA vs SS", modify
	collect label levels geno 2 "SS", modify
	collect label levels geno 3 "SC vs SS", modify
** Formatting the estimates
	collect composite define ci2 = _r_ci, trim replace
	collect style cell result[_r_b], nformat(%5.2f) halign(center)
	collect style cell result[_r_p], nformat(%5.4f) halign(center)
	collect style cell result[ci2], nformat(%6.2f) sformat("(%s)") cidelimiter(",") halign(center)
** Preview table
	collect layout (colname[aaexam 1.geno 3.geno]#result[_r_b ci2 _r_p]) (model), name(MyModels2)

** Export TWO tables to DOCX
	putdocx clear
	putdocx begin
	putdocx paragraph, style(Heading2)
	putdocx text ("Brief Methods")
	putdocx paragraph
	putdocx text ("We've fitted quite a few models over the past fortnight. I thought it worth documenting the full set of models ")
	putdocx text ("and how they affect the role of age and genotype on estimated spleen size. ")

	putdocx text ("Table A contains 4 regression models, all without censoring that helps to account for spleen atrophy. "), linebreak(1)
	putdocx text ("Model 1: Only includes measured spleens: all unmeasurable spleen visits ignored."), linebreak(1)
	putdocx text ("Model 2: Measured spleens + estimates of spleen length due to small breaths."), linebreak(1)
	putdocx text ("Model 3: Measured spleens + estimates of spleen length due to spleen atrophy."), linebreak(1)
	putdocx text ("Model 4: Measured spleens + estimates of spleen length due to small breaths and spleen atrophy."), linebreak(2)
	putdocx text ("Table A: Spleen length regression estimates WITHOUT censoring")
	collect style putdocx, width(100%) title("Table A: Spleen length regression estimates WITHOUT censoring")
	putdocx collect , name(MyModels)

	putdocx paragraph
	putdocx text ("Table B contains the same 4 regression models, ")
	putdocx text ("now with censoring "), underline
	putdocx text ("to account for spleen atrophy. ")
	putdocx text ("This censoring allows us to recognise our lower limit of spleen detection. "), linebreak(2)
	putdocx text ("Table B: Spleen length regression estimates WITH censoring")
	collect style putdocx, width(100%)
	putdocx collect , name(MyModels2)

	putdocx save "`outputpath'/regression_estimates", replace




** NEXT - estimate the margins from the MAIN FULL ESTIMATION MODELS

** FOUR xtset models
xtreg saheight_ig c.aaexam ib2.geno if aaexam>=12 & aaexam<=22
 	margins geno, at(aaexam=(12(2)22)) vsquish post
xtreg saheight_sb c.aaexam ib2.geno if aaexam>=12 & aaexam<=22
 	margins geno, at(aaexam=(12(2)22)) vsquish post
xtreg saheight_at cc.aaexam ib2.geno if aaexam>=12 & aaexam<=22
 	margins geno, at(aaexam=(12(2)22)) vsquish post
xtreg saheight_re c.aaexam ib2.geno if aaexam>=12 & aaexam<=22
 	margins geno, at(aaexam=(12(2)22)) vsquish post
** FOUR xttobit models
xttobit saheight_ig c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor)
 	margins geno, at(aaexam=(12(2)22)) vsquish post
xttobit saheight_sb c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor)
 	margins geno, at(aaexam=(12(2)22)) vsquish post
xttobit saheight_at c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor)
 	margins geno, at(aaexam=(12(2)22)) vsquish post
xttobit saheight_re c.aaexam ib2.geno if aaexam>=12 & aaexam<=22 , ll(lcensor)
 	margins geno, at(aaexam=(12(2)22)) vsquish post



** DATASET
clear
input model age str2 geno est se z p lb ub
1       1	aa     65.74658   1.864876    35.26   0.000     62.09149    69.40167
1       1	ss     53.90437   1.394073    38.67   0.000     51.17204     56.6367
1       1	sc      77.8053   1.376938    56.51   0.000     75.10655    80.50405
1       2	aa     63.73461   1.824712    34.93   0.000     60.15824    67.31098
1       2	ss     51.89241   1.363613    38.06   0.000     49.21978    54.56504
1       2	sc     75.79334   1.342891    56.44   0.000     73.16132    78.42535
1       3	aa     61.72265     1.7996    34.30   0.000      58.1955     65.2498
1       3	ss     49.88044    1.35374    36.85   0.000     47.22716    52.53373
1       3	sc     73.78137   1.329633    55.49   0.000     71.17534    76.38741
1       4	aa     59.71069   1.790172    33.35   0.000     56.20202    63.21936
1       4	ss     47.86848   1.364901    35.07   0.000     45.19332    50.54364
1       4	sc     71.76941   1.337784    53.65   0.000      69.1474    74.39142
1       5	aa     57.69872   1.796675    32.11   0.000     54.17731    61.22014
1       5	ss     45.85652   1.396593    32.83   0.000     43.11925    48.59379
1       5	sc     69.75745    1.36696    51.03   0.000     67.07825    72.43664
1       6	aa     55.68676    1.81894    30.61   0.000      52.1217    59.25182
1       6	ss     43.84455   1.447467    30.29   0.000     41.00757    46.68154
1       6	sc     67.74548   1.415862    47.85   0.000     64.97044    70.52052
2       1	aa      65.4171   1.847557    35.41   0.000     61.79595    69.03824
2       1	ss     53.14599   1.378687    38.55   0.000     50.44381    55.84817
2       1	sc     77.67113   1.371827    56.62   0.000     74.98239    80.35986
2       2	aa      63.5119   1.819182    34.91   0.000     59.94637    67.07744
2       2	ss      51.2408   1.356189    37.78   0.000     48.58272    53.89888
2       2	sc     75.76593   1.345723    56.30   0.000     73.12836     78.4035
2       3	aa     61.60671   1.801533    34.20   0.000     58.07577    65.13765
2       3	ss      49.3356   1.348282    36.59   0.000     46.69302    51.97819
2       3	sc     73.86074   1.334233    55.36   0.000     71.24569    76.47579
2       4	aa     59.70152   1.794929    33.26   0.000     56.18352    63.21951
2       4	ss     47.43041   1.355221    35.00   0.000     44.77423     50.0866
2       4	sc     71.95555   1.337734    53.79   0.000     69.33364    74.57746
2       5	aa     57.79633   1.799489    32.12   0.000     54.26939    61.32326
2       5	ss     45.52522   1.376783    33.07   0.000     42.82677    48.22366
2       5	sc     70.05035   1.356108    51.66   0.000     67.39243    72.70828
2       6	aa     55.89113    1.81513    30.79   0.000     52.33354    59.44872
2       6	ss     43.62003   1.412297    30.89   0.000     40.85198    46.38808
2       6	sc     68.14516   1.388767    49.07   0.000     65.42323    70.86709
3       1	aa     65.73668   1.876023    35.04   0.000     62.05974    69.41361
3       1	ss     46.09197   1.182727    38.97   0.000     43.77386    48.41007
3       1	sc     77.30199   1.407559    54.92   0.000     74.54323    80.06076
3       2	aa     63.72813   1.857478    34.31   0.000     60.08754    67.36872
3       2	ss     44.08342   1.162044    37.94   0.000     41.80585    46.36098
3       2	sc     75.29344   1.390376    54.15   0.000     72.56835    78.01853
3       3	aa     61.71958   1.845999    33.43   0.000     58.10148    65.33767
3       3	ss     42.07487   1.152638    36.50   0.000     39.81574      44.334
3       3	sc     73.28489   1.382677    53.00   0.000     70.57489    75.99489
3       4	aa     59.71103   1.841718    32.42   0.000     56.10132    63.32073
3       4	ss     40.06632   1.154785    34.70   0.000     37.80298    42.32965
3       4	sc     71.27634   1.384619    51.48   0.000     68.56254    73.99014
3       5	aa     57.70248   1.844685    31.28   0.000     54.08696    61.31799
3       5	ss     38.05777   1.168421    32.57   0.000      35.7677    40.34783
3       5	sc     69.26779   1.396162    49.61   0.000     66.53136    72.00422
3       6	aa     55.69392   1.854866    30.03   0.000     52.05845    59.32939
3       6	ss     36.04921   1.193152    30.21   0.000     33.71068    38.38775
3       6	sc     67.25924   1.417072    47.46   0.000     64.48183    70.03665
4       1	aa     65.86716   1.860498    35.40   0.000     62.22065    69.51367
4       1	ss     46.30678   1.172145    39.51   0.000     44.00942    48.60415
4       1	sc     77.43711   1.397883    55.40   0.000     74.69731    80.17691
4       2	aa     63.81639    1.84339    34.62   0.000     60.20341    67.42937
4       2	ss     44.25602    1.15347    38.37   0.000     41.99526    46.51678
4       2	sc     75.38635   1.382137    54.54   0.000     72.67741    78.09528
4       3	aa     61.76562   1.832806    33.70   0.000     58.17339    65.35786
4       3	ss     42.20525   1.145217    36.85   0.000     39.96067    44.44983
4       3	sc     73.33558   1.375132    53.33   0.000     70.64037    76.03079
4       4	aa     59.71485   1.828861    32.65   0.000     56.13035    63.29936
4       4	ss     40.15448   1.147611    34.99   0.000     37.90521    42.40376
4       4	sc     71.28481   1.377001    51.77   0.000     68.58594    73.98368
4       5	aa     57.66409   1.831597    31.48   0.000     54.07422    61.25395
4       5	ss     38.10371   1.160587    32.83   0.000     35.82901    40.37842
4       5	sc     69.23404    1.38771    49.89   0.000     66.51418    71.95391
4       6	aa     55.61332   1.840984    30.21   0.000     52.00506    59.22158
4       6	ss     36.05295   1.183796    30.46   0.000     33.73275    38.37315
4       6	sc     67.18328   1.407056    47.75   0.000      64.4255    69.94106
5       1	aa   65.74361   1.889625    34.79   0.000     62.04001    69.44721
5       1	ss   53.80781   1.417482    37.96   0.000      51.0296    56.58602
5       1	sc    77.7876   1.399495    55.58   0.000     75.04464    80.53056
5       2	aa   63.73261   1.850249    34.45   0.000     60.10619    67.35903
5       2	ss   51.79681   1.387764    37.32   0.000     49.07684    54.51678
5       2	sc    75.7766   1.366223    55.46   0.000     73.09885    78.45435
5       3	aa   61.72161   1.825645    33.81   0.000     58.14341    65.29981
5       3	ss   49.78581   1.378167    36.12   0.000     47.08465    52.48696
5       3	sc    73.7656    1.35328    54.51   0.000     71.11322    76.41798
5       4	aa   59.71061   1.816413    32.87   0.000      56.1505    63.27071
5       4	ss    47.7748   1.389107    34.39   0.000      45.0522     50.4974
5       4	sc    71.7546   1.361245    52.71   0.000      69.0866    74.42259
5       5	aa   57.69961   1.822787    31.65   0.000     54.12701     61.2722
5       5	ss    45.7638    1.42011    32.23   0.000     42.98044    48.54717
5       5	sc   69.74359   1.389758    50.18   0.000     67.01972    72.46747
5       6	aa    55.6886   1.844606    30.19   0.000     52.07324    59.30397
5       6	ss    43.7528   1.469907    29.77   0.000     40.87184    46.63377
5       6	sc   67.73259   1.437598    47.12   0.000     64.91495    70.55023
6       1	aa    65.4033   1.877592    34.83   0.000     61.72328    69.08331
6       1	ss   53.00931   1.406922    37.68   0.000     50.25179    55.76683
6       1	sc   77.65814   1.398403    55.53   0.000     74.91732    80.39896
6       2	aa   63.50258   1.849753    34.33   0.000     59.87713    67.12803
6       2	ss   51.10859   1.384974    36.90   0.000     48.39409    53.82309
6       2	sc   75.75742   1.372885    55.18   0.000     73.06662    78.44823
6       3	aa   61.60186   1.832447    33.62   0.000     58.01033    65.19339
6       3	ss   49.20787   1.377285    35.73   0.000     46.50844     51.9073
6       3	sc    73.8567   1.361667    54.24   0.000     71.18788    76.52552
6       4	aa   59.70114   1.825973    32.70   0.000      56.1223    63.27998
6       4	ss   47.30715   1.384095    34.18   0.000     44.59438    50.01993
6       4	sc   71.95598   1.365101    52.71   0.000     69.28043    74.63153
6       5	aa   57.80042   1.830447    31.58   0.000     54.21281    61.38803
6       5	ss   45.40643   1.405192    32.31   0.000     42.65231    48.16056
6       5	sc   70.05527   1.383079    50.65   0.000     67.34448    72.76605
6       6	aa    55.8997   1.845789    30.28   0.000     52.28202    59.51738
6       6	ss   43.50572   1.439948    30.21   0.000     40.68347    46.32796
6       6	sc   68.15455   1.415046    48.16   0.000     65.38111    70.92799
7       1	aa   67.11308   2.389708    28.08   0.000     62.42934    71.79682
7       1	ss   38.99999   1.650734    23.63   0.000     35.76461    42.23537
7       1	sc   78.19584   1.814949    43.08   0.000      74.6386    81.75307
7       2	aa   64.65908   2.365409    27.34   0.000     60.02296    69.29519
7       2	ss   36.54598   1.627589    22.45   0.000     33.35597      39.736
7       2	sc   75.74183   1.792807    42.25   0.000       72.228    79.25567
7       3	aa   62.20507   2.350368    26.47   0.000     57.59844    66.81171
7       3	ss   34.09198   1.617957    21.07   0.000     30.92084    37.26312
7       3	sc   73.28783   1.782945    41.10   0.000     69.79332    76.78234
7       4	aa   59.75107   2.344764    25.48   0.000     55.15542    64.34672
7       4	ss   31.63798   1.622078    19.50   0.000     28.45876    34.81719
7       4	sc   70.83383   1.785565    39.67   0.000     67.33418    74.33347
7       5	aa   57.29706   2.348663    24.40   0.000     52.69377    61.90036
7       5	ss   29.18397   1.639849    17.80   0.000     25.96993    32.39802
7       5	sc   68.37982   1.800612    37.98   0.000     64.85069    71.90896
7       6	aa   54.84306   2.362018    23.22   0.000     50.21359    59.47253
7       6	ss   26.72997   1.670834    16.00   0.000     23.45519    30.00474
7       6	sc   65.92582    1.82778    36.07   0.000     62.34343     69.5082
8       1	aa   67.18446    2.37692    28.27   0.000     62.52578    71.84313
8       1	ss   39.17342   1.646188    23.80   0.000     35.94695    42.39989
8       1	sc   78.23389   1.807203    43.29   0.000     74.69183    81.77594
8       2	aa   64.70734    2.35454    27.48   0.000     60.09252    69.32215
8       2	ss    36.6963   1.625482    22.58   0.000     33.51042    39.88219
8       2	sc   75.75677   1.786935    42.39   0.000     72.25444     79.2591
8       3	aa   62.23022   2.340696    26.59   0.000     57.64254     66.8179
8       3	ss   34.21919   1.617201    21.16   0.000     31.04953    37.38884
8       3	sc   73.27965    1.77797    41.22   0.000     69.79489    76.76441
8       4	aa    59.7531   2.335539    25.58   0.000     55.17553    64.33068
8       4	ss   31.74207   1.621534    19.58   0.000     28.56392    34.92022
8       4	sc   70.80253    1.78048    39.77   0.000     67.31286    74.29221
8       5	aa   57.27598   2.339128    24.49   0.000     52.69138    61.86059
8       5	ss   29.26495   1.638382    17.86   0.000     26.05378    32.47612
8       5	sc   68.32542   1.794415    38.08   0.000     64.80843     71.8424
8       6	aa   54.79887   2.351421    23.30   0.000     50.19017    59.40757
8       6	ss   26.78783   1.667365    16.07   0.000     23.51986    30.05581
8       6	sc    65.8483   1.819514    36.19   0.000     62.28211    69.41448
end

** Prepare margins dataset for tabulation

** Geno
rename geno t1 
gen geno = 1 if t1=="aa"
replace geno = 2 if t1=="ss"
replace geno = 3 if t1=="sc"
label define geno_ 1 "aa" 2 "ss" 3 "sc"
label values geno geno_

** Age
label define age_ 1 "12" 2 "14" 3 "16" 4 "18" 5 "20" 6 "22"
label values age age_ 

** Model 
label define model_ 1 "reg-ignore" 2 "reg_breath" 3 "reg-atrophy" 4 "reg-full" 5 "tobit-ignore" 6 "tobit-breath" 7 "tobit-atrophy" 8 "tobit-full"  
label values model model_

** Estimate
rename est spleen

** Keep variables
keep model geno age spleen lb ub

** Keep at age 12 and at age 22
keep if age==1 | age==6
** Keep full estimation
keep if model==1 | model==4 | model==8

** Reshape
reshape wide spleen lb ub , i(model age) j(geno)

** Table of marginal estimates
	rename model Model
	rename age Age
	format spleen1 %5.2fc 
	format spleen2 %5.2fc 
	format spleen3 %5.2fc 
	format lb1 %5.2fc 
	format lb2 %5.2fc 
	format lb3 %5.2fc 
	format ub1 %5.2fc 
	format ub2 %5.2fc 
	format ub3 %5.2fc 

	putdocx begin , font(calibri light, 10)
	putdocx paragraph 
		putdocx text ("Table "), bold
		putdocx text ("Spleen length predictions among AA, SC, SS participants"), 
		** Place data 
		putdocx table ss = data("Model Age spleen1 lb1 ub1 spleen2 lb2 ub2 spleen3 lb3 ub3"), varnames headerrow(2)

		** Line colors + Shadng
		putdocx table ss(2,.), border(bottom, single, "e6e6e6")
		putdocx table ss(4,.), border(bottom, single, "e6e6e6")
		putdocx table ss(6,.), border(bottom, single, "e6e6e6")
		putdocx table ss(.,4), border(right, single, "e6e6e6")
		putdocx table ss(.,7), border(right, single, "e6e6e6")
		putdocx table ss(.,10), border(right, single, "e6e6e6")
		putdocx table ss(1,.),  shading("e6e6e6")
		putdocx table ss(.,1),  shading("e6e6e6")

		** Row headers
		putdocx table ss(1,1) = ("Model"),  font(calibri light,10, "000000")
		putdocx table ss(1,2) = ("Age"),  font(calibri light,10, "000000")
		putdocx table ss(1,3) = ("AA Spleen"),  font(calibri light,10, "000000")
		putdocx table ss(1,4) = ("95% lo"),  font(calibri light,10, "000000")
		putdocx table ss(1,5) = ("95% hi"),  font(calibri light,10, "000000")
		putdocx table ss(1,6) = ("SS Spleen"),  font(calibri light,10, "000000")
		putdocx table ss(1,7) = ("95% lo"),  font(calibri light,10, "000000")
		putdocx table ss(1,8) = ("95% hi"),  font(calibri light,10, "000000")
		putdocx table ss(1,9) = ("SC Spleen"),  font(calibri light,10, "000000")
		putdocx table ss(1,10) = ("95% lo"),  font(calibri light,10, "000000")
		putdocx table ss(1,11) = ("95% hi"),  font(calibri light,10, "000000")
		** Column headers
		putdocx table ss(2,1) = ("Ignore Unmeasured Spleens (Table A, Model 1)"),  font(calibri light,10, "000000")
		putdocx table ss(3,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(4,1) = ("Full Estimation. No Censoring (Table A, Model 4)."),  font(calibri light,10, "000000")
		putdocx table ss(5,1) = (" "),  font(calibri light,10, "000000")
		putdocx table ss(6,1) = ("Full Estimation, Censored Atrophy (Table A, Model 4)"),  font(calibri light,10, "000000")
		putdocx table ss(7,1) = (" "),  font(calibri light,10, "000000")

		** Merge cells
		putdocx table ss(2,1),rowspan(2)
		putdocx table ss(4,1),rowspan(2)
		putdocx table ss(6,1),rowspan(2)

		** Redistribute row widths
		putdocx table ss(.,1), width(33%)

	putdocx save "`outputpath'/regression_predictions", replace

