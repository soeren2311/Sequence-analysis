********************************************************************************
********Original Do-File: modal.do**********************************************
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




***** modal plots

clear

********** load & prepare data new
$Daten_Bearb
use "Own_SD_Promo14_Cluster.dta", clear

//reshape long Status, i(id) j(month)
//sqset Status id month

******** sqmodalplot by cluster
preserve
label define lbward 1 "Wissenschaft" 2 "Übergang in die Erwerbstätigkeit" 3 "Familie/Elternzeit" ///
	4 "Übergang in die Wissenschaft" 5 "Erwerbstätigkeit"
label value wardsol5 lbward
sqmodalplot, ///
	over(wardsol5) ///
	tie(lead) ///
	legend(cols(1) symxsize(5) keygap(1) size(small) pos(6)) ///
	saving("modal1.gph", replace)
$Abbildungen
graph export "modal1.emf", replace
restore
exit
