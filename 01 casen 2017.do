clear all
global main "C:\Pablo\Documentos\FEN\00 20191 Otoño\Métodos Cuantitativos 4\00 Paper"
global dofiles "${main}/dofiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

*Análisis Casen 17
cd "$data"
use "Casen 2017.dta", clear
gen anio=2017

*CREACIÓN DE TODAS LAS VARIABLES POR VIVIENDA ANTES DE MANTENER UNA OBS POR VIV

*Dummy si tuvo asma bronquial en los últimos 12 meses, valor 1. Sin información es missing value.
gen bronq=.
replace bronq=0 if s28<=22 & s28>=1
replace bronq=1 if s28==9

*Si alguien en el hogar tuvo bronq=1, todos toman 1. Si nadie bronq=1, todos tienen cero.
bys folio : egen bronq2=max(bronq)
drop bronq
rename bronq2 bronq
tab bronq

*Proporción menor a 18
bys folio : egen _menor=count(o) if edad <18
replace _menor=0 if _menor==.
bys folio : egen den_menor=count(o)
gen propmenor = _menor/den_menor
drop _menor den_menor

*Mediana Edad por Hogar
bys folio : egen med_edad=median(edad)
tab med_edad

*Género jefe(a) vivienda 0=hombre; 1=mujer
gen sexo_jh = sexo if pco1==1
bys folio : egen sexo_jh2=max(sexo_jh)
drop sexo_jh
rename sexo_jh2 sexo_jh
replace sexo_jh = sexo_jh - 1
tab sexo_jh

**************************************************

*Edad jefe(a) vivienda
gen edad_jh = edad if pco1==1
bys folio : egen edad_jh2=max(edad_jh)
drop edad_jh
rename edad_jh2 edad_jh
tab edad_jh

*Escolaridad jefe(a) vivienda 0=hombre; 1=mujer
gen esc_jh = esc if pco1==1
bys folio : egen esc_jh2=max(esc_jh)
drop esc_jh
rename esc_jh2 esc_jh
tab esc_jh

**************************************************

*Prop Femenino por Hogar
tab sexo
gen fem=.
replace fem=1 if sexo==2
replace fem=0 if sexo==1
bys folio : egen prop_fem=mean(fem)
tab prop_fem

*Rural
gen rural=0
replace rural=1 if zona==2

*VARIABLES P SCORE
tab v13
tab v15
tab v28
tab v31

rename v13 viv_sit
rename v15 viv_compra_c_subsidio
rename v28 viv_qhogares
rename v31 viv_razon_compartir

*viv_sit viv_compra_c_subsidio viv_qhogares viv_razon_compartir
*label list v13 v15 v28 v31

replace viv_sit = 0 if viv_sit > 11 | viv_sit == .
replace viv_compra_c_subsidio = 0 if viv_compra_c_subsidio > 4 | viv_compra_c_subsidio == .
replace viv_qhogares = 0 if viv_qhogares > 15 | viv_qhogares == .
replace viv_razon_compartir = 0 if viv_razon_compartir > 15 | viv_razon_compartir == .

*Ingreso total del hogar corregido
*ytotcorh

*Ingreso autónomo del hogar per capita
gen y_auton_hog_pc=ytotcorh/numper

*MANTENER UNA OBSERVACIÓN POR HOGAR

bys folio : egen auxborrar=min(_n)
drop if auxborrar!=_n
drop auxborrar

*Revisamos variable ingreso pc por vivienda
sum y_auton_hog_pc, d

*CREACIÓN ÍNDICE MALA CALIDAD DE ACUERDO A PREGUNTAS SOBRE EL ESTADO DE LA VIVIENDA Y CARACT

gen index_vivienda=0

*v3. estado muros
gen _v3=.
replace _v3=0
*malo
replace _v3=1 if v3==3

*v5. estado piso
gen _v5=.
replace _v5=0
*malo
replace _v5=1 if v5==3

*v7. estado techo
gen _v7=.
replace _v7=0
*malo
replace _v7=1 if v7==3

replace index_vivienda=_v3+_v5+_v7
replace index_vivienda=1 if index_vivienda>=1
tab index_vivienda

*MANTENEMOS VARIABLES NECESARIAS ANTES DE UNIR*
keep bronq id_vivienda folio numper y_auton_hog_pc index_vivienda anio region med_edad prop_fem v1 v36b propmenor sexo_jh edad_jh esc_jh s12 hh_d_mal hh_d_prevs rural v37c viv_sit viv_compra_c_subsidio viv_qhogares viv_razon_compartir

*SE RENOMBRAN VARIABLES
rename v1 tipo_viv
rename v36b tipo_calefac
rename s12 sist_previs 
rename v37c centro_salud

order id_vivienda folio anio region bronq index_vivienda y_auton_hog_pc numper med_edad prop_fem propmenor sexo_jh edad_jh esc_jh tipo_viv tipo_calefac sist_previs hh_d_mal hh_d_prevs centro_salud rural viv_sit viv_compra_c_subsidio viv_qhogares viv_razon_compartir

replace centro_salud=0 if centro_salud!=1
label drop v37c region
replace tipo_calefac=tipo_calefac-1 if tipo_calefac>1
replace tipo_calefac=8 if tipo_calefac==98
replace region=8 if region==16

cd "$data"
save "casen hogares 2017.dta", replace
