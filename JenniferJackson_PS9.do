* Jennifer Jackson
* 18 April 2019

* APSTA.GE 2110
* Problem Set 9

* PROBLEMS 1~2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                        	

cd "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS9"
log using "JenniferJackson_PS9", text
use "Week 11 ECLSK Replication.dta", clear

* Convert all variable names to lowercase.
rename *, lower

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* (a) The PSU variable is "bycwpsu" and the strata variable is "bycwstr".

* (b) Define the survey design.
svyset bycwpsu [pweight=bycw0], strata(bycwstr)

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* (a) Define new variable for race.
gen race_v2 = 1  /* White */
replace race_v2 = 2 if w1raceth == 2  /* Black */
replace race_v2 = 3 if w1raceth == 3 | w1raceth == 4 /* Hispanic */
replace race_v2 = 4 if w1raceth == 5 | w1raceth == 6 /* Asian/Pacific Islander */
replace race_v2 = 5 if w1raceth == 7 | w1raceth == 8  /* Other */
replace race_v2 = 0 if w1raceth == -9 | w1raceth == .  /* Missing Values */

* Add Labels
label define race_v2 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian/Pacific Islander" 5 "Other" 0 "Missing", replace

* Check to make sure everyone is accounted for.
tabulate w1raceth race_v2

* Compare frequency to proportion.
tabulate race_v2
svy: tabulate race_v2

* The survey design adjusts the "Asian/Pacific Islander" category the most,
* implying that this group was oversampled.

** In order to recreate Table 2 in Problem 7 below, it's necessary to dummy code
* this race variable as follows:
gen Black = 0
replace Black = 1 if race_v2==2
gen Hispanic = 0
replace Hispanic = 1 if race_v2==3
gen Asian = 0
replace Asian = 1 if race_v2==4
gen Other = 0
replace Other = 1 if race_v2==5


* (b) Copy p1hmafb variable.
gen momage = p1hmafb

* (c) Create dummy variable to differentiate teen mothers.
gen teen = .
replace teen = 1 if p1hmafb <= 19 & p1hmafb >= 12
replace teen = 0 if p1hmafb > 19 & p1hmafb <= 49
tabulate teen /* Only 16,803 applicable values */
* 4,368 known teen mothers
* 12,435 not

* (d) Create dummy variable to differentiate new mothers in 30s.
gen thirties =.
replace thirties = 1 if p1hmafb >=30 & p1hmafb <=39
replace thirties = 0 if p1hmafb <30 & p1hmafb >=12 /* under 30 */
replace thirties = 0 if p1hmafb <=49 & p1hmafb > 39 /* over 30 */
tabulate thirties
* 2,671 known new mothers in 30s
* 14,132 not

* (e) Create dummy variable for gender.
gen female =.
replace female = 1 if gender == 2
replace female = 0 if gender == 1
tabulate female
* 10,446 known females
* 10,950 known males

* (f) Create a dummy variable to differentiate WIC participants.
gen wic =.
replace wic = 1 if p1wic ==1
replace wic = 0 if p1wic ==2
tabulate wic

* (g) Create two variables for book ownership.
gen books = p1chlboo if p1chlboo <= 200 & p1chlboo >=0
tabulate books
* Only 17,912 applicable values

gen books2 = (books^2)/1000

* (h) Create z-scores for fall kindergarten maths and reading scores.
gen math_z = c1r4mscl
replace math_z =. if c1r4mscl == -9
replace math_z =. if c1r4mscl == -8
replace math_z =. if c1r4mscl == -7
replace math_z =. if c1r4mscl == -1

tabstat math_z, stat(mean sd)
* mean = 25.90539
* sd = 9.099181
replace math_z = (math_z - 25.90539)/9.099181
* math_z is now the z score for maths scores


gen reading_z = c1r4rscl
replace reading_z =. if c1r4rscl == -9
replace reading_z =. if c1r4rscl == -8
replace reading_z =. if c1r4rscl == -7
replace reading_z =. if c1r4rscl == -1

tabstat reading_z, stat(mean sd)
* mean = 35.21451
* sd = 10.19878
replace reading_z = (reading_z - 35.21451)/10.19878
* reading_z is now the z score for reading scores

* (i) Create variable to express total weight in ounces.
* 1 lb = 16 oz
* Make copies to ensure no information is lost.
gen pounds = p1weighp
replace pounds = . if p1weighp == -9
replace pounds = . if p1weighp == -8
replace pounds = . if p1weighp == -7
replace pounds = . if p1weighp == -1

gen ounces = p1weigho
replace ounces = . if p1weigho == -9
replace ounces = . if p1weigho == -8
replace ounces = . if p1weigho == -7
replace ounces = . if p1weigho == -1

gen birthweight = (pounds*16 + ounces)/10

* (j) Copy variable for SES.
gen ses = wksesl

* (k) Tweak missing values.

* NEW VARIABLES
* race_v2
* momage ------- replace "." with 0
* teen --------- replace "." with 0
* thirties ----- replace "." with 0
* female ------- replace "." with 0 (this wouldn't make sense because male = 0)
* wic ---------- replace "." with 0
* books -------- replace "." with 0
* books2 ------- replace "." with 0
* math_z
* reading_z
* birthweight -- replace "." with 0
* ses ---------- replace "." with 0

* Create flags for missing values.
gen momage_miss = 0
replace momage_miss = 1 if momage ==.

gen teen_miss = 0
replace teen_miss = 1 if teen ==.

gen thirties_miss = 0
replace thirties_miss = 1 if thirties ==.

gen female_miss = 0
replace female_miss = 1 if female ==.

gen wic_miss = 0
replace wic_miss = 1 if wic ==.

gen books_miss = 0
replace books_miss = 1 if books ==.

gen books2_miss = 0
replace books2_miss = 1 if books2 ==.

gen math_z_miss = 0
replace math_z_miss = 1 if math_z ==.

gen reading_z_miss = 0
replace reading_z_miss = 1 if reading_z ==.

gen birthweight_miss = 0
replace birthweight_miss = 1 if birthweight ==.

gen ses_miss = 0
replace ses_miss = 1 if ses ==.

* Replace some of the missing values with 0.
replace momage = 0 if momage ==.
replace teen = 0 if teen ==.
replace thirties = 0 if thirties ==.
replace wic = 0 if wic ==.
replace books = 0 if books==.
replace books2 = 0 if books2==.
replace birthweight = 0 if birthweight ==.
replace ses = 0 if ses ==.

* PROBLEM 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	
* Drop observations for which age and race data is missing.
drop if r1_kage == -1 | r1_kage == -7 | r1_kage == -8 | r1_kage == -9 | r1_kage ==.
* 2,295 observations dropped because of age data missing
drop if race_v2 ==0
* 4,717 observations dropped because of race data missing
* 14,397 observations remain

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* Stratum 15 has only one PSU, so move this one into stratum 16.
replace bycwstr = 16 if bycwstr == 15

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* (a)
* Y = math_z
* Model 1: X  = race_v2
* Model 2: Xs = race_v2, ses
* Model 3: Xs = race_v2, ses, books, books2
* Model 4: Xs = race_v2, ses, books, books2, female, r1_kage, birthweight,
*                teen, thirties, wic

* Y = reading_z
* Model 5: X  = race_v2
* Model 6: Xs = race_v2, ses
* Model 7: Xs = race_v2, ses, books, books2
* Model 8: Xs = race_v2, ses, books, books2, female, r1_kage, birthweight,
*                teen, thirties, wic


* MATHS SCORES REGRESSION
svy: regress math_z Black Hispanic Asian Other
estimates store m1, title(Model 1)

svy: regress math_z Black Hispanic Asian Other ses ses_miss
estimates store m2, title(Model 2)

svy: regress math_z Black Hispanic Asian Other ses ses_miss books books_miss ///
books2 books2_miss
estimates store m3, title(Model 3)

svy: regress math_z Black Hispanic Asian Other ses ses_miss books books_miss ///
books2 books2_miss female female_miss r1_kage birthweight birthweight_miss teen ///
teen_miss thirties thirties_miss wic wic_miss
estimates store m4, title(Model 4)

* READING SCORES REGRESSION
svy: regress reading_z Black Hispanic Asian Other
estimates store m5, title(Model 5)

svy: regress reading_z Black Hispanic Asian Other ses ses_miss
estimates store m6, title(Model 6)

svy: regress reading_z Black Hispanic Asian Other ses ses_miss books books_miss ///
books2 books2_miss
estimates store m7, title(Model 7)

svy: regress reading_z Black Hispanic Asian Other ses ses_miss books books_miss ///
books2 books2_miss female female_miss r1_kage birthweight birthweight_miss teen ///
teen_miss thirties thirties_miss wic wic_miss
estimates store m8, title(Model 8)

* (b)
estout m1 m2 m3 m4 m5 m6 m7 m8, cells(se(par fmt(3))) legend label ///
varlabels(_cons Constant) stats(r2 obslast)

esttab * using "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS9/JenniferJackson_PS9.csv"

* (c) The values in the table created above are quite close to the ones found in
* the table given by Fryer and Levitt.

log close
