* Jennifer Jackson
* 7 March 2019

* APSTA.GE 2110
* Problem Set 4

log using "JenniferJackson_PS4", text

use "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS4/NHES data and documentation/NHES_12_PFI_v1_0_171007172721.dta"

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* This .do file analyses data from the National Household Education Survey
* (2012), which can be downloaded from the eDAT website.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

rename *, lower
* Converts all variable names to lowercase.

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

replace homeschlx = . if homeschlx == -1
replace scpubpri = . if scpubpri == -1
replace schoicex = . if schoicex == -1
replace schrtschl = . if schrtschl == -1
replace sneighbrx = . if sneighbrx == -1
replace spubchoix = . if spubchoix == -1
replace sconsidr = . if sconsidr == -1
replace sperform = . if sperform == -1
replace s1stchoi = . if s1stchoi == -1
replace seenjoy = . if seenjoy == -1
replace chisprm = . if chisprm == -1
replace par2educ = . if par2educ == -1

* s12chart == -1 --> homeschool or private school
* s12pbpv == -1 --> homeschool

* None of the continuous variables have missing data. Values of -1 indicate
* homeschooled students.

* allgradex is formatted as STRING

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

codebook, problems

egen nmis=rmiss2(homeschlx scpubpri schoicex schrtschl sneighbrx spubchoix ///
 sconsidr sperform s1stchoi seenjoy chisprm par2educ)

tab nmis

* chisprm is missing data for every observation.
drop chisprm

nmissing

* The variable with the most missing cases is sperform (9,642 missing).

* PROBLEM 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* Looking at the survey, the question about looking at the school's performance
* is preceded by a question about whether or not parents considered other schools.
* If the parents did not consider another school, then they were directed to skip
* the question about looking at those other school's performance. This is why so
* many observations are missing for this variable. Not everyone who took the
* survey even looked at the question.

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

duplicates report basmid

* No duplicate IDs

* PROBLEM 7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

codebook fsfreq
* Times Participated in School Meetings
* This variable came up as a problem when running "codebook, problems" because
* it was incompletely labeled. 61 nonmissing values are not labeled.

codebook cspeakx
* Language Spoken by Child at Home
* This one looks reasonable.

codebook scpubpri
* Type of School
* This one looks reasonable. The fact that there are 333 missing values makes
* sense considering the minimum age is 3.

codebook ttlhhinc
* Total Income
* This variable looks reasonable.

codebook hvintrnt
* Internet Access
* This one looks reasonable.

* PROBLEM 8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

tabulate schrtschl
* shows that 764 students attend charter schools, however

tabulate s12chart
* shows that 406 students attend charter schools.

* The inconsistency might be explained by the fact that a charter school is a
* type of public school.

* PROBLEM 9 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* 1 = White = cwhite           
* 2 = Black = cblack
* 3 = Asian or Pacific Islander = casian or cpaci
* 4 = Hispanic = chispan
* 5 = Other (not reported  or Native American) = camind or chisprm = .

generate race = 5
replace race = 1 if cwhite == 1
replace race = 2 if cblack == 1
replace race = 3 if casian == 1 | cpaci == 1
replace race = 4 if chispan == 1

label values race race_label

tabulate race

* PROBLEM 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

gen inc_1 = 1 if ttlhhinc == 1
gen inc_2 = 2 if ttlhhinc == 2
gen inc_3 = 3 if ttlhhinc == 3
gen inc_4 = 4 if ttlhhinc == 4
gen inc_5 = 5 if ttlhhinc == 5
gen inc_6 = 6 if ttlhhinc == 6
gen inc_7 = 7 if ttlhhinc == 7
gen inc_8 = 8 if ttlhhinc == 8
gen inc_9 = 9 if ttlhhinc == 9
gen inc_10 = 10 if ttlhhinc == 10

summarize inc_1 inc_2 inc_3 inc_4 inc_5 inc_6 inc_7 inc_8 inc_9 inc_10

* 7.37% of families earn between $50,001 and $60,000.

* I think this question could have been answered by just running "tabulate
* ttlhhinc" because it shows the frequency for each income bracket.


** NOTES FROM LECTURE
* forvalues x=1/10 {
*     gen inc1 = (tthhinc == 1) if ~missing(ttlhhinc)
* }

* PROBLEM 11 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

generate school_type = .
* Magnet or Regular Public School
replace school_type = 1 if s12chart == 2
* Charter School
replace school_type = 2 if s12chart == 1
* Other Public School
replace school_type = 3 if s12chart == 3
* Private School
replace school_type = 4 if s12pbpv == 2

tabulate school_type

label values school_type school_type_label

* PROBLEM 12 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

tabulate school_type par1educ, col

* Private school students have the largest percentage of parents with a
* university or graduate degree.

* PROBLEM 13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

sort school_type
by school_type: egen avg_meeting_time = mean(fsfreq)
tabulate avg_meeting_time school_type
label values avg_meeting_time avg_by_type_label

* Parents of private school students attend the most school meetings (approx
* 11 times).

* PROBLEM 14 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	
gen edu_max = max(par1educ, par2educ)
label values edu_max edu_max_label
tabulate edu_max

* PROBLEM 15 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	
compress

* PROBLEM 16 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

save NHES2012_lastedit_7March2019.dta

log close







