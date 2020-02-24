* Jennifer Jackson
* 2 May 2019

* APSTA.GE 2110
* Problem Set 10

cd "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS10"
log using "JenniferJackson_PS10", text

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                        	
use "Texas_elementary_panel_2004_2007.dta", clear

* (a)
rename cpemallp mobility
tabstat mobility
* The average is 20%.

* Declare the dataset to be a panel:
xtset campus year

xtsum mobility
* The variance of mobility is approximately 13 times higher between schools than
* within schools. We can tell this by looking at the standard deviation given in
* the table. Squaring the standard deviation gives a between-school variance of
* approximately 121 squared percentage points versus a within-school variance
* of approximately only 9 squared percentage points.


* (b)
rename ca311tar avgpassing

* Model 1 - Simple Regression
reg avgpassing mobility
* The model for this regression is: avgpassing = - 0.76(mobility) + 90.29
* These values are statistically significant, so the model can be interpreted as
* for each percentage point increase in mobility, the passing rate decreases by 
* almost one percentage point.

* (c)
* Model 2 - Adding Covariates
* Adding: %black(cpetblap), %white(cpetwhip), %Hispanic(cpethisp),
* %API(cpetpacp), LEP(cpetlepp), econ. disadvantaged(cpetecop), year dummy,
* charter school dummy
encode charter, generate(chart)
* charter school = 2, non-charter school = 1
reg avgpassing mobility cpetblap cpetwhip cpethisp cpetpacp cpetlepp cpetecop i.year chart
* Adding these covariates has increased the mobility coefficient (it is now
* -0.15) and it is still statistically significant.

* The coefficient for year 2006 is 6.2. For 2007 the coefficient is 8.21. This
* means that, holding everything else constant, the passing rate in 2007 was
* higher than in 2006. I.e., the passing rate has increased over time.

* (d)
* Model 3 - Accounting for Fixed Effects
xtreg avgpassing mobility cpetblap cpetwhip cpethisp cpetpacp cpetlepp cpetecop i.year chart, fe
* The mobility coefficient is 0.0001199, which is now positive, but no longer
* statistically significant. It makes sense that the mobility coeffecient is no
* longer statistically significant given all the other "better" predictors in
* the model now.
* The charter school dummy variable was dropped due to collinearity.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                        	
use "LUSD_sub_4_5.dta", clear

* (a)
* There is data for two grades over two years.
summarize
* There are 37,823 student observations in the data set.
codebook id
* There are 31,576 unique students and 12,494 of those students have 4th grade
* and 5th grade data in this dataset.
summarize if year==2005 & grade==4
* There were 9,676 4th graders in 2005.
summarize if year==2006 & grade==4
* There were 9,256 4th graders in 2006.
* 4th grade total = 18,932
summarize if year==2005 & grade==5
* There were 9,544 5th graders in 2005.
summarize if year==2006 & grade==5
* There were 9,347 5th graders in 2006.
codebook school
* There are 190 unique schools in the dataset.
codebook teacher
* There are 1,852 unique teachers in the dataset.

* (b)
drop if grade==4
 
* MODEL 1
regress mathz age female lep speced immig econdis black hispanic asian i.year
eststo model1
* For 5th grade, maths scores appear to be indirectly related to every covariate
* except a student's immigration status and Asian descent. I.e., if a student is
* a male Asian immigrant, he will have a relatively higher maths score.

* (c)
* MODEL 2
regress mathz age female lep speced immig econdis black hispanic asian i.year mathz_1
* Including the previous year's scores does not change the relationship between
* the covariates in the sense that maths scores are still only directly related
* to immigration status and Asian descent. However, the coeffecients of these
* variables are different. Taking the previous year's scores into account,
* immigration status has a larger effect and Asian descent has a smaller effect
* than if the previous year's scores had been ignored.

eststo model2
esttab

* (d)
xtset
* MODEL 3
xtreg mathz age female lep speced immig econdis black hispanic asian i.year mathz_1
* Adding teacher as a fixed effect has only altered the size of the coefficients.
* Being older, having limited English, being a special ed student, being
* economically disadvantaged, being black or Hispanic will all have a negative
* effect on a 5th grader's maths score. The only covariates having a positive
* relationship are being a male immigrant of Asian descent. The only difference
* between Model 2 and Model 3 is that taking into account the fixed effect of
* having the same teacher, the effect of immigration status has increased (from
* 0.099 to 0.104) and the effect of being of Asian descent has increased (from
* 0.100 to 0.088).


log close
