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


**********************************************************************
*                 5 Cluster nach Promotionsrahmen                    *
**********************************************************************
	tab d1instkont wardsol5 if monthnum==1, col
	tab d1instkont wardsol5 if monthnum==1, row
	*nach Geschlecht:
		tab d1instkont wardsol5 if sex==2 & monthnum==1, col // für Frauen
		tab d1instkont wardsol5 if sex==1 & monthnum==1, col // für Männer
		
		
**********************************************************************
*                  5 Cluster nach Promotionsfach                     *
**********************************************************************		
	tab promfach wardsol5 if monthnum==1, col
	tab promfach wardsol5 if monthnum==1, row
	*nach Geschlecht:
		tab promfach wardsol5 if sex==2 & monthnum==1, row // für Frauen
		tab promfach wardsol5 if sex==1 & monthnum==1, row // für Männer



**********************************************************************
*        5 Cluster nach Mobilität und Mobilitätseinstellungen        *
**********************************************************************

//Bereitschaft im Ausland zu arbeiten innerhalb der einzelnen Cluster 
	tab p1mobtaet wardsol5 if monthnum==1, col
	tab p1mobtaet wardsol5 if monthnum==1, row
	*nach Geschlecht:
		tab p1mobtaet wardsol5 if sex==1 & monthnum==1, col // für Männer
		tab p1mobtaet wardsol5 if sex==2 & monthnum==1, col // für Frauen
		
// Auslandsmobilität innerhalb der einzelnen Cluster
	tab ausland wardsol5 if monthnum==1, col
	tab ausland wardsol5 if monthnum==1, row
	*nach Geschlecht:
		tab ausland wardsol5 if sex==1 & monthnum==1, row // für Männer
		tab ausland wardsol5 if sex==2 & monthnum==1, row // für Frauen


// Bereitschaft auch anderso in Deutschland nach Arbeit zu suchen (clusterbezogen)
	tab p1mobarsu wardsol5 if monthnum==1, col
	tab p1mobarsu wardsol5 if monthnum==1, row
	*nach Geschlecht:	
		tab p1mobarsu wardsol5 if sex==1 & monthnum==1, row // für Männer
		tab p1mobarsu wardsol5 if sex==2 & monthnum==1, row // für Frauen 

**************************************************************************
*   Unterteilung des Wissenschaftlich Tätigen aus alter Statusvariable   *        
**************************************************************************	
	tab status status_old if status==1, row // Anzahl der Gesamtmonate
	
	
	
**************************************************************************
*       Verteilung der Monate auf Status Aktivität im 1. Cluster         *        
**************************************************************************
	tab wardsol5 status if wardsol5==1 // Anzahl der Gesamtmonate
		
		*Veränderung nach Monaten (Zahlen zur Grafik prop2):
		tab wardsol5 status if wardsol5==1 & monthnum==1
		tab wardsol5 status if wardsol5==1 & monthnum==6
		tab wardsol5 status if wardsol5==1 & monthnum==12
		tab wardsol5 status if wardsol5==1 & monthnum==24
	
	tab wardsol5 status_old if wardsol5==1 & status_old==6 | /// 
		wardsol5==1 & status_old==9 | wardsol5==1 & status_old==10 | /// 
		wardsol5==1 & status_old==14 | wardsol5==1 & status_old==15 // Unterteilung der wissenschaftlich Tätigen
		
	
*************************************************************************************************
*********************** Description of the characteristics of the cluster ***********************
*************************************************************************************************

***********************************************************************
*************** Sequence description for 48 months ********************
***********************************************************************
	
	sqset status pid monthnum

sqtab, ranks(1/10) // shows only the 10 most frequent sequences
sqtab, ranks(1/10) so // Treats identically all sequences that have the same order of elements
sqtab, ranks(1/10) se // considers sequences identical if they consists of the same elements

// Sequence-specific description
egen length = sqlength() 			  // There are 3458 Sequences each with a length of 48
tab length

egen length1 = sqlength(), element(1) // Some of the sequences contain the element 1 (academic)
tab length1			   		    	  // and at least one sequence where 48 positions contain this element

egen elemnum = sqelemcount()          // The number of elements in all sequences is at least 1
tab elemnum					          // some sequences contain all five possible elements

egen epinum = sqepicount()			  // max. number of episodes is higher, some seq. oscillate between elements
tab epinum

sqstatsum // see results above

sqstattab1 elemnum // only one sequence consists of all elements and 1403 of the 3458 seq. consist of two elements

sqstattabsum sex01

// SQ-Indexplots
sqindexplot

// Parallel-coordinates plots
sqparcoord, ylabel(1(1)5, valuelabel angle(0)) wlines(2)
sqparcoord, so ranks(1/10) offset(.5) wlines(1) ylabel(1(1)5, valuelabel angle(0))

// sqom command
sqom // without more options, sqom performs OM between each sequence and the most frequent sequence in the dataset
egen length2 = sqlength(), element(2)
egen length3 = sqlength(), element(3)
egen length4 = sqlength(), element(4)
egen length5 = sqlength(), element(5)
egen plotorder = group (_SQdist length1 length2 length3 length4 length5)
sqindexplot, order(plotorder)

egen plotorder = group (_SQdist length1 length2 length3 length4 length5)
sqindexplot, order(plotorder)
