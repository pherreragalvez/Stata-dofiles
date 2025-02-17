clear all

*2009
cd "C:\Users\Williams\Desktop\MICRO III\PS3\2009"
use entrevistado
merge 1:1 folio_n using salud
drop _merge
merge 1:1 folio_n using factor_EPS09
drop _merge 
merge 1:1 folio_n using baseingresos_2009
drop _merge
merge 1:m folio_n using hijos
drop _merge
merge m:m folio_n using hlaboral
drop _merge
merge m:m folio_n using hogar
drop _merge

rename factor_EPS09 fexp

gen anio=.
replace anio=2009

cd "C:\Users\Williams\Desktop\MICRO III\PS3"
save BASE_09, replace


*2015
clear all
cd "C:\Users\Williams\Desktop\MICRO III\PS3\2015"
use MODULOA_entrevistado
merge 1:1 folio_n using MODULOB_entrevistado
drop _merge
merge 1:1 folio_n using MODULOC_entrevistado
drop _merge
merge 1:1 folio_n using MODULOD_entrevistado
drop _merge
merge 1:1 folio_n using MODULOF_entrevistado
drop _merge
merge 1:1 folio_n using baseingresos_2015 //quizas con esta base basta para las consideraciones de ingreso. 
drop _merge
merge 1:1 folio_n using MODULOI_entrevistado //hijos
drop _merge
merge 1:1 folio_n using MODULOJ_entrevistado //calidad de vida
drop _merge
merge 1:m folio_n using MODULO_HOGAR
drop _merge 
merge m:m folio_n using MODULOB_historia_laboral

rename factor_EPS2015 fexp
gen anio=. 
replace anio=2015

cd "C:\Users\Williams\Desktop\MICRO III\PS3"
save BASE_15, replace

clear all 
cd "C:\Users\Williams\Desktop\MICRO III\PS3"
use BASE_09
append using BASE_15
save BASE_FINAL, replace

*3.1 estadistica descriptiva

*1) 
xtile decil=ytotmenpc [pw=fexp], nq(10) //creamos la variable para los deciles de ingreso

gen pobre=.
replace pobre=1 if (ytotmenpc<64134 & anio==2009) //linea de pobreza según estimacion del ministerio de desarrollo social
replace pobre=1 if (ytotmenpc<101113 & anio==2015) 

*2)
*3)
iis folio_n
tis anio

bys folio_n: gen dec_lag = decil[_n-1]
gen dif_dec = (decil - dec_lag)

gen t_pos=.
replace t_pos=0
replace t_pos = 1 if (dif_dec>0 & anio==2015)

gen t_neg=.
replace t_neg=0
replace t_neg=1 if (dif_dec<0 & anio==2015)
*4)
*5)
*6)

*3.2 Analisis empirico

*1) *Creamos las variables rezagadas del año 2015 para poder regresionar por los controles a nivel 2009

keep if a5==1

bys folio_n : gen educ_09 = a12n[_n-1]
bys folio_n : gen edad_09 = a9[_n-1]
*a6a es region
*f18b y f31 es rural (centro medico más frecuentado)
gen rururb=.
replace rururb = f18b if anio==2015
replace rururb = f31 if anio==2009
gen tipo_urb_rur=.
replace tipo_urb_rur=1
replace tipo_urb_rur=0 if rururb==2

bys folio_n : gen rur_urb = tipo_urb_rur[_n-1] 
bys folio_n : gen ocup_lag= b8[_n-1]

rename a8 sexo //1=h, 0=m
recode sexo (2=0)

gen RM=.
replace RM=0 if a6a !=13
replace RM=1 if a6a==13

logit t_pos i.educ_09 rur_urb RM sexo edad_09 i.ocup_lag, nocons
estimate store a1
outreg2 using a1, text replace

logit t_neg i.educ_09 rur_urb RM sexo edad_09 i.ocup_lag, nocons
estimate store b1
outreg2 using b1, text replace


*evaluar si dropear a los que no sean jefes de hogar

*2)
bys folio_n: egen cesante = count(b2) if b2==2 //cesante
gen duenio_casa=.
replace duenio_casa=1 if (d7==1 | d7==2) //asumimos que será dueño en la medida que la casa este pagada o pagandose
gen sindicato=.
replace sindicato=0 
replace sindicato=1 if (b16b==1 & anio==2015) 
replace sindicato=1 if (b16==1 & anio==2009)

gen enferm=.
replace enferm=0
replace enferm=1 if (f21_01==1 | f21_02==1) & anio==2009
replace enferm=1 if (f21==1 | f21==2) & anio==2015

bys folio_n : gen enfermo = enferm[_n-1]

logit t_pos i.educ_09 rur_urb RM sexo edad_09 ocup_lag cesante duenio_casa enfermo sindicato, nocons
estimates store a2
outreg2 using a2, text replace

logit t_neg i.educ_09 rur_urb RM sexo edad_09 ocup_lag cesante duenio_casa enfermo sindicato, nocons
estimates store b2
outreg2 using b2, text replace
