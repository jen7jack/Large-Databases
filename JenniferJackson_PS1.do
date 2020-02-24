* Jennifer Jackson
* 14 February 2019

* APSTA.GE 2110
* Problem Set 1

* PROBLEM 1
* This .do file analyses PISA 2006 data for the USA & Hong Kong.

* PROBLEM 2
* change working directory
cd "/Users/jenniferjackson/Desktop"
* open data set
use "PISA2006USAHKGFa17.dta"

* PROBLEM 3
desc, short
* students = 8,252
* variables = 490
summarize
* non-numeric variables = 24

* PROBLEM 4
* Drop all student weight data.
drop w_*

* PROBLEM 5
* Analyse grade data by country.
tabulate st01q01 if cnt == "USA"
tabulate st01q01 if cnt =="HKG"
* In both countries, 10th grade is the most common grade level tested.

* PROBLEM 6
* Drop student data for those who are not in grades 9 or 10.
drop if st01q01 <=8 | st01q01 >=11

* PROBLEM 7
* Summarise maths & science PISA scores.
* USA
gen pv1math_USA = pv1math if cnt == "USA"
sum pv1math_USA, detail						//* mean = 471
* 90th percentile for math is 588
gen pv1scie_USA = pv1scie if cnt == "USA"
sum pv1scie_USA, detail						//* mean = 485

* Hong Kong
gen pv1math_HKG = pv1math if cnt == "HKG"
sum pv1math_HKG, detail						//* mean = 560
* 90th percentile for math is 672
gen pv1scie_HKG = pv1scie if cnt == "HKG"
sum pv1scie_HKG, detail						//* mean = 555

* It's not possible to compare reading scores because there are no reading
* scores recorded for students in the USA.
gen pv1read_USA = pv1read if cnt == "USA"
sum pv1read_USA, detail


* PROBLEM 8
* Rename the following variables.
rename st06q01 momed  //* Mother's Education
rename st09q01 fathed //* Father's Education
rename st01q01 grade  
rename st04q01 gender

* PROBLEM 9
* Create a new variable for ages 15 to 16 called age2.
tabulate age
gen age2 = 0
replace age2 = 15 if age >= 15 & age <16
replace age2 = 16 if age >=16 & age <17
replace age2 = . if age2 == 0
tabulate age2

* PROBLEM 10
* Label age2.
label var age2 "students ages 15 and 16"

* PROBLEM 11
* Look at top science scores in the USA
drop if cnt == "HKG"
gen neg_pv1scie = -pv1scie
sort neg_pv1scie
summarize pv1scie in 1/250
* The mean science score for the top 250 US students is 684.

* PROBLEM 12
* (saving and closing log file)



