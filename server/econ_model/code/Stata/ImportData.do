* What Caused the U.S Pandemic-Era Inflation? Bernanke, Blanchard 2023 
* This version : May 19, 2023 
* Please contact James Lee (Brookings Institute) or Athiana Tettaravou (Peterson Institute) for further questions. 

*This file imports raw data, saved in dta format. 

*****************************CHANGE PATH HERE***********************************
* Note: change the filepath the the data\input_data\public folder on your computer
clear all 
clear matrix
cd "C:\Users\Athiana.Tettaravou\Dropbox\Bernanke_Blanchard\replication_versions\replication_06.13.2023_no_conf_data\data\input_data\public"
*cd "C:\Users\JALee\Dropbox\Code_Dropbox\Brookings\Bernanke_Blanchard\replication_versions\replication_06.13.2023_no_conf_data\data\input_data\public"
********************************************************************************

import excel "InfoData.xlsx", sheet("CPIAUCSL") cellrange(A11:B316) firstrow clear
label variable CPIAUCSL "CPI, All Items in U.S City Average"
tempfile CPIAUCSL
save "`CPIAUCSL'"

import excel "InfoData.xlsx", sheet("EXPINF1YR")cellrange(A11:B176) firstrow clear
label variable EXPINF1YR "Cleveland 1-yr Inflation Expectations"
tempfile EXPINF1YR
save "`EXPINF1YR'"

import excel "InfoData.xlsx", sheet("EXPINF10YR")cellrange(A11:B176) firstrow clear
label variable EXPINF10YR "Cleveland 10-yr Inflation Expectations"
tempfile EXPINF10YR
save "`EXPINF10YR'"

import excel "InfoData.xlsx", sheet("CPIUFDSL")cellrange(A11:B316) firstrow clear
label variable CPIUFDSL "CPI, Food in U.S City Average"
tempfile CPIUFDSL
save "`CPIUFDSL'"

import excel "InfoData.xlsx", sheet("CPIENGSL")cellrange(A11:B276) firstrow clear
label variable CPIENGSL "CPI, Energy in U.S City Average"
tempfile CPIENGSL
save "`CPIENGSL'"

import excel "InfoData.xlsx", sheet("PCEF")cellrange(A11:B268) firstrow clear
label variable PCEF "PCE, Food"
tempfile PCEF
save "`PCEF'"

import excel "InfoData.xlsx", sheet("PCEE")cellrange(A11:B268) firstrow clear
label variable PCEE "PCE, Energy goods and services"
tempfile PCEE
save "`PCEE'"

import excel "InfoData.xlsx", sheet("OPHNFB")cellrange(A11:B316) firstrow clear
label variable OPHNFB "Labor Productivity for all Employed Persons, Nonfarm Business Sector"
tempfile OPHNFB
save "`OPHNFB'"

import excel "InfoData.xlsx", sheet("DPCERD3Q086SBEA")cellrange(A11:B316) firstrow clear
label variable DPCERD3Q086SBEA "PCE, Implicit Price deflator"
tempfile DPCERD3Q086SBEA
save "`DPCERD3Q086SBEA'"

import excel "InfoData.xlsx", sheet("PNRGINDEXM")cellrange(A11:B135) firstrow clear
label variable PNRGINDEXM "Global price of energy index"
tempfile PNRGINDEXM
save "`PNRGINDEXM'"

import excel "InfoData.xlsx", sheet("CARSHORTAGE")cellrange(A11:B88) firstrow clear
label variable CARSHORTAGE "Car shortage"
tempfile CARSHORTAGE
save "`CARSHORTAGE'"

import excel "InfoData.xlsx", sheet("CHIPSHORTAGE")cellrange(A11:B88) firstrow clear
label variable CHIPSHORTAGE "Chip shortage"
tempfile CHIPSHORTAGE
save "`CHIPSHORTAGE'"

import excel "InfoData.xlsx", sheet("SHORTAGE")cellrange(A11:B88) firstrow clear
label variable SHORTAGE "Shortage"
tempfile SHORTAGE
save "`SHORTAGE'"

import excel "InfoData.xlsx", sheet("VOVERU")cellrange(A11:B268) firstrow clear
label variable VOVERU  "Vacancy Unemployment ratio"
tempfile VOVERU
save "`VOVERU'"

import excel "InfoData.xlsx", sheet("ECIWAG")cellrange(A11:B176) firstrow clear
label variable ECIWAG "ECI index wage adjusted from B"
tempfile ECIWAG
save "`ECIWAG'"

import excel "InfoData.xlsx", sheet("SPF1YR")cellrange(A11:B184) firstrow clear
label variable SPF1YR "SPF 1-yr Inflation Expectations from DR"
tempfile SPF1YR
save "`SPF1YR'"

import excel "InfoData.xlsx", sheet("SPF10YR")cellrange(A11:B184) firstrow clear
label variable SPF10YR "SPF 10-yr Inflation Expectations from DR"
tempfile SPF10YR
save "`SPF10YR'"

* MERGE
merge 1:m observation_date using  "`CPIAUCSL'"
rename _merge _merge1
merge 1:m observation_date using  "`EXPINF1YR'"
rename _merge _merge3
merge 1:m observation_date using  "`EXPINF10YR'"
rename _merge _merge4
merge 1:m observation_date using  "`CPIUFDSL'"
rename _merge _merge5
merge 1:m observation_date using  "`CPIENGSL'"
rename _merge _merge6
merge 1:m observation_date using  "`PCEF'"
rename _merge _merge7
merge 1:m observation_date using  "`PCEE'"
rename _merge _merge8
merge 1:m observation_date using  "`OPHNFB'"
rename _merge _merge9
merge 1:m observation_date using  "`DPCERD3Q086SBEA'"
rename _merge _merge10
merge 1:m observation_date using  "`PNRGINDEXM'"
rename _merge _merge11
merge 1:m observation_date using  "`CARSHORTAGE'"
rename _merge _merge12 
merge 1:m observation_date using  "`CHIPSHORTAGE'"
rename _merge _merge13 
merge 1:m observation_date using  "`SHORTAGE'"
rename _merge _merge14 
merge 1:m observation_date using  "`VOVERU'"
rename _merge _merge15
merge 1:m observation_date using  "`ECIWAG'"
rename _merge _merge16
merge 1:m observation_date using  "`SPF1YR'"
rename _merge _merge17
merge 1:m observation_date using  "`SPF10YR'"
rename _merge _merge18

summ _merge*
drop _merge*

* QUARTERLY TIME VARIABLE 
gen period = qofd(observation_date)
format period %tq 

tsset period
drop observation_date
order period

save "../../intermediate_data/ImportData.dta", replace
