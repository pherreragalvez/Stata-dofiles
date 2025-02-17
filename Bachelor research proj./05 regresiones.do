clear all
global main "C:\Pablo\Documentos\FEN\00 20191 Otoño\Métodos Cuantitativos 4\00 Paper"
global dofiles "${main}/dofiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

*BBDD
cd "$data"
use "casen hogares 2015-2017.dta"

*D E F I N I C I O N _ V A R I A B L E S ***************************************
********************************************************************************

*(SET 1)**RELACIÓN - `c_relacion' ***********************
local x1 "i.anio i.region"

*(SET 2)**CONDICIONES - `c_condiciones' *****************
local x2 "y_auton_hog_pc rural centro_salud i.tipo_viv"

*(SET 3)**CARACTERIZACIÓN - `c_caracterizacion' *********
*prop_fem med_edad 
local x3 "sexo_jh esc_jh edad_jh numper"
*local c_caracterizacion "sexo_jh propmenor numper"

*(SET 4)**MODELAMIENTO SALUD - `c_salud' ****************
*tipo_calefac sist_previs
local x4 "hh_d_mal hh_d_prevs i.tipo_calefac"


* E S T I M A C I O N E S ******************************************************
********************************************************************************

*1* (CONTROLES RELACIÓN)
probit bronq index_vivienda `x1'
margins, dydx(index_vivienda) atmeans post
estimates store prob_1

logit bronq index_vivienda `x1'
margins, dydx(index_vivienda) atmeans post
estimates store log_1

*2 (CONTROLES RELACIÓN) + (CONTROLES CONDICIONES) + (CONTROLES CARACTERIZACIÓN)
probit bronq index_vivienda `x1' `x2' `x3'
margins, dydx(index_vivienda y_auton_hog_pc sexo_jh esc_jh edad_jh numper) atmeans post
estimates store prob_2

logit bronq index_vivienda `x1' `x2' `x3'
margins, dydx(index_vivienda y_auton_hog_pc sexo_jh esc_jh edad_jh numper) atmeans post
estimates store log_2

*3
probit bronq index_vivienda `x1' `x2' `x3' `x4'
margins, dydx(index_vivienda y_auton_hog_pc sexo_jh esc_jh edad_jh numper hh_d_mal hh_d_prevs) atmeans post
*margins, dydx(index_vivienda) atmeans  at(_decil=(1 2 3)) post
estimates store prob_3

logit bronq index_vivienda `x1' `x2' `x3' `x4'
margins, dydx(index_vivienda y_auton_hog_pc sexo_jh esc_jh edad_jh numper hh_d_mal hh_d_prevs) atmeans post
estimates store log_3

cd "$tables"
esttab prob_1 log_1 prob_2 log_2 prob_3 log_3 using "estimaciones_123.rtf", replace


* E S T I M A C I O N  3  E V A L U A D A  E N  B A J O S  D E C I L E S *******
********************************************************************************

*Se definen localmente las medias de ingreso per capita para cada decil.
forvalues i = 1(1)10 {
summarize y_aut if _decil==`i'
local dec`i' = round(r(mean),0.1)
}

*Se replica la 3a estimación evaluada, EVALUANDO en la media de ingreso de cada decil
probit bronq index_vivienda `x1' `x2' `x3' `x4'
margins, dydx(y_auton_hog_pc index_vivienda) at(y_auton_hog_pc=(`dec1' `dec2' `dec3' `dec4' `dec5' `dec6' `dec7' `dec8' `dec9' `dec10')) post
estimates store prob_3b

logit bronq index_vivienda `x1' `x2' `x3' `x4'
margins, dydx(y_auton_hog_pc index_vivienda) at(y_auton_hog_pc=(`dec1' `dec2' `dec3' `dec4' `dec5' `dec6' `dec7' `dec8' `dec9' `dec10')) post
estimates store log_3b

cd "$tables"
esttab prob_3b log_3b using "estimacion3_endeciles.rtf", replace
