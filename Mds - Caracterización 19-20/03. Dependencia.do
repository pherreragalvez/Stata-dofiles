********************************************************
*********************DO CASEN - CMP*********************
***********************DEPENDENCIA**********************
********************************************************

clear all
set more off
*global main "C:\Users\pherrera\Documents\Práctica\8 Casen\main"
*global main "C:\Pablo\Documentos\Práctica\Casen\main"
global main "C:\CMP\CMP - Mideso\Datos\Casen\main"

global dofiles "${main}/dofiles"
global logfiles "${main}/logfiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

*Análisis Casen 17
cd "$data"
use "Casen 2017.02.dta"

********************************************************************************
*Creación variable dependencia
*Dependencia funcional

*SUMA DE ABVD QUE NO PUEDE REALIZAR: EXCEPTO BAÑARSE* (actividades básicas de la vida diaria)
gen s33a1_r=1 if s33a1==5
gen s33c1_r=1 if s33c1==5
gen s33d1_r=1 if s33d1==5
gen s33e1_r=1 if s33e1==5
gen s33f1_r=1 if s33f1==5
egen incap_abvd=rowtotal(s33a1_r s33c1_r s33d1_r s33e1_r s33f1_r)
tab incap_abvd [w=expr]

**SUMA DE AIVD QUE NO PUEDE REALIZAR** (actividades instrumentales de la vida diaria)
gen s33g1_r=1 if s33g1==5
gen s33h1_r=1 if s33h1==5
gen s33i1_r=1 if s33i1==5
gen s33j1_r=1 if s33j1==5
egen incap_aivd=rowtotal(s33g1_r s33h1_r s33i1_r s33j1_r)
tab incap_aivd [w=expr]

**SUMA DE ABVD PARA LAS QUE REQUIERE AYUDA CASI SIEMPRE O SIEMPRE: CONSIDERANDO DIFICULTAD MODERADA O SEVERA, O  AYUDA RECIBIDA MUCHAS VECES O SIEMPRE**
gen s33_a_r=1 if ((s33a1==3|s33a1==4)|(s33a2==4|s33a2==5))
gen s33_b_r=1 if ((s33b1==3|s33b1==4)|(s33b2==4|s33b2==5))
gen s33_c_r=1 if ((s33c1==3|s33c1==4)|(s33c2==4|s33c2==5))
gen s33_d_r=1 if ((s33d1==3|s33d1==4)|(s33d2==4|s33d2==5))
gen s33_e_r=1 if ((s33e1==3|s33e1==4)|(s33e2==4|s33e2==5))
gen s33_f_r=1 if ((s33f1==3|s33f1==4)|(s33f2==4|s33f2==5))
egen ayuda_abvd=rowtotal(s33_a_r s33_b_r s33_c_r s33_d_r s33_e_r s33_f_r)
tab ayuda_abvd [w=expr]

**SUMA DE AIVD PARA LAS QUE REQUIERE AYUDA CASI SIEMPRE O SIEMPRE: CONSIDERANDO DIFICULTAD MODERADA O SEVERA, O  AYUDA RECIBIDA MUCHAS VECES O SIEMPRE**
gen s33_g_r=1 if ((s33g1==3|s33g1==4)|(s33g2==4|s33g2==5))
gen s33_h_r=1 if ((s33h1==3|s33h1==4)|(s33h2==4|s33h2==5))
gen s33_i_r=1 if ((s33i1==3|s33i1==4)|(s33i2==4|s33i2==5))
gen s33_j_r=1 if ((s33j1==3|s33j1==4)|(s33j2==4|s33j2==5))
egen ayuda_aivd=rowtotal(s33_g_r s33_h_r s33_i_r s33_j_r)
tab ayuda_aivd [w=expr]

**GRADUACIÓN DEPENDENCIA FUNCIONAL
gen dependencia=0 if edad>=15
*LEVE: Incapacidad para efectuar 1 AIVD
replace dependencia=1 if incap_aivd==1
*LEVE: Necesidad de ayuda siempre o casi siempre para efectuar 1 ABVD (excepto bañarse)
replace dependencia=1 if ayuda_abvd==1
*LEVE: Necesidad de ayuda siempre o casi siempre para efectuar 2 AIVD
replace dependencia=1 if ayuda_aivd==2
*MODERADA: Incapacidad para bañarse (ABVD)
replace dependencia=2 if s33b1==5
*MODERADA: Necesidad de ayuda siempre o casi siempre para efectuar 2 O MAS ABVD
replace dependencia=2 if ayuda_abvd>=2 & ayuda_abvd!=.
*MODERADA: Necesidad de ayuda siempre o casi siempre para efectuar 3 O MAS AIVD
replace dependencia=2 if ayuda_aivd>=3 & ayuda_aivd!=.
*MODERADA: Incapacidad para efectuar 1 AIVD y necesidad de ayuda siempre o casi siempre para efectuar 1 ABVD
replace dependencia=2 if incap_aivd==1 & ayuda_abvd==1
*SEVERA: Incapacidad para efectuar 1 ABVD (excepto bañarse)
replace dependencia=3 if incap_abvd>=1 & incap_abvd!=.
*SEVERA: Incapacidad para efectuar  2 AIVD
replace dependencia=3 if incap_aivd>=2 & incap_aivd!=.

label var dependencia "Dependencia Funcional"
label define dependencia  0 "No dependiente" 1 "Dependencia Leve" 2 "Dependencia Moderada" 3 "Dependencia Severa" 9 "Dependiente no clasificado"
label values dependencia dependencia


********************************************
*2-DEPENDENCIA Y ADULTOS MAYORES************
********************************************

*Para todas las personas, si son o no AAMM
gen adultomayor=.
*hombres
replace adultomayor=1 if edad>=65 & sexo==1
replace adultomayor=0 if edad<65 & sexo==1
*mujeres
replace adultomayor=1 if edad>=60 & sexo==2
replace adultomayor=0 if edad<60 & sexo==2

*Para todas las personas, si son o no dependientes
gen dum_dep=.
replace dum_dep=1 if dependencia>=1 & dependencia<=3
replace dum_dep=0 if dependencia==0 | dependencia==9
label define dummy_dependencia  0 "No dependiente" 1 "Dependencia"
label values dum_dep dummy_dependencia

*Para todos los adultos mayores, si son o no dependientes
gen dum_depam=.
replace dum_depam=0 if adultomayor==1 & dum_dep==0
replace dum_depam=1 if adultomayor==1 & dum_dep==1
label define dummy_dependencia_am  0 "No dependiente" 1 "Dependencia"
label values dum_depam dummy_dependencia_am

*TABLA 1.
*A. cuantos adultos mayores son dependientes en algún grado 
tab dependencia if adultomayor==1 [w=expr]
*tab dependencia [w=expr]
tab dum_depam [w=expr]
*tab dum_dep [w=expr]

*B. por tramo de ingresos
tab dum_depam ygroups3 [w=expr], col
*tab dum_dep ygroups3 [w=expr], col
*tab dum_dep ygroups3 [w=expr], col

*C. por sistema de salud
tab dum_depam prevsalud2 [w=expr], col
*tab dum_dep prevsalud2 [w=expr], col


*TABLA 2.

*y26_1a: pensión básica solidaria
*y26_1b: jubilación vejez aporte previsional solidario
*y26_1c: jubilación o pensión de vejez
*y26_1d: pensión básica solidaria de invalidez
*y26_1e: jubilación invalidez con aporte prev solidario
*y26_1f: jubilación o previsión de invalidez

*A
tab y26_1a if adultomayor==1 [w=expr]
tab y26_1b if adultomayor==1 [w=expr]
tab y26_1c if adultomayor==1 [w=expr]

*B
tab y26_1d adultomayor [w=expr], col
tab y26_1e adultomayor [w=expr], col
tab y26_1f adultomayor [w=expr], col

**C. para adultos mayores, de que régime? /ffaa, solidaria básica , etc)
*y26_3b_in: institución aporte previsional solidario
*y26_3c_in: institución jubilación o pensión vejez
*y26_3e_in: institución aporte previsional solidario
*y26_3f_in: institución jubilación o pensión invalidez

*C
tab y26_3b_in if adultomayor==1 [w=expr]
tab y26_3c_in if adultomayor==1 [w=expr]

*D
tab y26_3e_in adultomayor [w=expr], col
tab y26_3f_in adultomayor [w=expr], col

*TABLA 3.

*A
gen jub_vejez=.
replace jub_vejez=1 if y26_1a==1
replace jub_vejez=2 if y26_1b==1
replace jub_vejez=3 if y26_1c==1
replace jub_vejez=0 if jub_vejez==. & adultomayor==1
label define lblpension 0 "No recibe" 1 "Básica Solidaria" 2 "Con APS" 3 "Normal"
label values jub_vejez lblpension
tab jub_vejez ygroups3 [w=expr], col
**Notar que hay 16 casos que declaran jubilación de vejez con aps y normal.
*Para el resto de los casos no existen cruces.
*gen aux=1 if y26_1c==1 & y26_1b==1.

*B
gen jub_invalidez=.
replace jub_invalidez=1 if y26_1d==1
replace jub_invalidez=2 if y26_1e==1
replace jub_invalidez=3 if y26_1f==1
replace jub_invalidez=0 if jub_invalidez==. & adultomayor==1
label values jub_invalidez lblpension
tab jub_invalidez ygroups3 [w=expr], col

cd "$data"
save "Casen 2017.03.dta", replace
