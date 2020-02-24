* Jennifer Jackson
* 28 March 2019

* APSTA.GE 2110
* Problem Set 6

log using "JenniferJackson_PS6", text
use "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS6/FFCWS_sub2.dta"

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* This .do file analyses data from the Fragile Families and Child Wellbeing
* Study.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

describe
* 16 Variables
* 1,154 Observations

codebook
* No values are missing.

* Categorical Variables (7): usborn, firstborn, lbw, male, momrace, momeduc,
* povertystatus

* Continuous Variables (9): wjss, ageatbirth, numberofmoves, internalizing,
* attention, exdternalizing, ppvt, childage_mos, avgpoverty_topcode

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

tabulate momrace momeduc, cell
* 11.09% of the mothers had completed college.

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* group average poverty into 3 levels
gen income_group = 1
replace income_group = 2 if avgpoverty_topcode >=1 & avgpoverty_topcode<2
replace income_group = 3 if avgpoverty_topcode >= 2

tabstat wjss ageatbirth, by (income_group) statistics (mean sd med p75)

*     Income Group 1      WJ Score   Mother's Age

*               mean      94.6       19 
* standard deviation      13.9       4
*             median      95         19
*    75th percentile      104.5      21
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Income Group 2      WJ Score   Mother's Age

*               mean      100.1      21 
* standard deviation      14.3       4
*             median      102        19
*    75th percentile      108        22
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Income Group 3      WJ Score   Mother's Age

*               mean      105.1      25 
* standard deviation      14.8       6
*             median      105        24
*    75th percentile      112        29


* PROBLEM 5a ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

regress wjss avgpoverty_topcode
* The linear model is wjss = 3.3(avgpoverty_topcode) + 93.9
* This means that for every 1 unit increase in avgpoverty (i.e., up and out of
* poverty), there are, on average, 3.3 points added to a kid's Woodcock Johnson
* score.

* PROBLEM 5b ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

regress wjss b3.income_group
* Excluding the highest income category, the linear model is now
* wjss = -10.5(income_group1) - 5.0(income_group2) + 105.1
* This means there is a 10.5 point difference (drop) in WJ points from group 3
* to group 1 and there is a 5 point drop in points from group 3 to group 2.

* PROBLEM 5c ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

regress wjss usborn#ib3.income_group
* Having an interaction term essentially means that a mother's country of birth
* has an effect on how income group effects a child's WJ scores.
* If you had a regression line for WJ score and mother's country of birth and a
* second regression line for WJ score and income group, the coefficient of the
* interaction term would represent the difference between the two slopes of
* those lines.

* In this particular case, for example, if a mother were a US native
* (usborn = 1) and she were in income group 1 (lowest income bracket in this
* context), then there would be, on average, a 12-point drop in WJ score
* compared to the standard of comparison - in this case, a non-US native in the
* highest income bracket (usborn#income_group: (0 3)).  

* PROBLEM 5d ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

margins usborn#income_group
* Income Group 1:
* WJ score if US native mother = 95.02
* WJ score if non-US native mother = 90.61
* Differnce = 4.41 points

margins usborn income_group
* Children of US native mothers have average WJ scores of 99.79 whereas children
* of non-US native mothers only have average WJ scores of 98.43.

margins r.usborn@income_group
* For all three income groups, the difference in scores between children of US
* and non-US native mothers is not statistically significant (none of the three
* p-values are less than 5%).

* PROBLEM 6a ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

regress wjss male avgpoverty_topcode
estimates store x
estout x, cells (b se _star)
* The 3 stars indicate p-values < 0.001

* PROBLEM 6b ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

regress wjss male avgpoverty_topcode i.usborn ageatbirth i.momrace
estimates store y
estout y, cells (b se _star)
* The 2 stars indicate p-values < 0.01

log close

