********************************************************
*********************DO CASEN - CMP*********************
*************************SALUD**************************
********************************************************

clear all
set more off
*global main "C:\Users\pherrera\Documents\Práctica\Casen\main"
*global main "C:\Pablo\Documentos\Práctica\Casen\main"
global main "C:\CMP\CMP - Mideso\Datos\Casen\main"

global dofiles "${main}/dofiles"
global logfiles "${main}/logfiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

*Análisis Casen 17
cd "$data"
use "Casen 2017.01.dta"

*s12: sistema previsional de salud
*tab s12

*crear variable PREVSALUD1 sin "ninguno (particular)", "otro sistema", "no sabe"
gen prevsalud1=.
replace prevsalud1=s12 if s12<=7
replace prevsalud1=8 if s12==8
replace prevsalud1=99 if s12==9 | s12==99
label define prev1 1 "FONASA A" 2 "FONASA B" 3 "FONASA C" 4 "FONASA D" 5 "FONASA (n/s grupo)" 6 "FFAA & orden" 7 "ISAPRE" 8 "Ninguno" 99 "Otro sistema / No sabe"
label values prevsalud1 prev1
tab prevsalud1

*crear variable PREVSALUD2 agrupando todo fonasa
gen prevsalud2=.
replace prevsalud2=prevsalud1
replace prevsalud2=1 if prevsalud2==1 | prevsalud2==2 | prevsalud2==3 | prevsalud2==4 | prevsalud2==5
label define prev2 1 "FONASA" 6 "FFAA & orden" 7 "ISAPRE" 8 "Ninguno" 99 "Otro sistema / No sabe" 
label values prevsalud2 prev2
tab prevsalud2

*TABLA 1.
tabulate prevsalud2 ygroups3 [w=expr], col

*TABLA 2.
tabulate prevsalud1 ygroups3 [w=expr], col

*s13: nota estado de salud actual (auto reportado)
*tab s13

*Estado de salud. Nota: se borran los No Sabe en estado de salud. Cerca de 2mil obs que representan 187mil personas (aprox. 1% de la población)
gen estadosalud=.
replace estadosalud=s13 if s13<9
*TABLA 3. A.
tabstat estadosalud [w=expr], by(prevsalud2) format(%9.2f)
*TABLA 3. B.
tabstat estadosalud [w=expr], by(etario) format(%9.2f)
*TABLA 3. C.
tabstat estadosalud [w=expr], by(ygroups3) format(%9.2f)

*s14: seguro complementario de salud
tab s14

*consolidación de una respuesta del seguro de salud por hogar
*bys folio: egen auxseguro=min(s14)
gen segurosalud=.
replace segurosalud=1 if s14==1
replace segurosalud=0 if s14==2
replace segurosalud=9 if s14==9
label define lblsegurosalud 0 "Sin seguro Salud" 1 "Con seguro Salud" 9 "NS/NR"
label values segurosalud lblsegurosalud
*drop auxseguro
tab segurosalud

*TABLA 4. (por persona / por hogar***)
tabulate prevsalud2 segurosalud [w=expr] , row
*tabulate prevsalud2 segurosalud if pco1==1 [w=expr] , row

*TABLA 5. (por persona / por hogar***)
tabulate ygroups3 segurosalud [w=expr] , row
*tabulate ygroups3 segurosalud if pco1==1 [w=expr] , row

*s15: en últimos 3 meses, algún problema de salud, enfermedad o accidente?

gen prob_salud=.
replace prob_salud=s15
replace prob_salud=0 if prob_salud==5
replace prob_salud=99 if prob_salud==9
label define probsal 0 "Sin problema de Salud" 1 "Enf. Labor" 2 "Enf. No Labor" 3 "Acc. Labor/Esc" 4 "Acc. No Labor/Esc." 99 "NS/NR"
label values prob_salud probsal
tab prob_salud

*TABLA 6.
tabulate ygroups3 prob_salud [w=expr] , row

*s16: consulta/ atención médica por esa enfermedad
*tab s16

gen consat_medica=.
replace consat_medica=s16
******Notar que los no sabe/no recuerda (9) se dejan como NO. Quizás modificar esto.
replace consat_medica=0 if consat_medica==2
replace consat_medica=99 if consat_medica==9
label define consat 0 "Sin at. médica" 1 "Con at. médica" 99 "NS/NR"
label values consat_medica consat

*TABLA 7.
tabulate ygroups3 consat_medica [w=expr] , row

*s17: por qué no tuvo consulta ni atención?
tab s17

*se agrupan las respuestas de s17 en menos categorías
gen sinatencion=.
replace sinatencion=99 if s17==99
replace sinatencion=1 if s17==1 | s17==2
replace sinatencion=2 if s17==3 | s17==4
replace sinatencion=3 if s17==5 | s17==6 | s17==7
replace sinatencion=4 if s17==8 | s17==9 | s17==10
replace sinatencion=5 if s17==11 | s17==12 | s17==13

label define label_sinaten 99 "No sabe" 1 "No lo considera necesario" 2 "Lo soluciona con medicamentos" 3 "Recurre a medicina alternativa" 4 "Piensa consultar pero no lo hace" 5 "Busca hora pero no se concreta"
label values sinatencion label_sinaten
*tab sinatencion

*TABLA 8.
tabulate sinatencion ygroups3 [w=expr], col

*s18a-e: de quienes si tuviero atención (tabla 7) se pregunta si se les presentó algún problema
*tabulate s18a [w=expr]
*tabulate s18b [w=expr]
*tabulate s18c [w=expr]
*tabulate s18d [w=expr]
*tabulate s18e [w=expr]

*TABLA 9.
tabulate s18a prevsalud2 [w=expr], col
tabulate s18b prevsalud2 [w=expr], col
tabulate s18c prevsalud2 [w=expr], col
tabulate s18d prevsalud2 [w=expr], col
tabulate s18e prevsalud2 [w=expr], col

label define label_consultas 0 "Sin atención" 1 "Al menos una atención" 99 "NS/NR"
label define label_pagosalud 99 "NS/NR" 1 "Pago total" 2 "Pago parcial" 3 "Gratuito"

*tabla 10
*tabla 11

forvalues i = 19(1)25 {
gen auxsalud_`i'_a=.
replace auxsalud_`i'_a=s`i'a if s`i'a==0 | s`i'a==99
replace auxsalud_`i'_a=1 if s`i'a>0 & s`i'a<99
label values auxsalud_`i'_a label_consultas
gen auxsalud_`i'_c=.
replace auxsalud_`i'_c=s`i'c if s`i'c==1 | s`i'c==99
replace auxsalud_`i'_c=2 if s`i'c>=2 & s`i'c<=7
replace auxsalud_`i'_c=3 if s`i'c>=8 & s`i'c<=17
label values auxsalud_`i'_c label_pagosalud
*10.A.
tab ygroups3 auxsalud_`i'_a [w=expr], row
*10.B.
tab prevsalud2 auxsalud_`i'_a [w=expr], row
*11.A.
tab auxsalud_`i'_c ygroups3 [w=expr], col
*11.B.
tab auxsalud_`i'_c prevsalud2 [w=expr], col
}


**************************************
**************************************

*TABLA ADICIONAL
gen hospit=.
replace hospit=1 if s27a==1
replace hospit=2 if s27a==2
replace hospit=3 if s27a==3 | s27a==4 | s27a==5
replace hospit=4 if s27a==6
replace hospit=5 if s27a==7
replace hospit=6 if s27a==8
replace hospit=99 if s27a==99
label define lblhospit 1 "Interv. quirúrgica (por enfermedad)" 2 "Tratam. médico (por enfermedad)" 3 "Embarazo" 4 "Interv. quirúrgica (por accidente)" 5 "Tratam. médico (por accidente)" 6 "Otra razón" 99 "NS/NR"
label values hospit lblhospit
tab hospit [w=expr]

gen pago_hosp=.
replace pago_hosp=s27d if s27d==1 | s27d==99
replace pago_hosp=2 if s27d>=2 & s27d<=8
replace pago_hosp=3 if s27d>=9 & s27d<=15
label values pago_hosp label_pagosalud

*1
tab hospit pago_hosp [w=expr], row
*2
tab prevsalud2 pago_hosp [w=expr], row

********************************************************************************
*s26 - Controles de salud*******************************************************
*s31a1 al s31a3 - Pregunta por condiciones permanentes**************************
********************************************************************************

*s28 - Tratamiento médico por...
gen tratam=.
replace tratam=1 if s28>=1 & s28<=21
replace tratam=0 if s28==22
replace tratam=9 if s28==99
label define label_tratam 0 "No recibe tratam." 1 "Si recibe tratam." 9 "NS/NR"
label values tratam label_tratam
*tab tratam

*TABLA 12.A.
tab tratam ygroups3 [w=expr], col
*TABLA 12.B.
tab tratam prevsalud2 [w=expr], col

*s29 - Tratamiento fue cubierto por AUGE GES?
*TABLA 13.
tab s29 ygroups3 [w=expr], col
tab s29 prevsalud2 [w=expr], col

*TABLA 14.**(pendiente)*********************************************************
*s30 - Pq no cubierto por el AUGE GES?
tab s30 [w=expr]

cd "$data"
save "Casen 2017.02.dta", replace
