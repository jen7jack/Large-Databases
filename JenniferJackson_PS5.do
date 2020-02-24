* Jennifer Jackson
* 14 March 2019

* APSTA.GE 2110
* Problem Set 5

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* This .do file analyses data from the National Household Education Survey
* (2012), which can be downloaded from the eDAT website.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

global workdir "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS5/NHES data and documentation"
cd "$workdir"
log using "JenniferJackson_PS5", text
use "NHES_12_PFI_v1_0_171007172721.dta"

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* Convert all variable names to lowercase.
rename *, lower

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* Replace missing data designated as "-1" with "."
foreach var of varlist homeschlx scpubpri schoicex schrtschl sneighbrx ///
spubchoix sconsidr sperform s1stchoi seenjoy chisprm par2educ {
recode `var' (-1=.)
}

* PROBLEM 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* Recode Yes/No after saving the original variables.
label define no_label 0 "No" 1 "Yes"
foreach var of varlist homeschlx schoicex schrtschl sneighbrx spubchoix sconsidr ///
 sperform s1stchoi chispan camind casian cblack cpaci cwhite hvintrnt {
clonevar `var'_copy = `var'
recode `var'_copy (2=0)
label values `var'_copy no_label
}

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
global variables "homeschlx schoicex schrtschl sneighbrx spubchoix sconsidr sperform s1stchoi chispan camind casian cblack cpaci cwhite hvintrnt"
foreach vars in variables {
summarize $variables
}

tabulate schrtschl
* Approximately 6% of the respondents attend charter schools.

tabulate homeschlx
* Approximately 1% of the respondents are homeschooled.
                        	
* PROBLEM 7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

forvalues i = 1/2 {
	summarize fsfreq if csex == `i'
	display r(mean)
	display r(sd)
	summarize age2011 if csex == `i'
	display r(mean)
}

* BOYS
* The average number of meetings was approximately 7.
* The standard deviation was almost 9 meetings.
* The average age was 12.

* GIRLS
* The average number of meetings was approximately 7.
* The standard deviation was almost 9 meetings.
* The average age was 12.

* PROBLEM 8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

forvalues i = 1/2 {
	foreach var of varlist fsfreq age2011 {
		summarize `var' if csex == `i'
		display r(mean)
		display r(sd)
	}
}

* PROBLEM 9 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Replace any value of fpwt with 10,000 if the weight is greater than 10,000.
foreach x of varlist fpwt-fpwt80 {
	replace `x' = 10000 if `x' > 10000
}

* Still cannot get this one to work. >.<
* global y "fpwt1-fpwt80"
* gen weight_label = " "
* forvalues j = 1/80 {
*	replace `y' = "Replicate Weight "+`j'
* }
 

* PROBLEM 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

regress fsfreq i.par1educ

tabulate par1educ, generate(ed_level)

* Approximately 4% of the variability among frequency of school meeting
* attendance is explained by the education level of the child's "first" parent.

regress fsfreq i.ed_level2 /* R^2 = 0.0088 */
regress fsfreq i.ed_level3 /* R^2 = 0.0009 */
regress fsfreq i.ed_level4 /* R^2 = 0.0130 */
regress fsfreq i.ed_level5 /* R^2 = 0.0103 */

* After running regression analysis on each individulal level of education, it
* seems that for level 4 - college graduated parents - there is a slightly
* larger amount of variance among school meeting attendance explained by this
* education level.

* PROBLEM 11 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	


save NHES_lastedit_16March2019.dta

log close




