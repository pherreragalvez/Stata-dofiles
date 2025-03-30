********************************************************
*********************DO CASEN - CMP*********************
***********************EDUCACIÓN************************
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
use "Casen 2017.05.dta"

tab e7_subarea [w=expr]
tab e7_cod_area [w=expr]

************************************Comportamiento de las personas y estudiantes
gen educaux=.
replace educaux=0 if educ==0
replace educaux=1 if (educ==1|educ==2|educ==3|educ==4)
replace educaux=2 if (educ==5|educ==6)
replace educaux=3 if (educ==7|educ==8|educ==9|educ==10|educ==11|educ==12)
label define lbleducaux 0 "Sin Educ. Formal" 1 "Colegio Incompleto" 2 "4° Medio" 3 "Profesional"
label values educaux lbleducaux
*NIVEL EDUCACIONAL
***
tab educaux dytot if edad>=25 [w=expr], col
tab educaux ygroups3 if edad>=25 [w=expr], col

*ASISTENCIA NETA EDUC. SUPERIOR (numerador son estudiantes de el tramo etario indicado 18-24)
tabstat asiste [w=expr] if edad>17 & edad<=24 & (e6a==12|e6a==14) & asiste==1, stat (sum) by (dytot) format(%12.0f)save
matrix a1= r(Stat1) \ r(Stat2) \ r(Stat3) \ r(Stat4) \ r(Stat5) \ r(Stat6) \ r(Stat7) \ r(Stat8) \ r(Stat9) \ r(Stat10)
gen pob1824=0
replace pob1824=1 if edad>17 & edad<=24
tabstat pob1824 [w=expr] if edad>17 & edad<=24, stat (sum) by (dytot) format(%12.0f)save
matrix a2= r(Stat1) \ r(Stat2) \ r(Stat3) \ r(Stat4) \ r(Stat5) \ r(Stat6) \ r(Stat7) \ r(Stat8) \ r(Stat9) \ r(Stat10)
matrix a3= J(10,1,0)
forvalues i=1/10 {
forvalues j=1/1 {
matrix a3 [`i',`j'] = a1[`i',`j']/a2[`i',`j']
}
}
matrix a3=a3*100
***
matrix list a3

*RAZÓN DE NO ASISTENCIA

***********************************************Caracterización de la institución
*NIVEL EDUCACIONAL INSTITUCIÓN (excluyendo Ed Superior FFAA y NS. i.e. menos del 2%)
tab e10 dytot [w=expr] if e9depen>=7 & e9depen<=10 & e10<13, col

**********************Financiamiento educación (beneficios que ofrece el Estado)
*FINANCIAMIENTO
**GRATUIDAD
***
tab e17 dytot [w=expr], col

gen gratuidad=.
replace gratuidad=0 if (e6a==12|e6a==14) & asiste==1
replace gratuidad=1 if e17==2
***
tab gratuidad dytot [w=expr], col
*tab dytot if gratuidad==1 [w=expr]

***
tab e10 gratuidad [w=expr] if e9depen>=7 & e9depen<=10 & e10<13, col

***
tab e10 dytot [w=expr] if e9depen>=7 & e9depen<=10 & e10<13, col
***
tab e10 dytot [w=expr] if e9depen>=7 & e9depen<=10 & e10<13 & gratuidad==1, row

**CRÉDITOS (para los no gratuidad)
tab e19_1 [w=expr]
gen credsuperior=.
replace credsuperior=0 if e19_1==8
replace credsuperior=1 if e19_1==2
replace credsuperior=2 if e19_1==3
replace credsuperior=3 if e19_1==1 | e19_1==4 | e19_1==5 | e19_1==6 | e19_1==7
replace credsuperior=9 if e19_1==9
label define lblcred 0 "Sin crédito" 1 "Crédito CORFO" 2 "CAE" 3 "Otro crédito" 9 "NS/NR"
label values credsuperior lblcred
tab credsuperior dytot [w=expr] if e9depen>=7 & e9depen<=10 & e10<13, col

*CREAr uno que tenga créditos y gratuidad (las dos últimas variables)


cd "$data"
save "Casen 2017.06.dta", replace
