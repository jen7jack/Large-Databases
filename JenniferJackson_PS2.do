* Jennifer Jackson
* 19 February 2019

* APSTA.GE 2110
* Problem Set 2

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* This .do file analyses data from the National Longitudinal Survey of Youth
* of 1979 (NLSY-79) from the Bureau of Labor Statistics

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* change working directory
cd "/Users/jenniferjackson/Desktop"
* open data set
use "NLSY_women_v12.dta"
* 4,440 observations
use "NLSY_children_v12.dta"
* 1,557 observations

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

use "/Users/jenniferjackson/Desktop/NLSY_women_v12.dta"
summarize nlsyid
* There are 4,440 unique values of nlsyid in the women dataset.

use "/Users/jenniferjackson/Desktop/NLSY_children_v12.dta"
summarize nlsyid
* There are 1,557 unique values of childid in the children dataset.

by nlsyid, sort: gen mothers = _n == 1
count if mothers
* There are 1,177 unique values of nlsyid in the children dataset, implying
* there are duplicates.

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* It is best to match nlsyid because this ID is in both datasets.

* Re-open the women's dataset so it is the master.
use "/Users/jenniferjackson/Desktop/NLSY_women_v12.dta", clear

merge 1:m nlsyid using "/Users/jenniferjackson/Desktop/NLSY_children_v12.dta"

* master only: 3,602               i.e., number of women not matched to a child
* using only: 449                  i.e., '' '' children not matched to a mother
* observation is in both: 1,108    i.e., '' '' mothers matched to a child

* And thus, the number of children matched to a mother is also 1,108.

* PROBLEM 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

tabstat afqt if !missing(childid)
* The average AFQT score of women with children is 43.8.
tabstat age if !missing(childid)
* The average age of women with children is 17.

tabstat afqt if missing(childid)
* The average AFQT score of women without children is 40.6
tabstat age if missing(childid)
* The average age of women without children is 18.

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

drop if missing(childid)
drop if missing(afqt)
drop if missing(mathzscore)
summarize nlsyid
* Only looking at those women who are mothers, who have an AFQT score and whose
* children have a mathzscore, we have 998 observations.

* PROBLEM 7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

corr mathzscore afqt
* Pearson Correlation Coefficient between AFQT and mathzscore = 0.51

gen boys_math = mathzscore if childsex == 1
corr boys_math afqt
* Pearson Correlation Coefficient between AFQT and boys' mathzscore = 0.52

gen girls_math = mathzscore if childsex == 2
corr girls_math afqt
* Pearson Correlation Coefficient between AFQT and girls' mathzscore = 0.51

* There is only a slightly stronger correlation between the boys' math scores
* and mothers' AFQT scores than that of girls' math scores.

* PROBLEM 8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*(saving and closing log file)






