clear all
global main "C:\Pablo\Documentos\FEN\00 20191 Otoño\Métodos Cuantitativos 4\00 Paper"
global dofiles "${main}/dofiles"
global figures "${main}/figures"
global tables "${main}/tables"
global data "${main}/data"

clear all
cd "$data"
use "casen hogares 2015-2017.dta"

*************************************************************************************************************
* V A R I A B L E S
*id_vivienda folio anio region bronq index_vivienda y_auton_hog_pc numper med_edad prop_fem propmenor sexo_jh
*tipo_viv tipo_calefac sist_previs hh_d_mal hh_d_prevs centro_salud rural
*************************************************************************************************************
*i.tipo_viv i.v_sit v_sub v_qhogares v_razoncompartir
* i.region y_auton_hog_pc rural i.tipo_viv sexo_jh propmenor numper i.v_sit v_sub v_qhogares v_razoncompartir
*************************************************************************************************************

*1*
logit index_vivienda y_auton_hog_pc rural sexo_jh esc_jh edad_jh i.v_sit v_sub v_qhogares v_razoncompartir
predict xhat1
**

*2*
logit index_vivienda y_auton_hog_pc rural i.tipo_viv sexo_jh esc_jh edad_jh i.v_sit v_sub v_qhogares v_razoncompartir
predict xhat2
**

*3*
logit index_vivienda i.region y_auton_hog_pc rural i.tipo_viv sexo_jh esc_jh edad_jh i.v_sit v_sub v_qhogares v_razoncompartir
predict xhat3
**

*Correlación X 
corr index_vivienda xhat1 xhat2 xhat3

gen error1 = index_vivienda - xhat1
gen error2 = index_vivienda - xhat2
gen error3 = index_vivienda - xhat3

twoway(kdensity xhat1)(kdensity xhat2)(kdensity xhat3)
twoway(kdensity error1)(kdensity error2)(kdensity error3)

* i.region y_auton_hog_pc rural i.tipo_viv sexo_jh propmenor numper i.v_sit v_sub v_qhogares v_razoncompartir

*Se escoge el tercer set de variables explicativas

*PARA LOGIT
local x1 "i.anio i.region"
local x2 "y_auton_hog_pc rural centro_salud i.tipo_viv"
local x3 "sexo_jh esc_jh edad_jh numper"
local x4 "hh_d_mal hh_d_prevs i.tipo_calefac"

*PARA MATCHING
ingreso
composición hogar
jefe hogar
clima
información







**CORRE BIEN
teffects nnmatch (bronq i.region y_auton_hog_pc rural centro_salud sexo_jh esc_jh edad_jh numper hh_d_mal)(index_vivienda), biasadj(y_auton_hog_pc numper) ematch(sexo_jh i.region rural hh_d_mal) dmvariables
*no exact matches for observation 134328; use option osample() to identify all observations with deficient matches

teffects nnmatch (bronq i.region y_auton_hog_pc rural centro_salud sexo_jh esc_jh edad_jh numper hh_d_mal)(index_vivienda), biasadj(y_auton_hog_pc numper) ematch(sexo_jh rural) dmvariables
*ahí si
 
teffects nnmatch (bronq i.region y_auton_hog_pc) (index_vivienda), ematch(sexo_jh) dmvariables level(90)
 
 
 
 
teffects psmatch






*******************************************************************************************************************************
*******************************************************************************************************************************
*******************************************************************************************************************************

*local treatment "index_vivienda"
*local xlist "i.region y_auton_hog_pc rural i.tipo_viv sexo_jh i.v_sit v_sub v_qhogares v_razoncompartir"


pscore index_vivienda y_auton_hog_pc sexo_jh v_sub v_qhogares v_razoncompartir, pscore(myscore) blockid(myblock) logit comsup level(0.1) numblo(10)


* Propensity score matching with common support
pscore index_vivienda i.region y_auton_hog_pc rural i.tipo_viv sexo_jh i.v_sit v_sub v_qhogares v_razoncompartir, pscore(myscore) blockid(myblock) comsup

pscore index_vivienda y_auton_hog_pc sexo_jh v_sub v_qhogares v_razoncompartir, pscore(myscore) blockid(myblock) logit comsup level(0.1) numblo(10)

pscore index_vivienda y_auton_hog_pc rural sexo_jh v_sub v_qhogares v_razoncompartir, pscore(myscore) blockid(myblock) logit level(0.1) numblo()


    numblo(#) allows to set the number of blocks of equal score range to be used at the beginning of the test of the balancing hypothesis. The default is set to 5
        blocks.



*(SET 1)**RELACIÓN - `c_relacion' ***********************
local x1 "i.anio i.region"

*(SET 2)**CONDICIONES - `c_condiciones' *****************
local x2 "y_auton_hog_pc rural centro_salud i.tipo_viv"

*(SET 3)**CARACTERIZACIÓN - `c_caracterizacion' *********
*prop_fem med_edad 
local x3 "sexo_jh numper"
*local c_caracterizacion "sexo_jh propmenor numper"

*(SET 4)**MODELAMIENTO SALUD - `c_salud' ****************
*tipo_calefac sist_previs
local x4 "hh_d_mal hh_d_prevs i.tipo_calefac"

		
		
		
		
* Matching methods 

* Nearest neighbor matching 
attnd bronq index_vivienda `x1' `x2' `x3' `x4', pscore(myscore) comsup boot dots 

attnd bronq index_vivienda anio region y_auton_hog_pc rural centro_salud sexo_jh numper hh_d_mal hh_d_prevs , pscore(myscore) comsup boot dots 




* Radius matching 
attr $ylist $treatment $xlist, pscore(myscore) comsup boot reps($breps) dots radius(0.1)

* Kernel Matching
attk $ylist $treatment $xlist, pscore(myscore) comsup boot reps($breps) dots

* Stratification Matching
atts $ylist $treatment $xlist, pscore(myscore) blockid(myblock) comsup boot reps($breps) dots

