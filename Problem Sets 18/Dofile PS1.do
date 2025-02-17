/* Problem Set 1. Microeconomía III
Rut 1: 18.935.148-8
Rut 2: 19.133..542-2
Semestre Otoño 2017*/ 

clear all 
set more off

*PARTE 2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2000

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen2000_Stata.dta", clear
/*La primera pregunta que responderemos es la referida a 
la pirámide poblacional, pues luego dropearemos individuos*/

*e) Pirámide poblacional

*Re-ordenamos variable sexo

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos tramos de edad.
gen tramoedad=.
replace tramoedad=1 if edad<5
replace tramoedad=2 if edad>=5 & edad<10
replace tramoedad=3 if edad>=10 & edad<15
replace tramoedad=4 if edad>=15 & edad<20
replace tramoedad=5 if edad>=20 & edad<25
replace tramoedad=6 if edad>=25 & edad<30
replace tramoedad=7 if edad>=30 & edad<35
replace tramoedad=8 if edad>=35 & edad<40
replace tramoedad=9 if edad>=40 & edad<45
replace tramoedad=10 if edad>=45 & edad<50
replace tramoedad=11 if edad>=50 & edad<55
replace tramoedad=12 if edad>=55 & edad<60
replace tramoedad=13 if edad>=60 & edad<65
replace tramoedad=14 if edad>=65 & edad<70
replace tramoedad=15 if edad>=70 & edad<75
replace tramoedad=16 if edad>=75 & edad<80
replace tramoedad=17 if edad>=80

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)

gen ocup=.
*Buscan por primera vez
replace ocup=0 if o5==2 & o3==1 
*Cesantes
replace ocup=0 if o5==1 & o3==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1

***Ahora podemos obtener los datos de la pirámide poblacional
*Tablas

*Poblacional
tab tramoedad if sexo==0
tab tramoedad if sexo==1
*Fuerza de trabajo
tab tramoedad if sexo==0 & ft==1
tab tramoedad if sexo==1 & ft==1

/*Fin de la parte e) pirámide poblacional
Ahora continuaremos con la parte 2.1.a hasta la d.*/

*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*En primer lugar, generamos escolaridad (por tramos).

gen escolaridad=.
replace escolaridad=0 if educ==1 
replace escolaridad=1 if educ==2
replace escolaridad=2 if educ==3
replace escolaridad=3 if educ==4 | educ==6
replace escolaridad=4 if educ==5 | educ==7
replace escolaridad=5 if educ==8 | educ==10
replace escolaridad=6 if educ==9 | educ==11

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(r)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1

table participa, by(escolaridad)
table participa, by(escolaridad sexo)
table participa, by(r)

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(r)
/*Forma fea (con porcentajes)*/
tab ocup if r==1
tab ocup if r==2
tab ocup if r==3
tab ocup if r==4
tab ocup if r==5
tab ocup if r==6
tab ocup if r==7
tab ocup if r==8
tab ocup if r==9
tab ocup if r==10
tab ocup if r==11
tab ocup if r==12
tab ocup if r==13

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yopraj, nq(10)
xtile quintil = yopraj, nq(5)

*Promedio de ingreso según escolaridad
summ yopraj if escolaridad==0
summ yopraj if escolaridad==1
summ yopraj if escolaridad==2
summ yopraj if escolaridad==3
summ yopraj if escolaridad==4
summ yopraj if escolaridad==5
summ yopraj if escolaridad==6

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yopraj if escolaridad==0 & sexo==0
summ yopraj if escolaridad==1 & sexo==0
summ yopraj if escolaridad==2 & sexo==0
summ yopraj if escolaridad==3 & sexo==0
summ yopraj if escolaridad==4 & sexo==0
summ yopraj if escolaridad==5 & sexo==0
summ yopraj if escolaridad==6 & sexo==0
*Mujeres
summ yopraj if escolaridad==0 & sexo==1
summ yopraj if escolaridad==1 & sexo==1
summ yopraj if escolaridad==2 & sexo==1
summ yopraj if escolaridad==3 & sexo==1
summ yopraj if escolaridad==4 & sexo==1
summ yopraj if escolaridad==5 & sexo==1
summ yopraj if escolaridad==6 & sexo==1

*Promedio de ingreso por quintiles
summ yopraj if quintil==1
summ yopraj if quintil==2
summ yopraj if quintil==3
summ yopraj if quintil==4
summ yopraj if quintil==5

*Promedio de ingreso por deciles
summ yopraj if decil==1
summ yopraj if decil==2
summ yopraj if decil==3
summ yopraj if decil==4
summ yopraj if decil==5
summ yopraj if decil==6
summ yopraj if decil==7
summ yopraj if decil==8
summ yopraj if decil==9
summ yopraj if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones

*Generamos variable pensionado 
gen pens=.
replace pens=1 if y13==1 | y13==2 | y13==3 | y13==6
replace pens=0 if y13==0 

*Generamos el monto de la pensión (pues pueden recibir más de una)
gen totpen=yjubaj 
replace totpen=. if y13==4 | y13==5
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace pens=. if totpen==.
/* Ahora los pen=1 reciben el monto totpen==yjubaj*/ 

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==1
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5
sum totpen if escolaridad==6

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==1 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
sum totpen if escolaridad==6 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==1 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0
sum totpen if escolaridad==6 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=1 if y15==1
replace institucion=2 if y15==2
replace institucion=3 if y15==3
replace institucion=4 if y15==4
replace institucion=5 if y15==5
replace institucion=6 if y15==6
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==0
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2000 */
**********************************************************

clear all 
set more off

*2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2003

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen2003.dta", clear

*Re-ordenamos variable sexo
replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)
gen ocup=.
*Buscan por primera vez
replace ocup=0 if o5==2 & o3==1 
*Cesantes
replace ocup=0 if o5==1 & o3==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1

*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*Generamos escolaridad (por tramos). var e9

gen escolaridad=.
replace escolaridad=0 if educ==1 
replace escolaridad=1 if educ==2
replace escolaridad=2 if educ==3
replace escolaridad=3 if educ==4 | educ==6
replace escolaridad=4 if educ==5 | educ==7
replace escolaridad=5 if educ==8 | educ==10
replace escolaridad=6 if educ==9 | educ==11

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(r)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1

table participa, by(escolaridad)
***
tab participa if escolaridad==0
tab participa if escolaridad==1
tab participa if escolaridad==2
tab participa if escolaridad==3
tab participa if escolaridad==4
tab participa if escolaridad==5
tab participa if escolaridad==6
******
table participa, by(escolaridad sexo)
******
*Hombres
tab participa if escolaridad==0 & sexo==0
tab participa if escolaridad==1 & sexo==0
tab participa if escolaridad==2 & sexo==0
tab participa if escolaridad==3 & sexo==0
tab participa if escolaridad==4 & sexo==0
tab participa if escolaridad==5 & sexo==0
tab participa if escolaridad==6 & sexo==0
*Mujeres

tab participa if escolaridad==0 & sexo==1
tab participa if escolaridad==1 & sexo==1
tab participa if escolaridad==2 & sexo==1
tab participa if escolaridad==3 & sexo==1
tab participa if escolaridad==4 & sexo==1
tab participa if escolaridad==5 & sexo==1
tab participa if escolaridad==6 & sexo==1
***
table participa, by(r)
tab participa if r==1
tab participa if r==2
tab participa if r==3
tab participa if r==4
tab participa if r==5
tab participa if r==6
tab participa if r==7
tab participa if r==8
tab participa if r==9
tab participa if r==10
tab participa if r==11
tab participa if r==12
tab participa if r==13

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(r)
/*Forma fea (con porcentajes)*/
tab ocup if r==1
tab ocup if r==2
tab ocup if r==3
tab ocup if r==4
tab ocup if r==5
tab ocup if r==6
tab ocup if r==7
tab ocup if r==8
tab ocup if r==9
tab ocup if r==10
tab ocup if r==11
tab ocup if r==12
tab ocup if r==13

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yopraj, nq(10)
xtile quintil = yopraj, nq(5)

*Promedio de ingreso según escolaridad
summ yopraj if escolaridad==0
summ yopraj if escolaridad==2
summ yopraj if escolaridad==3
summ yopraj if escolaridad==4
summ yopraj if escolaridad==5

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yopraj if escolaridad==0 & sexo==0
summ yopraj if escolaridad==2 & sexo==0
summ yopraj if escolaridad==3 & sexo==0
summ yopraj if escolaridad==4 & sexo==0
summ yopraj if escolaridad==5 & sexo==0
*Mujeres
summ yopraj if escolaridad==0 & sexo==1
summ yopraj if escolaridad==2 & sexo==1
summ yopraj if escolaridad==3 & sexo==1
summ yopraj if escolaridad==4 & sexo==1
summ yopraj if escolaridad==5 & sexo==1

*Promedio de ingreso por quintiles
summ yopraj if quintil==1
summ yopraj if quintil==2
summ yopraj if quintil==3
summ yopraj if quintil==4
summ yopraj if quintil==5

*Promedio de ingreso por deciles
summ yopraj if decil==1
summ yopraj if decil==2
summ yopraj if decil==3
summ yopraj if decil==4
summ yopraj if decil==5
summ yopraj if decil==6
summ yopraj if decil==7
summ yopraj if decil==8
summ yopraj if decil==9
summ yopraj if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones

*Generamos variable pensionado 
gen pens=.
replace pens=1 if y4_t1==1 | y4_t1==2 | y4_t1==5 
replace pens=0 if y4_t1==0 

*Generamos el monto de la pensión (pues pueden recibir más de una)
gen totpen=yjubaj 
replace totpen=. if y4_t1==3 | y4_t1==4 
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace pens=. if totpen==.
/* Ahora los pen=1 reciben el monto totpen==yjubaj*/ 

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=1 if y4_i1==1
replace institucion=2 if y4_i1==2
replace institucion=3 if y4_i1==3
replace institucion=4 if y4_i1==4
replace institucion=5 if y4_i1==5
replace institucion=6 if y4_i1==6
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2003 */
**********************************************************

clear all 
set more off

*2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2006

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen2006.dta", clear

*Re-ordenamos variable sexo

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)

gen ocup=.
*Buscan por primera vez
replace ocup=0 if o8==2 & o4==1 
*Cesantes
replace ocup=0 if o8==1 & o4==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 | o3==1
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1

*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*Generamos escolaridad (por tramos). var e9

gen escolaridad=.
replace escolaridad=0 if educ==0 
replace escolaridad=1 if educ==1
replace escolaridad=2 if educ==2
replace escolaridad=3 if educ==3 | educ==4
replace escolaridad=4 if educ==5 | educ==6
replace escolaridad=5 if educ==7
replace escolaridad=6 if educ==8

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(r)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1

table participa, by(escolaridad)

tab participa if escolaridad==0
tab participa if escolaridad==1
tab participa if escolaridad==2
tab participa if escolaridad==3
tab participa if escolaridad==4
tab participa if escolaridad==5
tab participa if escolaridad==6
tab participa if escolaridad==7
***
table participa, by(escolaridad sexo)
*Hombres
tab participa if escolaridad==0 & sexo==0
tab participa if escolaridad==1 & sexo==0
tab participa if escolaridad==2 & sexo==0
tab participa if escolaridad==3 & sexo==0
tab participa if escolaridad==4 & sexo==0
tab participa if escolaridad==5 & sexo==0
tab participa if escolaridad==6 & sexo==0
tab participa if escolaridad==7 & sexo==0
*Mujeres
tab participa if escolaridad==0 & sexo==1
tab participa if escolaridad==1 & sexo==1
tab participa if escolaridad==2 & sexo==1
tab participa if escolaridad==3 & sexo==1
tab participa if escolaridad==4 & sexo==1
tab participa if escolaridad==5 & sexo==1
tab participa if escolaridad==6 & sexo==1
tab participa if escolaridad==7 & sexo==1

table participa, by(r)
*Forma fea (regiones)
tab participa if r==1
tab participa if r==2
tab participa if r==3
tab participa if r==4
tab participa if r==5
tab participa if r==6
tab participa if r==7
tab participa if r==8
tab participa if r==9
tab participa if r==10
tab participa if r==11
tab participa if r==12
tab participa if r==13

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(r)
/*Forma fea (con porcentajes)*/
tab ocup if r==1
tab ocup if r==2
tab ocup if r==3
tab ocup if r==4
tab ocup if r==5
tab ocup if r==6
tab ocup if r==7
tab ocup if r==8
tab ocup if r==9
tab ocup if r==10
tab ocup if r==11
tab ocup if r==12
tab ocup if r==13

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yopraj, nq(10)
xtile quintil = yopraj, nq(5)

*Promedio de ingreso según escolaridad
summ yopraj if escolaridad==0
summ yopraj if escolaridad==1
summ yopraj if escolaridad==2
summ yopraj if escolaridad==3
summ yopraj if escolaridad==4
summ yopraj if escolaridad==5
summ yopraj if escolaridad==6

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yopraj if escolaridad==0 & sexo==0
summ yopraj if escolaridad==1 & sexo==0
summ yopraj if escolaridad==2 & sexo==0
summ yopraj if escolaridad==3 & sexo==0
summ yopraj if escolaridad==4 & sexo==0
summ yopraj if escolaridad==5 & sexo==0
summ yopraj if escolaridad==6 & sexo==0
*Mujeres
summ yopraj if escolaridad==0 & sexo==1
summ yopraj if escolaridad==1 & sexo==1
summ yopraj if escolaridad==2 & sexo==1
summ yopraj if escolaridad==3 & sexo==1
summ yopraj if escolaridad==4 & sexo==1
summ yopraj if escolaridad==5 & sexo==1
summ yopraj if escolaridad==6 & sexo==1

*Promedio de ingreso por quintiles
summ yopraj if quintil==1
summ yopraj if quintil==2
summ yopraj if quintil==3
summ yopraj if quintil==4
summ yopraj if quintil==5

*Promedio de ingreso por deciles
summ yopraj if decil==1
summ yopraj if decil==2
summ yopraj if decil==3
summ yopraj if decil==4
summ yopraj if decil==5
summ yopraj if decil==6
summ yopraj if decil==7
summ yopraj if decil==8
summ yopraj if decil==9
summ yopraj if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones

*Generamos el monto de la pensión (pues pueden recibir más de una)
egen totpen = rsum(yjubaj yvitaj yinvaj)
*Hay quienes reciben pensiones de orfandad o viudez, no se consideraron
replace totpen=. if totpen==0

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==1
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5
sum totpen if escolaridad==6

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==1 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
sum totpen if escolaridad==6 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==1 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0
sum totpen if escolaridad==6 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=1 if y20_1i==1 | y20_2i==1 | y20_3i==1
replace institucion=2 if y20_1i==2 | y20_2i==2 | y20_3i==2
replace institucion=3 if y20_1i==3 | y20_2i==3 | y20_3i==3
replace institucion=4 if y20_1i==4 | y20_2i==4 | y20_3i==4
replace institucion=5 if y20_1i==5 | y20_2i==5 | y20_3i==5
replace institucion=6 if y20_1i==6 | y20_2i==6 | y20_3i==6
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==0
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2006 */
**********************************************************

clear all 
set more off

*2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2009

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen2009stata.dta", clear
merge 1:1 segmento idviv hogar o using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen_2009.dta"

*Re-ordenamos variable sexo

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)

gen ocup=.
*Buscan por primera vez
replace ocup=0 if o8==2 & o4==1 
*Cesantes
replace ocup=0 if o8==1 & o4==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 | o3==1
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1

*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*Generamos escolaridad (por tramos). 
gen escolaridad=.
replace escolaridad=0 if educ==1 
replace escolaridad=1 if educ==2
replace escolaridad=2 if educ==3
replace escolaridad=3 if educ==4 | educ==5
replace escolaridad=4 if educ==6 | educ==7
replace escolaridad=5 if educ==8
replace escolaridad=6 if educ==9

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(region)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1

tab participa if escolaridad==0
tab participa if escolaridad==1
tab participa if escolaridad==2
tab participa if escolaridad==3
tab participa if escolaridad==4
tab participa if escolaridad==5
tab participa if escolaridad==6
tab participa if escolaridad==7
***
table participa, by(escolaridad sexo)
*Hombres
tab participa if escolaridad==0 & sexo==0
tab participa if escolaridad==1 & sexo==0
tab participa if escolaridad==2 & sexo==0
tab participa if escolaridad==3 & sexo==0
tab participa if escolaridad==4 & sexo==0
tab participa if escolaridad==5 & sexo==0
tab participa if escolaridad==6 & sexo==0
tab participa if escolaridad==7 & sexo==0
*Mujeres
tab participa if escolaridad==0 & sexo==1
tab participa if escolaridad==1 & sexo==1
tab participa if escolaridad==2 & sexo==1
tab participa if escolaridad==3 & sexo==1
tab participa if escolaridad==4 & sexo==1
tab participa if escolaridad==5 & sexo==1
tab participa if escolaridad==6 & sexo==1
tab participa if escolaridad==7 & sexo==1

table participa, by(region)
*Forma fea (regiones)
tab participa if region==1
tab participa if region==2
tab participa if region==3
tab participa if region==4
tab participa if region==5
tab participa if region==6
tab participa if region==7
tab participa if region==8
tab participa if region==9
tab participa if region==10
tab participa if region==11
tab participa if region==12
tab participa if region==13
tab participa if region==14
tab participa if region==15
***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(region)
/*Forma fea (con porcentajes)*/
tab ocup if region==1
tab ocup if region==2
tab ocup if region==3
tab ocup if region==4
tab ocup if region==5
tab ocup if region==6
tab ocup if region==7
tab ocup if region==8
tab ocup if region==9
tab ocup if region==10
tab ocup if region==11
tab ocup if region==12
tab ocup if region==13
tab ocup if region==14
tab ocup if region==15
table participa, by(escolaridad)
table participa, by(escolaridad sexo)
table participa, by(region)

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(region)
/*Forma fea (con porcentajes)*/
tab ocup if region==1
tab ocup if region==2
tab ocup if region==3
tab ocup if region==4
tab ocup if region==5
tab ocup if region==6
tab ocup if region==7
tab ocup if region==8
tab ocup if region==9
tab ocup if region==10
tab ocup if region==11
tab ocup if region==12
tab ocup if region==13
tab ocup if region==14
tab ocup if region==15

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yopraj, nq(10)
xtile quintil = yopraj, nq(5)

*Promedio de ingreso según escolaridad
summ yopraj if escolaridad==0
summ yopraj if escolaridad==1
summ yopraj if escolaridad==2
summ yopraj if escolaridad==3
summ yopraj if escolaridad==4
summ yopraj if escolaridad==5
summ yopraj if escolaridad==6

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yopraj if escolaridad==0 & sexo==0
summ yopraj if escolaridad==1 & sexo==0
summ yopraj if escolaridad==2 & sexo==0
summ yopraj if escolaridad==3 & sexo==0
summ yopraj if escolaridad==4 & sexo==0
summ yopraj if escolaridad==5 & sexo==0
summ yopraj if escolaridad==6 & sexo==0
*Mujeres
summ yopraj if escolaridad==0 & sexo==1
summ yopraj if escolaridad==1 & sexo==1
summ yopraj if escolaridad==2 & sexo==1
summ yopraj if escolaridad==3 & sexo==1
summ yopraj if escolaridad==4 & sexo==1
summ yopraj if escolaridad==5 & sexo==1
summ yopraj if escolaridad==6 & sexo==1

*Promedio de ingreso por quintiles
summ yopraj if quintil==1
summ yopraj if quintil==2
summ yopraj if quintil==3
summ yopraj if quintil==4
summ yopraj if quintil==5

*Promedio de ingreso por deciles
summ yopraj if decil==1
summ yopraj if decil==2
summ yopraj if decil==3
summ yopraj if decil==4
summ yopraj if decil==5
summ yopraj if decil==6
summ yopraj if decil==7
summ yopraj if decil==8
summ yopraj if decil==9
summ yopraj if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones

*Generamos el monto de la pensión (pues pueden recibir más de una)
egen totpen = rsum(yjubaj yvitaj yinvaj)
*Hay quienes reciben pensiones de orfandad o viudez, no se consideraron
replace totpen=. if totpen==0

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==1
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5
sum totpen if escolaridad==6

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==1 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
sum totpen if escolaridad==6 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==1 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0
sum totpen if escolaridad==6 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=1 if y21i1==1 | y21i2==1 | y21i3==1
replace institucion=2 if y21i1==2 | y21i2==2 | y21i3==2
replace institucion=3 if y21i1==3 | y21i2==3 | y21i3==3
replace institucion=4 if y21i1==4 | y21i2==4 | y21i3==4
replace institucion=5 if y21i1==5 | y21i2==5 | y21i3==5
replace institucion=6 if y21i1==6 | y21i2==6 | y21i3==6

*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2009 */
**********************************************************

clear all 
set more off

*2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2011

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen2011_octubre2011_enero2012_principal_08032013stata.dta", clear
gen o=ck1
merge 1:1 folio o using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\ingresos_originales_casen_2011_stata.dta"

*Re-ordenamos variable sexo

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)

gen ocup=.
*Buscan por primera vez
replace ocup=0 if o4==2 & o6==1 
*Cesantes
replace ocup=0 if o4==1 & o6==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 | o3==1
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1


*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*Generamos escolaridad (por tramos).

gen escolaridad=.
replace escolaridad=0 if educ==0 
replace escolaridad=1 if educ==1
replace escolaridad=2 if educ==2
replace escolaridad=3 if educ==3 | educ==4
replace escolaridad=4 if educ==5 | educ==6
replace escolaridad=5 if educ==7
preserve 
drop if e6a==13
replace escolaridad=6 if educ==8
restore
replace escolaridad=7 if e6a==13 

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(region)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1
*Participación por escolaridad
tab participa if escolaridad==0
tab participa if escolaridad==1
tab participa if escolaridad==2
tab participa if escolaridad==3
tab participa if escolaridad==4
tab participa if escolaridad==5
tab participa if escolaridad==6
tab participa if escolaridad==7
*Participación por escolaridad y sexo
*Hombres
tab participa if escolaridad==0 & sexo==0
tab participa if escolaridad==1 & sexo==0
tab participa if escolaridad==2 & sexo==0
tab participa if escolaridad==3 & sexo==0
tab participa if escolaridad==4 & sexo==0
tab participa if escolaridad==5 & sexo==0
tab participa if escolaridad==6 & sexo==0
tab participa if escolaridad==7 & sexo==0
*Mujeres
tab participa if escolaridad==0 & sexo==1
tab participa if escolaridad==1 & sexo==1
tab participa if escolaridad==2 & sexo==1
tab participa if escolaridad==3 & sexo==1
tab participa if escolaridad==4 & sexo==1
tab participa if escolaridad==5 & sexo==1
tab participa if escolaridad==6 & sexo==1
tab participa if escolaridad==7 & sexo==1
*Participación por regiones
tab participa if region==1
tab participa if region==2
tab participa if region==3
tab participa if region==4
tab participa if region==5
tab participa if region==6
tab participa if region==7
tab participa if region==8
tab participa if region==9
tab participa if region==10
tab participa if region==11
tab participa if region==12
tab participa if region==13
tab participa if region==14
tab participa if region==15

table participa, by(escolaridad)
table participa, by(escolaridad sexo)
table participa, by(region)

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(region)
/*Forma fea (con porcentajes)*/
tab ocup if region==1
tab ocup if region==2
tab ocup if region==3
tab ocup if region==4
tab ocup if region==5
tab ocup if region==6
tab ocup if region==7
tab ocup if region==8
tab ocup if region==9
tab ocup if region==10
tab ocup if region==11
tab ocup if region==12
tab ocup if region==13
tab ocup if region==14
tab ocup if region==15

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yopraj, nq(10)
xtile quintil = yopraj, nq(5)

*Promedio de ingreso según escolaridad
summ yopraj if escolaridad==0
summ yopraj if escolaridad==1
summ yopraj if escolaridad==2
summ yopraj if escolaridad==3
summ yopraj if escolaridad==4
summ yopraj if escolaridad==5
summ yopraj if escolaridad==6

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yopraj if escolaridad==0 & sexo==0
summ yopraj if escolaridad==1 & sexo==0
summ yopraj if escolaridad==2 & sexo==0
summ yopraj if escolaridad==3 & sexo==0
summ yopraj if escolaridad==4 & sexo==0
summ yopraj if escolaridad==5 & sexo==0
summ yopraj if escolaridad==6 & sexo==0
*Mujeres
summ yopraj if escolaridad==0 & sexo==1
summ yopraj if escolaridad==1 & sexo==1
summ yopraj if escolaridad==2 & sexo==1
summ yopraj if escolaridad==3 & sexo==1
summ yopraj if escolaridad==4 & sexo==1
summ yopraj if escolaridad==5 & sexo==1
summ yopraj if escolaridad==6 & sexo==1

*Promedio de ingreso por quintiles
summ yopraj if quintil==1
summ yopraj if quintil==2
summ yopraj if quintil==3
summ yopraj if quintil==4
summ yopraj if quintil==5

*Promedio de ingreso por deciles
summ yopraj if decil==1
summ yopraj if decil==2
summ yopraj if decil==3
summ yopraj if decil==4
summ yopraj if decil==5
summ yopraj if decil==6
summ yopraj if decil==7
summ yopraj if decil==8
summ yopraj if decil==9
summ yopraj if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones
*Generamos el monto de la pensión (pues pueden recibir más de una)
egen totpen = rsum(yjubaj yvitaj yinvaj)
*Hay quienes reciben pensiones de orfandad o viudez, no se consideraron
replace totpen=. if totpen==0

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==1
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5
sum totpen if escolaridad==6

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==1 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
sum totpen if escolaridad==6 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==1 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0
sum totpen if escolaridad==6 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=1 if y27ai==1 | y27bi==1 | y27ci==1
replace institucion=2 if y27ai==2 | y27bi==2 | y27ci==2
replace institucion=3 if y27ai==3 | y27bi==3 | y27ci==3
replace institucion=4 if y27ai==4 | y27bi==4 | y27ci==4
replace institucion=5 if y27ai==5 | y27bi==5 | y27ci==5
replace institucion=6 if y27ai==6 | y27bi==6 | y27ci==6

*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2011 */
**********************************************************

clear all 
set more off

*2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2013

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\ProblemSet 1\casen2013_mn_b_principal.dta", clear

*Re-ordenamos variable sexo

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)

gen ocup=.
*Buscan por primera vez
replace ocup=0 if o4==2 & o6==1 
*Cesantes
replace ocup=0 if o4==1 & o6==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 | o3==1
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1

*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*Generamos escolaridad (por tramos). 

gen escolaridad=.
replace escolaridad=0 if educ==0
replace escolaridad=1 if educ==1
replace escolaridad=2 if educ==2
replace escolaridad=3 if educ==3 | educ==4
replace escolaridad=4 if educ==5 | educ==6
replace escolaridad=5 if educ==7 | educ==9
replace escolaridad=6 if educ==8 | educ==10 | educ==11
replace escolaridad=7 if educ==12

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(region)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1

*Por escolaridad
tab participa if escolaridad==0
tab participa if escolaridad==1
tab participa if escolaridad==2
tab participa if escolaridad==3
tab participa if escolaridad==4
tab participa if escolaridad==5
tab participa if escolaridad==6
tab participa if escolaridad==7

*Por esoclaridad y sexo
*Hombres
tab participa if escolaridad==0 & sexo==0
tab participa if escolaridad==1 & sexo==0
tab participa if escolaridad==2 & sexo==0
tab participa if escolaridad==3 & sexo==0
tab participa if escolaridad==4 & sexo==0
tab participa if escolaridad==5 & sexo==0
tab participa if escolaridad==6 & sexo==0
tab participa if escolaridad==7 & sexo==0
*Mujeres
tab participa if escolaridad==0 & sexo==1
tab participa if escolaridad==1 & sexo==1
tab participa if escolaridad==2 & sexo==1
tab participa if escolaridad==3 & sexo==1
tab participa if escolaridad==4 & sexo==1
tab participa if escolaridad==5 & sexo==1
tab participa if escolaridad==6 & sexo==1
tab participa if escolaridad==7 & sexo==1
**Por regiones 
tab participa if region==1
tab participa if region==2
tab participa if region==3
tab participa if region==4
tab participa if region==5
tab participa if region==6
tab participa if region==7
tab participa if region==8
tab participa if region==9
tab participa if region==10
tab participa if region==11
tab participa if region==12
tab participa if region==13
tab participa if region==14
tab participa if region==15
***
table participa, by(escolaridad)
table participa, by(escolaridad sexo)
table participa, by(region)

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(region)
/*Forma fea (con porcentajes)*/
tab ocup if region==1
tab ocup if region==2
tab ocup if region==3
tab ocup if region==4
tab ocup if region==5
tab ocup if region==6
tab ocup if region==7
tab ocup if region==8
tab ocup if region==9
tab ocup if region==10
tab ocup if region==11
tab ocup if region==12
tab ocup if region==13
tab ocup if region==14
tab ocup if region==15

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yoprcor, nq(10)
xtile quintil = yoprcor, nq(5)

*Promedio de ingreso según escolaridad
summ yoprcor if escolaridad==0
summ yoprcor if escolaridad==1
summ yoprcor if escolaridad==2
summ yoprcor if escolaridad==3
summ yoprcor if escolaridad==4
summ yoprcor if escolaridad==5
summ yoprcor if escolaridad==6

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yoprcor if escolaridad==0 & sexo==0
summ yoprcor if escolaridad==1 & sexo==0
summ yoprcor if escolaridad==2 & sexo==0
summ yoprcor if escolaridad==3 & sexo==0
summ yoprcor if escolaridad==4 & sexo==0
summ yoprcor if escolaridad==5 & sexo==0
summ yoprcor if escolaridad==6 & sexo==0
*Mujeres
summ yoprcor if escolaridad==0 & sexo==1
summ yoprcor if escolaridad==1 & sexo==1
summ yoprcor if escolaridad==2 & sexo==1
summ yoprcor if escolaridad==3 & sexo==1
summ yoprcor if escolaridad==4 & sexo==1
summ yoprcor if escolaridad==5 & sexo==1
summ yoprcor if escolaridad==6 & sexo==1

*Promedio de ingreso por quintiles
summ yoprcor if quintil==1
summ yoprcor if quintil==2
summ yoprcor if quintil==3
summ yoprcor if quintil==4
summ yoprcor if quintil==5

*Promedio de ingreso por deciles
summ yoprcor if decil==1
summ yoprcor if decil==2
summ yoprcor if decil==3
summ yoprcor if decil==4
summ yoprcor if decil==5
summ yoprcor if decil==6
summ yoprcor if decil==7
summ yoprcor if decil==8
summ yoprcor if decil==9
summ yoprcor if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones

*Generamos el monto de la pensión (pues pueden recibir más de una)
egen totpen = rsum(y2009 y2010 y2601 y2602 y2701c yinv)
*Hay quienes reciben pensiones de orfandad o viudez, no se consideraron
replace totpen=. if totpen==0

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==1
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5
sum totpen if escolaridad==6

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==1 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
sum totpen if escolaridad==6 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==1 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0
sum totpen if escolaridad==6 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=1 if y27ai==1 | y27bi==1
replace institucion=2 if y27ai==2 | y27bi==2
replace institucion=3 if y27ai==3 | y27bi==3
replace institucion=4 if y27ai==4 | y27bi==4
replace institucion=5 if y27ai==5 | y27bi==5
replace institucion=6 if y27ai==6 | y27bi==6

*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==0
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2013 */
**********************************************************

clear all 
set more off

*2. Oferta Laboral

*a) Fuerza de trabajo y tasa de participación. CASEN 2015 

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Paper\CASEN\Casen 2015.dta", clear

/*La primera pregunta que responderemos es la referida a 
la pirámide poblacional, pues luego dropearemos individuos*/

*e) Pirámide poblacional

*Re-ordenamos variable sexo

replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos tramos de edad.
gen tramoedad=.
replace tramoedad=1 if edad<5
replace tramoedad=2 if edad>=5 & edad<10
replace tramoedad=3 if edad>=10 & edad<15
replace tramoedad=4 if edad>=15 & edad<20
replace tramoedad=5 if edad>=20 & edad<25
replace tramoedad=6 if edad>=25 & edad<30
replace tramoedad=7 if edad>=30 & edad<35
replace tramoedad=8 if edad>=35 & edad<40
replace tramoedad=9 if edad>=40 & edad<45
replace tramoedad=10 if edad>=45 & edad<50
replace tramoedad=11 if edad>=50 & edad<55
replace tramoedad=12 if edad>=55 & edad<60
replace tramoedad=13 if edad>=60 & edad<65
replace tramoedad=14 if edad>=65 & edad<70
replace tramoedad=15 if edad>=70 & edad<75
replace tramoedad=16 if edad>=75 & edad<80
replace tramoedad=17 if edad>=80

*Generamos fuerza de trabajo (Ocupad@s+Cesantes+Buscan por 1ra vez)

gen ocup=.
*Buscan por primera vez
replace ocup=0 if o4==2 & o6==1 
*Cesantes
replace ocup=0 if o4==1 & o6==1 
*Ocupad@s
replace ocup=1 if o1==1 | o2==1 | o3==1
**Etiquetamos
label define Ocupados 0 "Cesantes+PrimeraVez" 1 "Ocupados"
label values ocup Ocupados

***Fuerza de trabajo***
gen ft=0
replace ft=1 if ocup==0 | ocup==1

***Ahora podemos obtener los datos de la pirámide poblacional
*Tablas

*Poblacional
tab tramoedad if sexo==0
tab tramoedad if sexo==1
*Fuerza de trabajo
tab tramoedad if sexo==0 & ft==1
tab tramoedad if sexo==1 & ft==1
/*Fin de la parte e) pirámide poblacional
Ahora continuaremos con la parte 2.1.a hasta la d.*/

*Primero generamos niños en el hogar por tramos
*Esto lo usaremos en la 2.2.l
gen nin=0
replace nin=1 if edad<18
gen nin1=0 
replace nin1=1 if edad<3
gen nin2=0
replace nin2=1 if edad>=3 & edad<=5
gen nin3=0
replace nin3=1 if edad>5 & edad<=10 
gen nin4=0
replace nin4=1 if edad>10 & edad<18
*Asignamos una dummy=1 si hay niños o niñas en el hogar.
bys folio: egen qnin=total(nin)
bys folio: egen qnin1=total(nin1)
bys folio: egen qnin2=total(nin2)
bys folio: egen qnin3=total(nin3)
bys folio: egen qnin4=total(nin4)

replace qnin1=1 if qnin1>0
replace qnin2=1 if qnin2>0
replace qnin3=1 if qnin3>0
replace qnin4=1 if qnin4>0

*Dropeamos a quienes no tienen edad para trabajar

drop if edad<15

*En primer lugar, generamos escolaridad (por tramos).

gen escolaridad=.
replace escolaridad=0 if educ==0
replace escolaridad=1 if educ==1
replace escolaridad=2 if educ==2
replace escolaridad=3 if educ==3 | educ==4
replace escolaridad=4 if educ==5 | educ==6
replace escolaridad=5 if educ==7 | educ==9
replace escolaridad=6 if educ==8 | educ==10 | educ==11
replace escolaridad=7 if educ==12

label define ESC 0 "No asistió" 1 "Básica incompleta" 2 "Básica completa" 3 "Media incompleta" 4 "Media completa" 5 "Superior incompleta" 6 "Superior completa" 7 "Postgrado"
label values escolaridad ESC
label list ESC

***Fuerza de trabajo igual a:***
table ft
/* Acá el 0 es inactivos y 1 la fuerza de trabajo*/

*Fuerza de trabajo por escolaridad
table ft, by(escolaridad)
*Fuerza de trabajo por escolaridad y género
table ft, by(escolaridad sexo)
*Fuerza de trabajo por regiones
table ft, by(region)

***Tasa de participación***
gen participa=0
replace participa=1 if ocup==0 | ocup==1
tab participa if sexo==0
tab participa if sexo==1

*Por escolaridad
tab participa if escolaridad==0
tab participa if escolaridad==1
tab participa if escolaridad==2
tab participa if escolaridad==3
tab participa if escolaridad==4
tab participa if escolaridad==5
tab participa if escolaridad==6
tab participa if escolaridad==7

*Por esoclaridad y sexo
*Hombres
tab participa if escolaridad==0 & sexo==0
tab participa if escolaridad==1 & sexo==0
tab participa if escolaridad==2 & sexo==0
tab participa if escolaridad==3 & sexo==0
tab participa if escolaridad==4 & sexo==0
tab participa if escolaridad==5 & sexo==0
tab participa if escolaridad==6 & sexo==0
tab participa if escolaridad==7 & sexo==0
*Mujeres
tab participa if escolaridad==0 & sexo==1
tab participa if escolaridad==1 & sexo==1
tab participa if escolaridad==2 & sexo==1
tab participa if escolaridad==3 & sexo==1
tab participa if escolaridad==4 & sexo==1
tab participa if escolaridad==5 & sexo==1
tab participa if escolaridad==6 & sexo==1
tab participa if escolaridad==7 & sexo==1
**Por regiones 
tab participa if region==1
tab participa if region==2
tab participa if region==3
tab participa if region==4
tab participa if region==5
tab participa if region==6
tab participa if region==7
tab participa if region==8
tab participa if region==9
tab participa if region==10
tab participa if region==11
tab participa if region==12
tab participa if region==13
tab participa if region==14
tab participa if region==15

table participa, by(escolaridad)
table participa, by(escolaridad sexo)
table participa, by(region)

***********************Fin 2.1.a****************************

*b) Tasa de desempleo
*Tasa de desempleo femenino
tab ocup if sexo==1
*Tasa de desempleo masculino
tab ocup if sexo==0
/* 0 es el porcentaje de desempleados*/

***Tasa de desempleo por escolaridad
table ocup, by(escolaridad)
*Forma fea (con porcentajes)
tab ocup if escolaridad==0
tab ocup if escolaridad==1
tab ocup if escolaridad==2
tab ocup if escolaridad==3
tab ocup if escolaridad==4
tab ocup if escolaridad==5
tab ocup if escolaridad==6

***Tasa de desempleo por escolaridad y sexo
table ocup, by(escolaridad sexo)
/*Forma fea (con porcentajes)*/
*Hombres
tab ocup if escolaridad==0 & sexo==0
tab ocup if escolaridad==1 & sexo==0
tab ocup if escolaridad==2 & sexo==0
tab ocup if escolaridad==3 & sexo==0
tab ocup if escolaridad==4 & sexo==0
tab ocup if escolaridad==5 & sexo==0
tab ocup if escolaridad==6 & sexo==0

*Mujeres
tab ocup if escolaridad==0 & sexo==1
tab ocup if escolaridad==1 & sexo==1
tab ocup if escolaridad==2 & sexo==1
tab ocup if escolaridad==3 & sexo==1
tab ocup if escolaridad==4 & sexo==1
tab ocup if escolaridad==5 & sexo==1
tab ocup if escolaridad==6 & sexo==1

***Tasa de desempleo por regiones
table ocup, by(region)
/*Forma fea (con porcentajes)*/
tab ocup if region==1
tab ocup if region==2
tab ocup if region==3
tab ocup if region==4
tab ocup if region==5
tab ocup if region==6
tab ocup if region==7
tab ocup if region==8
tab ocup if region==9
tab ocup if region==10
tab ocup if region==11
tab ocup if region==12
tab ocup if region==13
tab ocup if region==14
tab ocup if region==15

***********************Fin 2.1.b****************************

*c) Promedio de ingreso de la ocupación principal 
*Armar deciles y quintiles
xtile decil = yoprcor, nq(10)
xtile quintil = yoprcor, nq(5)

*Promedio de ingreso según escolaridad
summ yoprcor if escolaridad==0
summ yoprcor if escolaridad==1
summ yoprcor if escolaridad==2
summ yoprcor if escolaridad==3
summ yoprcor if escolaridad==4
summ yoprcor if escolaridad==5
summ yoprcor if escolaridad==6

*Promedio de ingreso según escolaridad y sexo
*Hombres
summ yoprcor if escolaridad==0 & sexo==0
summ yoprcor if escolaridad==1 & sexo==0
summ yoprcor if escolaridad==2 & sexo==0
summ yoprcor if escolaridad==3 & sexo==0
summ yoprcor if escolaridad==4 & sexo==0
summ yoprcor if escolaridad==5 & sexo==0
summ yoprcor if escolaridad==6 & sexo==0
*Mujeres
summ yoprcor if escolaridad==0 & sexo==1
summ yoprcor if escolaridad==1 & sexo==1
summ yoprcor if escolaridad==2 & sexo==1
summ yoprcor if escolaridad==3 & sexo==1
summ yoprcor if escolaridad==4 & sexo==1
summ yoprcor if escolaridad==5 & sexo==1
summ yoprcor if escolaridad==6 & sexo==1

*Promedio de ingreso por quintiles
summ yoprcor if quintil==1
summ yoprcor if quintil==2
summ yoprcor if quintil==3
summ yoprcor if quintil==4
summ yoprcor if quintil==5

*Promedio de ingreso por deciles
summ yoprcor if decil==1
summ yoprcor if decil==2
summ yoprcor if decil==3
summ yoprcor if decil==4
summ yoprcor if decil==5
summ yoprcor if decil==6
summ yoprcor if decil==7
summ yoprcor if decil==8
summ yoprcor if decil==9
summ yoprcor if decil==10

***********************Fin 2.1.c****************************

*d) Pensiones

*Generamos variable pensionado 
gen pens=.
replace pens=1 if y26_1a==1 | y26_1b==1 | y26_1c==1 | y26_1d==1 | y26_1e==1 | y26_1f==1 | y26_1j==1 

*Limpiamos a quienes dicen no saber el monto de la pensión (marca 99)
replace y26_1am=. if y26_1am==99 | y26_1am==0 
replace y26_2bm1=. if y26_2bm1==99
replace y26_2bm2=. if y26_2bm2==99
replace y26_2c=. if y26_2c==99
replace y26_1dm=. if y26_1dm==99
replace y26_2em1=. if y26_2em1==99
replace y26_2em2=. if y26_2em2==99
replace y26_2f=. if y26_2f==99
replace y26_2g=. if y26_2g==99
replace y26_2h=. if y26_2h==99
replace y26_2i=. if y26_2i==99
replace y26_2j=. if y26_2j==99

*Generamos el monto de la pensión (pues pueden recibir más de una)
egen totpen = rsum (y26_1am y26_2bm1 y26_2bm2 y26_2c y26_1dm y26_2em1 y26_2em2 y26_2f)
replace totpen=. if totpen==0
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace pens=. if totpen==.
/* Ahora los pen=1 reciben el monto totpen*/ 

*Pensión promedio por escolaridad
sum totpen if escolaridad==0
sum totpen if escolaridad==1
sum totpen if escolaridad==2
sum totpen if escolaridad==3
sum totpen if escolaridad==4
sum totpen if escolaridad==5
sum totpen if escolaridad==6

*Pensión promedio por escolaridad y sexo
*Mujeres
sum totpen if escolaridad==0 & sexo==1
sum totpen if escolaridad==1 & sexo==1
sum totpen if escolaridad==2 & sexo==1
sum totpen if escolaridad==3 & sexo==1
sum totpen if escolaridad==4 & sexo==1
sum totpen if escolaridad==5 & sexo==1
sum totpen if escolaridad==6 & sexo==1
*Hombres
sum totpen if escolaridad==0 & sexo==0
sum totpen if escolaridad==1 & sexo==0
sum totpen if escolaridad==2 & sexo==0
sum totpen if escolaridad==3 & sexo==0
sum totpen if escolaridad==4 & sexo==0
sum totpen if escolaridad==5 & sexo==0
sum totpen if escolaridad==6 & sexo==0

*Tipos de sistema de previsión.
gen institucion=.

replace institucion=0 if totpen==89764
replace institucion=1 if y26_3b_in==1 | y26_3c_in==1 | y26_3e_in==1 | y26_3f_in==1
replace institucion=2 if y26_3b_in==2 | y26_3c_in==2 | y26_3e_in==2 | y26_3f_in==2
replace institucion=3 if y26_3b_in==3 | y26_3c_in==3 | y26_3e_in==3 | y26_3f_in==3
replace institucion=4 if y26_3b_in==4 | y26_3c_in==4 | y26_3e_in==4 | y26_3f_in==4
replace institucion=5 if y26_3b_in==5 | y26_3c_in==5 | y26_3e_in==5 | y26_3f_in==5
replace institucion=6 if y26_3b_in==6 | y26_3c_in==6 | y26_3e_in==6 | y26_3f_in==6
*Hay quienes reciben pensiones de orfandad o viudez, los hacemos missing values
replace institucion=. if totpen==.

*Pnesiones según institución (sistema de previsión)
summ totpen if institucion==0
summ totpen if institucion==1
summ totpen if institucion==2
summ totpen if institucion==3
summ totpen if institucion==4
summ totpen if institucion==5
summ totpen if institucion==6

*Pensiones por decil
*Armamos el decilpen para ordenar deciles según monto de la pensión
xtile decilpen=totpen, nq(10)

summ totpen if decilpen==1
summ totpen if decilpen==2
summ totpen if decilpen==3
summ totpen if decilpen==4
summ totpen if decilpen==5
summ totpen if decilpen==6
summ totpen if decilpen==7
summ totpen if decilpen==8
summ totpen if decilpen==9
summ totpen if decilpen==10

*Pensiones por ocupación 

summ totpen if ocup==0
summ totpen if ocup==1

**Hombres mayores de 65 y mujeres mayores de 60 trabajando.
summ ocup if sexo==0 & edad>65
summ ocup if sexo==1 & edad>60

**********************************************************
/* Fin parte 2.1, de estadística descriptiva CASEN 2015 */
**********************************************************

/*2.2 Modelo Aplicado, sólo se utilizará la CASEN 2015
Impacto de la discapacidad en el mercado laboral chileno*/
drop if edad< 15 & edad>65
*f) Ecuación de Mincer con discapacidad, personas en edad de trabajar

*Generamos variable Salario por hora
gen w=.
gen hmens=o10*4
replace w=yoprcor/hmens
gen lnw=ln(w)

*Generamos variable Discapacidad
gen disc=.
replace disc=0 if s31c1==7
replace disc=1 if s31c1==1 | s31c1==2 | s31c1==3 | s31c1==4 | s31c1==5 | s31c1==6

*Generamos experiencia (potencial)
gen exp=.
replace exp=edad-esc-6
*Y la experiencia al cuadrado
gen exp2=exp^2
**Mincer con salario
reg w disc esc exp, r

**Mincer con logaritmo del salario
reg lnw disc esc exp, r

/*Es mejor la segunda especificación puesto que
al analizar con logaritmo natural tomamos en cuenta las 
variaciones porcentuales, no los cambios unitarios (que tienden
a ser más acentuados en salarios más altos), evitando sesgar
al alza la estimación por los elevados valores de la 
cota superior*/

***********************Fin 2.2.f****************************

*g) hacer un comentario técnico, sin estimaciones. Es mejor que el error esté en la dependiente, así que el compañero está en nada

***********************Fin 2.2.g****************************

*h) Modelo anterior controlado por sexo edad y región
reg lnw disc esc exp sexo edad region exp2, r
/*Ojo, esto entrega colinealidad en la escolaridad*/

***********************Fin 2.2.h****************************

*i) limitaciones del modelo (tirar el rollo)

***********************Fin 2.2.i****************************

*j) Determinación de efectos heterogéneos de la discapacidad sobre el salario
*Para las mujeres
preserve
drop if sexo==0
reg lnw disc esc exp, r
restore 
*Para los hombres
preserve
drop if sexo==1
reg lnw disc esc exp, r
restore 
*Muestra completa, con interactivas
*Generamos la variable interactiva
gen sexodisc=sexo*disc
reg lnw disc sexo esc exp sexodisc, r

*Mostramos si hay diferencias significativas (verificar diferencias según sexo)

***********************Fin 2.2.j****************************

*k) Efectos según tipos de discapacidad
*Generamos las dummies de discapacidades según tipo
gen discfis=. 
replace discfis=1 if s31c1==1
replace discfis=0 if s31c1==2 | s31c1==3 | s31c1==4 | s31c1==5 | s31c1==6

gen discsen=. 
replace discsen=1 if s31c1==2 | s31c1==5 | s31c1==6
replace discsen=0 if  s31c1==1 | s31c1==3 | s31c1==4 | s31c1==7

gen discog=. 
replace discog=1 if s31c1==3 | s31c1==4
replace discog=0 if  s31c1==1 | s31c1==2 | s31c1==5 | s31c1==6 | s31c1==7

gen discmul=.
replace discmul=0 if s31c1==7
replace discmul=0 if s31c1==1 | s31c1==2 | s31c1==3 | s31c1==4 | s31c1==5 | s31c1==6 & s31c2==7
replace discmul=1 if s31c1==1 & s31c2==2
replace discmul=1 if s31c1==1 & s31c2==3
replace discmul=1 if s31c1==1 & s31c2==4
replace discmul=1 if s31c1==1 & s31c2==5
replace discmul=1 if s31c1==1 & s31c2==6
replace discmul=1 if s31c1==2 & s31c2==3
replace discmul=1 if s31c1==2 & s31c2==4
replace discmul=1 if s31c1==3 & s31c2==5
replace discmul=1 if s31c1==3 & s31c2==6
replace discmul=1 if s31c1==4 & s31c2==5
replace discmul=1 if s31c1==4 & s31c2==6

*Estimamos con estas dummies
reg lnw esc exp sexo edad region exp2 discfis discsen discog discmul, r

***********************Fin 2.2.l****************************

*L) Modelo de participación laboral (Probit)
*Generamos las variables necesarias
gen edad2=edad^2

gen jefh=0
replace jefh=1 if marca=="J"

gen cas=0
replace cas=1 if ecivil==1

gen urb=0
replace urb=1 if zona==1
probit ocup disc escolaridad edad edad2 qnin1 qnin2 qnin3 qnin4 jefh cas urb 

**********************************************************
/*     Fin parte 2.2, del modelo aplicado CASEN 2015    */
**********************************************************

*PARTE 3
*3.1
clear all
set more off
cd "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS1\3\stata"
use "experimentales13"

*b)

eststo sumA : estpost summarize age education black hispanic married nodegree re74 re75 if treat==1
eststo sumB : estpost summarize age education black hispanic married nodegree re74 re75 if treat==0
eststo sumC : estpost ttest age education black hispanic married nodegree re74 re75, by(treat)
esttab sumA sumB sumC, cells("t(pattern(0 0 1)) mean(pattern(1 1 0))") mtitles("Treated" "Control" "t test Mean Diff")

*c)
ttest re78, by(treat)
reg re78 treat,r
*Se crea la variable promedio de los ingresos previo al tratamiento
gen mediapre=(re74+re75)/2
*Regresión contra todas las variables disponibles
reg re78 treat age education black hispanic married nodegree mediapre,r
*Regresión sólo contra las variables significativas estadísticamente
reg re78 treat education black ,r

*d)
reg mediapre treat
*Resultado similar intuitivamente a lo obtenido en el ttest de la parte (b).

*******************************************

*3.2
clear all
set more off
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS1\3\Stata\noexperimentales13.dta"

*e)
eststo sumA : estpost summarize age education black hispanic married nodegree re74 re75 if treat==1
eststo sumB : estpost summarize age education black hispanic married nodegree re74 re75 if treat==0
eststo sumC : estpost ttest age education black hispanic married nodegree re74 re75, by(treat)
esttab sumA sumB sumC, cells("t(pattern(0 0 1)) mean(pattern(1 1 0))") mtitles("Treated" "Control" "t test Mean Diff")

gen mediapre=(re74+re75)/2
twoway (kdensity mediapre if treat==0)(kdensity mediapre if treat==1)

*f)
*En primer lugar se crean las variables de la Tabla 17 del Paper de Imbens para estimar posteriormente MPS

gen unemp74=.
replace unemp74=0 if re74>0
replace unemp74=1 if re74==0

gen unemp75=.
replace unemp75=0 if re75>0
replace unemp75=1 if re75==0

gen age2=age^2
gen u74u75=unemp74*unemp75
gen re74age=re74*age
gen re75married=re75*married
gen u74re75=unemp74*re75

pscore treat re74 unemp74 re75 unemp75 black married nodegree hispanic age age2 u74u75 re74age re75married u74re75, pscore(myscore) blockid(myblock) comsup logit

twoway (kdensity myscore if treat==0)(kdensity myscore if treat==1)

*g)
*Estimación del efecto por MCO
*Alternativa #1
reg re78 treat myscore
