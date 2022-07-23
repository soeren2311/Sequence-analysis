*******************************************************
***** Part 3: Graphical representation of clusters *****
*******************************************************

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



***** 5-cluster-solution: sequence index plot
// For all
preserve
keep pid status monthnum wardsol5
reshape wide status, i(pid) j(monthnum)
set seed 123456
sample 150, count by(wardsol5)
generate order=runiform()
reshape long
sqindexplot, ///
	by(wardsol5, yrescale rows(2) holes(4) legend(at(7))) ///
	rbar ///
	order(order) ///
	ylabel(none) ///
	ytitle("observations") ///
	xtitle("time points")
	$Abbildungen
		save "cluster5_alle.gph", replace
		graph export "cluster_alle_5.emf", replace
restore

// For those most recently active in science
preserve
keep pid status monthnum wardsol5 c2jwiss
keep if c2jwiss==1 
reshape wide status, i(pid) j(monthnum)
set seed 123456
sample 150, count by(wardsol5) // hier vielleicht auf 10 runtergehen?
generate order=runiform()
reshape long
sqindexplot, ///
	by(wardsol5, yrescale rows(2) holes(4) legend(at(7))) ///
	rbar ///
	order(order) ///
	ylabel(none) ///
	ytitle("observations") ///
	xtitle("time points")
	$Abbildungen
		save "cluster5_Wissenschaft.gph", replace
		graph export "cluster5_Wissenschaft.emf", replace
restore

// women
preserve
keep pid status monthnum wardsol5 sex01
keep if sex01==0 
reshape wide status, i(pid) j(monthnum)
set seed 123456
sample 250, count by(wardsol5) // 
generate order=runiform()
reshape long
sqindexplot, ///
	by(wardsol5, yrescale rows(2) holes(4) legend(at(7))) ///
	rbar ///
	order(order) ///
	ylabel(none) ///
	ytitle("observations") ///
	xtitle("time points")
	$Abbildungen
		save "cluster5_Frauen.gph", replace
		graph export "cluster5_Frauen.emf", replace
restore

// Men
preserve
keep pid status monthnum wardsol5 sex01
keep if sex01==1 
reshape wide status, i(pid) j(monthnum)
set seed 123456
sample 250, count by(wardsol5) // Cluster 3 scheint nur für einen zuzutreffen..
generate order=runiform()
reshape long
sqindexplot, ///
	by(wardsol5, yrescale rows(2) holes(4) legend(at(7))) ///
	rbar ///
	order(order) ///
	ylabel(none) ///
	ytitle("observations") ///
	xtitle("time points")
	$Abbildungen
		save "cluster5_Männer.gph", replace
		graph export "cluster5_Männer.emf", replace
restore

// professionally mobile people
preserve
keep pid status monthnum wardsol5 ausland
keep if ausland==1 
reshape wide status, i(pid) j(monthnum)
set seed 123456
sample 250, count by(wardsol5) 
generate order=runiform()
reshape long
sqindexplot, ///
	by(wardsol5, yrescale rows(2) holes(4) legend(at(7))) ///
	rbar ///
	order(order) ///
	ylabel(none) ///
	ytitle("observations") ///
	xtitle("time points")
	$Abbildungen
		save "cluster5_Mobil.gph", replace
		graph export "cluster5_Mobil.emf", replace
restore

// not professionally mobile people
preserve
keep pid status monthnum wardsol5 ausland
keep if ausland==2 | ausland==3
reshape wide status, i(pid) j(monthnum)
set seed 123456
sample 250, count by(wardsol5) 
generate order=runiform()
reshape long
sqindexplot, ///
	by(wardsol5, yrescale rows(2) holes(4) legend(at(7))) ///
	rbar ///
	order(order) ///
	ylabel(none) ///
	ytitle("observations") ///
	xtitle("time points")
	$Abbildungen
		save "cluster5_Nicht-Mobil.gph", replace
		graph export "cluster5_Nicht-Mobil.emf", replace
restore


