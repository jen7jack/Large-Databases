* Jennifer Jackson
* 27 February 2019

* APSTA.GE 2110
* Problem Set 3

* Part 2: NLS Investigator

log using "JenniferJackson_PS3_Part2", text

* PROBLEM 5a ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

infile using "/Users/jenniferjackson/Desktop/NLSY79.dct"

* PROBLEM 5b ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

rename R0000100 id
rename R0214800 sex
rename R0618200 achievement
gen year = 1979
save nlsy79.dta

* PROBLEM 5c ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

infile using "/Users/jenniferjackson/Desktop/NLSY97.dct", clear

* PROBLEM 5d ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

rename R0000100 id
rename R0536300 sex

* Came back to this step after starting Problem 5f and adjusted achievement
* scores for the 1997 group because they weren't on the same scale as the 1979
* group. According to the site, it was a matter of decimal places, which I
* corrected for below.
rename  R9829600 achievement_needs_adjustment
gen achievement = achievement_needs_adjustment / 1000

gen year = 1997
save nlsy97.dta


* PROBLEM 5e ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

clear
use nlsy79.dta
append using nlsy97.dta

* PROBLEM 5f ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* 1 = Males & 2 = Females
list if sex !=1 & sex !=2
* There are no missing values for sex.

* Achievment scores were NOT measured on the same scale, so I went back and
* adjusted the scores before appending the datasets because that seemed to be
* the simplest route.

* For both the 1979 and 1997 groups, negative numbers imply missing test scores.
replace achievement = . if achievement <= 0

* PROBLEM 6  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

summarize achievement if year == 1979
* The average achievement score in 1979 was 41, meaning the 41st percentile.

summarize achievement if year != 1979
* The average achievement score in 1979 was 45, meaning the 45th percentile.

summarize achievement if year == 1979 & sex == 1 /* Males */
summarize achievement if year == 1979 & sex == 2 /* Females */
* Both males and females averaged a 41st percentile, only varying by tenths of
* a percentile.

summarize achievement if year == 1997 & sex == 1 /* Males */
summarize achievement if year == 1997 & sex == 2 /* Females */
* In 1997 though, men averaged a 45th percentile while women averaged a 46th
* percentile.

log close
















