******************************************************
***** Processing of the DZHW episode dataset for *****
************ sequence pattern analysis ***************
******************************************************

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

$Daten_Orig
use "phd2014_e_d_4-0-0.dta", clear


// I first have to clear the names and labels which is really helpful
label variable pid "ID"
label variable status "Status Aktivität"
** 1) I then create datetime variables from month and year-variables:
**    'begin_y' = It's the beginning year of the episode
**    'begin_m' = It shows the number of the month (e.g. 'July' has the value '7')
**     New variable 'begin': number of months since January 1960
**     values of 'begin': '2010m7' means July 2010 (2010, month 7)
**     e.g., '2002m7 - 2001m3' gives value '16', 
**     --> Why?  Because the difference between March 2001 to July 2002 is 16 month
generate begin = ym(begin_y, begin_m)
format begin %tm

** 2) This is also done for variables containing the end of the episode:
generate end = ym(end_y, end_m)
format end %tm

** 3) Now I label the new variables with "Episodenanfang" and "Episodenende"
label variable begin "Episodenanfang"
label variable end "Episodenende"

** Drop the old variables 
drop begin_y begin_m end_y end_m

** After droping the old variables I will sort the rows (episodes/spells)
sort pid begin end


// Rename the previous status. Only category 6 and 8 for Employment (8 = "Employment, "non-self-employed").
rename status status_original

//neue Variable nach Version 3
gen status=.
replace status=1 if status_original==4 | status_original==7 | status_original==12 | status_original==13 
replace status=2 if status_original==6 | status_original==8 
replace status=3 if status_original==1 
replace status=4 if status_original==5 | status_original==11 
replace status=5 if status_original==2 | status_original==3 
label var status "Status Aktivität"
label define status_lb 1 "Academic Field" 2 "Employment" 3 "Unemployment" 4 "Further Edu." 5 "Informal Care" 
label values status status_lb
tab status
tab status status_original


** I now generate episode duration
generate epidur=end-begin+1

** expand dataset --> one line for each person-month: each episode (line) is duplicated as often as the value of the
** variable epidur, which reflects the episode duration in months
expand epidur
sort pid begin end status

** I now generate variable epinum which is a counter of each episode
by pid begin status, sort: generate epinum=_n

** I generate variable month = concrete month for each row 
generate month=begin+epinum-1
format month %tm

** drop variables 'begin' & 'end' that don't have to be used anymore
drop begin end

** In order to find out the overlaps, the commands 'duplicates tag' generates a new variable (dups) that shows the number of duplicates
** for each line regarding the specified variables (id month). It helps get a look at the overlapping months. 
duplicates tag pid month, generate(dups)

** The dataset is now sorted by id, month & status
sort pid month status

** Only the first row with the lowest value of status variable is kept. I also drop the variable 'dups' and fill the gaps
duplicates drop pid month, force
drop dups
sort pid month

** calculation of number indicating gaps if it is larger than 1 
by pid, sort: generate gapmon=month-month[_n-1]

** duplication of observations (=person-month) for which gapmon>1;
** generate indicator variable: value=1 if duplicated 
expand gapmon, generate(exp)
gsort pid month -exp
by pid month, sort: generate reduc1=_n if exp==1
by pid month, sort: generate reduc2=_N if exp==1
generate reduc3=reduc2-reduc1

**  re-definition of month variable
replace month=month-reduc3 if exp==1

**  drop help variables
drop reduc* exp gapmon epidur epinum

** generate new time variable starting with 1
by pid, sort: generate monthnum=_n

** save new dataset
$Daten_Bearb
save "Own_SD_Promo14_Sequenz.dta", replace

***************************************************
****** Finally, the data can be sqset ************
***************************************************


** Install sq for "sequence analysis" and sqset the dataset
// ssc install sq // I already installed the sq-package
sqset status pid monthnum

** save the dataset again
$Daten_Bearb
save "Own_SD_Promo14_Sequenz.dta", replace

exit
