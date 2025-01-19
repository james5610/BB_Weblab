* What Caused the U.S Pandemic-Era Inflation? Bernanke, Blanchard 2023 
* This version : May 19, 2023 
* Please contact James Lee (Brookings Institute) or Athiana Tettaravou (Peterson Institute) for further questions. 

*This file produces Appendix Table A2 using ImportData.dta 

*****************************CHANGE PATH HERE***********************************
* Note: change the filepath the the data folder on your computer. Then, set 
* outfilename to be 

clear all 
clear matrix
// local data_dir = "C:\Users\Athiana.Tettaravou\Dropbox\Bernanke_Blanchard\replication_versions\replication_06.13.2023_no_conf_data\data"
local data_dir = "C:\Users\JALee\Dropbox\Code_Dropbox\Brookings\Bernanke_Blanchard\replication_versions\replication_06.13.2023_no_conf_data\data"
cd `data_dir'

local outfilename = "`data_dir'" + "\..\tables\appendix\Replication_tablesA2_Bernanke_Blanchard_2023.rtf"
********************************************************************************

use "intermediate_data\ImportData.dta", replace

* DATA MANIPULATION 
gen pce = DPCERD3Q086SBEA
gen gpce = 400*(ln(DPCERD3Q086SBEA)-ln(l1.DPCERD3Q086SBEA))
gen gw = 400*(ln(ECIWAG)-ln(l1.ECIWAG))
gen magw = 0.25*(gw+ l1.gw + l2.gw + l3.gw )
gen gpty = 400*(ln(OPHNFB)-ln(l1.OPHNFB))
gen magpty = 0.125*(gpty + l1.gpty + l2.gpty + l3.gpty + l4.gpty + l5.gpty + l6.gpty + l7.gpty )
gen rpe = PCEE/ECIWAG
gen rpf = PCEF/ECIWAG
gen grpe = 400*(ln(rpe)-ln(l1.rpe))
gen grpf = 400*(ln(rpf)-ln(l1.rpf))
gen vu = VOVERU
gen cf1 = EXPINF1YR
gen cf10 = EXPINF10YR
	* Shortage
gen shortage = SHORTAGE
replace shortage=5 if shortage==.
	* Catchup term
gen diffpcecf  = 0.25*(pce+l1.pce + l2.pce + l3.pce) -l4.cf1
	* Correct the discontinuity from ECIWAG (2001:1) 
gen dummygw = 0.0
replace dummygw = 1.0 if period==tq(2001:1)

* REGRESSIONS 
global WAGE "gw"
global CF1 "cf1"
global CF10 "cf10"
global GPCE "gpce"

keep if period>=tq(1989:1) & period<=tq(2023:1)
keep period gpce vu gw dummygw magpty grpe grpf cf1 cf10 shortage diff

	* gw 
constraint define 1  l1.gw + l2.gw + l3.gw + l4.gw + l1.cf1 + l2.cf1 + l3.cf1 + l4.cf1 = 1
cnsreg $WAGE l1.gw l2.gw l3.gw l4.gw l1.cf1 l2.cf1 l3.cf1 l4.cf1 l1.magpty l1.vu l2.vu l3.vu l4.vu l1.diffpcecf l2.diffpcecf l3.diffpcecf l4.diffpcecf if period<=tq(2019:4), c(1)
eststo col1
predict gwf1
gen resid1 = gw-gwf1
	* Compute sum of coefficients 
gen aa1 = _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw]
gen bb1 = _b[l1.vu] + _b[l2.vu] + _b[l3.vu] + _b[l4.vu]
gen cc1 = _b[l1.diffpcecf] + _b[l2.diffpcecf] + _b[l3.diffpcecf] + _b[l4.diffpcecf]			   					                                               
gen dd1 = _b[l1.cf1] + _b[l2.cf1] + _b[l3.cf1] + _b[l4.cf1]
list aa1 bb1 cc1 dd1 if period == tq(2019:1)  
	* P-value (sum)
test _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw]  = 0 
test _b[l1.vu] + _b[l2.vu] + _b[l3.vu] + _b[l4.vu] = 0  
test _b[l1.diffpcecf] + _b[l2.diffpcecf] + _b[l3.diffpcecf] + _b[l4.diffpcecf] = 0 				   					                                          
test _b[l1.cf1] + _b[l2.cf1] + _b[l3.cf1] + _b[l4.cf1] = 0
test l1.magpty
	* P-value (joint)
test l1.gw l2.gw l3.gw l4.gw 
test l1.cf1 l2.cf1 l3.cf1 l4.cf1
test l1.vu l2.vu l3.vu l4.vu 
test l1.diffpcecf l2.diffpcecf l3.diffpcecf l4.diffpcecf
test l1.magpty
corr gw gwf1 if period>=tq(1990:1) & period <= tq(2019:4)
di r(rho)^2

	* gpce
constraint define 2 l1.gpce + l2.gpce + l3.gpce + l4.gpce + gw + l1.gw + l2.gw + l3.gw + l4.gw =1
cnsreg $GPCE magpty l1.gpce l2.gpce l3.gpce l4.gpce gw l1.gw l2.gw l3.gw l4.gw grpe l1.grpe l2.grpe l3.grpe l4.grpe grpf l1.grpf l2.grpf l3.grpf l4.grpf shortage l1.shortage l2.shortage l3.shortage l4.shortage , c(2)
eststo col2
predict gpcef
gen resid2 =  gpcef - gpce
	* Compute sum of coefficients 
gen aa2 = _b[l1.gpce] + _b[l2.gpce] + _b[l3.gpce] + _b[l4.gpce] 
gen bb2 = _b[gw] + _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw]
gen cc2 = _b[grpe] + _b[l1.grpe] + _b[l2.grpe] + _b[l3.grpe] + _b[l4.grpe]
gen dd2 = _b[grpf] + _b[l1.grpf] + _b[l2.grpf] + _b[l3.grpf] + _b[l4.grpf]
gen ee2 = _b[shortage] + _b[l1.shortage] + _b[l2.shortage] + _b[l3.shortage] +_b[l4.shortage]
list period aa2 bb2 cc2 dd2 ee2  if period == tq(2019:1)
	* P-value (sum)
test _b[l1.gpce] + _b[l2.gpce] + _b[l3.gpce] + _b[l4.gpce] =0
test _b[gw] + _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw] =0 
test _b[grpe] + _b[l1.grpe] + _b[l2.grpe] + _b[l3.grpe] + _b[l4.grpe] = 0
test _b[grpf] + _b[l1.grpf] + _b[l2.grpf] + _b[l3.grpf] + _b[l4.grpf] = 0
test _b[shortage] + _b[l1.shortage] + _b[l2.shortage] + _b[l3.shortage] +_b[l4.shortage] = 0 
	* P-value (joint)
test l1.gpce l2.gpce l3.gpce l4.gpce
test gw l1.gw l2.gw l3.gw l4.gw 
test grpe l1.grpe l2.grpe l3.grpe l4.grpe 
test grpf l1.grpf l2.grpf l3.grpf l4.grpf 
test shortage l1.shortage l2.shortage l3.shortage l4.shortage

corr gpce gpcef if period>=tq(1990:1)
di r(rho)^2

* cf1 
constraint define 3 l1.cf1 + l2.cf1 +l3.cf1 +l4.cf1 +cf10 +l1.cf10 +l2.cf10 +l3.cf10 +l4.cf10 +gpce +l1.gpce +l2.gpce +l3.gpce +l4.gpce = 1.0
cnsreg $CF1 l1.cf1 l2.cf1 l3.cf1 l4.cf1 cf10 l1.cf10 l2.cf10 l3.cf10 l4.cf10 gpce l1.gpce l2.gpce l3.gpce l4.gpce if period<=tq(2019:4), c(3) noconstant
eststo col3
predict cf1f
gen resid3 = cf1-cf1f 
	* Compute sum of coefficients 
gen aa3 = _b[l1.cf1] + _b[l2.cf1] + _b[l3.cf1]+ _b[l4.cf1]
gen bb3 = _b[cf10] +_b[l1.cf10] + _b[l2.cf10] + _b[l3.cf10] + _b[l4.cf10]
gen cc3 = _b[gpce]+_b[l1.gpce] + _b[l2.gpce] +  _b[l3.gpce] + _b[l4.gpce]
list period aa3 bb3 cc3 if period==tq(2019:1) 
	* P-value (sum)
test _b[l1.cf1] + _b[l2.cf1] + _b[l3.cf1]+ _b[l4.cf1] = 0
test _b[cf10] +_b[l1.cf10] + _b[l2.cf10] + _b[l3.cf10] + _b[l4.cf10] = 0 
test _b[gpce]+_b[l1.gpce] + _b[l2.gpce] +  _b[l3.gpce] + _b[l4.gpce] = 0
	* P-value (joint)
test l1.cf1 l2.cf1 l3.cf1 l4.cf1 
test cf10 l1.cf10 l2.cf10 l3.cf10 l4.cf10
test gpce l1.gpce l2.gpce l3.gpce l4.gpce

corr cf1 cf1f if period>=tq(1990:1) & period <= tq(2019:4)
di r(rho)^2

* cf10 
constraint define 4 l1.cf10 +l2.cf10 +l3.cf10 + l4.cf10 + gpce +l1.gpce +l2.gpce + l3.gpce + l4.gpce = 1.0
cnsreg $CF10 l1.cf10 l2.cf10 l3.cf10 l4.cf10 gpce l1.gpce l2.gpce l3.gpce l4.gpce if period<=tq(2019:4), c(4) noconstant
eststo col4
predict cf10f
gen resid4 = cf10f-cf10 
	* Compute sum of coefficients 
gen aa4 = _b[l1.cf10] + _b[l2.cf10] + _b[l3.cf10] + _b[l4.cf10]
gen bb4 = _b[gpce] + _b[l1.gpce] + _b[l2.gpce] + _b[l3.gpce] + _b[l4.gpce]
list period aa4 bb4 if period == tq(2019:1) 
	* P-value (sum)
test _b[l1.cf10] + _b[l2.cf10] + _b[l3.cf10] + _b[l4.cf10] = 0 
test _b[gpce] + _b[l1.gpce] + _b[l2.gpce] + _b[l3.gpce] + _b[l4.gpce] = 0 
	* P-value (joint)
test l1.cf10 l2.cf10 l3.cf10 l4.cf10
test gpce l1.gpce l2.gpce l3.gpce l4.gpce 

corr cf10 cf10f if period>=tq(1990:1) & period <= tq(2019:4)
di r(rho)^2

* OUTPUT    
#delimit;
esttab col1 col2 col3 col4  using `outfilename', replace compress
title("Replication table A2 Bernanke Blanchard 2023")
mlab("gw" "gpce" "cf1" "cf10")
stats(r2 N, fmt(%9.3f %9.0f)
labels("R-squared" "Obs"))
nonote addnote("Note: Clustered standard errors in parentheses, * p < 0.10, ** p < 0.05, *** p < 0.01") star(* 0.10 ** 0.05 *** 0.01)
varlabels(
_cons "Intercept"
)
b(%9.2f) se(%9.2f);
