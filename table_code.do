
** -----------------------------------------------------
** AUTOMATED WORD TABLE FOR REPORT
** -----------------------------------------------------
** matrix twidth = (20, 13, 13, 13, 13, 13, 13)

putdocx begin , pagesize(A4) font(calibri light, 9)
putdocx table t2 = (35 , 8) 

** ----------------------
** Formatting
** ----------------------
putdocx table t2(.,1), width(25%) 

** All cells - vertical centering
putdocx table t2(.,.), valign(center) 

** ROWS 1 and 2 - shading
putdocx table t2(1/2,.), bold border(all, single, "000000") shading("bfbfbf")
/// putdocx table t2(3,.) , shading("e6e6e6")
/// putdocx table t2(12,.) , shading("e6e6e6")

** Line colors
putdocx table t2(3/5,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(7/9,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(11/13,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(15/17,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(19/21,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(23/25,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(27/29,.), bold border(bottom, single, "e6e6e6")
putdocx table t2(31/33,.), bold border(bottom, single, "e6e6e6")

** Merge rows
putdocx table t2(1,3),colspan(2)
putdocx table t2(1,4),colspan(2)
putdocx table t2(1,5),colspan(2)
    ** ROW 10 as single cell for comments
putdocx table t2(35,1),colspan(7)
putdocx table t2(35,.),halign(left) font(calibri light, 8)
putdocx table t2(35,.),border(left, single, "FFFFFF")
putdocx table t2(35,.),border(right, single, "FFFFFF")
putdocx table t2(35,.),border(bottom, single, "FFFFFF")

** ----------------------
** Row and Column Titles
** ----------------------
putdocx table t2(1,3) = ("Number of events "),  font(calibri light,10, "000000")
putdocx table t2(2,3) = ("2000 "),              font(calibri light,10, "000000") 
putdocx table t2(2,4) = ("2019 "),              font(calibri light,10, "000000") 

putdocx table t2(1,4) = ("Rate per 100,000"),   font(calibri light,10, "000000")
putdocx table t2(2,5) = ("2000 "),              font(calibri light,10, "000000") 
putdocx table t2(2,6) = ("2019 "),              font(calibri light,10, "000000") 

putdocx table t2(1,5) = ("Percent change (2000 - 2019)"),  font(calibri light,10, "000000")
putdocx table t2(2,7) = ("Rate "),  font(calibri light,10, "000000")
putdocx table t2(2,8) = ("Count "),  font(calibri light,10, "000000")

** ROW headers
putdocx table t2(3,1) = ("CVD "), halign(left) bold
putdocx table t2(7,1) = ("Cancer "), halign(left) bold
putdocx table t2(11,1) = ("Respiratory "), halign(left) bold
putdocx table t2(15,1) = ("Diabetes "), halign(left) bold
putdocx table t2(19,1) = ("Mental Health "), halign(left) bold
putdocx table t2(23,1) = ("Neurological "), halign(left) bold
putdocx table t2(27,1) = ("Combined NCD "), halign(left) bold
putdocx table t2(27,1) = ("1"), halign(left) script(super) append
putdocx table t2(31,1) = ("All NCD "), halign(left) bold
putdocx table t2(31,1) = ("2"), halign(left) script(super) append

putdocx table t2(3,2) = ("Deaths "), halign(left) bold
putdocx table t2(4,2) = ("DALYs "), halign(left) bold
putdocx table t2(5,2) = ("YLLs "), halign(left) bold
putdocx table t2(6,2) = ("YLDs "), halign(left) bold
putdocx table t2(7,2) = ("Deaths "), halign(left) bold
putdocx table t2(8,2) = ("DALYs "), halign(left) bold
putdocx table t2(9,2) = ("YLLs "), halign(left) bold
putdocx table t2(10,2) = ("YLDs "), halign(left) bold
putdocx table t2(11,2) = ("Deaths "), halign(left) bold
putdocx table t2(12,2) = ("DALYs "), halign(left) bold
putdocx table t2(13,2) = ("YLLs "), halign(left) bold
putdocx table t2(14,2) = ("YLDs "), halign(left) bold
putdocx table t2(15,2) = ("Deaths "), halign(left) bold
putdocx table t2(16,2) = ("DALYs "), halign(left) bold
putdocx table t2(17,2) = ("YLLs "), halign(left) bold
putdocx table t2(18,2) = ("YLDs "), halign(left) bold
putdocx table t2(19,2) = ("Deaths "), halign(left) bold
putdocx table t2(20,2) = ("DALYs "), halign(left) bold
putdocx table t2(21,2) = ("YLLs "), halign(left) bold
putdocx table t2(22,2) = ("YLDs "), halign(left) bold
putdocx table t2(23,2) = ("Deaths "), halign(left) bold
putdocx table t2(24,2) = ("DALYs "), halign(left) bold
putdocx table t2(25,2) = ("YLLs "), halign(left) bold
putdocx table t2(26,2) = ("YLDs "), halign(left) bold
putdocx table t2(27,2) = ("Deaths "), halign(left) bold
putdocx table t2(28,2) = ("DALYs "), halign(left) bold
putdocx table t2(29,2) = ("YLLs "), halign(left) bold
putdocx table t2(30,2) = ("YLDs "), halign(left) bold
putdocx table t2(31,2) = ("Deaths "), halign(left) bold
putdocx table t2(32,2) = ("DALYs "), halign(left) bold
putdocx table t2(33,2) = ("YLLs "), halign(left) bold
putdocx table t2(34,2) = ("YLDs "), halign(left) bold


** ----------------------
** DATA
** ----------------------
** COL3. COUNT in 2000
putdocx table   t2(3,3) = ("$count3_3a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(4,3) = ("$count3_3b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(5,3) = ("$count3_3c") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(6,3) = ("$count3_3d") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(7,3) = ("$count4_3a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(8,3) = ("$count4_3b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(9,3) = ("$count4_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(10,3) = ("$count4_3d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(11,3) = ("$count5_3a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(12,3) = ("$count5_3b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(13,3) = ("$count5_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(14,3) = ("$count5_3d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(15,3) = ("$count6_3a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(16,3) = ("$count6_3b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(17,3) = ("$count6_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(18,3) = ("$count6_3d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(19,3) = ("$count7_3a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(20,3) = ("$count7_3b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(21,3) = ("$count7_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(22,3) = ("$count7_3d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(23,3) = ("$count8_3a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(24,3) = ("$count8_3b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(25,3) = ("$count8_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(26,3) = ("$count8_3d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(27,3) = ("$count9_3a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(28,3) = ("$count9_3b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(29,3) = ("$count9_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(30,3) = ("$count9_3d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(31,3) = ("$count1_3a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(32,3) = ("$count1_3b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(33,3) = ("$count1_3c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(34,3) = ("$count1_3d") , nformat(%12.0fc) trim halign(right)

** COL4. COUNT in 2019
putdocx table   t2(3,4) = ("$count3_4a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(4,4) = ("$count3_4b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(5,4) = ("$count3_4c") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(6,4) = ("$count3_4d") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(7,4) = ("$count4_4a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(8,4) = ("$count4_4b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(9,4) = ("$count4_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(10,4) = ("$count4_4d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(11,4) = ("$count5_4a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(12,4) = ("$count5_4b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(13,4) = ("$count5_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(14,4) = ("$count5_4d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(15,4) = ("$count6_4a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(16,4) = ("$count6_4b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(17,4) = ("$count6_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(18,4) = ("$count6_4d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(19,4) = ("$count7_4a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(20,4) = ("$count7_4b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(21,4) = ("$count7_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(22,4) = ("$count7_4d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(23,4) = ("$count8_4a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(24,4) = ("$count8_4b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(25,4) = ("$count8_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(26,4) = ("$count8_4d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(27,4) = ("$count9_4a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(28,4) = ("$count9_4b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(29,4) = ("$count9_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(30,4) = ("$count9_4d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(31,4) = ("$count1_4a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(32,4) = ("$count1_4b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(33,4) = ("$count1_4c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(34,4) = ("$count1_4d") , nformat(%12.0fc) trim halign(right)

** COL5: RATE in 2000
putdocx table   t2(3,5) = ("$rate3_5a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(4,5) = ("$rate3_5b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(5,5) = ("$rate3_5c") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(6,5) = ("$rate3_5d") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(7,5) = ("$rate4_5a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(8,5) = ("$rate4_5b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(9,5) = ("$rate4_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(10,5) = ("$rate4_5d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(11,5) = ("$rate5_5a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(12,5) = ("$rate5_5b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(13,5) = ("$rate5_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(14,5) = ("$rate5_5d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(15,5) = ("$rate6_5a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(16,5) = ("$rate6_5b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(17,5) = ("$rate6_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(18,5) = ("$rate6_5d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(19,5) = ("$rate7_5a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(20,5) = ("$rate7_5b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(21,5) = ("$rate7_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(22,5) = ("$rate7_5d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(23,5) = ("$rate8_5a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(24,5) = ("$rate8_5b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(25,5) = ("$rate8_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(26,5) = ("$rate8_5d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(27,5) = ("$rate9_5a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(28,5) = ("$rate9_5b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(29,5) = ("$rate9_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(30,5) = ("$rate9_5d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(31,5) = ("$rate1_5a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(32,5) = ("$rate1_5b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(33,5) = ("$rate1_5c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(34,5) = ("$rate1_5d") , nformat(%12.0fc) trim halign(right)


** COL6. RATE in 2019
putdocx table   t2(3,6) = ("$rate3_6a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(4,6) = ("$rate3_6b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(5,6) = ("$rate3_6c") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(6,6) = ("$rate3_6d") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(7,6) = ("$rate4_6a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(8,6) = ("$rate4_6b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(9,6) = ("$rate4_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(10,6) = ("$rate4_6d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(11,6) = ("$rate5_6a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(12,6) = ("$rate5_6b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(13,6) = ("$rate5_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(14,6) = ("$rate5_6d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(15,6) = ("$rate6_6a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(16,6) = ("$rate6_6b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(17,6) = ("$rate6_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(18,6) = ("$rate6_6d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(19,6) = ("$rate7_6a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(20,6) = ("$rate7_6b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(21,6) = ("$rate7_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(22,6) = ("$rate7_6d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(23,6) = ("$rate8_6a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(24,6) = ("$rate8_6b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(25,6) = ("$rate8_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(26,6) = ("$rate8_6d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(27,6) = ("$rate9_6a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(28,6) = ("$rate9_6b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(29,6) = ("$rate9_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(30,6) = ("$rate9_6d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(31,6) = ("$rate1_6a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(32,6) = ("$rate1_6b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(33,6) = ("$rate1_6c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(34,6) = ("$rate1_6d") , nformat(%12.0fc) trim halign(right)

** COL7. Percent change in RATE
putdocx table   t2(3,7) = ("$pc3_7a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(4,7) = ("$pc3_7b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(5,7) = ("$pc3_7c") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(6,7) = ("$pc3_7d") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(7,7) = ("$pc4_7a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(8,7) = ("$pc4_7b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(9,7) = ("$pc4_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(10,7) = ("$pc4_7d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(11,7) = ("$pc5_7a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(12,7) = ("$pc5_7b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(13,7) = ("$pc5_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(14,7) = ("$pc5_7d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(15,7) = ("$pc6_7a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(16,7) = ("$pc6_7b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(17,7) = ("$pc6_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(18,7) = ("$pc6_7d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(19,7) = ("$pc7_7a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(20,7) = ("$pc7_7b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(21,7) = ("$pc7_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(22,7) = ("$pc7_7d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(23,7) = ("$pc8_7a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(24,7) = ("$pc8_7b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(25,7) = ("$pc8_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(26,7) = ("$pc8_7d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(27,7) = ("$pc9_7a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(28,7) = ("$pc9_7b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(29,7) = ("$pc9_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(30,7) = ("$pc9_7d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(31,7) = ("$pc1_7a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(32,7) = ("$pc1_7b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(33,7) = ("$pc1_7c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(34,7) = ("$pc1_7d") , nformat(%12.0fc) trim halign(right)

** COL8. Percent change in COUNT
putdocx table   t2(3,8) = ("$pnum3_8a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(4,8) = ("$pnum3_8b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(5,8) = ("$pnum3_8c") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(6,8) = ("$pnum3_8d") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(7,8) = ("$pnum4_8a") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(8,8) = ("$pnum4_8b") , nformat(%12.0fc) trim halign(right)
putdocx table   t2(9,8) = ("$pnum4_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(10,8) = ("$pnum4_8d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(11,8) = ("$pnum5_8a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(12,8) = ("$pnum5_8b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(13,8) = ("$pnum5_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(14,8) = ("$pnum5_8d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(15,8) = ("$pnum6_8a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(16,8) = ("$pnum6_8b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(17,8) = ("$pnum6_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(18,8) = ("$pnum6_8d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(19,8) = ("$pnum7_8a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(20,8) = ("$pnum7_8b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(21,8) = ("$pnum7_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(22,8) = ("$pnum7_8d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(23,8) = ("$pnum8_8a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(24,8) = ("$pnum8_8b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(25,8) = ("$pnum8_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(26,8) = ("$pnum8_8d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(27,8) = ("$pnum9_8a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(28,8) = ("$pnum9_8b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(29,8) = ("$pnum9_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(30,8) = ("$pnum9_8d") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(31,8) = ("$pnum1_8a") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(32,8) = ("$pnum1_8b") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(33,8) = ("$pnum1_8c") , nformat(%12.0fc) trim halign(right)
putdocx table  t2(34,8) = ("$pnum1_8d") , nformat(%12.0fc) trim halign(right)


** FINAL TABLE NOTES
putdocx table t2(35,1) = ("(1) ") , script(super) font(calibri light, 8)
putdocx table t2(35,1) = ("Combined NCDs, includes the following six groups of conditions: cardiovascular diseases, cancers, chronic respiratory diseases, diabetes, mental and substance-use disorders, neurological conditions.") , append font(calibri light, 8) 

putdocx table t2(35,1) = ("(2) ") , script(super) font(calibri light, 8) append
putdocx table t2(35,1) = ("All NCDs, includes all noncommunicable diseases") , append font(calibri light, 8) 

** Save the Table
putdocx save "`outputpath'/articles/paper-ncd/article-draft/ncd_table2_version2", replace 


