********************************************************
*********************DO CASEN - CMP*********************
***********************VIVIENDA*************************
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
use "Casen 2017.04.dta"

*Estado de conservación de muros, piso y techo
gen aux1=1 if v3==3
replace aux1=0 if v3!=3
gen aux2=1 if v5==3
replace aux2=0 if v5!=3
gen aux3=1 if v7==3
replace aux3=0 if v7!=3
gen estadoviv=aux1+aux2+aux3
drop aux1 aux2 aux3
gen estadoviv2=.
replace estadoviv2=0 if estadoviv==0
replace estadoviv2=1 if estadoviv==1 | estadoviv==2 | estadoviv==3

*************
*tab estadoviv
*TABLA 1
tab estadoviv ygroups3 [w=expr] if pco1==1, col
tab estadoviv2 ygroups3 [w=expr] if pco1==1, col
tab estadoviv2 dytot [w=expr] if pco1==1, col
*tab dytot [w=expr] if pco1==1 & estadoviv2==1

*v9. propiedad del sitio
*v10. situación titulo del sitio

*Metros cuadrados vivienda
*tab v12
gen aux_m2=.
*Menos de 30 m2
replace aux_m2=25 if v12==1
*De 30 a 40 m2
replace aux_m2=35 if v12==2
*De 41 a 60 m2
replace aux_m2=50 if v12==3
*De 61 a 100 m2
replace aux_m2=80 if v12==4
*De 101 a 150 m2
replace aux_m2=125 if v12==5
*M�s de 150 m2
replace aux_m2=150 if v12==6
gen rat_m2numper=.
*replace rat_m2numper=aux_m2/numper
replace rat_m2numper=aux_m2/(numper*tot_hog)

*TABLA 2
*tabstat rat_m2numper if pco1==1 [w=expr], by(ygroups3) stat(N mean p5 p50 p95) format(%-12.1fc)
*bys ygroups3: summarize rat_m2numper if pco1==1 [w=expr], d

tabstat rat_m2numper [w=expr] if pco1==1, stat(mean p50 p5 p95) by(ygroups3) format(%12.0f)
tabstat rat_m2numper [w=expr] if pco1==1, stat(mean p50 p5 p95) by(dytot) format(%12.0f)

*Situación del uso de la vivienda
*tab v13
gen viv_sit=.
replace viv_sit=1 if v13==1 | v13==3
replace viv_sit=2 if v13==2 | v13==4
replace viv_sit=3 if v13==5 | v13==6
replace viv_sit=4 if v13==7 | v13==8
replace viv_sit=5 if v13==9 | v13==10 | v13==11 | v13==99
label define lbl_viv_sit 1"Propia Pagada" 2"Propia Pagándose" 3"Arrendada" 4"Cedida" 5"Otro"
label values viv_sit lbl_viv_sit

*TABLA 3.A.
tab viv_sit ygroups3 [w=expr] if pco1==1, col
tab viv_sit dytot [w=expr] if pco1==1, col

gen viv_sit2=viv_sit
replace viv_sit2=1 if viv_sit2==2
label define lbl_viv_sit2 1"Propia" 3"Arrendada" 4"Cedida" 5"Otro"
label values viv_sit2 lbl_viv_sit2

*TABLA 3.B.
tab viv_sit2 ygroups3 [w=expr] if pco1==1, col
tab viv_sit2 dytot [w=expr] if pco1==1, col

*Compra de vivienda con subsidio del estado (para propietarios de la pregunta anterior)
*tab v15
*TABLA 4
*tab v15 ygroups3 [w=expr] if pco1==1, col
label list v15
tab v15 dytot [w=expr] if pco1==1, col

*Compra de vivienda con crédito (para viviendas propias compradas con recursos propios (sea deuda o no))
*tab v16
*TABLA 5
*tab v16 ygroups3 [w=expr] if pco1==1, col
label list v16
tab v16 dytot [w=expr] if pco1==1, col

*Precio de arriendo por vivienda o vivienda similar
sum v19
*TABLA 6
tabstat v19 if pco1==1 [w=expr], by(ygroups3) stat(n mean p5 p50 p95) format(%12.0fc)
tabstat v19 if pco1==1 [w=expr], by(dytot) stat(n mean p5 p50 p95) format(%12.0fc)

*	matrix tseis=J(7,5,.)
*	forvalues i = 1(1)6 {
*	summarize v19 if pco1==1 & ygroups3==`i' [w=expr], d
*	matrix tseis[`i',1]=round(r(sum_w),0.01)
*	matrix tseis[`i',2]=round(r(mean),1)
*	matrix tseis[`i',3]=round(r(p5),0.01)
*	matrix tseis[`i',4]=round(r(p50),0.01)
*	matrix tseis[`i',5]=round(r(p95),0.01)
*	}
*	summarize v19 if pco1==1 [w=expr], d
*	matrix tseis[7,1]=round(r(sum_w),0.01)
*	matrix tseis[7,2]=round(r(mean),1)
*	matrix tseis[7,3]=round(r(p5),0.01)
*	matrix tseis[7,4]=round(r(p50),0.01)
*	matrix tseis[7,5]=round(r(p95),0.01)
*	matrix colnames tseis = N Media pc5 Mediana pc95
*	matrix rownames tseis = Pobre Vulnerable Media_baja Media_mediana Media_alta Altos_ingresos Total
*	matrix list tseis

*Origen del agua de la vivienda
*tab v20

*Mejoras o transformaciones
*tab v25 [w=expr]
gen mejorasviv=.
replace mejorasviv=1 if v25<=6
replace mejorasviv=0 if v25==7
replace mejorasviv=9 if v25==9
label define lbl_mejorasviv 1"Sí" 0"No" 9"NS/NR"
label values mejorasviv lbl_mejorasviv
*TABLA 7
tab mejorasviv ygroups3 [w=expr] if pco1==1, col
tab mejorasviv dytot [w=expr] if pco1==1, col

*Si realiza mejoras o transformaciones a la vivienda, cómo las financia ppalmente?
*TABLA 8
tab v26 ygroups3 [w=expr] if pco1==1, col
tab v26 dytot [w=expr] if pco1==1, col

*Q piezas para dormitorio y baño
*tab v27a
*tab v27b

*Q hogares en vivienda
*tab v28
gen qhogares=.
replace qhogares=v28 if v28<=3
replace qhogares=3 if v28>3 & v28<=10
label define lbl_qhog 3"3+"
label values qhogares lbl_qhog
*TABLA 9
tab qhogares ygroups3 [w=expr] if pco1==1 & hogar==1, col
tab qhogares dytot [w=expr] if pco1==1 & hogar==1, col

*Razón para compartir vivienda c otro hogar
*tab v31
gen razoncompartir=.
replace razoncompartir=1 if v31==1
replace razoncompartir=2 if v31==2 | v31==3
replace razoncompartir=3 if v31==4 | v31==5
replace razoncompartir=4 if v31==6
replace razoncompartir=5 if v31==7 | v31==8
replace razoncompartir=6 if v31==9
replace razoncompartir=99 if v31==99
label define lbl_razoncompartir 1"Cuidado familiar(es)" 2"Motivos económicos" 3"Razones laborales o de estudio" 4"Emergencia" 5"Preferencia o costumbre" 6"Otra" 99"NS/NR"
label values razoncompartir lbl_razoncompartir
*tab razoncompartir
*TABLA 10
tab razoncompartir ygroups3 [w=expr] if pco1==1 & hogar==1, col
tab razoncompartir dytot [w=expr] if pco1==1 & hogar==1, col

*Hace algo para vivir en una vivienda exclusivamente para su hogar?
tab v32
gen buscaviv_exclusiva=.
replace buscaviv_exclusiva=1 if v32==1 | v32==3 | v32==4
replace buscaviv_exclusiva=2 if v32==2
replace buscaviv_exclusiva=3 if v32==5
replace buscaviv_exclusiva=4 if v32==6
replace buscaviv_exclusiva=5 if v32==7
replace buscaviv_exclusiva=6 if v32==8
replace buscaviv_exclusiva=99 if v32==9
label define lbl_buscaviv_exclusiva 1"Postula a subsidio de compra, arriendo o construcción" 2"Busca vivienda para arrendar" 3"Participa en comité" 4"Ahorra o solicita crédito para comprar" 5"Otra cosa" 6"No hace nada" 99"NS/NR"
label values buscaviv_exclusiva lbl_buscaviv_exclusiva
*TABLA POCO INFORMATIVA
tab buscaviv_exclusiva

*Q de nucleos en este hogar
*tab v33
*Razón para compartir vivienda c otro nucleo del hogar
*tab v34

cd "$data"
save "Casen 2017.05.dta", replace

**********************PENDIENTES*************************************************

*Cercanía con distintos servicios públicos (<2.5 km)
*Servicio transporte
tab v37a
*Centro educacional
tab v37b
*Centro salud
tab v37c
*Supermercado, almacén, feria
tab v37d
*Cajero automático
tab v37e
*Equipamiento deportivo
tab v37f
*Áreas verdes
tab v37g
*Equipamiento comunitario
tab v37h
*Farmacia
tab v37i

