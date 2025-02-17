/*Problem Set 2.
Microeconomía III - Economía Laboral
Prof. Dante Contreras - Otoño 2017
*/

clear all 
set more off

**************************************************************
*Pregunta 1.
**************************************************************

*****************************************************************************************************
*****************************************************************************************************

*1)

*Unión de BBDD necesarias
clear all
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.1\Bases\Completa\simce2m2013_alu_publica_final estudiante.dta"
merge 1:m idalumno using "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.1\Bases\Completa\simce2m2013_cpad_publica_final cuestionario_padres.dta"
tab _merge
drop _merge
merge m:1 rbd using "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.1\Bases\Completa\simce2m2013_rbd_publica_final establecimientos.dta"
tab _merge
drop _merge

*Generación de variable ingreso a partir de los tramos para posterior creación de deciles

gen Inghogar=.
*1: Menos 100.000
replace Inghogar=rnormal(50000,10000) if cpad_p09==1
*2: Entre 100.001 - 200.000
replace Inghogar=rnormal(150000,10000) if cpad_p09==2
*3: Entre 200.001 - 300.000
replace Inghogar=rnormal(250000,10000) if cpad_p09==3
*4: Entre 300.001 - 400.000
replace Inghogar=rnormal(350000,10000) if cpad_p09==4
*5: Entre 400.001 - 500.000
replace Inghogar=rnormal(450000,10000) if cpad_p09==5
*6: Entre 500.001 - 600.000
replace Inghogar=rnormal(550000,10000) if cpad_p09==6
*7: Entre 600.001 - 800.000
replace Inghogar=rnormal(700000,10000) if cpad_p09==7
*8: Entre 800.001 - 1.000.000
replace Inghogar=rnormal(900000,10000) if cpad_p09==8
*9: Entre 1.000.001 - 1.200.000
replace Inghogar=rnormal(1100000,10000) if cpad_p09==9
*10: Entre 1.200.001 - 1.400.000
replace Inghogar=rnormal(1300000,10000) if cpad_p09==10
*11: Entre 1.400.001 - 1.600.000
replace Inghogar=rnormal(1500000,10000) if cpad_p09==11
*12: Entre 1.600.001 - 1.800.000
replace Inghogar=rnormal(1700000,10000) if cpad_p09==12
*13: Entre 1.800.001 - 2.000.000
replace Inghogar=rnormal(1900000,10000) if cpad_p09==13
*14: Entre 2.000.001 - 2.200.000
replace Inghogar=rnormal(2100000,10000) if cpad_p09==14
*15. Más 2.200.000
replace Inghogar=rnormal(2300000,10000) if cpad_p09==15
*No se hacen cambios cuando cpad_p09==0 Vacío | cpad_p09==99 Doble Marca


*Cuantil ingresos
xtile Ing10=Inghogar, nq(10)
hist Ing10

*Cantidad Libros
tab cpad_p06
replace cpad_p06=. if cpad_p06==0 | cpad_p06==99
replace cpad_p06=0 if cpad_p06==1
replace cpad_p06=5 if cpad_p06==2
replace cpad_p06=30 if cpad_p06==3
replace cpad_p06=75 if cpad_p06==4
replace cpad_p06=150 if cpad_p06==5

*Internet
tab cpad_p05_02
replace cpad_p05_02=. if cpad_p05_02==0 | cpad_p05_02==99
replace cpad_p05_02=0 if cpad_p05_02==2

*Computador
tab cpad_p05_01
replace cpad_p05_01=. if cpad_p05_01==0 | cpad_p05_01==99
replace cpad_p05_01=0 if cpad_p05_01==2

*Dependencia
tab cod_depe2

gen Municipal=.
replace Municipal=0 if cod_depe2==2 | cod_depe2==3
replace Municipal=1 if cod_depe2==1

gen Parsub=.
replace Parsub=0 if cod_depe2==1 | cod_depe2==3
replace Parsub=1 if cod_depe2==2

gen Particular=.
replace Particular=0 if cod_depe2==1 | cod_depe2==2
replace Particular=1 if cod_depe2==3

rename ptje_lect2m_alu Lenguaje
rename ptje_mate2m_alu Matemáticas
rename cpad_p06 Libros
rename cpad_p05_02 Internet
rename cpad_p05_01 Computador

tabstat Lenguaje Matemáticas Libros Internet Computador Municipal Parsub Particular, by(Ing10)

*****************************************************************************************************
*****************************************************************************************************

*2)
*Por deciles de puntaje, Ingreso Familiar promedio, numro libros acceso a internet, computador y dependencia del establecimiento

xtile Mate10=Matemáticas, nq(10)
tabstat Inghogar Libros Internet Computador Municipal Parsub Particular, by (Mate10)

xtile Leng10=Lenguaje, nq(10)
tabstat Inghogar Libros Internet Computador Municipal Parsub Particular, by (Leng10)

*****************************************************************************************************
*****************************************************************************************************

*3)
*Creación Variable Cantidad por Sala
egen Cantidad=count(idalumno), by (cod_curso)
tabstat Cantidad, by(cod_depe2)

gen Hombre=.
replace Hombre=1 if gen_alu==1
replace Hombre=0 if gen_alu==2

gen Mujer=.
replace Mujer=1 if gen_alu==2
replace Mujer=0 if gen_alu==1

egen qhom=total(Hombre), by(cod_curso)
egen qmuj=total(Mujer), by(cod_curso)

*Creación Variable Cantidad por Sala Mixto
gen Mixto=.
replace Mixto=1 if qmuj!=0 & qhom!=0
replace Mixto=0 if qmuj==0 | qhom==0

*Creación Variable Cantidad por Sala Hombres
gen Solohombres=.
replace Solohombres=1 if qmuj==0 & qhom!=0
replace Solohombres=0 if Mixto==1

*Creación Variable Cantidad por Sala Mujeres
gen Solomujeres=.
replace Solomujeres=1 if qhom==0 & qmuj!=0
replace Solomujeres=0 if Mixto==1

*Existen 117 variables que no entran en ninguna de las tres categorías. Ésto representa 0,7% del total 158.046.

tabstat Cantidad if Mixto==1, by(cod_depe2)
tabstat Cantidad if Solohombres==1, by(cod_depe2)
tabstat Cantidad if Solomujeres==1, by(cod_depe2)

*****************************************************************************************************
*****************************************************************************************************

*4)

*Quintiles en base a:
**Ingresos promedios de los cursos,
**Escolaridad promedio de los padres de los cursos
**Escolaridad promedio de las madres de los cursos.

*Generar ingresos por curso
egen Ingcurso=mean(Inghogar), by (cod_curso)
xtile Ingcur5=Ingcurso, nq(5)


*Creación Escolaridad Padre (Escpad) y Madre (Escmad)
*Escolaridad Padre=cpad_p07
gen Escpad=.
*"0: Vacío
*1: No estudío
replace Escpad=0 if cpad_p07==1
*2: 1° año de educación básica
replace Escpad=1 if cpad_p07==2
*3: 2° año de educación básica
replace Escpad=2 if cpad_p07==3
*4: 3° año de educación básica
replace Escpad=3 if cpad_p07==4
*5: 4° año de educación básica
replace Escpad=4 if cpad_p07==5
*6: 5° año de educación básica
replace Escpad=5 if cpad_p07==6
*7: 6° año de educación básica
replace Escpad=6 if cpad_p07==7
*8: 7° año de educación básica
replace Escpad=7 if cpad_p07==8
*9: 8° año de educación básica
replace Escpad=8 if cpad_p07==9
*10: I año de educación media
replace Escpad=9 if cpad_p07==10
*11: II año de educación media
replace Escpad=10 if cpad_p07==11
*12: III año de educación media
replace Escpad=11 if cpad_p07==12
*13: IV año de educación media cientifico-humanista
replace Escpad=12 if cpad_p07==13
*14: IV o V año de educación media técnico-profesional o vocaional
replace Escpad=13 if cpad_p07==14
*15: Educación incompleta en un centro de FT o IP (SE ASUMIRÁ UN AÑO EXTRA)
replace Escpad=13 if cpad_p07==15
*16: Títulado de un centro de FT o IP (SE ASUMIRÁN DOS AÑOS DE FT)
replace Escpad=14 if cpad_p07==16
*17: Educación incompleta de una universidad (SE ASUMIRÁN DOS AÑOS UNIVERSITARIOS)
replace Escpad=15 if cpad_p07==17
*18: Títulado de una universidad (SE ASUMIRÁN CARRERAS UNIVERSITARIAS DE 5 AÑOS)
replace Escpad=17 if cpad_p07==18
*19: Grado de magister universitario (SE ASUMIRÁN 5 AÑOS UNIVERSITARIOS + 2 MAGISTER)
replace Escpad=19 if cpad_p07==19
*20: Grado de doctor universitario (SE ASUMIRÁN 5 AÑOS UNIVERSITARIOS + 4 MAGISTER)
replace Escpad=21 if cpad_p07==20
*21: No sabe o no recuerda
*99: Doble marca"

*Escolaridad Madre=cpad_p08
gen Escmad=.
*"0: Vacío
*1: No estudío
replace Escmad=0 if cpad_p08==1
*2: 1° año de educación básica
replace Escmad=1 if cpad_p08==2
*3: 2° año de educación básica
replace Escmad=2 if cpad_p08==3
*4: 3° año de educación básica
replace Escmad=3 if cpad_p08==4
*5: 4° año de educación básica
replace Escmad=4 if cpad_p08==5
*6: 5° año de educación básica
replace Escmad=5 if cpad_p08==6
*7: 6° año de educación básica
replace Escmad=6 if cpad_p08==7
*8: 7° año de educación básica
replace Escmad=7 if cpad_p08==8
*9: 8° año de educación básica
replace Escmad=8 if cpad_p08==9
*10: I año de educación media
replace Escmad=9 if cpad_p08==10
*11: II año de educación media
replace Escmad=10 if cpad_p08==11
*12: III año de educación media
replace Escmad=11 if cpad_p08==12
*13: IV año de educación media cientifico-humanista
replace Escmad=12 if cpad_p08==13
*14: IV o V año de educación media técnico-profesional o vocaional
replace Escmad=13 if cpad_p08==14
*15: Educación incompleta en un centro de FT o IP (SE ASUMIRÁ UN AÑO EXTRA)
replace Escmad=13 if cpad_p08==15
*16: Títulado de un centro de FT o IP (SE ASUMIRÁN DOS AÑOS DE FT)
replace Escmad=14 if cpad_p08==16
*17: Educación incompleta de una universidad (SE ASUMIRÁN DOS AÑOS UNIVERSITARIOS)
replace Escmad=15 if cpad_p08==17
*18: Títulado de una universidad (SE ASUMIRÁN CARRERAS UNIVERSITARIAS DE 5 AÑOS)
replace Escmad=17 if cpad_p08==18
*19: Grado de magister universitario (SE ASUMIRÁN 5 AÑOS UNIVERSITARIOS + 2 MAGISTER)
replace Escmad=19 if cpad_p08==19
*20: Grado de doctor universitario (SE ASUMIRÁN 5 AÑOS UNIVERSITARIOS + 4 MAGISTER)
replace Escmad=21 if cpad_p08==20
*21: No sabe o no recuerda
*99: Doble marca"

*Creación Quintiles Escolaridad Padre
xtile Escpad5=Escpad, nq(5)
*Creación Quintiles Escolaridad Madre
xtile Escmad5=Escmad, nq(5)

*Puntajes promedio para cada quintil en las tres especificaciones dadas (Quintiles de Ingreso, escolaridad padre y escolaridad madre)
tabstat Lenguaje Matemáticas, by(Ingcur5)
tabstat Lenguaje Matemáticas, by(Escpad5)
tabstat Lenguaje Matemáticas, by(Escmad5)


*****************************************************************************************************
*****************************************************************************************************

*5)


*Creación expectativas de Escolaridad

*Expectativas padres=cpad_p15
gen expectpad=.
*"0: vacío
*1: No creo que complete 4º año de EM
replace expectpad=10 if cpad_p15==1
*2: 4º año de EM TP
replace expectpad=12 if cpad_p15==2
*3: 4º año de EM HC
replace expectpad=12 if cpad_p15==3
*4: Una carrera en un IP o CFT
replace expectpad=14 if cpad_p15==4
*5: Una carrera en la Universidad
replace expectpad=17 if cpad_p15==5
*6: Estudios de Postgrado
replace expectpad=21 if cpad_p15==6
*99: doble marca"

merge 1:1 idalumno rbd using "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.1\Bases\Simce 2013\2013 2m bbdd estudiante.dta", keepusing(cest_p06)

*Expectativas alumnos=cest_p06
gen expectalu=.
*"0: Vacío
*1:  No creo completar 4° medio
replace expectalu=10 if cest_p06==1
*2:  Completaré 4° medio
replace expectalu=12 if cest_p06==2
*3:  Completaré carrera Tec o Inst Prof
replace expectalu=14 if cest_p06==3
*4:  Completaré carrera universitaria
replace expectalu=17 if cest_p06==4
*99: Doble marca"

replace cpad_p09=. if cpad_p09==0
replace cpad_p09=. if cpad_p09==99
label define TramoIngresolbl 1 "<100.000" 2 "100.001 - 200.000" 3 "200.001 - 300.000" 4 "300.001 - 400.000" 5 "400.001 - 500.000" 6 "500.001 - 600.000" 7 "600.001 - 800.000" 8 "800.001 - 1.000.000" 9 "1.000.001 - 1.200.000" 10 "1.200.001 - 1.400.000" 11 "1.400.001 - 1.600.000" 12 "1.600.001 - 1.800.000" 13 "1.800.001 - 2.000.000" 14 "2.000.001 - 2.200.000" 15 ">2.200.000"
label values cpad_p09 TramoIngresolbl
label list TramoIngresolbl

tabstat expectpad expectalu, by (cpad_p09) stat(mean min max sd)

**************************************************************
*Pregunta 2.2
**************************************************************

clear all
set more off
*2.2.

***************************************************************************
**1)***********************************************************************
***************************************************************************
{
*Evolución Matemáticas y Lenguaje
*Tipo dependencia

matrix A=J(10,5,.)
*Cada dos filas se cambiará el año (Filas serán leng10 mate10 leng11 mate11...)

*2010
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2010\simce4b2010_rbd_publica_final.dta"

sum prom_lect4b_rbd if cod_depe2==1
matrix A[1,1]=r(mean)
sum prom_lect4b_rbd if cod_depe2==2
matrix A[1,2]=r(mean)
sum prom_lect4b_rbd if cod_depe2==3
matrix A[1,3]=r(mean)
matrix A[1,4]=2010
matrix A[1,5]=1
matrix list A

sum prom_mate4b_rbd if cod_depe2==1
matrix A[2,1]=r(mean)
sum prom_mate4b_rbd if cod_depe2==2
matrix A[2,2]=r(mean)
sum prom_mate4b_rbd if cod_depe2==3
matrix A[2,3]=r(mean)
matrix A[2,4]=2010
matrix A[2,5]=2
matrix list A

*2012
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2012\simce4b2012_rbd_publica_final.dta"

sum prom_lect4b_rbd if cod_depe2==1
matrix A[5,1]=r(mean)
sum prom_lect4b_rbd if cod_depe2==2
matrix A[5,2]=r(mean)
sum prom_lect4b_rbd if cod_depe2==3
matrix A[5,3]=r(mean)
matrix A[5,4]=2012
matrix A[5,5]=1
matrix list A

sum prom_mate4b_rbd if cod_depe2==1
matrix A[6,1]=r(mean)
sum prom_mate4b_rbd if cod_depe2==2
matrix A[6,2]=r(mean)
sum prom_mate4b_rbd if cod_depe2==3
matrix A[6,3]=r(mean)
matrix A[6,4]=2012
matrix A[6,5]=2
matrix list A


*2013
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2013\simce4b2013_rbd_publica_final.dta"

sum prom_lect4b_rbd if cod_depe2==1
matrix A[7,1]=r(mean)
sum prom_lect4b_rbd if cod_depe2==2
matrix A[7,2]=r(mean)
sum prom_lect4b_rbd if cod_depe2==3
matrix A[7,3]=r(mean)
matrix A[7,4]=2013
matrix A[7,5]=1
matrix list A

sum prom_mate4b_rbd if cod_depe2==1
matrix A[8,1]=r(mean)
sum prom_mate4b_rbd if cod_depe2==2
matrix A[8,2]=r(mean)
sum prom_mate4b_rbd if cod_depe2==3
matrix A[8,3]=r(mean)
matrix A[8,4]=2013
matrix A[8,5]=2
matrix list A


*2014
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_rbd.dta"

sum prom_lect4b_rbd if cod_depe2==1
matrix A[9,1]=r(mean)
sum prom_lect4b_rbd if cod_depe2==2
matrix A[9,2]=r(mean)
sum prom_lect4b_rbd if cod_depe2==3
matrix A[9,3]=r(mean)
matrix A[9,4]=2014
matrix A[9,5]=1
matrix list A

sum prom_mate4b_rbd if cod_depe2==1
matrix A[10,1]=r(mean)
sum prom_mate4b_rbd if cod_depe2==2
matrix A[10,2]=r(mean)
sum prom_mate4b_rbd if cod_depe2==3
matrix A[10,3]=r(mean)
matrix A[10,4]=2014
matrix A[10,5]=2
matrix list A

*2011
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2011\estab_4to_2011.dta"
gen depen=.
replace depen=1 if ddcia=="MC" | ddcia=="MD"
replace depen=2 if ddcia=="PS"
replace depen=3 if ddcia=="PP"

gen plect=real(PROM_LECT)
gen pmat=real(PROM_MAT)

sum plect if depen==1
matrix A[3,1]=r(mean)
sum plect if depen==2
matrix A[3,2]=r(mean)
sum plect if depen==3
matrix A[3,3]=r(mean)
matrix A[3,4]=2011
matrix A[3,5]=1
matrix list A

sum pmat if depen==1
matrix A[4,1]=r(mean)
sum pmat if depen==2
matrix A[4,2]=r(mean)
sum pmat if depen==3
matrix A[4,3]=r(mean)
matrix A[4,4]=2011
matrix A[4,5]=2
matrix list A

svmat A

rename A1 Municipal
rename A2 Particular_Sub
rename A3 Particular_Pag
rename A4 Agno
rename A5 Ramo

label define Ramolbl 1 "Lenguaje" 2 "Matemáticas"
label values Ramo Ramolbl
label list Ramolbl

graph bar Municipal Particular_Sub Particular_Pag if Ramo==1, over(Agno) title(Puntaje Simce Lenguaje) subtitle(Según dependencia del Establecimiento) ytitle(prom Puntaje Lenguaje) exclude0
graph bar Municipal Particular_Sub Particular_Pag if Ramo==2, over(Agno) title(Puntaje Simce Matemáticas) subtitle(Según dependencia del Establecimiento) ytitle(prom Puntaje Matemáticas) exclude0
}

***************************************************************************
**2)***********************************************************************
***************************************************************************
{
clear all
set more off

matrix A=J(10,4,.)

*2010
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2010\simce4b2010_alu_publica_final.dta"
sum ptje_lect4b_alu if gen_alu==1
matrix A[1,1]=r(mean)
sum ptje_lect4b_alu if gen_alu==2
matrix A[1,2]=r(mean)
matrix A[1,3]=2010
matrix A[1,4]=1
matrix list A

sum ptje_mate4b_alu if gen_alu==1
matrix A[2,1]=r(mean)
sum ptje_mate4b_alu if gen_alu==2
matrix A[2,2]=r(mean)
matrix A[2,3]=2010
matrix A[2,4]=2
matrix list A


*2012
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2012\simce4b2012_alu_publica_final.dta"
sum ptje_lect4b_alu if gen_alu==1
matrix A[5,1]=r(mean)
sum ptje_lect4b_alu if gen_alu==2
matrix A[5,2]=r(mean)
matrix A[5,3]=2012
matrix A[5,4]=1
matrix list A

sum ptje_mate4b_alu if gen_alu==1
matrix A[6,1]=r(mean)
sum ptje_mate4b_alu if gen_alu==2
matrix A[6,2]=r(mean)
matrix A[6,3]=2012
matrix A[6,4]=2
matrix list A


*2013
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2013\alumno_4to_simce_2013.dta"
sum ptje_lect4b_alu if gen_alu==1
matrix A[7,1]=r(mean)
sum ptje_lect4b_alu if gen_alu==2
matrix A[7,2]=r(mean)
matrix A[7,3]=2013
matrix A[7,4]=1
matrix list A

sum ptje_mate4b_alu if gen_alu==1
matrix A[8,1]=r(mean)
sum ptje_mate4b_alu if gen_alu==2
matrix A[8,2]=r(mean)
matrix A[8,3]=2013
matrix A[8,4]=2
matrix list A


*2014
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_alu.dta"
sum ptje_lect if gen_alu==1
matrix A[9,1]=r(mean)
sum ptje_lect if gen_alu==2
matrix A[9,2]=r(mean)
matrix A[9,3]=2014
matrix A[9,4]=1
matrix list A

sum ptje_mate if gen_alu==1
matrix A[10,1]=r(mean)
sum ptje_mate if gen_alu==2
matrix A[10,2]=r(mean)
matrix A[10,3]=2014
matrix A[10,4]=2
matrix list A


*2011
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2011\alumno_4to_simce_2011_mrun.dta"

gen gen_alu=.
replace gen_alu=1 if genero=="M"
replace gen_alu=2 if genero=="F"

sum ptje_lect if gen_alu==1
matrix A[3,1]=r(mean)
sum ptje_lect if gen_alu==2
matrix A[3,2]=r(mean)
matrix A[3,3]=2011
matrix A[3,4]=1
matrix list A

sum ptje_mat if gen_alu==1
matrix A[4,1]=r(mean)
sum ptje_mat if gen_alu==2
matrix A[4,2]=r(mean)
matrix A[4,3]=2011
matrix A[4,4]=2
matrix list A

svmat A

rename A1 Ptje_Hombre
rename A2 Ptje_Mujer
rename A3 Agno
rename A4 Ramo

label define Ramolbl 1 "Lenguaje" 2 "Matemáticas"
label values Ramo Ramolbl
label list Ramolbl

graph bar Ptje_Hombre Ptje_Mujer if Ramo==1, over(Agno) title(Puntaje Simce Lenguaje) subtitle(Por Género) ytitle(prom Puntaje Lenguaje) exclude0
graph bar Ptje_Hombre Ptje_Mujer if Ramo==2, over(Agno) title(Puntaje Simce Matemáticas) subtitle(Por Género) ytitle(prom Puntaje Matemáticas) exclude0
}


***************************************************************************
**3)***********************************************************************
***************************************************************************
{
clear all
set more off

matrix A=J(5,4,.)

*2010
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2010\simce4b2010_rbd_publica_final.dta",
egen matricula=total(nalu_4b_rbd), by(cod_depe2)

sum matricula if cod_depe2==1
matrix A[1,1]=r(mean)
sum matricula if cod_depe2==2
matrix A[1,2]=r(mean)
sum matricula if cod_depe2==3
matrix A[1,3]=r(mean)
matrix A[1,4]=2010
matrix list A

*2012
clear
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2012\simce4b2012_rbd_publica_final.dta"
egen matricula=total(nalu_4b_rbd), by(cod_depe2)

sum matricula if cod_depe2==1
matrix A[3,1]=r(mean)
sum matricula if cod_depe2==2
matrix A[3,2]=r(mean)
sum matricula if cod_depe2==3
matrix A[3,3]=r(mean)
matrix A[3,4]=2012
matrix list A

*2013
clear
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2013\simce4b2013_rbd_publica_final.dta"
egen matricula=total(nalu_4b_rbd), by(cod_depe2)

sum matricula if cod_depe2==1
matrix A[4,1]=r(mean)
sum matricula if cod_depe2==2
matrix A[4,2]=r(mean)
sum matricula if cod_depe2==3
matrix A[4,3]=r(mean)
matrix A[4,4]=2013
matrix list A

*2014
*crear variable
clear
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_rbd.dta"

egen nalu_4b_rbd = rowmax(nalu_lect4b_rbd nalu_mate4b_rbd)
egen matricula=total(nalu_4b_rbd), by(cod_depe2)


sum matricula if cod_depe2==1
matrix A[5,1]=r(mean)
sum matricula if cod_depe2==2
matrix A[5,2]=r(mean)
sum matricula if cod_depe2==3
matrix A[5,3]=r(mean)
matrix A[5,4]=2014
matrix list A


*2011
clear
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2011\estab_4to_2011.dta", clear

gen depen=.
replace depen=1 if ddcia=="MC" | ddcia=="MD"
replace depen=2 if ddcia=="PS"
replace depen=3 if ddcia=="PP"

egen matricula=total(alumnos), by(depen)

sum matricula if depen==1
matrix A[2,1]=r(mean)
sum matricula if depen==2
matrix A[2,2]=r(mean)
sum matricula if depen==3
matrix A[2,3]=r(mean)
matrix A[2,4]=2011
matrix list A

svmat A

rename A1 Municipal
rename A2 Particular_Sub
rename A3 Particular_Pag
rename A4 Agno

graph bar Municipal Particular_Sub Particular_Pag , over(Agno) title(Matrícula Establecimientos) subtitle(Según dependencia del Establecimiento) ytitle(Número de Alumnos) exclude0
}


***************************************************************************
**4)***********************************************************************
***************************************************************************
 {
clear all
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_alu.dta",
merge 1:1 idalumno rbd using "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_cpad.dta", keepusing(cpad_p04 cpad_p05)

gen Educpad=.
replace Educpad=1 if cpad_p04==1 | cpad_p04==2 | cpad_p04==3 | cpad_p04==4 | cpad_p04==5 | cpad_p04==6 | cpad_p04==7
replace Educpad=2 if cpad_p04==8 | cpad_p04==9 | cpad_p04==10 | cpad_p04==11
replace Educpad=3 if cpad_p04==12 | cpad_p04==13 | cpad_p04==14 | cpad_p04==16
replace Educpad=4 if cpad_p04==15
replace Educpad=5 if cpad_p04==17
replace Educpad=6 if cpad_p04==18 | cpad_p04==19

label define Educpadlbl 1 "Básica incompleta" 2 "Básica completa" 3 "Media completa" 4 "CFT o IP completa" 5 "Universitaria completa" 6 "Postgrado"
label values Educpad Educpadlbl
label list Educpadlbl

gen Educmad=.
replace Educmad=1 if cpad_p05==1 | cpad_p05==2 | cpad_p05==3 | cpad_p05==4 | cpad_p05==5 | cpad_p05==6 | cpad_p05==7
replace Educmad=2 if cpad_p05==8 | cpad_p05==9 | cpad_p05==10 | cpad_p05==11
replace Educmad=3 if cpad_p05==12 | cpad_p05==13 | cpad_p05==14 | cpad_p05==16
replace Educmad=4 if cpad_p05==15
replace Educmad=5 if cpad_p05==17
replace Educmad=6 if cpad_p05==18 | cpad_p05==19

label define Educmadlbl 1 "Básica incompleta" 2 "Básica completa" 3 "Media completa" 4 "CFT o IP completa" 5 "Universitaria completa" 6 "Postgrado"
label values Educmad Educmadlbl
label list Educmadlbl

graph pie, over(Educpad) plabel(_all percent, gap(-5))
graph pie, over(Educmad) plabel(_all percent, gap(-5))}


***************************************************************************
**5)***********************************************************************
***************************************************************************
{
clear all
use "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_alu.dta"
*Cálculo promedio de cada alumno
egen medalumno=rowmean(ptje_lect ptje_mate)
merge m:1 rbd using "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS2\2\2.2\Bases PSET2\2014\simce4b2014_rbd.dta"
drop _merge
egen medestab=rowmean(prom_lect4b_rbd prom_mate4b_rbd)
xtile medestab10=medestab , nq(10)
*Se agrega línea de tendencia para ilustrar de mejor manera los resultados del gráfico de dispersión
twoway(scatter medalumno medestab10)(lfit medalumno medestab10)
}

**************************************************************
*Pregunta 3. SIMCE: Corte Transversal
**************************************************************
clear all
set more off
*En primer lugar, juntaremos las bases necesarias
use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_rbd_publica_final.dta", clear
merge 1:m rbd using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_alu_publica_final.dta", nogenerate
merge 1:1 rbd idalumno using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_cest_publica_final.dta", nogenerate
merge 1:1 rbd idalumno using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_cpad_publica_final.dta", nogenerate
merge 1:1 rbd idalumno using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\2013 2m bbdd estudiante.dta", nogenerate
*Tenemos las bases unidas en una sola. 

*1) Caracterización de las víctimas de Bullying.
*Ordenamos el sexo
replace gen_alu=0 if gen_alu==1
replace gen_alu=1 if gen_alu==2

label define Genero 0 "Hombre" 1 "Mujer"
label values gen_alu Genero
label list Genero

*Generaremos variable Bullying (Dummy)
gen bullying=.
replace bullying=0 if cest_p27==3
replace bullying=1 if cest_p27==1 | cest_p27==2

*Renombramos puntajes SIMCE
rename ptje_lect2m_alu leng
rename ptje_mate2m_alu mate

*Generamos promedio SIMCE
gen promedio=(leng+mate)/2

*Dependencia
rename cod_depe2 dependencia
gen municipal=.
replace municipal=0 if dependencia==2 | dependencia==3
replace municipal=1 if dependencia==1
gen subvencionado=.
replace subvencionado=0 if dependencia==1 | dependencia==3
replace subvencionado=1 if dependencia==2
gen particular=.
replace particular=0 if dependencia==1 | dependencia==2
replace particular=1 if dependencia==3

*Ingreso Familiar
gen ingfam=.
replace ingfam=100000 if cpad_p09==1
replace ingfam=150000 if cpad_p09==2
replace ingfam=250000 if cpad_p09==3
replace ingfam=350000 if cpad_p09==4
replace ingfam=450000 if cpad_p09==5
replace ingfam=550000 if cpad_p09==6
replace ingfam=700000 if cpad_p09==7
replace ingfam=900000 if cpad_p09==8
replace ingfam=1100000 if cpad_p09==9
replace ingfam=1300000 if cpad_p09==10
replace ingfam=1500000 if cpad_p09==11
replace ingfam=1700000 if cpad_p09==12
replace ingfam=1900000 if cpad_p09==13
replace ingfam=2100000 if cpad_p09==14
replace ingfam=2500000 if cpad_p09==15

*Estadística descriptiva
summ promedio if bullying==0
summ promedio if bullying==1
ttest promedio, by(bullying)

summ leng if bullying==0
summ leng if bullying==1
ttest leng, by(bullying)

summ mate if bullying==0
summ mate if bullying==1
ttest mate, by(bullying)

summ ingfam if bullying==0
summ ingfam if bullying==1
ttest ingfam, by(bullying)

tab gen_alu if bullying==0
tab gen_alu if bullying==1
ttest gen_alu, by(bullying)

table dependencia, by(bullying)
table municipal, by(bullying)
tab municipal if bullying==0
tab municipal if bullying==1

table subvencionado, by(bullying)
tab subvencionado if bullying==0
tab subvencionado if bullying==1

table particular, by(bullying)
tab particular if bullying==0
tab particular if bullying==1

*2) Estimación por MCO
*Generamos log natural del ingreso
gen lny=.
replace lny=ln(ingfam)
*Regresión
reg leng gen_alu lny dependencia bullying, r

*3) Determinantes del Bullying
*Generamos capital cultural
rename cpad_p06 libros
replace libros=. if libros==0 | libros==99
*Generamos efecto par
rename cod_grupo gse
replace gse=. if gse==0
rename prom_lect2m_rbd promleng
rename prom_mate2m_rbd prommate
gen promest=.
replace promest=(promleng+prommate)/2

*Generamos disciplina
gen disciplina=.
replace cest_p09_01=. if cest_p09_01==0 | cest_p09_01==99
replace cest_p09_03=. if cest_p09_03==0 | cest_p09_03==99
replace cest_p09_05=. if cest_p05_01==0 | cest_p09_05==99
replace cest_p09_06=. if cest_p09_01==0 | cest_p09_06==99
replace cest_p09_07=. if cest_p09_07==0 | cest_p09_07==99 //Ojo
recode cest_p09_07 (4=1) (3=2) (2=3) (1=4)
replace cest_p17_01=. if cest_p17_01==0 | cest_p17_01==99
replace cest_p17_05=. if cest_p17_05==0 | cest_p17_05==99

replace disciplina=(cest_p09_01+cest_p09_03+cest_p09_05+cest_p09_06+cest_p09_07+cest_p17_01+cest_p17_05)/7

*Generamos uso de drogas y alcohol
gen alcohol=.
replace alcohol=0 if cest_p23_02==3
replace alcohol=1 if cest_p23_02==1 | cest_p23_02==2

gen drogas=.
replace drogas=0 if cest_p23_03==3
replace drogas=1 if cest_p23_03==1 | cest_p23_03==2

gen alcdro=.
replace alcdro=alcohol*drogas

*Estimamos usando una probit
probit bullying gen_alu lny dependencia promedio libros promest disciplina alcdro

*4) Nueva estimación MCO
reg leng gen_alu lny dependencia bullying libros promest disciplina alcdro, r

*5) Clusters (Usar dependencia del establecimiento)
reg leng municipal subvencionado particular gen_alu lny bullying libros promest disciplina alcdro, r noconst

**************************************************************
*Pregunta 4. SIMCE: Panel.
**************************************************************

clear all 
set more off

*En primer lugar, juntaremos las bases necesarias
use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_alu_publica_final.dta", clear
merge m:1 rbd using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_rbd_publica_final.dta", nogenerate
merge 1:1 rbd idalumno using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_cest_publica_final.dta", nogenerate
merge 1:1 rbd idalumno using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce2m2013_cpad_publica_final.dta", nogenerate
merge 1:1 rbd idalumno using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\2013 2m bbdd estudiante.dta", nogenerate

**************************************************************
*Hay ruts duplicados, los eliminamos
duplicates r mrun //esto identifica cuántos están repetidos
duplicates drop mrun, force //esto los elimina
**************************************************************
*Creamos las variables necesarias (las mismas de la parte 3)

*Ordenamos el sexo
replace gen_alu=0 if gen_alu==1
replace gen_alu=1 if gen_alu==2

label define Genero 0 "Hombre" 1 "Mujer"
label values gen_alu Genero
label list Genero

*Generaremos variable Bullying (Dummy)
gen bullying=.
replace bullying=0 if cest_p27==3
replace bullying=1 if cest_p27==1 | cest_p27==2
gen bullying2013=bullying

*Renombramos puntajes SIMCE
rename ptje_lect2m_alu leng
rename ptje_mate2m_alu mate
gen leng2013=leng
gen mate2013=mate

*Generamos promedio SIMCE
gen promedio=(leng+mate)/2
gen promedio2013=promedio
*Dependencia
rename cod_depe2 dependencia
gen municipal=.
replace municipal=0 if dependencia==2 | dependencia==3
replace municipal=1 if dependencia==1
gen subvencionado=.
replace subvencionado=0 if dependencia==1 | dependencia==3
replace subvencionado=1 if dependencia==2
gen particular=.
replace particular=0 if dependencia==1 | dependencia==2
replace particular=1 if dependencia==3

*Ingreso Familiar
gen ingfam=.
replace ingfam=100000 if cpad_p09==1
replace ingfam=150000 if cpad_p09==2
replace ingfam=250000 if cpad_p09==3
replace ingfam=350000 if cpad_p09==4
replace ingfam=450000 if cpad_p09==5
replace ingfam=550000 if cpad_p09==6
replace ingfam=700000 if cpad_p09==7
replace ingfam=900000 if cpad_p09==8
replace ingfam=1100000 if cpad_p09==9
replace ingfam=1300000 if cpad_p09==10
replace ingfam=1500000 if cpad_p09==11
replace ingfam=1700000 if cpad_p09==12
replace ingfam=1900000 if cpad_p09==13
replace ingfam=2100000 if cpad_p09==14
replace ingfam=2500000 if cpad_p09==15

gen ingfam2013=ingfam

*Generamos log natural del ingreso
gen lny=.
replace lny=ln(ingfam)

*Generamos capital cultural
rename cpad_p06 libros
replace libros=. if libros==0 | libros==99

*Generamos efecto par
rename cod_grupo gse
replace gse=. if gse==0
rename prom_lect2m_rbd promleng
rename prom_mate2m_rbd prommate
gen promest=.
replace promest=(promleng+prommate)/2

*Generamos disciplina
gen disciplina=.
replace cest_p09_01=. if cest_p09_01==0 | cest_p09_01==99
replace cest_p09_03=. if cest_p09_03==0 | cest_p09_03==99
replace cest_p09_05=. if cest_p05_01==0 | cest_p09_05==99
replace cest_p09_06=. if cest_p09_01==0 | cest_p09_06==99
replace cest_p09_07=. if cest_p09_07==0 | cest_p09_07==99 //Ojo
recode cest_p09_07 (4=1) (3=2) (2=3) (1=4)
replace cest_p17_01=. if cest_p17_01==0 | cest_p17_01==99
replace cest_p17_05=. if cest_p17_05==0 | cest_p17_05==99

replace disciplina=(cest_p09_01+cest_p09_03+cest_p09_05+cest_p09_06+cest_p09_07+cest_p17_01+cest_p17_05)/7

*Generamos uso de drogas y alcohol
gen alc=.
replace alc=0 if cest_p23_02==3
replace alc=1 if cest_p23_02==1 | cest_p23_02==2

gen dro=.
replace dro=0 if cest_p23_03==3
replace dro=1 if cest_p23_03==1 | cest_p23_03==2

gen alcdro=.
replace alcdro=alc*dro
gen alcdro2013=alcdro

**************************************************************
save base2m_2013_9
**************************************************************

*Ahora trabajamos la base de 8 básico 2011
use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce8b2011_alu_publica_final.dta"
merge 1:1 agno idalumno rbd using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce8b2011_cest_publica_final.dta", nogenerate
merge 1:1 agno idalumno rbd using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce8b2011_cpad_publica_final.dta", nogenerate
merge m:1 agno rbd using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce8b2011_rbd_publica_final.dta", nogenerate
merge m:1 agno rbd cod_curso using "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Problem Set 2\simce8b2011_cprof_mate_publica_final.dta", nogenerate
**************************************************************
*Al igual que antes, hay mrun duplicados (observaciones duplicadas)
duplicates drop mrun, force
**************************************************************

*Creamos las variables necesarias
*Ordenamos el sexo
replace gen_alu=0 if gen_alu==1
replace gen_alu=1 if gen_alu==2

label define Genero 0 "Hombre" 1 "Mujer"
label values gen_alu Genero
label list Genero

*Renombramos puntajes SIMCE
rename ptje_lect8b_alu leng
rename ptje_mate8b_alu mate
gen leng2011=leng
gen mate2011=mate

*Generamos promedio SIMCE
gen promedio=(leng+mate)/2
gen promedio2011=promedio

*Dependencia
rename cod_depe2 dependencia
gen municipal=.
replace municipal=0 if dependencia==2 | dependencia==3
replace municipal=1 if dependencia==1
gen subvencionado=.
replace subvencionado=0 if dependencia==1 | dependencia==3
replace subvencionado=1 if dependencia==2
gen particular=.
replace particular=0 if dependencia==1 | dependencia==2
replace particular=1 if dependencia==3

*Ingreso familiar
gen ingfam=.
replace ingfam=100000 if cpad_p10_01==1

replace ingfam=100000 if cpad_p10_01==1
replace ingfam=150000 if cpad_p10_02==1
replace ingfam=250000 if cpad_p10_03==1
replace ingfam=350000 if cpad_p10_04==1
replace ingfam=450000 if cpad_p10_05==1
replace ingfam=550000 if cpad_p10_06==1
replace ingfam=700000 if cpad_p10_07==1
replace ingfam=900000 if cpad_p10_08==1
replace ingfam=1100000 if cpad_p10_09==1
replace ingfam=1300000 if cpad_p10_10==1
replace ingfam=1500000 if cpad_p10_11==1
replace ingfam=1700000 if cpad_p10_12==1
replace ingfam=1900000 if cpad_p10_13==1
replace ingfam=2100000 if cpad_p10_14==1
replace ingfam=2500000 if cpad_p10_15==1

gen ingfam2011=ingfam

*Generamos log natural del ingreso
gen lny=.
replace lny=ln(ingfam)

*Generamos capital cultural
rename cpad_p07 libros
replace libros=. if libros==0 | libros==99

*Generamos efecto par
rename cod_grupo gse
replace gse=. if gse==0
rename prom_lect8b_rbd promleng
rename prom_mate8b_rbd prommate
gen promest=.
replace promest=(promleng+prommate)/2

*Disciplina
replace cest_p12_01=. if cest_p12_01==0 | cest_p12_01==99
recode cest_p12_01 (4=1) (3=2) (2=3) (1=4)
replace cest_p12_02=. if cest_p12_02==0 | cest_p12_02==99
recode cest_p12_02 (4=1) (3=2) (2=3) (1=4)
replace cest_p12_04=. if cest_p12_04==0 | cest_p12_04==99
replace cest_p12_05=. if cest_p12_05==0 | cest_p12_05==99
replace cest_p12_06=. if cest_p12_06==0 | cest_p12_06==99
replace cest_p12_07=. if cest_p12_07==0 | cest_p12_07==99
recode cest_p12_07 (4=1) (3=2) (2=3) (1=4)
replace cest_p12_08=. if cest_p12_08==0 | cest_p12_08==99
recode cest_p12_08 (4=1) (3=2) (2=3) (1=4)

gen disciplina=(cest_p12_01+cest_p12_02+cest_p12_04+cest_p12_05+cest_p12_06+cest_p12_07+cest_p12_08)/7

*Uso drogas y alcohol
rename cprof_p27_02 alc
replace alc=. if alc==0 | alc==3 | alc==99
recode alc (2=0)

rename cprof_p27_03 dro 
replace dro=. if dro==0 | dro==3 | dro==99
recode dro (2=0)

gen alcdro=alc*dro
gen alcdro2011=alcdro

*Bullying
gen bullying=.
replace bullying=0 if cpad_p29_04==1 | cpad_p29_04==2
replace bullying=1 if cpad_p29_04==3 | cpad_p29_04==4

gen bullying2011=bullying

save base8b_2011_9
*Append
use base8b_2011_9
append using base2m_2013_9

**************************************************************
*Tenemos las bases unidas en una sola.
**************************************************************

*Reconocemos a la base como un panel 
xtset mrun agno
**************************************************************
*Ahora avanzamos

*1) Estimación Pooled
gen g1= (agno==2011)
gen g1_lny=g1*lny
gen g1_dependencia=g1*dependencia
gen g1_bullying=g1*bullying
bys mrun: egen prom2011=total(promedio2011)
reg promedio2013 gen_alu lny dependencia bullying g1_lny g1_dependencia g1_bullying prom2011, r

*2) EF y EA
*Efectos fijos
xtreg leng gen_alu lny dependencia bullying,fe i(mrun)
estimates store fixed
*Efectos aleatorios
xtreg leng gen_alu lny dependencia bullying,re i(mrun)
*Test de Hausman
hausman fixed ., sig

*3) Efectos Fijos a nivel de individuo
xtreg leng gen_alu lny dependencia bullying,fe i(mrun)

*4) Efectos Fijos a nivel de establecimiento
xtreg leng gen_alu lny dependencia bullying,fe i(rbd)

*5) Estimaciones
*Para el año 2011
reg leng gen_alu lny dependencia bullying if agno==2011

*Aplicando primeras diferencias
**Hacemos las diferencias de las variables
bys mrun: egen lenguaje2013=total(leng2013)
bys mrun: egen lenguaje2011=total(leng2011)
gen dleng=lenguaje2013-lenguaje2011

bys mrun: egen b2011=total(bullying2011)
bys mrun: egen b2013=total(bullying2013)
gen dbullying=b2013-b2011

bys mrun: egen ing2011=total(ingfam2011)
bys mrun: egen ing2013=total(ingfam2013)
gen dingfam=ing2013-ing2011

bys mrun: egen prome2011=total(promedio2011)
bys mrun: egen prome2013=total(promedio2013) 
gen dpromest=prome2013-prome2011

bys mrun: egen alcdroga2011=total(alcdro2011)
bys mrun: egen alcdroga2013=total(alcdro2013)
gen dalcdro=alcdroga2013-alcdroga2011

*Estimación en primeras diferencias
reg dleng dingfam dbullying, r

*6) Nueva regresión
*a
reg dleng dingfam dbullying lenguaje2011, r
*b
reg dleng dingfam dbullying lenguaje2011 gen_alu dependencia dalcdro dpromest, r
*Se asume que capital cultural y disciplina son constantes en el tiempo

*Fin :) 
