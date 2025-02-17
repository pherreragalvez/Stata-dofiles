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

*Revisión de variables a incluir en la estimación pscore de index_vivienda
matrix IC=J(3,6,.)

*1*
logit index_vivienda y_auton_hog_pc rural sexo_jh i.v_sit v_sub v_qhogares v_razoncompartir
estat ic
matrix IC[1,1]=r(S)
predict xhat1
**

*2*
logit index_vivienda 	y_auton_hog_pc rural i.tipo_viv sexo_jh i.v_sit v_sub v_qhogares v_razoncompartir
estat ic
matrix IC[2,1]=r(S)
predict xhat2
**

*3*
logit index_vivienda i.region y_auton_hog_pc rural i.tipo_viv sexo_jh i.v_sit v_sub v_qhogares v_razoncompartir
estat ic
matrix IC[3,1]=r(S)
predict xhat3
**

*Criterios de elección de modelo
matrix colnames IC = N null full df AIC BIC
matrix rownames IC = I II III
matrix list IC

*Correlación X 
corr index_vivienda xhat1 xhat2 xhat3

gen error1 = index_vivienda - xhat1
gen error2 = index_vivienda - xhat2
gen error3 = index_vivienda - xhat3

twoway(kdensity xhat1)(kdensity xhat2)(kdensity xhat3)
twoway(kdensity error1)(kdensity error2)(kdensity error3)

* i.region y_auton_hog_pc rural i.tipo_viv sexo_jh propmenor numper i.v_sit v_sub v_qhogares v_razoncompartir

*Se escoge el tercer set de variables explicativas



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

