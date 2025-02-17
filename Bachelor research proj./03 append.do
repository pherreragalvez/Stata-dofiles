clear all
global main "C:\Pablo\Documentos\FEN\00 20191 Otoño\Métodos Cuantitativos 4\00 Paper"
global dofiles "${main}/dofiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

*APPEND

clear all
cd "$data"
use "casen hogares 2015.dta"
append using "casen hogares 2017.dta"

*Ajustes Previos

*Se eliminan viviendas sin información de enfermedades
drop if bronq==.

*Creación Decil de Ingreso por año. Luego se agrupan todos los hogares en una variable decil
xtile _decil = y_auton_hog_pc if anio==2015, nquantiles(10)
xtile __decil = y_auton_hog_pc if anio==2017, nquantiles(10)
*Decil de Ingresos para toda la BBDD
replace _decil=__decil if anio==2017
drop __decil

*Sistema de calefacción - Se mantienen sólo aquellos sistemas en base a [gas], [parafina o petróleo] y [leña y derivados]
replace tipo_calefac = 0 if tipo_calefac > 3

*Tipo Vivienda
tab tipo_viv
replace tipo_viv = 0 if tipo_viv > 5
replace tipo_viv = 4 if tipo_viv == 5
tab tipo_viv

*Variables PSCORE

*********************************
tab viv_sit
gen v_sit=.
*1.propia
replace v_sit=1 if viv_sit>=1 & viv_sit<=4
*2.arriendo c/ contrato
replace v_sit=2 if viv_sit==5
*3.arriendo s/ contrato
replace v_sit=3 if viv_sit==6
*4.cedida
replace v_sit=4 if viv_sit==7 | viv_sit==8
*0.no regular
replace v_sit=0 if viv_sit>8
drop viv_sit

*********************************
tab viv_compra_c_subsidio
gen v_sub=.
*1. con subsidio
replace v_sub=1 if viv_compra_c_subsidio==1 | viv_compra_c_subsidio==2
*0. sin subsidio
replace v_sub=0 if v_sub==.
drop viv_compra_c_subsidio

*********************************
tab viv_qhogares
gen v_qhogares=.
*1. mayor a 1
replace v_qhogares=1 if viv_qhogares>1
*0. menor o igual a 1
replace v_qhogares=0 if v_qhogares==.
drop viv_qhogares

*********************************
tab viv_razon_compartir
gen v_razoncompartir=.
*1. económicas
replace v_razoncompartir=1 if viv_razon_compartir==2
*2.
replace v_razoncompartir=0 if v_razoncompartir==.
drop viv_razon_compartir

tab v_sit
tab v_sub
tab v_qhogares
tab v_razoncompartir

save "casen hogares 2015-2017.dta", replace
