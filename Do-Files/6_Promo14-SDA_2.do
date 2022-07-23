********************************************************************************
****Do-File Original: stprop.do*************************************************
********************************************************************************

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~ status proportion plots
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

$Daten_Bearb
use "Own_SD_Promo14_Cluster.dta", clear

//reshape long Status, i(pid) j(monthnum)
//sqset Status id month

*~~~~~ status proportion plot by c2jwiss  
preserve
keep if c2jwiss==1 | c2jwiss==2
quietly tabulate status, gen(stat)
collapse WissTaetig=stat1 Erwerbs=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum c2jwiss)
graph bar  WissTaetig Erwerbs Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(nolabel)) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(c2jwiss, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_wiss2.gph", replace)
$Abbildungen
	graph export "prop_wiss2.emf", replace
restore

// Scientist in wave 1
preserve
keep if c1jwisstaet==1 | c1jwisstaet==2
quietly tabulate status, gen(stat)
collapse WissTaetig=stat1 Erwerbs=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum c2jwiss)
graph bar  WissTaetig Erwerbs Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(nolabel)) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(c2jwiss, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop1.gph", replace)
$Abbildungen
	graph export "prop1.emf", replace
restore

****** status proportion plot by cluster (long syntax)    
preserve
quietly tabulate status, generate(stat)
collapse Academic=stat1 Employment=stat2 Unenployment=stat3 Education=stat4 ///
	Care=stat5, by(monthnum wardsol5)
label define lbward 1 "Acadamic" 2 "Transition into Employment" 3 "Informal Care" ///
	4 "Transition into academic" 5 "Employment"
label value wardsol5 lbward
graph bar Academic Employment Unenployment Education Care, ///
	over(month, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(wardsol5, rows(3) legend(at(6) pos(4)) note ("")) ///
	saving("prop2a.gph", replace)
$Abbildungen
	graph export "prop2a.emf", replace
restore

*~~~~~ status proportion plot by sex  
preserve
keep if sex01==1 | sex01==0
quietly tabulate status, gen(stat)
collapse WissTaetig=stat1 Erwerbs=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum sex)
graph bar  WissTaetig Erwerbs Weiterbildung Elternzeit Arbeitslos, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(sex, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("propl2.gph", replace)
$Abbildungen
	graph export "prop12.emf", replace
restore
