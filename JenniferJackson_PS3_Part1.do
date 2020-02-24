* Jennifer Jackson
* 27 February 2019

* APSTA.GE 2110
* Problem Set 3

* Part 1: IPEDS Data Center

log using "JenniferJackson_PS3_Part1", text

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

insheet using "/Users/jenniferjackson/Desktop/STATA_RV_1042017-457.csv", clear
label data STATA_RV_1042017_457
label variable unitid "UNITID"
label variable instnm "Institution Name"
label variable year "Survey year 2015"
label variable instnm "Institution (entity) name"
label variable ialias "Institution name alias"
label variable tufeyr3 "Tuition and fees, 2015-16"
label variable stabbr "State abbreviation"
label variable sector "Sector of institution"
label variable iclevel "Level of institution"
label variable control "Control of institution"
label variable deggrant "Degree-granting status"
label variable grrttot "Graduation rate, total cohort"
label variable grrtm "Graduation rate, men"
label variable grrtw "Graduation rate, women"
 
label define label_sector 0 "Administrative Unit"
label values sector label_sector
label define label_sector 1 "Public, 4-year or above", add
label values sector label_sector
label define label_sector 2 "Private not-for-profit, 4-year or above", add
label values sector label_sector
label define label_sector 3 "Private for-profit, 4-year or above", add
label values sector label_sector
label define label_sector 4 "Public, 2-year", add
label values sector label_sector
label define label_sector 5 "Private not-for-profit, 2-year", add
label values sector label_sector
label define label_sector 6 "Private for-profit, 2-year", add
label values sector label_sector
label define label_sector 7 "Public, less-than 2-year", add
label values sector label_sector
label define label_sector 8 "Private not-for-profit, less-than 2-year", add
label values sector label_sector
label define label_sector 9 "Private for-profit, less-than 2-year", add
label values sector label_sector
label define label_sector 99 "Sector unknown (not active)", add
label values sector label_sector
label define label_iclevel 1 "Four or more years"
label values iclevel label_iclevel
label define label_iclevel 2 "At least 2 but less than 4 years", add
label values iclevel label_iclevel
label define label_iclevel 3 "Less than 2 years (below associate)", add
label values iclevel label_iclevel
label define label_iclevel -3 "{Not available}", add
label values iclevel label_iclevel
label define label_control 1 "Public"
label values control label_control
label define label_control 2 "Private not-for-profit", add
label values control label_control
label define label_control 3 "Private for-profit", add
label values control label_control
label define label_control -3 "{Not available}", add
label values control label_control
label define label_deggrant 1 "Degree-granting"
label values deggrant label_deggrant
label define label_deggrant 2 "Nondegree-granting, primarily postsecondary", add
label values deggrant label_deggrant
label define label_deggrant -3 "{Not available}", add
label values deggrant label_deggrant

tab stabbr
tab sector
tab iclevel
tab control
tab deggrant

summarize tufeyr3
summarize grrttot
summarize grrtm
summarize grrtw


save cdsfile_all_STATA_RV_1042017-457.dta

* There are 469 New York post-secondary institutions in the dataset.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

drop if deggrant != 1
* There are 311 institutions left in the dataset.

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

drop if grrttot == .

list instnm grrttot in 252/261
** The TOP 15 institutions in terms of graduation rate in 2015 were:
* Belanger School of Nursing
* Rabbinical College of Ch'san Sofer New York
* Phillips School of Nursing at Mount Sinai Beth Israel
* St Joseph's College of Nursing at St Joseph's Hospital Health Center
* Columbia University in the City of New York
* New York College of Health Professions
* Swedish Institute a College of Health Sciences
* Cornell University
* The Juilliard School
* Hamilton College

list instnm grrttot in 1/15
** The BOTTOM 15 institutions in terms of graduation rate in 2015 were:
* Samaritan Hospital School of Nursing
* Yeshiva Shaarei Torah of Rockland
* Yeshivas Novominsk
* Yeshiva of the Telshe Alumni
* Yeshiva Gedolah Kesser Torah
* Mirrer Yeshiva Cent Institute
* CUNY Medgar Evers College
* Beth Hatalmud Rabbinical College
* Torah Temimah Talmudical Seminary
* Yeshiva Derech Chaim
* Yeshivat Mikdash Melech
* SUNY Westchester Community College
* CUNY Bronx Community College
* CUNY New York City College of Technology
* Bryant & Stratton College-Buffalo

list if instnm == "New York University"
* NYU's graduation rate in 2015 was 84% overall, with more women having
* graduated than men. Women's graduation rate was 85% versus 82% for men.

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

corr grrttot tufeyr3
* The correlation coefficient for graduation rate versus fees and tutition is
* 0.57, which shows there is a relatively strong positive correlation between
* the two.

scatter grrttot tufeyr3, saving(scatterplot, replace)

log close













