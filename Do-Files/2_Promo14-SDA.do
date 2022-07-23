************************************************************************
***** Teil 2: Hinzufügen relevanter Variablen zum Sequenzdatensatz *****
************************************************************************
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
use "abstract_4.dta", clear


// Merge the datasets abstract_4 with Own_SD_Promo14_Sequenz.dta
	merge 1:m pid using "Own_SD_Promo14_Sequenz.dta"
// assert _merge==3 // 100 months could not be merged
					 tab status _merge if _merge==1 // Months are assigned to statuses

	drop _merge
	sort pid monthnum

//  Keep only sequences of the length of 36 monhts
	drop if monthnum > 36
	by pid, sort: generate max=_N
	drop if max<36

// Save the dataset
$Daten_Bearb
save "Own_SD_Promo14_Sequenz2.dta", replace

// Clustering

** Daten als Sequenzdaten definieren
** element variable:  status, 1 to 5, and missings
** identifier variable:  pid, 1 to 4821
** order variable:  monthnum, 1 to 36

		sqset status pid monthnum // 5 Status, 36 Zeitpunkte, 4821 Fälle
		
// Clustering with Optimal Matching algorithm
	
display "START optimal matching at $S_TIME on $S_DATE"
sqom, full k(2)
display "FINISH optimal matching at $S_TIME on $S_DATE"
sqclusterdat
	
//  Cluster Wards
display "START cluster analysis at $S_TIME on $S_DATE"
clustermat wardslinkage SQdist, name(wards) add
cluster generate wardsol=groups(2/20), name(wards)
		
 
// Show dendogram to find out the number of clusters
char _dta[wards_info] `"`"t hierarchical"' `"m wards"' `"d user matrix SQdist"' `"v id wards_id"' `"v order wards_ord"' `"v height wards_hgt"'"'
cluster tree wards, cutnumber(20)
 			
		capture clustermat stop wards, rule(calinski)
		capture clustermat stop wards, variables() rule(duda)
		sqclusterdat, return
		display "FINISH cluster analysis at $S_TIME on $S_DATE"

// Save dataset
$Daten_Bearb
save "Own_SD_Promo14_Cluster.dta", replace
	
	
// Wardsol and status
tab wardsol3 status
tab wardsol4 status
tab wardsol5 status
tab wardsol6 status
tab wardsol7 status	

// Naming of the 5-Clusters
$Daten_Bearb
use "Own_SD_Promo14_Cluster.dta"
	label var wardsol5 "5-Cluster-Solution"
	label define wardsol5_l 1 "Academic" 2 "Transition into Academic" ///
			3 "Transition into Employment" 4 "Informal Care" 5 "Employment"
	label values wardsol5 wardsol5_l
	tab wardsol5
	
// save datset as Own_SD_Promo14_Cluster.dta
$Daten_Bearb
	save "Own_SD_Promo14_Cluster.dta", replace

	
	
******************************************************************************************************
****************************** 6-Cluster? With further education as * ********************************
***********************************  sixth cluster-analysis  *****************************************
******************************************************************************************************
	
// 6 cluster
$Daten_Bearb
use "Own_SD_Promo14_Cluster.dta"
	label var wardsol6 "6-Cluster-Solution"
	label define wardsol6_l 1 "Academic" 2 "Transition into Academic" 3 "Transition into Employment" ///
			4 "Further Education" 5 "Informal Care" 6 "Employment"
	label values wardsol6 wardsol6_l
	tab wardsol6
	
// save dataset
$Daten_Bearb
	save "Own_SD_Promo14_Cluster_6.dta", replace	
	
	
// Test 6 -Cluster and save graph
preserve
quietly tabulate status, generate(stat)
collapse Academic=stat1 Employment=stat2 Unemployment=stat3 Education=stat4 ///
	Care=stat5, by(monthnum wardsol6)
label define lbward_6 1 "Acadamic" 2 "Transition into Academic" 3 "Transition into Employment" 4 "Further Education" ///
	5 "Informal Care" 6 "Employment"
label value wardsol6 lbward_6
graph bar Academic Employment Unemployment Education Care, ///
	over(month, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5 6)) ///
	by(wardsol6, rows(3) legend(at(7) pos(7)) note ("")) ///
	saving("prop_c6_alle.gph", replace)
$Abbildungen
graph export "prop_c6_alle.emf", replace
restore