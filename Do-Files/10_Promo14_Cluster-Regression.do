********************************************************************************
****Do-File Original: stprop.do*************************************************
********************************************************************************

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~ Regressionsmodelle 
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
use "Own_SD_Promo14_Personencluster.dta", clear


/*Cluster einzeln 
gen ward_academia=.
replace ward_academia=1 if wardsol5==1
replace ward_academia=0 if wardsol5>=2 & wardsol5<=5
tab ward_academia

gen ward_transemp=. 
replace ward_transemp=1 if wardsol5==2
replace ward_transemp=0 if wardsol5==1 | wardsol5>=3 & wardsol5<=5
tab ward_transemp

gen ward_care=. 
replace ward_care=1 if wardsol5==3
replace ward_care=0 if wardsol5>=1 & wardsol5<=2 | wardsol5>=4 & wardsol5<=5
tab ward_care

gen ward_transacadem=. 
replace ward_transacadem=1 if wardsol5==4
replace ward_transacadem=0 if wardsol5>=1 & wardsol5<=3 | wardsol5==5
tab ward_transacadem

gen ward_emp=.
replace ward_emp=1 if wardsol5==5
replace ward_emp=0 if wardsol5>=1 & wardsol5<=4
tab ward_emp
*/
				
//Gewichtung
svyset [pweight=x2gewi]


// Definition Variable "postprom_mobil"
// --> Häufigkeit dafür, wie oft Personen nach Promotion AG gewechselt haben


**********************************************************************************************************
**************************** Multinominales logistisches Regressionsmodell *******************************
**********************************************************************************************************

// Soziodemographische Faktoren
mlogit wardsol5 woman gebort kinder2 i.sa_vat i.sa_mut, baseoutcome(5) 
$Tabellen
outreg2 using mlogit_results_1, replace excel dec(3)

// + Auslandsmobilitität/-Bereitschaft
mlogit wardsol5 sex01 gebort kinder2 i.sa_vat i.sa_mut d1mobilaus ausland_nachstudium postprom_mobil ///
anzahltagungen p1mobausl, baseoutcome(5) 
$Tabellen
outreg2 using mlogit_results_2, append excel dec(3)

// + Soziale Mobilität 
mlogit wardsol5 sex01 gebort kinder2 i.sa_vat i.sa_mut d1mobilaus ausland_nachstudium postprom_mobil ///
anzahltagungen p1mobausl bedeut_wiss befrist2 c2zufeink c2zufbed logeink c2zufleb, baseoutcome(5) 
$Tabellen
outreg2 using mlogit_results_3, replace excel dec(3)

mlogit wardsol5 bedeut_wiss gebort ausland woman postprom_mobil p1mobausl logeink, baseoutcome(5) nolog

//Margins
predict(outcome(1))
margins, at(bedeut_wiss=(1(1)5) predict(outcome(1)))
marginsplot

*********************************************************************************
******************** Weitere Modelle mit Interaktionstermen *********************
*********************************************************************************

/*
set more off
webuse sysdsn1, clear
mlogit insure age i.male##i.site i.nonwhite, nolog base(3)
margins, dydx(male) at(site=(1 2 3))
margins r.site, dydx(male)
mlogit, rrr
*/

// Mit Interaktion zwischen Geschlecht und Partnerschaft
mlogit wardsol5 woman i.partner2 i.woman#i.partner2 kinder2 i.sa_vat i.sa_mut, baseoutcome(5) 
$Tabellen
outreg2 using mlogit_results_4, replace excel dec(3)


margins, dydx(woman) at(partner2=(0 1 2))
marginsplot


**********************************************************************************************************
**********************************  logistisches Regressionsmodell ***************************************
**********************************************************************************************************

logit ward_academia sex01 gebort kinder2 logeink bild_eltern // Akademie-Cluster
logit ward_emp sex01 gebort kinder2 logeink bild_eltern // Employment-Cluster
logit ward_transemp sex01 gebort kinder2 logeink bild_eltern // Transition-into-Employment-Cluster
logit ward_transacadem sex01 gebort kinder2 logeink bild_eltern // Transition-into-Academic-Cluster
logit ward_care sex01 gebort kinder2 logeink bild_eltern // Care-Cluster


display exp(_b[_cons] + _b[bild_eltern]*1) // Chance bei bildung_eltern=1 ist 4.193
display exp(_b[_cons] + _b[bild_eltern]*2) // Chance bei bildung_eltern=2 ist 3.764
di exp(_b[_cons] + _b[bild_eltern]*2)/exp(_b[_cons] + _b[bild_eltern]*1) 
// wenn Bildung der Eltern um 1 Einheit steigt, sinkt die Chance dem Akademie-Cluster 
// anzugehören um 0.897
di exp(_b[_cons] + _b[bild_eltern]*4)/exp(_b[_cons] + _b[bild_eltern]*1) 
// Odds-Ratios
logit, or 

//Beispiel Akademie-Cluster (Geschlecht=sex01)
// Odd's ratio = 1.369
// Erhöht sich sex01 um 1 (Von Frauen auf Männer), steigt Wahrschein. dem Akademie-Cluster anzugehören
// um 1.369 - 1 = 0.369 = 36,9 % 

//Beispiel Akademie-Cluster (Einkommen=logeink)
// odd's ratio = 0.78
// Verdoppelt sich das Einkommen, sinkt Wahrschein. dem Akademie-Cluster anzugehören um 
// 0.78 - 1 = 0.22 = 22 %



