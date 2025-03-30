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

*ESC
*id_hogar. identificador hogar
*ch01. Confirmación de integrantes actuales del hogar
*lista_hogar__id. identificacion de personas en el hogar
***CARACTERIZACIÓN**************************************************************
*ch05. Sexo
*ch06. Edad
*ch07. Identificacion jefa/a de hogar
*ch11. Nivel educ
***EMPLEO***********************************************************************
*ie01. Ocupación antes de la crisis Covid-19
*ie03. Empleo la semana pasada
*ie10. Empleo actual = empleo pre Covid?
***CUIDADOS*********************************************************************
*c01. Realización de tareas domésticas.
*	c02. Complemento c01 (identificación integrante).
*c03. Desde Covid, encargado del cuidado de niños del hogar.
*	c04. Complemento c03 (identificación integrante).
*c07. Desde Covid. encargado de cuidado de personas enfermas, en situación de discapacidad o personas mayores q requieren cuidados.
*	c08. Complemento c07 (identificación integrante).
*	c09. Cuidados de niños, personas adultas enfermas o dependientes FUERA DEL HOGAR (identificación integrante).
***QUINTIL**********************************************************************
*qytot_19. Quintil ing. total pc hogar 2019.
*qytot_21. Quintil ing. total pc hogar 2021 noviembre.

clear all
use "C:\CMP\2022\2022 08 03 Cuidados\Insumos Encuesta Social Covid\data\Encuesta Social COVID-19 IV.dta"
svyset [pweight=exp_macrozona]

* Sin duplicados.
duplicates report id_hogar lista_hogar__id
sort id_hogar lista_hogar__id
br id_hogar lista_hogar__id ch01 ch07 c02 c04 c08 c09

gen cuidados=0
replace cuidados=1 if c03_opcion1==1 & c04==lista_hogar__id
replace cuidados=1 if c07_opcion1==1 & c08==lista_hogar__id

*17%
tab cuidados
*decreciente en ingresos
tab cuidados qytot_21
*88% mujeres
tab cuidados ch05, col
* cuidados y trabajar
tab cuidados ie03
* cuidados para la gente que no trabaja
tab cuidados if ie03==2

*Razón no trabajó ni buscó empleo la semana pasada
gen motivonotrab_cuidados=0
replace motivonotrab_cuidados=1 if ie06_1 == 1 | ie06_1 == 2 | ie06_2 == 1 | ie06_2 == 2
lab define motivonotrab_cuidados 0 "Otro" 1 "Cuidados"
lab value motivonotrab_cuidados motivonotrab_cuidados 
lab var motivonotrab_cuidados motivonotrab_cuidados 
*           1 Tiene que cuidar a niños o niñas
*           2 Tiene que cuidar a adultos enfermos, en situación discapacidad o persona mayor
gen grupo1=1 if ie06_1 != .

*¿Qué tendría que ocurrir para busque trabajo las próximas 4 semanas? 
gen razonbuscartrab=0
replace razonbuscartrab=1 if ie08_1 == 1 | ie08_1 == 2 | ie08_1 == 3 | ie08_2 == 1 | ie08_2 == 2 | ie08_2 == 3
lab define razonbuscartrab 0 "Otro" 1 "Apoyo cuidados"
lab value razonbuscartrab razonbuscartrab
lab var razonbuscartrab razonbuscartrab
*           1 Que reabran salas cuna, jardines infantiles, escuelas o colegios
*           2 Contar con apoyo para cuidar niñas o niños
*           3 Contar con apoyo para cuidar a adultos enfermos, situación discapacidad o persona mayor
gen grupo2=1 if ie08_1 != .

********************************************************************************
* Razón no trabajó ni buscó empleo la semana pasada [cuidadora mujer, que no trabaja]
tab ie06_1 if cuidados == 1 & ie03 == 2 & ch05==2 [fw=exp_macrozona]
tab motivonotrab_cuidados if cuidados == 1 & ie03 == 2 & ch05==2 [fw=exp_macrozona]
tabb motivonotrab_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas ESC.xlsx", hoja(1) calculo(media) subpop(if cuidados == 1 & ie03 == 2 & ch05==2)

* ocurrir para busque trabajo las próximas 4 semanas [cuidadora mujer, que no trabaja]
tab razonbuscartrab if cuidados == 1 & ie03 == 2 & ch05==2 & grupo2==1 [fw=exp_macrozona]
tabb razonbuscartrab using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas ESC.xlsx", hoja(2) calculo(media) subpop(if cuidados == 1 & ie03 == 2 & ch05==2)


*¿Qué tendría que ocurrir para busque trabajo las próximas 4 semanas? 
gen 	razonbuscartrab_1=0
replace razonbuscartrab_1=1 if ie08_1 == 1 | ie08_2 == 1

gen 	razonbuscartrab_2=0
replace razonbuscartrab_2=1 if ie08_1 == 2 | ie08_2 == 2

gen 	razonbuscartrab_3=0
replace razonbuscartrab_3=1 if ie08_1 == 3 | ie08_2 == 3


tab razonbuscartrab_1 if cuidados == 1 & ie03 == 2 & ch05==2 & grupo2==1 [fw=exp_macrozona]
tab razonbuscartrab_2 if cuidados == 1 & ie03 == 2 & ch05==2 & grupo2==1 [fw=exp_macrozona]
tab razonbuscartrab_3 if cuidados == 1 & ie03 == 2 & ch05==2 & grupo2==1 [fw=exp_macrozona]


replace razonbuscartrab=1 if ie08_1 == 1 | ie08_1 == 2 | ie08_1 == 3 | ie08_2 == 1 | ie08_2 == 2 | ie08_2 == 3
lab define razonbuscartrab 0 "Otro" 1 "Apoyo cuidados"
lab value razonbuscartrab razonbuscartrab
lab var razonbuscartrab razonbuscartrab
*           1 Que reabran salas cuna, jardines infantiles, escuelas o colegios
*           2 Contar con apoyo para cuidar niñas o niños
*           3 Contar con apoyo para cuidar a adultos enfermos, situación discapacidad o persona mayor
gen grupo2=1 if ie08_1 != .



















*ie06.
* a quienes no estan buscando trabajos ie08. quizás ver 

*cuidados - sexo
tab cuidados ch05, col

*nivel educ - sexo
tab ch11 cuidados , row

*ie01. Ocupación antes de la crisis Covid-19
tab cuidados ie01 [fw=exp_macrozona], row

*ie03. Empleo la semana pasada
tab cuidados ie03 [fw=exp_macrozona], row

*ie10. Empleo actual = empleo pre Covid?
tab cuidados ie10 [fw=exp_macrozona], col














tabb tramos_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(1) calculo(prop) v1(sexo)
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(1b) calculo(media) v1(sexo)
tabb dummy_cuidados using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(2) calculo(total) v1(sexo)
tabb h_cuidado using "C:\CMP\2022\2022 08 03 Cuidados\Tablas\Tablas cuidados.xlsx", hoja(5dcui) calculo(ratio) denominador(total_hdesoc) subpop(if ocup != 1) v1(grupos) v2(sexo-grupos)


