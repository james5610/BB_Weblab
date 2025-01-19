* What Caused the U.S Pandemic-Era Inflation? Bernanke, Blanchard 2023 
* This version : May 19, 2023 
* Please contact James Lee (Brookings Institute) or Athiana Tettaravou (Peterson Institute) for further questions. 

*This file produces Appendix Table A3 using ImportData.dta 

*****************************CHANGE PATH HERE***********************************
clear all 
clear matrix
// local data_dir = "C:\Users\Athiana.Tettaravou\Dropbox\Bernanke_Blanchard\replication_versions\replication_06.13.2023_no_conf_data\data"
local data_dir = "C:\Users\JALee\Dropbox\Code_Dropbox\Brookings\Bernanke_Blanchard\replication_versions\replication_06.13.2023_no_conf_data\data"
cd `data_dir'

local outfilename = "`data_dir'" + "\..\tables\appendix\Replication_tablesA3_Bernanke_Blanchard_2023.rtf"
********************************************************************************

use "intermediate_data\ImportData.dta", replace

* DATA MANIPULATION 
gen gcpi = 400*(ln(CPIAUCSL)-ln(l1.CPIAUCSL))
gen gw = 400*(ln(ECIWAG)-ln(l1.ECIWAG))
gen magw = 0.25*(gw+ l1.gw + l2.gw + l3.gw )
gen gpty = 400*(ln(OPHNFB)-ln(l1.OPHNFB))
gen magpty = 0.125*(gpty + l1.gpty + l2.gpty + l3.gpty + l4.gpty + l5.gpty + l6.gpty + l7.gpty )
gen rpe = CPIUFDSL/ECIWAG
gen rpf = CPIENGSL/ECIWAG
gen grpe = 400*(ln(rpe)-ln(l1.rpe))
gen grpf = 400*(ln(rpf)-ln(l1.rpf))
gen vu = VOVERU
gen spf1 = SPF1YR
gen spf10 = SPF10YR
	* Shortage
gen shortage = SHORTAGE
replace shortage=5 if shortage==.
	* Catchup term
gen diffcpispf  = 0.25*(gcpi+l1.gcpi + l2.gcpi + l3.gcpi) -l4.spf1
	* Correct the discontinuity from ECIWAG (2001:1) 
gen dummygw = 0.0
replace dummygw = 1.0 if period==tq(2001:1)

* REGRESSIONS 
global WAGE "gw"
global SPF1 "spf1"
global SPF10 "spf10"
global GCPI "gcpi"

keep if period>=tq(1989:1) & period<=tq(2023:1)
keep period gcpi vu gw dummygw magpty grpe grpf spf1 spf10 shortage diffcpispf

	* gw 
constraint define 1  l1.gw + l2.gw + l3.gw + l4.gw + l1.spf1 + l2.spf1 + l3.spf1 + l4.spf1 = 1
cnsreg $WAGE l1.gw l2.gw l3.gw l4.gw l1.spf1 l2.spf1 l3.spf1 l4.spf1 l1.magpty l1.vu l2.vu l3.vu l4.vu l1.diffcpispf l2.diffcpispf l3.diffcpispf l4.diffcpispf if period<=tq(2019:4), c(1)
eststo col1
predict gwf1
gen resid1 = gw-gwf1
	* Compute sum of coefficients 
gen aa1 = _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw]   
gen bb1 = _b[l1.vu] + _b[l2.vu] + _b[l3.vu] + _b[l4.vu]
gen cc1 = _b[l1.diffcpispf] + _b[l2.diffcpispf] + _b[l3.diffcpispf] + _b[l4.diffcpispf]				   					   
gen dd1 = _b[l1.spf1] + _b[l2.spf1] + _b[l3.spf1] + _b[l4.spf1]
list aa1 bb1 cc1 dd1 if period == tq(2019:1)  
	* P-value (sum)
test _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw]  = 0       
test _b[l1.vu] + _b[l2.vu] + _b[l3.vu] + _b[l4.vu] = 0    
test _b[l1.diffcpispf] + _b[l2.diffcpispf] + _b[l3.diffcpispf] + _b[l4.diffcpispf] = 0                                
test _b[l1.spf1] + _b[l2.spf1] + _b[l3.spf1] + _b[l4.spf1] = 0
test l1.magpty		   					   
	* P-value (joint)
test l1.gw l2.gw l3.gw l4.gw 
test l1.vu l2.vu l3.vu l4.vu 
test l1.diffcpispf l2.diffcpispf l3.diffcpispf l4.diffcpispf
test l1.spf1 l2.spf1 l3.spf1 l4.spf1
test l1.magpty

corr gw gwf1 if period>=tq(1990:1) & period <= tq(2019:4)
di r(rho)^2

	* gcpi 
constraint define 2 l1.gcpi + l2.gcpi + l3.gcpi + l4.gcpi + gw + l1.gw + l2.gw + l3.gw + l4.gw =1
cnsreg $GCPI magpty l1.gcpi l2.gcpi l3.gcpi l4.gcpi gw l1.gw l2.gw l3.gw l4.gw grpe l1.grpe l2.grpe l3.grpe l4.grpe grpf l1.grpf l2.grpf l3.grpf l4.grpf shortage l1.shortage l2.shortage l3.shortage l4.shortage , c(2)
eststo col2
predict gcpif
gen resid2 =  gcpif - gcpi
	* Compute sum of coefficients 
gen aa2 = _b[l1.gcpi] + _b[l2.gcpi] + _b[l3.gcpi] + _b[l4.gcpi] 
gen bb2 = _b[gw] + _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw]
gen cc2 = _b[grpe] + _b[l1.grpe] + _b[l2.grpe] + _b[l3.grpe] + _b[l4.grpe]
gen dd2 = _b[grpf] + _b[l1.grpf] + _b[l2.grpf] + _b[l3.grpf] + _b[l4.grpf]
gen ee2 = _b[shortage] + _b[l1.shortage] + _b[l2.shortage] + _b[l3.shortage] +_b[l4.shortage]
list period aa2 bb2 cc2 dd2 ee2  if period == tq(2019:1)
	* P-value (sum)
test _b[l1.gcpi] + _b[l2.gcpi] + _b[l3.gcpi] + _b[l4.gcpi] =0
test _b[gw] + _b[l1.gw] + _b[l2.gw] + _b[l3.gw] + _b[l4.gw] =0 
test _b[grpe] + _b[l1.grpe] + _b[l2.grpe] + _b[l3.grpe] + _b[l4.grpe] = 0
test _b[grpf] + _b[l1.grpf] + _b[l2.grpf] + _b[l3.grpf] + _b[l4.grpf] = 0
test _b[shortage] + _b[l1.shortage] + _b[l2.shortage] + _b[l3.shortage] +_b[l4.shortage] = 0 
	* P-value (joint)
test l1.gcpi l2.gcpi l3.gcpi l4.gcpi
test gw l1.gw l2.gw l3.gw l4.gw 
test grpe l1.grpe l2.grpe l3.grpe l4.grpe 
test grpf l1.grpf l2.grpf l3.grpf l4.grpf 
test shortage l1.shortage l2.shortage l3.shortage l4.shortage

corr gcpi gcpif if period>=tq(1990:1)
di r(rho)^2

* spf1 
constraint define 3 l1.spf1 + l2.spf1 +l3.spf1 +l4.spf1 +spf10 +l1.spf10 +l2.spf10 +l3.spf10 +l4.spf10 +gcpi +l1.gcpi +l2.gcpi +l3.gcpi +l4.gcpi = 1.0
cnsreg $SPF1 l1.spf1 l2.spf1 l3.spf1 l4.spf1 spf10 l1.spf10 l2.spf10 l3.spf10 l4.spf10 gcpi l1.gcpi l2.gcpi l3.gcpi l4.gcpi if period<=tq(2019:4), c(3) noconstant
eststo col3
predict spf1f
gen resid3 = spf1-spf1f 
	* Compute sum of coefficients 
gen aa3 = _b[l1.spf1] + _b[l2.spf1] + _b[l3.spf1]+ _b[l4.spf1]
gen bb3 = _b[spf10] +_b[l1.spf10] + _b[l2.spf10] + _b[l3.spf10] + _b[l4.spf10]
gen cc3 = _b[gcpi]+_b[l1.gcpi] + _b[l2.gcpi] +  _b[l3.gcpi] + _b[l4.gcpi]
list period aa3 bb3 cc3 if period==tq(2019:1) 
	* P-value (sum)
test _b[l1.spf1] + _b[l2.spf1] + _b[l3.spf1]+ _b[l4.spf1] = 0
test _b[spf10] +_b[l1.spf10] + _b[l2.spf10] + _b[l3.spf10] + _b[l4.spf10] = 0 
test _b[gcpi]+_b[l1.gcpi] + _b[l2.gcpi] +  _b[l3.gcpi] + _b[l4.gcpi] = 0
	* P-value (joint)
test l1.spf1 l2.spf1 l3.spf1 l4.spf1 
test spf10 l1.spf10 l2.spf10 l3.spf10 l4.spf10
test gcpi l1.gcpi l2.gcpi l3.gcpi l4.gcpi

corr spf1 spf1f if period>=tq(1990:1) & period <= tq(2019:4)
di r(rho)^2

* spf10 
constraint define 4 l1.spf10 +l2.spf10 +l3.spf10 + l4.spf10 + gcpi +l1.gcpi +l2.gcpi + l3.gcpi + l4.gcpi = 1.0
cnsreg $SPF10 l1.spf10 l2.spf10 l3.spf10 l4.spf10 gcpi l1.gcpi l2.gcpi l3.gcpi l4.gcpi if period<=tq(2019:4), c(4) noconstant
eststo col4
predict spf10f
gen resid4 = spf10f-spf10 
	* Compute sum of coefficients 
gen aa4 = _b[l1.spf10] + _b[l2.spf10] + _b[l3.spf10] + _b[l4.spf10]
gen bb4 = _b[gcpi] + _b[l1.gcpi] + _b[l2.gcpi] + _b[l3.gcpi] + _b[l4.gcpi]
list period aa4 bb4 if period == tq(2019:1) 
	* P-value (sum)
test _b[l1.spf10] + _b[l2.spf10] + _b[l3.spf10] + _b[l4.spf10] = 0 
test _b[gcpi] + _b[l1.gcpi] + _b[l2.gcpi] + _b[l3.gcpi] + _b[l4.gcpi] = 0 
	* P-value (joint)
test l1.spf10 l2.spf10 l3.spf10 l4.spf10
test gcpi l1.gcpi l2.gcpi l3.gcpi l4.gcpi 

corr spf10 spf10f if period>=tq(1990:1) & period <= tq(2019:4)
di r(rho)^2

* OUTPUT    
#delimit;
esttab col1 col2 col3 col4  using `outfilename', replace compress
title("Replication table A3 Bernanke Blanchard 2023")
mlab("gw" "gcpi" "spf1" "spf10")
stats(r2 N, fmt(%9.3f %9.0f)
labels("R-squared" "Obs"))
nonote addnote("Note: Clustered standard errors in parentheses, * p < 0.10, ** p < 0.05, *** p < 0.01") star(* 0.10 ** 0.05 *** 0.01)
varlabels(
_cons "Intercept"
)
b(%9.2f) se(%9.2f);
