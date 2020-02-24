* Jennifer Jackson
* 4 April 2019

* APSTA.GE 2110
* Problem Set 7

* PROBLEM 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                         	

* This .do file analyses US Census Bureau data, more specifically, the March
* 2005 Current Population Survey, which looks at employment information.

* PROBLEM 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

cd "/Users/jenniferjackson/Desktop/NYU/Large Databases/PS7"
use "March CPS 2005 extract.dta"

* PROBLEM 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

tabstat annwage, statistics (mean med p10 p90 sd)
 
* Men's Annual Earnings
* mean = $53,613.54
* median = $40k
* 10th percentile = $14k
* 90th percentile = $100k
* standard deviation = $59,423.92

histogram annwage

* The data for men's annual earnings, although probably normally distributed,
* is very skewed to the right.

* PROBLEM 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

set more off
forvalues j=1/250 {
   tempfile temp`j' 
   preserve
   bsample 100
   collapse (mean) xbar=annwage
   save `temp`j'' 
   restore
   }

use `temp1', clear
forvalues j=2/250 {
   append using `temp`j''
   }

tabstat xbar, statistics (mean sd p10 p90)
* Men's Annual Earnings ~ SAMPLING DISTRIBUTION
* mean = $54,210.25
* standard deviation = $5,912.37
* 10th percentile = $47k
* 90th percentile = $62k

histogram xbar, freq
* It looks a bit more normal than the histogram of annwage, but still skewed.

* PROBLEM 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
* Men's Annual Earnings Stratified (disproportionately) by Region

* Get original data set:
use "March CPS 2005 extract.dta", clear

set more off
forvalues j=1/250 {
   tempfile temp`j' 
   preserve
   bsample 25, strata(_region)
   collapse (mean) xbar=annwage
   save `temp`j'' 
   restore
   }

use `temp1', clear
forvalues j=2/250 {
   append using `temp`j''
   }

tabstat xbar, statistics (mean sd p10 p90)
* Men's Annual Earnings ~ STRATIFIED SAMPLING DISTRIBUTION (disproportionate)
* mean = $53,911.03
* standard deviation = $3,104.39
* 10th percentile = $50k
* 90th percentile = $57k

histogram xbar, freq
* This histogram looks a lot more normal than the previous two graphs.

* PROBLEM 6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* Standard deviation of Sampling Distribution = $5,912.37
* Standard deviation of Stratified Sampling Distribution (disprop.) = $3,104.39

* The standard deviation of the stratified sampling distribution is nearly half
* of the standard deviation of the regular sampling distribution. It makes sense
* that the variance would be smaller (and thus smaller standard deviation) among
* observations which share something in common. In this case, region. The fact
* that it is such an extreme difference though, is most likely due to the
* disproportionate stratification, which makes the data look like it has less
* variance than it acutally does.

* Stratified sampling is meant to reduce bias, but the proper way to stratify is
* by taking proportional samples from each group, which did not happen in
* Part 5.

use "March CPS 2005 extract.dta", clear
sort _region
by _region: count
* Observations in Region 1: 6,924
* Observations in Region 2: 6,756
* Observations in Region 3: 9,670
* Observations in Region 4: 8,774

* The regions were not equal in size, so the sample size drawn from each should
* have been proportional to these totals.

* PROBLEM 7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* Men's Annual Earnings Stratified (proportionately) by Region

* Get original data set:
use "March CPS 2005 extract.dta", clear

gen nsamp = 22
replace nsamp = 21 if _region == 2
replace nsamp = 30 if _region == 3
replace nsamp = 27 if _region == 4

set more off
forvalues j=1/250 {
   tempfile temp`j' 
   preserve
   bsample nsamp, strata(_region)
   collapse (mean) xbar=annwage
   save `temp`j'' 
   restore
   }

use `temp1', clear
forvalues j=2/250 {
   append using `temp`j''
   }

tabstat xbar, statistics (mean sd p10 p90)
* Men's Annual Earnings ~ STRATIFIED SAMPLING DISTRIBUTION (proportionate)
* mean = $53,569.19
* standard deviation = $5,806.42
* 10th percentile = $46k
* 90th percentile = $61k

histogram xbar, freq
* This histogram looks the most normal of all of the graphs so far.

* PROBLEM 8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* Standard deviation of Sampling Distribution = $5,912.37
* Standard deviation of Stratified Sampling Distribution (disprop.) = $3,104.39
* Standard deviation of Stratified Sampling Distribution (prop.) = $5,806.42

* The standard deviation of the proportionately stratified sampling distribution
* is much closer to the original sampling distribution, though still slightly
* smaller than the non-stratified sampling distribution.

* The sample mean of the proportionately stratified sampling distribution is not
* biased because the sample sizes are proportionate to the region sizes, as
* shown below.

* The nsamp values are proportional to the region sizes:
* nsamp value / group size
* region 1: 22 / 6,924 = 0.003
* region 2: 21 / 6,756 = 0.003
* region 3: 30 / 9,670 = 0.003
* region 4: 27 / 8,774 = 0.003



















