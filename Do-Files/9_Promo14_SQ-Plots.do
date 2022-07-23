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


****************************************************************************************
*************** Vergleich Anteil Cluster anhand einer Ausprägung ***********************
****************************************************************************************

// Erstelle Variable woman zur besseren Interpretation
gen woman=.
replace woman=1 if sex01==0
replace woman=0 if sex01==1
label define womanlb 0 "Männer" 1 "Frauen"
label values woman womanlb
label var woman "Geschlecht"
tab woman

// Prob_a1
preserve
quietly tabulate status, generate(stat)
collapse Academic=stat1 Employment=stat2 Unemployment=stat3 Education=stat4 ///
	Care=stat5, by(monthnum wardsol5)
label define lbward 1 "Acadamic" 2 "Transition into Academic" 3 "Transition into Employment" ///
	4 "Informal Care" 5 "Employment"
label value wardsol5 lbward
graph bar Academic Employment Unemployment Education Care, ///
	over(month, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(wardsol5, rows(3) legend(at(6) pos(4)) note ("")) ///
	saving("prop_a1_alle.gph", replace)
$Abbildungen
	graph export "prop_a1_alle.emf", replace
restore

****************************************************************************************
******** Vergleich der Anteilswerte zwischen zwei Ausprägungen einer Variablen *********
****************************************************************************************

// Prob_a2
// Kinder 0=Nein; 1=Ja
preserve
keep if kinder2==1 | kinder2==0
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum kinder2)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(kinder2, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_kinder.gph", replace)
$Abbildungen
	graph export "prop_kinder_a2.emf", replace
restore

// Work-life-Balance (0 = Geringe Chance; 1 = Hohe Chance) -> Wissenschaft und Familienleben zu vereinen
preserve
keep if worklife_dummy==1 | worklife_dummy==0
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum worklife_dummy)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(worklife_dummy, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_worklife.gph", replace)
$Abbildungen
	graph export "prop_worklife_a2.emf", replace
restore

// Berufspraxis während Promotion gesammelt
preserve
keep if prom_berufprax==1 | prom_berufprax==0
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum prom_berufprax)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(prom_berufprax, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_berufpraxis.gph", replace)
$Abbildungen
	graph export "prop_berufpraxis_a2.emf", replace
restore

// Bereitschaft Auslandsmobilität Hoch=1; Niedrig=0
preserve
keep if bereit_auslmob==1 | bereit_auslmob==0
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum bereit_auslmob)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(bereit_auslmob, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_auslbereit.gph", replace)
$Abbildungen
	graph export "prop_auslbereit_a2.emf", replace
restore

// Forschungsaufenthalte im Ausland

/*
label define d1moblb 0 "Nein" 1 "Ja"
label val d1mobilaus d1moblb
lab var d1mobilaus "Forschungsaufenthalte im Ausland während Promotion"
tab d1mobilaus
*/

preserve
keep if d1mobilaus==0 | d1mobilaus==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum d1mobilaus)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(d1mobilaus, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_forschaufenthalte.gph", replace)
$Abbildungen
	graph export "prop_forschaufenthalte_a2.emf", replace
restore

// Habilitation geplant bzw. bereits begonnen

/*
label define habillb 0 "Nein" 1 "Ja"
label val habil2 habillb
lab var habil2 "Habilitation geplant bzw. bereits begeonnen"
tab habil2
*/

preserve
keep if habil2==0 | habil2==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum habil2)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(habil2, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_habil2.gph", replace)
$Abbildungen
	graph export "prop_habil2_a2.emf", replace
restore


// Ausländische Staatsangehörigkeit

preserve
keep if gebort==0 | gebort==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum gebort)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(gebort, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_gebort.gph", replace)
$Abbildungen
	graph export "prop_gebort_a2.emf", replace
restore

// Befristung 
preserve
keep if befrist2==0 | befrist2==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum befrist2)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(befrist2, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_befrist2.gph", replace)
$Abbildungen
	graph export "prop_befrist2_a2.emf", replace
restore

// Einkommen
preserve
keep if einkommen==1 | einkommen==2 | einkommen==3
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum einkommen)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(einkommen, rows(2) holes(4 5) legend(at(4) pos(4)) note ("")) ///
	saving("prop_a2_inc.gph", replace)
$Abbildungen
	graph export "prop_inc_a2.emf", replace
restore


// Absicht in Zukunft ins Ausland zu gehen
preserve
keep if ausland2==0 | ausland2==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum ausland2)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(ausland2, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_auslanddummy.gph", replace)
$Abbildungen
	graph export "prop_auslanddummy_a2.emf", replace
restore


// AG-Wechsel 

/*
label define AGlb 0 "0 Mal" 1 "1 Mal" 2 "2 Mal"
label val postprom_mobil AGlb
lab var postprom_mobil "Häufigkeit Arbeitsplatzwechsel seit Promotion"
tab postprom_mobil
*/

preserve
keep if postprom_mobil==0 | postprom_mobil==1 | postprom_mobil==2
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum postprom_mobil)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(postprom_mobil, rows(2) holes(4 5) legend(at(4) pos(4)) note ("")) ///
	saving("prop_a2_postprom_mobil.gph", replace)
$Abbildungen
	graph export "prop_postprom_mobil_a2.emf", replace
restore

// index-Variable (Mit Beginn des Studiums/ggf. Zweitstudiums/HS-Abschluss/Promotion 
// einhergehender Ortswechsel --> Dummy-Variable)

gen index_dummy=.
replace index_dummy=0 if index2==0 | index2==1
replace index_dummy=1 if index2>=2 & index2<=5
lab define indlb 0 "0-1 Ortswechsel" 1 "mehr als 2 Ortswechsel"
lab value index_dummy indlb
lab var index_dummy "Aufstieg soziale Mobilität mit Ortswechsel"
tab index_dummy


preserve
keep if index_dummy==0 | index_dummy==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum index_dummy)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(index_dummy, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_index_dummy.gph", replace)
$Abbildungen
	graph export "prop_index_dummy_a2.emf", replace
restore


// Geschlecht
preserve
keep if sex01==0 | sex01==1
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum sex01)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(sex01, rows(2) holes(4 5) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_geschlecht.gph", replace)
$Abbildungen
	graph export "prop_geschlecht_a2.emf", replace
restore


// Anzahl der Publikationen mit Peer-Review-Verfahren
preserve
keep if pub_peer_kat==1 | pub_peer_kat==2 | pub_peer_kat==3
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum pub_peer_kat)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(pub_peer_kat, rows(2) holes(4 5) legend(at(5) pos(4)) note ("")) ///
	saving("prop_a2_anzpublikationen.gph", replace)
$Abbildungen
	graph export "prop_anzpubliktionen_a2.emf", replace
restore


// Schulabschluss Vater
preserve
keep if sa_vat==1 | sa_vat==2 | sa_vat==3 | sa_vat==4
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum sa_vat)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(sa_vat, rows(2) holes(3 6) legend(at(3) pos(4)) note ("")) ///
	saving("prop_a2_sa_vat.gph", replace)
$Abbildungen
	graph export "prop_sa_vat_a2.emf", replace
restore

// Unterscheidung nach Branche
preserve
keep if branche2==1 | branche2==2 | branche2==3
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum branche2)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(branche2, rows(2) holes(4 5) legend(at(4) pos(5)) note ("Branchenzugehörigkeit abgefragt ab Welle 2")) ///
	saving("prop_a2_branche.gph", replace)
$Abbildungen
	graph export "prop_branche_a2.emf", replace
restore


// Unterscheidung nach Partnerschaft
preserve
keep if partner2==0 | partner2==1 | partner2==2
quietly tabulate status, gen(stat)
collapse WissTätig=stat1 Erwerbstätigkeit=stat2 Arbeitslos=stat3 Weiterbildung=stat4 ///
	Elternzeit=stat5, by(monthnum partner2)
graph bar  WissTätig Erwerbstätigkeit Arbeitslos Weiterbildung Elternzeit, ///
	over(monthnum, gap(0) label(labsize(tiny))) ///
	percentage ///
	stack ///
	nolabel ///
	legend(cols(1) symxsize(5) keygap(1) size(small) order(1 2 3 4 5)) ///
	by(partner2, rows(2) holes(4 5) legend(at(4) pos(5)) note ("Partnerschaft")) ///
	saving("prop_a2_partner.gph", replace)
$Abbildungen
	graph export "prop_partner_a2.emf", replace
restore

//egen tag = tag(pid wardsol5)
//egen distinct = total(tag), by(wardsol5) --> Fälle zählen 

//list
list pid wardsol5 monthnum in 1/250
//Auf Personenebene wechseln
drop if monthnum>=2

$Daten_Bearb
save "Own_SD_Promo14_Personencluster.dta", replace

exit