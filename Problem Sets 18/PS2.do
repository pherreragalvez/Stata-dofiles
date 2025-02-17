*3. Paper 1. Capital Humano.

*b)

clear all
set more off
import delimited "C:\Pablo\Documentos\FEN\0 20181 Otoño\Microeconomía III\Problems Set\2\3\The impact of disease\The impact of disease\ner9212_chonly.csv"

duplicates report indiv
*Dado que existen observaciones xt duplicadas, se eliminan estos casos
sort year indiv
gen suma=indiv-indiv[_n-1]
drop if suma==0

*Se define la base como panel
xtset indiv year

*Se transforma edu_years a una variable numérica
drop if edu_years=="NA"
destring edu_years, generate(escolaridad)
hist escolaridad

*Se genera una variable numérica de name_2(información distrito) para controlar en la regresión
sort name_2
encode name_2, generate(districtcode)

*Reg sin interactivas Columna 1a
xtreg escolaridad female cohcase86_05 cohcase86_612 cohcase86_1320 districtcode year_birth, fe

matrix Q=J(8,2,.)

matrix Q[1,1]=_b[female]
matrix Q[2,1]=_b[cohcase86_05]
matrix Q[4,1]=_b[cohcase86_612]
matrix Q[6,1]=_b[cohcase86_1320]
matrix Q[8,1]=_b[_cons]

matrix list Q

*Generamos las variables interactivas para controlar por ellas también
gen fem_05=.
replace fem_05=cohcase86_05*female

gen fem_612=.
replace fem_612=cohcase86_612*female

gen fem_1320=.
replace fem_1320=cohcase86_1320*female

*Reg con interactivas Columna 1b
xtreg escolaridad female cohcase86_05 fem_05 cohcase86_612 fem_612 cohcase86_1320 fem_1320 districtcode year year_birth, fe

matrix Q[1,2]=_b[female]
matrix Q[2,2]=_b[cohcase86_05]
matrix Q[3,2]=_b[fem_05]
matrix Q[4,2]=_b[cohcase86_612]
matrix Q[5,2]=_b[fem_612]
matrix Q[6,2]=_b[cohcase86_1320]
matrix Q[7,2]=_b[fem_1320]
matrix Q[8,2]=_b[_cons]

matrix rownames Q = Female Mening_0-5 xfemale Mening_6-12 xfemale Mening_13-20 xfemale Constant
matrix colnames Q = (1a) (1b)

matrix list Q

*c)

*Reg sin interactivas Columna 1a
xtreg escolaridad female cohcase90_05 cohcase90_612 cohcase90_1320 districtcode year_birth, fe

matrix T=J(8,2,.)

matrix T[1,1]=_b[female]
matrix T[2,1]=_b[cohcase90_05]
matrix T[4,1]=_b[cohcase90_612]
matrix T[6,1]=_b[cohcase90_1320]
matrix T[8,1]=_b[_cons]

matrix list T

*Generamos las variables interactivas para controlar por ellas también
gen fem90_05=.
replace fem90_05=cohcase90_05*female

gen fem90_612=.
replace fem90_612=cohcase90_612*female

gen fem90_1320=.
replace fem90_1320=cohcase90_1320*female

*Reg con interactivas Columna 1b
xtreg escolaridad female cohcase90_05 fem90_05 cohcase90_612 fem90_612 cohcase90_1320 fem90_1320 districtcode year year_birth, fe

matrix T[1,2]=_b[female]
matrix T[2,2]=_b[cohcase90_05]
matrix T[3,2]=_b[fem90_05]
matrix T[4,2]=_b[cohcase90_612]
matrix T[5,2]=_b[fem90_612]
matrix T[6,2]=_b[cohcase90_1320]
matrix T[7,2]=_b[fem90_1320]
matrix T[8,2]=_b[_cons]

matrix rownames T = Female Mening_0-5 xfemale Mening_6-12 xfemale Mening_13-20 xfemale Constant
matrix colnames T = (1a) (1b)

matrix list T
