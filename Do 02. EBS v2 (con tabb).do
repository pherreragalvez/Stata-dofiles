*view "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\Otros\tabb.sthlp"
* prop: proporcion. Arroja el porcentaje que representa cada categoría del total. Variable debe ser una categórica.
* media. Arroja promedio de la variable por cada grupo v1.
* total: totales. Indica la cantidad de observaciones para cada grupo v1.
* prop_des: proporción por desagregación. Para cada nivel de la variable, reparte un 100 entre cada uno de los niveles de v1.
************
* mediana. (ERROR) Pero arroja un error: command epctile is unrecognized.
* tab: distribuciones de totales. (ERROR) Tiene problemas, no arroja al excel la tabla.
************
* ratio: Cómo funciona el ratio? tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(5_ratio) calculo(ratio) denominador(grupos) v1(grupos)
* gini: coeficiente de gini de desigualdad?

*IMPORTAR***********************************************************************

clear all
use "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\data\Encuesta de Bienestar Social\Base_EBS_(10921)_210721.dta"
merge m:1 folio using "C:\CMP\2022\2022 05 19 Revisión Casen y EBS\data\aux_grupos_casen.dta"
drop if _merge==2
svyset [pweight=fexp]

*LBL HOGAR DEPEN****************************************************************

lab define hogar_depen 1 "Sólo NNA" 2 "Sólo AM" 3 "Con NNA y AM" 4 "Sin cargas"
lab value hogar_depen hogar_depen
lab var hogar_depen hogar_depen

*LBL GRUPOS*********************************************************************

lab drop lblgrupos
lab define grupos 1 "Pobres" 2 "Vulnerables" 3 "RVA" 4 "RVB" 5 "Altos Ingresos"
lab value grupos grupos
lab var grupos grupos

*HORAS CUIDADOS***********************************************************************

*c1.1. Horas dedicadas al cuidado de niños(as), de personas dependientes o enfermas en el hogar
gen h_cuidado = substr(c1_1,1,2)
destring h_cuidado , replace

gen tramos_cuidado = .
replace tramos_cuidado = 0 if h_cuidado == 0
replace tramos_cuidado = 1 if h_cuidado >= 1 & h_cuidado <= 7 & tramos_cuidado == .
replace tramos_cuidado = 2 if h_cuidado >= 8 & h_cuidado <= 16 & tramos_cuidado == .
replace tramos_cuidado = 3 if h_cuidado > 16 & tramos_cuidado == .
lab define tramos_cuidado 0 "0 horas" 1 "1 a 7 horas" 2 "8 a 16 horas" 3 "NS NR"
lab value tramos_cuidado tramos_cuidado
lab var tramos_cuidado tramos_cuidado

gen dummy_cuidados = 0
replace dummy_cuidados = 1 if tramos_cuidado == 2
lab define dummy_cuidados 0 "No cuidador(a)" 1 "Cuidador(a)"
lab value dummy_cuidados dummy_cuidados
lab var dummy_cuidados dummy_cuidados

*****EDAD***********************************************************************
*gen tramos_edad = .
*replace tramos_edad = 1 if l1 <= 24
*replace tramos_edad = 2 if l1 >= 25 & l1 <= 45 & tramos_edad == .
*replace tramos_edad = 3 if l1 >= 46 & l1 <= 65 & tramos_edad == .
*replace tramos_edad = 4 if l1 >= 66 & tramos_edad == .
*lab define tramos_edad 1 "18 a 24" 2 "25 a 45" 3 "46 a 65" 4 "66 o más"
*lab value tramos_edad tramos_edad 
*lab var tramos_edad tramos_edad

gen tramos_edad = .
replace tramos_edad = 1 if l1 <= 29
replace tramos_edad = 2 if l1 <= 39 & tramos_edad == .
replace tramos_edad = 3 if l1 <= 49 & tramos_edad == .
replace tramos_edad = 4 if l1 <= 59 & tramos_edad == .
replace tramos_edad = 5 if l1 >= 60 & tramos_edad == .
lab define tramos_edad 1 "18 a 29" 2 "30 a 39" 3 "40 a 49" 4 "50 a 59" 5 "60 o más"
lab value tramos_edad tramos_edad 
lab var tramos_edad tramos_edad

*OCUPACIÓN**********************************************************************

gen ocup = .
replace ocup = 1 if l8 == 1 | l9 == 1 | l10a == 1 | l10b == 1
replace ocup = 2 if l12 == 1
replace ocup = 3 if l12 == 2
lab define lbl_ocup 1 "Ocupado" 2 "Desocupado" 3 "Inactivo"
lab value ocup lbl_ocup 
lab var ocup Ocupación

replace h_cuidado = 0 if h_cuidado > 24

*c1.2. Horas dedicadas a tareas domésticas sin pago (aseo, preparar comida, lavar ropa, planchar)
gen h_domes = substr(c1_2,1,2)
destring h_domes , replace
replace h_domes = 0 if h_domes > 24

*Sólo si es Ocupado: l8=1 | l9=1 | l10a=1 | l10b=1
*c1.3. Trabajo remunerado u ocupación
gen h_trab = substr(c1_3,1,2)
destring h_trab , replace
replace h_trab = 0 if h_trab > 24

*Sólo si es Ocupado: l8=1 | l9=1 | l10a=1 | l10b=1
*c1.4. Traslado al lugar de trabajo
gen h_traslado = substr(c1_4,1,2)
destring h_traslado , replace
replace h_traslado = 0 if h_traslado > 24

*c1.5. Ocio, vida social y pasatiempos
gen h_ocio = substr(c1_5,1,2)
destring h_ocio, replace
replace h_ocio = 0 if h_ocio > 24

*c1.6. Estudiar
gen h_est = substr(c1_6,1,2)
destring h_est, replace
replace h_est = 0 if h_est > 24

*c1.7. Dormir (incluyendo siestas)
gen h_dormir = substr(c1_7,1,2)
destring h_dormir, replace
replace h_dormir = 0 if h_dormir > 24

*gen total_hdesoc = h_cuidado + h_domes + h_ocio + h_est + h_dormir
gen total_hdesoc = h_cuidado + h_domes + h_ocio
replace total_hdesoc = . if ocup == 1
*gen total_hocup = h_cuidado + h_domes + h_trab + h_traslado + h_ocio + h_est + h_dormir
gen total_hocup = h_cuidado + h_domes + h_trab + h_ocio

gen muj_cuidadora = 0
replace muj_cuidadora = 1 if dummy_cuidados == 1 & sexo == 2
replace muj_cuidadora = 2 if muj_cuidadora == 0
lab define muj_cuidadora 1 "Mujer cuidadora" 2 "Resto de la población"
lab value muj_cuidadora muj_cuidadora
lab var muj_cuidadora muj_cuidadora

gen conoce_apoyo = 0
replace conoce_apoyo = 1 if e3_1 < 4
lab define conoce_apoyo 0 "No" 1 "Sí"
lab value conoce_apoyo conoce_apoyo
lab var conoce_apoyo conoce_apoyo

gen ocdesoc = .
replace ocdesoc = 1 if ocup == 1
replace ocdesoc = 2 if ocup != 1
lab define ocdesoc 1 "Ocupado" 2 "Desocupado"
lab value ocdesoc ocdesoc
lab var ocdesoc ocdesoc

gen cuidados_trabajo = .
replace cuidados_trabajo = 1 if muj_cuidadora == 1 & ocdesoc == 2
replace cuidados_trabajo = 2 if muj_cuidadora == 1 & ocdesoc == 1
replace cuidados_trabajo = 3 if muj_cuidadora == 2
lab define cuidados_trabajo 1 "Con cuidados y sin trabajo" 2 "Con cuidados y con trabajo" 3 "Sin cuidados"
lab value cuidados_trabajo cuidados_trabajo
tab cuidados_trabajo
lab var cuidados_trabajo cuidados_trabajo

gen mental = 0
replace mental = 1 if phq4_ag == 2
lab define mental 1 "Moderado o severo"
lab value mental mental 
tab mental 
lab var mental mental

*TAB GRUPOS*********************************************************************
tabb tramos_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(1) calculo(prop) v1(sexo)
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(1b) calculo(media) v1(sexo)

*SEXO***************************************************************************
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(2) calculo(total) v1(sexo)

*GRUPOS*************************************************************************
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(3) calculo(total) v1(grupos) v2(sexo-grupos)
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(3b) calculo(media) v1(grupos) v2(sexo-grupos)
tabb tramos_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(3c) calculo(prop) v1(grupos) subpop(if tramos_cuidado != 3)

*EDAD***************************************************************************
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(4) calculo(total) v1(tramos_edad) v2(sexo-tramos_edad)
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(4b) calculo(media) v1(tramos_edad) v2(sexo-tramos_edad)

*DESOCUPADOS GRUPOS*************************************************************
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(5dcui) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(grupos) v2(sexo-grupos)
tabb h_domes using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(6ddomes) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(grupos) v2(sexo-grupos)
tabb h_ocio using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(7docio) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(grupos) v2(sexo-grupos)
*tabb h_est using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(7destudio) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(grupos) v2(sexo-grupos)
*tabb h_dormir using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(7ddormir) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(grupos) v2(sexo-grupos)

*OCUPADOS GRUPOS****************************************************************
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(8ocui) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)
tabb h_trab using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(9otrab) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)
*tabb h_traslado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(10otras) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)
tabb h_ocio using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(11oocio) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)
tabb h_domes using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(11odom) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)
*tabb h_est using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(11oestudio) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)
*tabb h_dormir using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(11odormir) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(grupos) v2(sexo-grupos)

*DESOCUPADOS SEXO***************************************************************
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(12dcui) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(sexo)
tabb h_domes using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(13ddomes) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(sexo)
tabb h_ocio using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(14docio) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(sexo)

*OCUPADOS SEXO******************************************************************
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(15ocui) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(sexo)
tabb h_trab using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(16otrab) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(sexo)
*tabb h_traslado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(17otras) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(sexo)
tabb h_ocio using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(18oocio) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(sexo)
tabb h_domes using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(19odom) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1) v1(sexo)

*tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(4) calculo(total) v1(tramos_edad) v2(sexo-tramos_edad)
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(30) calculo(media) v1(hogar_depen) v2(sexo-hogar_depen)

tabb tramos_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(40mujocupdesoc) calculo(prop) subpop(if sexo == 2) v1(ocdesoc)


*tabb h_domes using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(aux) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1 & sexo==2) v1(grupos) v2(sexo-grupos)
*tabb h_domes using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(aux2) calculo(ratio) denominador(total_hocup) subpop(if ocup == 1 & sexo==2) v1(grupos) v2(sexo-grupos)

*ESTADÍSTICA DESCRIPTIVA********************************************************

* tramos_edad
* grupos
* ocupación

gen ocupac = .
replace ocupac = 1 if l8 == 1 | l9 == 1 | l10a == 1 | l10b == 1
replace ocupac = 2 if l12 == 1
replace ocupac = 3 if l12 == 2
lab define ocupac 1 "Ocupado" 2 "Desocupado" 3 "Inactivo"
lab value ocupac ocupac
lab var ocupac ocupac

tabb tramos_edad using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(90) calculo(prop) v1(muj_cuidadora)
tabb grupos using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(91) calculo(prop) v1(muj_cuidadora)
tabb ocupac using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(92) calculo(prop) v1(muj_cuidadora)

tabb ypc_ytotcorh using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(ypc) calculo(media) v1(cuidados_trabajo)
tabstat ypc_ytotcorh [fw=fexp], by(cuidados_trabajo)

gen apoyo_cuidadosc4=.
replace apoyo_cuidadosc4=0 if c4==2
replace apoyo_cuidadosc4=1 if c4==1
tabb apoyo_cuidadosc4 using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(apoyo_cuidadosc4) calculo(media) v1(cuidados_trabajo)

gen apoyo_cuidadose3=0
replace apoyo_cuidadose3=1 if e3_1==1 | e3_1==2 | e3_1==3
tabb apoyo_cuidadose3 using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(apoyo_cuidadose3) calculo(media) v1(cuidados_trabajo)

gen ocupadas_mujcui_resto=.
replace ocupadas_mujcui_resto = 0 if muj_cuidadora == 1 & ocupac == 1
replace ocupadas_mujcui_resto = 1 if muj_cuidadora == 2 & ocupac == 1
lab define ocupadas_mujcui_resto 0 "Cuidadoras trabajadoras" 1 "Resto"
lab value ocupadas_mujcui_resto ocupadas_mujcui_resto
lab var ocupadas_mujcui_resto ocupadas_mujcui_resto


tab ocupadas_mujcui_resto [fw=fexp]

tabb h_trab using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(horastrab) calculo(media) v1(ocupadas_mujcui_resto )











*tabb ypc_ytotcorh using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(ypc) calculo(media) v1(cuidados_trabajo)

tabb mental using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(mental) calculo(media) v1(muj_cuidadora)








*e6a: nivel educacional
*conoce_apoyo
*hogar_depen


*c1.6. Estudiar

*c1.7. Dormir (incluyendo siestas)

*c4. Si lo necesitara, ¿podría contar con apoyo para el cuidado de menores de edad, tales como sala cuna o servicios de guardería, o de familiares o amigos(as)?

* Caracterización cuidadorxs

tabstat sexo, by(cuidador)

tabstat l1, by(cuidador)
tabstat l1 [fweight=fexp], by(cuidador)

tab ocup cuidador [fweight=fexp], col

*i1
tab i1 cuidador [fweight=fexp], col

*e3
tab e3 cuidador [fweight=fexp], col

*f2
tab f2 cuidador [fweight=fexp], col
tab f3 cuidador [fweight=fexp], col

*f3



*NOTAS:
** Hacer un primer borrador con las tablas que he sacado hasta ahora con la EBS.
** Usar calculo(media).
