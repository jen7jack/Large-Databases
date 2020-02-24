* Jennifer Jackson
* 16 May 2019

* APSTA.GE 2110
* Problem Set 11

cd "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS11"
log using "JenniferJackson_PS11", text
use "LUSD_sub_4_5.dta", clear

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                        	
* (a)
drop if grade==4
* MODEL 1
xtreg mathz age female lep speced immig econdis black hispanic asian i.year mathz_1, fe
eststo
* stored as est1
* For 5th grade, when using a fixed effect for classroom teacher, maths scores
* are only directly related to immigration status and Asian ethnicity.

* (b)
* MODEL 2
xtreg mathz age female lep speced immig econdis black hispanic asian i.year mathz_1, re
eststo
* stored as est2
* When using a random effect for the classroom teacher, the effects of the
* covariates are only slighly changed (in both directions - some a bit higher and
* some a bit lower).

* (c)
hausman est1 est2
* The p-value for this test is 0, meaning that we reject the null hypothesis.
* I.e., we do have reason to believe there is a systematic difference in
* coefficients between these two models. Because the Chi-Squared statistic is
* statistically significant, we should not use the random effects model.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                        	

use "LUSD_sub_4_5.dta", clear
* Can only use students who have both 4th grade and 5th grade data (6,247 students)
duplicates tag id, generate (dupe)
drop if dupe == 0

* (a)
gen same_race = 0
replace same_race = 1 if tch_black == 1 & black == 1 & year == 2005
* 1,077 black teacher/student matches in 2005
replace same_race = 1 if tch_black == 1 & black == 1 & year == 2006
* 1,169 black teacher/student matches in 2006

replace same_race = 1 if tch_hisp == 1 & hispanic == 1 & year == 2005
* 1,903 Hispanic teacher/student matches in 2005
replace same_race = 1 if tch_hisp == 1 & hispanic == 1 & year == 2006
* 1,313 Hispanic teacher/student matches in 2006

replace same_race = 1 if tch_asian == 1 & asian == 1 & year == 2005
* 14 Asian teacher/student matches in 2005
replace same_race = 1 if tch_asian == 1 & asian == 1 & year == 2006
* 6 Asian teacher/student matches in 2006

replace same_race = 1 if tch_white == 1 & white == 1 & year == 2005
* 470 white teacher/student matches
replace same_race = 1 if tch_white == 1 & white == 1 & year == 2006
* 456 white teacher/student matches

* In 2005, there were 6,247 student observations and 3,464 of those were
* same-race matches between teachers and students. That is a 55% match rate
* for 2005.

* In 2006, of the 6,247 student observations, 2,944 were same-race matches
* between teachers and students. That is a 47% match rate for 2006.

* (b)
* MODEL 3
xtset id year
xtreg mathz age female lep speced immig econdis black hispanic asian i.year mathz_1 same_race, fe
eststo
* stored as est3
* The coefficient of "same_race" is 0.03 and is statistically significant. This
* means that a student paired with a teacher of the same race will see a slight
* increase in maths scores (about 3 points on average).

* (c)
xttrans same_race
* Of the 47.13% of students ever matched with teachers of the same race, 67.32%
* of those students stayed matched from 4th grade to 5th grade.

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                        	

use "math_BMI_sub.dta", clear

* (a) Reshape data.

* Time-varying variables:
rename C1R3MSCL cr3mscl1
rename C2R3MSCL cr3mscl2
rename C3R3MSCL cr3mscl3
rename C4R3MSCL cr3mscl4
rename C5R3MSCL cr3mscl5
rename C6R3MSCL cr3mscl6
rename C1BMI cbmi1
rename C2BMI cbmi2
rename C3BMI cbmi3
rename C4BMI cbmi4
rename C5BMI cbmi5
rename C6BMI cbmi6

reshape long cr3mscl cbmi, i(CHILDID GENDER RACE R3SAMPLE FKCHGSCH R4R2SCHG ///
R5R4SCHG R6R5SCHG P1FIRKDG T6GLVL) j(when) string
* "when" takes on the values 1 through 6

* (b)
drop if cbmi==.
drop if cbmi <0
drop if cr3mscl==.

* Model 1
regress cr3mscl cbmi
eststo
* stored as est4

* Model 2
destring when, generate(time)
regress cr3mscl cbmi i.time
eststo
* stored as est5

* (c)
* Model 3
xtset time
xtreg cr3mscl cbmi, fe
* By making time the fixed effect, we're looking at the effect of maths scores
* on bmi for each time interval.
eststo
* stored as est6

* (d)
estimates table est4 est5 est6
* Model 1, a simple OLS regression, gives a positive coefficient of 3.57, but
* when taking into account that this is panel data, Models 2 and 3 both give the
* same negative coefficient: -0.35. This can be interpreted as, for every one
* unit increase in BMI, on average, there is a -0.35 point decrease in maths
* scores.

log close



