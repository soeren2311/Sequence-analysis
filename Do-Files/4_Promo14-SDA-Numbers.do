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

********************************************************************************
********** Cross-tabulations of the 5-cluster representations ******************
********************************************************************************

// all
tab wardsol5 if monthnum==1

// Zuletzt in der Wissenschaft tätig?
tab wardsol5 c2jwiss if monthnum==1, row

// Geschlecht
tab wardsol5 sex01 if monthnum==1, col

// Beruflich mobil?
tab wardsol5 ausland if monthnum==1, col

//Anzahl Tagungen während Promotion
tab wardsol5 anzahltagungen if monthnum==1, row

//Mobilitsbereitschaft (Für Arbeit an anderen Ort ziehen)
tab wardsol5 p1mobausl if monthnum==1, row
tab wardsol5 p1mobtaet if monthnum==1, row
tab wardsol5 p1mobarsu if monthnum==1, row