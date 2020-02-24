* Jennifer Jackson
* 11 April 2019

* APSTA.GE 2110
* Problem Set 8

log using "JenniferJackson_PS8", text

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* (a) The target population of the PISA was students age 15, attending school or
* vocational training, either full-time or part-time, anywhere between grade 7
* and up. This excluded those who were homeschooled and those studying abroad.

* (b) The sampling design used in each country was a two-stage stratified
* design, except in Russia, where it was a three-stage stratified design. For
* the two-stage stratifications, schools made up the first stratum and students
* within those sampled schools made up the second stratum. In Russia, the first
* stratum consisted of various sampled geographical locations within the
* country. The second stratum consisted of schools within those areas and the
* first stratum consisted of students within those schools.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* This .do file analyses 2015 data from the OECD's Programme for International
* Student Assessment (PISA).

cd "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS8"
use "PISA 2015 seven countries.dta", clear

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

summarize pv1math-pv10math
summarize pv1scie-pv10scie
* For both maths and science, the score means and standard deviations among the
* plausible values hardly vary at all.

tabstat pv1math-pv10math, statistics(mean sd) by (cnt)
tabstat pv1scie-pv10scie, statistics(mean sd) by (cnt)
* Between countries, there is much more variance in scores for both maths and
* science. The range of maths scores and the range of science scores are both
* more than 100 points.

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* (a) "While the students included in the final PISA sample for a given country
* were chosen randomly, the selection probabilities of the students vary. Survey
* weights must be incorporated into the analysis to ensure that each sampled
* student appropriately represents the correct number of students in the full
* PISA population." (PISA 2015 Technical Report, Chapter 8, p 116)

* (b) The methodology recommended for calculating variance is called "balanced
* repeated replication" (BRR), more specifically, "Fay's method".  

* PROBLEM 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

svyset [pweight = w_fstuwt], vce(brr) fay(0.5) mse brrweight(w_fsturwt1-w_fsturwt80)

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* Check possible values for "cnt".
codebook cnt

* Create a new variable "cnt_num" to represent the country codes numerically.
gen cnt_num = 1  /* "AUS" */
replace cnt_num = 2 if cnt == "BRA"
replace cnt_num = 3 if cnt == "EST"
replace cnt_num = 4 if cnt == "FIN"
replace cnt_num = 5 if cnt == "JPN"
replace cnt_num = 6 if cnt == "KOR"
replace cnt_num = 7 if cnt == "USA"

* Mean MATHS scores organised by country:
mean pv1math, over(cnt_num)
* Mean MATHS scores organised by country, taking into account survey design:
svy: mean pv1math, over(cnt_num)

* Mean SCIENCE scores organised by country:
mean pv1scie, over(cnt_num)
* Mean SCIENCE scores organised by country, taking into account survey design:
svy: mean pv1scie, over(cnt_num)

* In general, for both maths and science, taking into account survey design 
* slightly lowers the variance of means among the seven countries and increases
* the standard error for those means (when compared to means not taking into
* account the BRR approach to weighting the data).

* PROBLEM 7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

** MATHS **

* Regression Analysis of economic, social & cultural status as a predictor of
* maths scores.

* NOT taking into account survey design:
regress pv1math escs
* Math = 50.5(Status) + 475      SE = .35 and .39
* A one unit increase in status is associated with an average increase in maths
* score of 50.5 points.

* Taking into account survey design:
svy: regress pv1math escs
* Math = 44.0(Status) + 470      SE = .83 and 1.40
* A one unit increase in status is associated with an average increase in maths
* score of 44 points.

** SCIENCE **

* Regression Analysis of economic, social & cultural status as a predictor of
* science scores.

* NOT taking into account survey design:
regress pv1scie escs
* Science = 48.0(Status) + 492      SE = .36 and .39
* A one unit increase in status is associated with an average increase in science
* score of 48 points.

* Taking into account survey design:
svy: regress pv1scie escs
* Science = 43.2(Status) + 489      SE = .80 and 1.32
* A one unit increase in status is associated with an average increase in science
* score of 43.2 points.

** SUMMARY **
* In general, taking into account survey design leads to smaller slope
* coefficients (smaller increases in scores) and larger standard errors.

* PROBLEM 8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

svy: regress pv1math escs c.escs#b7.cnt_num
svy: regress pv1scie escs c.escs#b7.cnt_num

* In Australia, Brasil, Estonia and Finland, there was a positive association
* between status and test scores. An increase in status was associated with an
* increase in score that is even greater than the increase that would be seen
* in the USA. I.e., the interaction effect between status and score in these
* countries was stronger than it was in the USA. In Japan and Korea, there was
* also a positive association between status and test scores. However, compared
* to the USA, the interaction effect was weaker. These relationships held for
* both maths and science scores.

log close


**** ADDED AFTER SUBMITTING ASSIGNMENT ****
margins cnt_num, at(escs=(-2000(100)2000))
marginsplot
