
clear all
*cd "C:\Users\Williams\Desktop\MICRO III\PS1"
cd "C:\Pablo\Documentos\FEN\0 20181 Otoño\Microeconomía III\Problems Set\1\PSET1"
use nsw_dw_treated&controls

*3

eststo sum1 : estpost tabstat age education black hispanic married nodegree re74 re75 if treat==1, listwise s(mean semean) columns(statistics) 
eststo sum2 : estpost tabstat age education black hispanic married nodegree re74 re75 if treat==0, listwise s(mean semean) columns(statistics) 
esttab sum1 sum2, title("Sample means and standard error of covariates for male NSW participants") mtitles("Tratados" "Control") main(mean) aux(semean) nostar 

*4

reg re78 treat
ttest re78, by(treat)
*AMBOS SON IGUALES. CONSIDERAR LOS ESTADISTICOS T.
reg re78 treat age education nodegree black hispanic married 
reg re78 treat education black


*5

drop if treat==0
append using cps_controls
pscore treat age education nodegree black hispanic married re74 re75, pscore(ps) blockid(men) logit
attk re78 treat age education nodegree black hispanic married, pscore(ps) comsup boot reps(100) dots
histogram ps, kdens //para pregunta 7 (NSW & CPS)

drop if treat==0
drop ps
drop men
append using psid_controls
pscore treat age education nodegree black hispanic married, pscore(ps) blockid(men) logit detail //no se realiza el balanceo de algunos bloques. 
histogram ps, kdens //para pregunta 7 (NSW & PSID)

*6
//para PSID
attnd re78 treat age education black nodegree married hispanic, pscore(ps) logit comsup 
drop ps men
drop if treat==0
//Para CPS
append using cps_controls
pscore treat age education nodegree black hispanic married, pscore(ps) blockid(men) logit
attnd re78 treat age education black nodegree married hispanic, pscore(ps) logit comsup
//FALTA CREAR TABLAS RESUMEN DE PREGUNTAS 5 Y 6

*7
//Comandos utilizados se encuentran en la parte 5, resultados adjuntos en el pdf. 

*8
clear
use nsw_dw_treated&controls
drop if treat==0
append using cps_controls
reg re78 treat
ttest re78, by(treat)
reg re78 treat age education black hispanic nodegree married


drop if treat==0
append using psid_controls
reg re78 treat
ttest re78, by(treat)
reg re78 treat age education black hispanic nodegree married
//tratamiento tiene un efecto negativo en re78. no tiene sentido

