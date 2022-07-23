********************************************************************************
****Do-File Original: sqindex.do*************************************************
********************************************************************************

clear all
version 16
set more off
set scrollbufsize 500000 

*Globals
	
	global Verzeichnis "C:\Users\sonon001\Desktop\DZHW\HS Niederrhein\Forschung\Datenanalyse Mobilität\Analysen\Own_SD_Promo14"
	global Abbildungen "cd "${Verzeichnis}/Abbildungen""
	global Daten_Bearb "cd "${Verzeichnis}/Daten/Daten_Bearb""
	global Daten_Orig "cd "${Verzeichnis}/Daten/Daten_Orig""
	global Do-Files "cd "${Verzeichnis}/Do-Files""
	global Tabellen "cd "${Verzeichnis}/Tabellen""



******************************
********* sequence index plots
**********************************
clear

*~~~~~ load & prepare data new
$Daten_Bearb
use "Own_SD_Promo14_Cluster.dta", clear

//reshape long Status, i(pid) j(monthnum)
//sqset status pid month

*~~~~~ pure graph (only 250 observations, unordered) to avoid overplotting; too few colors available -> only for the graph, not for the calculation!
reshape wide status, i(pid) j(monthnum)
set seed 24041972
sample 250, count
generate ord=uniform()
reshape long
sqindexplot, ///
	rbar ///
	order(ord) ///
	ytitle("observations") ///
	xtitle("time points") ///
	saving("sqbegin.gph", replace)
$Abbildungen
graph export "sqbegin.emf", replace  
*~~~~~ pure graph (all observations, ordered by cluster; incl. dividing lines)
sqindexplot, ///
	order(wardsol5 ord) ///
	yline(50) ///
	yline(86) ///
	yline(108) ///
	yline(120) ///
	rbar ///
	saving("sqplord.gph", replace)
$Abbildungen
graph export "sqplord.emf", replace  


*~~~~~ pure graph by sex (all observations, ordered by cluster)
sqindexplot, ///
	order(wardsol5 ord) ///
	by(sex) /// 
	rbar ///
	saving("sqplordsex.gph", replace)
$Abbildungen
graph export "sqplordsex.emf", replace   

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~ data were changed => load it again
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Daten_Bearb
use "Own_SD_Promo14_Cluster.dta", clear
//reshape long Status, i(pid) j(monthnum)
//sqset status pid monthnum

*~~~~~ by aktuelle Tätigkeit
keep if c2jwiss==1 | c2jwiss==2 
sqindexplot, ///
	by(c2jwiss, rows(1) legend(at(2)) note("")) ///
	order(wardsol5) ///
	rbar ///
	saving("sqplre1.gph", replace)
	$Abbildungen
graph export "sqplre1.emf", replace  /*Folie Seite 102 */

*~~~~~ by c2jwiss (rescaling)
sqindexplot, ///
	by(c2jwiss, rows(1) rescale legend(at(2)) note("")) ///
	order(wardsol5) ///
	note("") ///
	saving("sqplre2.gph", replace)
	$Abbildungen
graph export "sqplre2.emf", replace

*~~~~~ by c2jwiss (rescaling & rbar)
sqindexplot, ///
	by(c2jwiss, rows(1) rescale legend(at(2)) note("")) ///
	order(wardsol5) ///
	rbar ///
	note("") ///
	saving("sqplre3.gph", replace)
	$Abbildungen
graph export "sqplre3.emf", replace


