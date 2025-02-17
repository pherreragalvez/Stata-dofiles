clear all
global main "C:\Pablo\Documentos\FEN\00 20191 Otoño\Métodos Cuantitativos 4\00 Paper"
global dofiles "${main}/dofiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

clear all
cd "$data"
use "casen hogares 2015-2017.dta"

*Revisión datos

* V A R I A B L E S
*id_vivienda folio anio region bronq index_vivienda
*y_auton_hog_pc numper med_edad prop_fem propmenor sexo_jh
*tipo_viv tipo_calefac
*sist_previs hh_d_mal hh_d_prevs centro_salud rural

tab anio
**********************
tab region
**********************
tab bronq
**********************
tab index_vivienda
**********************
sum y_auton_hog_pc,d
*Hist. del "y_auton_hog_pc " para el 95% de menos ingresos
hist y_auton_hog_pc if y_auton_hog_pc<900000
**********************
sum numper
*Hist. del 99% de hogares con menos número de personas.
hist numper if numper <=8
**********************
hist med_edad
**********************
tab prop_fem
**********************
tab propmenor
**********************
*sexo_jh 0 si hombre; 1 si mujer
tab sexo_jh
**********************
tab tipo_viv
**********************
tab tipo_calefac
**********************
tab sist_previs
**********************
tab hh_d_mal
**********************
tab hh_d_prevs
**********************
tab centro_salud
**********************
tab rural
**********************
