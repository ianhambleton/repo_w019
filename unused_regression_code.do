** XTREG. No height adjustment
xtreg saheight_reg c.aaexam##geno if aaexam>=12 & aaexam<=22 & geno==1
 	* genotype difference
 	margins geno, at(aaexam=(12(2)22)) vsquish
 	marginsplot, x(aaexam) name(xtreg)  ylab(0(20)80)
 	** Test of genotype differences at various ages
 	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish
** Relative to SC
xtreg saheight_reg c.aaexam##ib3.geno if aaexam>=12 & aaexam<=22
	** Test of differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

** FINAL TOBIT MODEL
** TOBIT: Adjusted for height
* Relative to AA
xttobit saheight_reg c.aaexam##geno if aaexam>=12 & aaexam<=22 , ll(lcensor_val)
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(tobit)  ylab(0(20)80)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish
** Relative to SC
xttobit saheight_reg c.aaexam##ib3.geno if aaexam>=12 & aaexam<=22 , ll(lcensor_val)
	** Test of differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish











/*
** XTREG. No height adjustment
xtreg sheight_ip c.aaexam##geno if aaexam>=12 & aaexam<=22 
	* genotype difference
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(xtreg_unadj) ylab(40(20)140)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

** TOBIT: No height adjustment
xttobit sheight_ip c.aaexam##geno if aaexam>=12 & aaexam<=22 , ll(45)
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(tobit_unadj)  ylab(40(20)140)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

** XTREG. Adjusted for height
xtreg sheight_ip c.aaexam##geno c.height_ip if aaexam>=12 & aaexam<=22 
	* genotype difference
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(xtreg_unadj_ht) ylab(40(20)140)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

** TOBIT: Adjusted for height
xttobit sheight_ip c.aaexam##geno c.height_ip if aaexam>=12 & aaexam<=22 , ll(45)
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(tobit_unadj_ht)  ylab(40(20)140)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

** Adjusted 
xtreg saheight_ip c.aaexam##geno height_ip if aaexam>=12 & aaexam<=22 
	* genotype difference
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(xtreg_adj) ylab(0(20)100)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish 
	** Test of age change for each genotype
** Baseline SC
xtreg saheight_ip c.aaexam##ib3.geno if aaexam>=12 & aaexam<=22 
	** Test of differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish













/*
** TOBIT: Censored regression - censored at lower limit spleen length of 45mm
xttobit sheight_ip c.aaexam##geno if aaexam>=12 & aaexam<=22 , ll(45)
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(tobit_unadj)  ylab(40(20)140)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish

xttobit saheight_ip c.aaexam##geno if aaexam>=12 & aaexam<=22 , ll(lcensor_val)
	margins geno, at(aaexam=(12(2)22)) vsquish
	marginsplot, x(aaexam) name(tobit_adj) ylab(0(20)100)
	** Test of genotype differences at various ages
	margins, dydx(geno) at(aaexam=(12(2)22)) vsquish


