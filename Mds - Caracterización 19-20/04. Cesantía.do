********************************************************
*********************DO CASEN - CMP*********************
***********************CESANTÍA*************************
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
use "Casen 2017.03.dta"


*I. CARACTERIZACIÓN DEL MERCADO
********************************************************************************
********************************************************************************

*activ: Condición de actividad (notar que menores de 15 años son missing value)
*1
tab activ [w=expr]
*2
tab activ ygroups3 [w=expr], col
*3
tab o28 activ [w=expr], col
*4
tab prevsalud2 activ [w=expr], col


*CARACTERIZAR A LOS HOGARES
********************************************************************************
********************************************************************************

gen y_jefe=.
replace y_jefe=ytrabajocor if pco1==1
gen y_pareja=.
replace y_pareja=ytrabajocor if pco1==2
replace y_pareja=ytrabajocor if pco1==3 & y_pareja==. & y_jefe==.
gen y_parent=.
replace y_parent=ytrabajocor if pco1==7 & y_pareja==. & y_jefe==.

gen y_jefe_aux=.
replace y_jefe_aux=y_jefe
replace y_jefe_aux=y_pareja if y_jefe_aux==.
replace y_jefe_aux=y_parent if y_jefe_aux==.

bys folio: egen max_ingreso_trabajo=max(y_jefe_aux)

*0
*Cantidad de personas y hogares por cada tramo de ingresos
tab ygroups3 [w=expr]
tab ygroups3 [w=expr] if pco1==1

*5
*(INGRESOS LABORALES DEL "JEFE DE HOGAR") CON RESPECTO AL (INGRESO TOTAL DEL HOGAR)
gen tasajefehogar=(max_ingreso_trabajo/ytotcorh)*100
tabstat tasajefehogar [w=expr] if pco1==1, stat(mean p50) by(ygroups3) format(%9.2f)

*6
*(INGRESOS LABORALES DEL "JEFE DE HOGAR") CON RESPECTO AL (INGRESO LABORAL TOTAL DEL HOGAR)
*gen tasalaboralhogar=(max_ingreso_trabajo/ytrabajocorh)*100
gen tasalaboralhogar=(max_ingreso_trabajo/ytrabajocorh)*100
tabstat tasalaboralhogar [w=expr] if pco1==1, stat(mean p50) by(ygroups3) format(%9.2f)

*7
*(INGRESOS SUBSIDIOS) CON RESPECTO A (INGRESO TOTAL DEL HOGAR)
gen tasasubsidios=(ysubh/ytotcorh)*100
tabstat tasasubsidios [w=expr] if pco1==1, stat(mean p50) by(ygroups3) format(%9.2f)

*8
*NÚMERO DE PERSONAS POR HOGAR
tabstat numper [w=expr] if pco1==1, by(ygroups3) format(%9.2f)

*9
*NÚMERO DE PERSONAS DEPENDIENTES POR HOGAR
gen auxdepend=.
replace auxdepend=1 if edad<18
replace auxdepend=1 if edad>=18 & ytrabajocor==.
bys folio: egen qdepend=total(auxdepend)
tabstat qdepend [w=expr] if pco1==1, by(ygroups3) format(%9.2f)

*COMPARACIÓN INGRESOS LABORALES Y POR SEGURO DE CESANTÍA
*10
tabstat ytrabajocorh [w=expr] if pco1==1, stat(mean p50) by(ygroups3) format(%-12.0fc)
*11
tabstat ydesh [w=expr] if ydesh>0 & pco1==1, stat(mean p50) by(ygroups3) format(%-12.0fc)


*CARACTERIZAR A LOS OCUPADOS *activ==1
********************************************************************************
********************************************************************************

*12
*INGRESO LABORAL DE OCUPADOS COMO PARTE DEL INGRESO TOTAL DEL HOGAR
gen tasayocupados=.
replace tasayocupados=(ytrabajocor/ytotcorh)*100 if activ==1
*sum tasayocupados, d
tabstat tasayocupados [w=expr], by(ygroups3) format(%9.2f)

*16
*ROL/EMPLEADO EN TRABAJO O NEGOCIO PRINCIPAL
*o15:
gen roltrabajo=.
replace roltrabajo=1 if o15==1 & activ==1
replace roltrabajo=2 if o15==2 & activ==1
replace roltrabajo=3 if o15==3 & activ==1
replace roltrabajo=3 if o15==4 & activ==1
replace roltrabajo=4 if o15==5 & activ==1
replace roltrabajo=5 if o15==6 & activ==1
replace roltrabajo=5 if o15==7 & activ==1
replace roltrabajo=6 if o15==8 & activ==1
replace roltrabajo=7 if o15==9 & activ==1
label define lblroltrabajo 1 "Patrón o empleador" 2 "Cta. propia" 3 "S. público o emp. públicas" 4 "S. privado" 5 "Serv. doméstico" 6 "FFAA y orden" 7 "Familiar no remunerado"
label values roltrabajo lblroltrabajo
tab roltrabajo ygroups3 [w=expr], col

*13
*CONTRATO POR ESCRITO
gen contrato=.
replace contrato=1 if activ==1 & o17==1
replace contrato=1 if activ==1 & o17==2
replace contrato=0 if activ==1 & o17==3
replace contrato=9 if activ==1 & o17==4
replace contrato=9 if activ==1 & o17==9
label define lblcontrato 0 "No tiene contrato" 1 "Si tiene contrato" 9 "No recuerda/NS/NR"
label values contrato lblcontrato
tab contrato ygroups3 [w=expr], col

*14
*TIPO DE CONTRATO/ACUERDO
tab o16
tab o16 ygroups3 [w=expr], col

*15
*TIEMPO EN LLEGAR
gen tenllegar=.
*replace tenllegar=((o25a_hr*60)+o25a_min) if activ==1
replace tenllegar=o25a_hr*60 if activ==1
replace tenllegar=tenllegar+o25a_min if activ==1
sum tenllegar, d
tabstat tenllegar [w=expr], by(ygroups3) format(%9.2f)

*17
*HORAS TRABAJADAS
*o15: horas trabajadas por semana
gen hrssemanales=.
replace hrssemanales=1 if o10>=1 & o10<=30
replace hrssemanales=2 if o10>30 & o10<=40
replace hrssemanales=3 if o10>40 & o10<=45
replace hrssemanales=4 if o10>45 & o10<=220
label define lblhrssemana 1 "1-30" 2 "31-40" 3 "41-45" 4 "45+"
label values hrssemanales lblhrssemana
tab hrssemanales ygroups3 [w=expr], col
*otros cruces
*18
tab hrssemanales roltrabajo [w=expr], col
*19
tab hrssemanales contrato [w=expr], col

*AFILIACIÓN A PENSIONES
*20
tab o28 ygroups3 if activ==1 [w=expr], col
*otros cruces
*21
tab o28 roltrabajo if activ==1 [w=expr], col
*22
tab o28 hrssemanales if activ==1 [w=expr], col
*23
tab o28 contrato if activ==1 [w=expr], col

*COTIZA EN PENSIONES EL MES PASADO?
*o29
gen cotpensionmespasado=.
replace cotpensionmespasado=1 if o29<=6
replace cotpensionmespasado=2 if o29==7
replace cotpensionmespasado=3 if o29==9
label define lblcotpensionmespasado 1 "Sí" 2 "No" 3 "NS"
label values cotpensionmespasado lblcotpensionmespasado
*24
tab cotpensionmespasado ygroups3 if activ==1 [w=expr], col
*25
tab cotpensionmespasado roltrabajo if activ==1 [w=expr], col
*26
tab cotpensionmespasado hrssemanales if activ==1 [w=expr], col
*27
tab cotpensionmespasado contrato if activ==1 [w=expr], col


*CARACTERIZAR A LOS DESOCUPADOS *activ==2
********************************************************************************
********************************************************************************

*TIEMPO BUSCANDO TRABAJO
*o8 (en semanas)

gen tbuscandotrab=.
replace tbuscandotrab=1 if o8<=4
replace tbuscandotrab=5 if o8<=12 & tbuscandotrab==.
replace tbuscandotrab=7 if o8<=26 & tbuscandotrab==.
replace tbuscandotrab=8 if o8<=52 & tbuscandotrab==.
replace tbuscandotrab=10 if o8<=360 & tbuscandotrab==.
replace tbuscandotrab=99 if o8==999
label define lbltbuscandotrab 1 "1-4 semanas" 5 "5-12 semanas" 7 "3-6 meses" 8 "7-12 meses" 10 "+1 año" 99 "NS/NR"
label values tbuscandotrab lbltbuscandotrab
*28
tab tbuscandotrab ygroups3 if activ==2 [w=expr], col

*COBRO DEL SEGURO DE CESANTÍA
*29
tabstat ydes [w=expr] if ydes>0 & activ==2, by(ygroups3) format(%12.2fc)

*INGRESOS TOTALES DEL HOGAR CUANDO HAY DESOCUPADOS
*30
gen auxdesocup=.
replace auxdesocup=2 if activ==2
bys folio: egen max_auxdesocup=max(auxdesocup)
tabstat ytotcorh [w=expr] if max_auxdesocup==2 & pco1==1, by(ygroups3) format(%12.1fc)

*31
*INGRESOS LABORALES DEL HOGAR CUANDO HAY DESOCUPADOS
tabstat ytrabajocorh [w=expr] if max_auxdesocup==2 & pco1==1, by(ygroups3) format(%12.1fc)

*32
*NÚMERO DE PERSONAS POR HOGAR CUANDO HAY DESOCUPADOS
tabstat numper [w=expr] if max_auxdesocup==2 & pco1==1, by(ygroups3) format(%12.1fc)

*33
*NÚMERO DE PERSONAS DEPENDIENTES POR HOGAR CUANDO HAY DESOCUPADOS
tabstat qdepend [w=expr] if max_auxdesocup==2 & pco1==1, by(ygroups3) format(%12.1fc)

*34
*AFILIACIÓN A PENSIONES
tab o28 ygroups3 if activ==2 [w=expr], col

*35
*COTIZA EN PENSIONES EL MES PASADO?
tab cotpensionmespasado ygroups3 if activ==2 [w=expr], col

********************************************************************************
********************************************************************************
********************************************************************************

tabstat esc if edad>=15, stat(mean p10 p50 p90) by(ygroups3)













cd "$data"
save "Casen 2017.04.dta", replace
