clear all
global main "C:\Pablo\Documentos\FEN\00 20191 Otoño\Métodos Cuantitativos 4\00 Paper"
global dofiles "${main}/dofiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

* V A R I A B L E S
*id_vivienda folio anio region bronq index_vivienda
*y_auton_hog_pc numper med_edad prop_fem propmenor sexo_jh
*tipo_viv tipo_calefac
*sist_previs hh_d_mal hh_d_prevs centro_salud rural

* folio anio region bronq index_vivienda y_auton_hog_pc numper med_edad prop_fem propmenor sexo_jh edad_jh esc_jh tipo_viv tipo_calefac sist_previs hh_d_mal hh_d_prevs centro_salud rural viv_sit viv_compra_c_subsidio viv_qhogares viv_razon_compartir


*BASE LISTA
clear all
cd "$data"
use "casen hogares 2015-2017.dta"

*Estadística Descriptiva

*Se crea la variable porcentaje_bronq para ofrecer valores en % en la estadística descriptiva.
gen porcentaje_bronq=bronq*100

*ASMA BRONQUIAL POR DECIL
*tabstat bronq, by(_decil)
matrix A=J(10,2,.)
forvalues i = 1(1)10 {
summarize porcentaje_bronq if _decil==`i', d
matrix A[`i',1]=round(r(mean),0.01)
matrix A[`i',2]=round(r(sd),0.01)
}
matrix colnames A = Porcentaje Desv_Estándar
matrix rownames A = 1 2 3 4 5 6 7 8 9 10
matrix list A

*ESTADÍSTICA DESCRIPTIVA INDEX_ SI INDEX_ NO
matrix D=J(8,4,.)

*Tratamiento
ttest porcentaje_bronq, by(index_vivienda)
matrix D[1,1]=round(r(mu_1),0.01)
matrix D[1,2]=round(r(mu_2),0.01)
matrix D[1,3]=round(r(mu_1),0.01)-round(r(mu_2),0.01)
matrix D[1,4]=round(r(t),0.01)

*Ingreso
ttest y_auton_hog_pc, by(index_vivienda)
matrix D[2,1]=round(r(mu_1),1)
matrix D[2,2]=round(r(mu_2),1)
matrix D[2,3]=round(r(mu_1),1)-round(r(mu_2),1)
matrix D[2,4]=round(r(t),0.01)

*Numper
ttest numper, by(index_vivienda)
matrix D[3,1]=round(r(mu_1),0.01)
matrix D[3,2]=round(r(mu_2),0.01)
matrix D[3,3]=round(r(mu_1),0.01)-round(r(mu_2),0.01)
matrix D[3,4]=round(r(t),0.01)

*Sexo jh
ttest sexo_jh, by(index_vivienda)
matrix D[4,1]=round(r(mu_1),0.0001)*100
matrix D[4,2]=round(r(mu_2),0.0001)*100
matrix D[4,3]=round(r(mu_1),0.0001)*100-round(r(mu_2),0.0001)*100
matrix D[4,4]=round(r(t),0.01)

*Edad
ttest edad_jh, by(index_vivienda)
matrix D[5,1]=round(r(mu_1),0.01)
matrix D[5,2]=round(r(mu_2),0.01)
matrix D[5,3]=round(r(mu_1),0.01)-round(r(mu_2),0.01)
matrix D[5,4]=round(r(t),0.01)

*Esc
ttest esc_jh, by(index_vivienda)
matrix D[6,1]=round(r(mu_1),0.01)
matrix D[6,2]=round(r(mu_2),0.01)
matrix D[6,3]=round(r(mu_1),0.01)-round(r(mu_2),0.01)
matrix D[6,4]=round(r(t),0.01)

*N
matrix D[7,1]=r(N_1)
matrix D[7,2]=r(N_2)
*Porcentaje
matrix D[8,1]=round(r(N_1)/(r(N_1)+r(N_2))*100,0.1)
matrix D[8,2]=round(r(N_2)/(r(N_1)+r(N_2))*100,0.1)

matrix colnames D = No_Precario Precario Diferencia T-Test
matrix rownames D = Tratamiento Ingreso Numper Sexo_jh Edad_jh Esc_jh N %
matrix list D

**GRÁFICO ASMA BRONQUIAL POR DECIL
matrix list A
svmat A
gen A3 = _n if _n <=10
scatter A1 A3, xtitle(Decil de Ingreso) ytitle(% de Hogares con Tratamiento) title(Porcentaje de Tratamientos por Asma Bronquial) subtitle(según decil de Ingresos del Hogar) msize(large)
cd "$figures"
graph export "graf1.png", as(png) replace
drop A1 A2 A3

**TTEST BRONQ vs. NO BRONQ
matrix list D
cd "$tables"
putexcel set "matrixA.xlsx", sheet("A") replace
putexcel A1=matrix(A)

cd "$tables"
putexcel set "matrixD.xlsx", sheet("D") replace
putexcel A1=matrix(D)

*ÍNDICE POR DECIL
*tabstat bronq, by(_decil)
matrix E=J(10,2,.)
forvalues i = 1(1)10 {
summarize index_vivienda if _decil==`i', d
matrix E[`i',1]=round(r(mean),0.01)
matrix E[`i',2]=round(r(sd),0.01)
}
matrix colnames E = Índice Desv_Estándar
matrix rownames E = 1 2 3 4 5 6 7 8 9 10
matrix list E

svmat E
replace E1=E1*100
replace E2=E2*100
gen E3 = _n if _n <=10
cd "$figures"
scatter E1 E3, xtitle(Decil de Ingreso) ytitle(% de Hogares con Vivienda Precaria) title(Hogares con Vivienda Precaria) subtitle(según decil de Ingresos del Hogar) msize(large)
graph export "graf2.png", as(png) replace
drop E1 E2 E3
