/* Problem Set 3. Economía Laboral
18.935.148-8 / 19.133.542-2
Prof. Dante Contreras, Otoño 2017*/

************************************************
*2.2.*******************************************
************************************************

clear all
set more off
cd "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS3\2"
use lakisha_aer.dta

gen black=.
replace black=1 if race=="b"
replace black=0 if race=="w"

gen white=.
replace white=1 if race=="w"
replace white=0 if race=="b"

*2
*Todos
ttest call, by(black)

*Chicago
ttest call if city=="c", by(black)

*Boston
ttest call if city=="b", by(black)

*Mujeres
ttest call if sex=="f", by(black)

*Mujeres en Trabajos Administrativos
ttest call if sex=="f" & (occupbroad==1 | occupbroad==2), by(black)

*Mujeres en Trabajos de Ventas
ttest call if sex=="f" & (occupbroad==3 | occupbroad==4), by(black)

*Hombres
ttest call if sex=="m", by(black)

*3
gen yearsexp_2 = yearsexp^2

gen city1 =.
replace city1 = 1 if city=="b"
replace city1 = 2 if city=="c"

gen sex1 =.
replace sex1 = 1 if sex=="f"
replace sex1 = 2 if sex=="m"

*Estimacion muestra completa
probit call yearsexp yearsexp_2 volunteer military email empholes workinschool honors computerskills specialskills i.city1 i.sex1 i.occupbroad req expreq comreq orgreq educreq ,vce(cluster ad)
predict callpredict1
sum callpredict1

*Estimacion solo Blancos
probit call yearsexp yearsexp_2 volunteer military email empholes workinschool honors computerskills specialskills i.city1 i.sex1 i.occupbroad req expreq comreq orgreq educreq if white==1 ,vce(cluster ad)
predict callpredict2
sum callpredict2

*Estimacion solo negros
probit call yearsexp yearsexp_2 volunteer military email empholes workinschool honors computerskills specialskills i.city1 i.sex1 i.occupbroad req expreq comreq orgreq educreq if black==1 ,vce(cluster ad)
predict callpredict3
sum callpredict3




************************************************
*3.1.*******************************************
************************************************

clear all
set more off

cd "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS3\3\ELPI"

use Hogar_2010.dta, clear
merge m:1 folio using Entrevistada_2010.dta, gen(merge1)
merge m:1 folio using Evaluaciones_2010.dta, gen(merge2)
save bbdd_2010, replace

use Hogar_2012.dta, clear
merge m:1 folio using Entrevistada_2012.dta, gen(merge1)
merge m:1 folio using Evaluaciones_2010.dta, gen(merge2)
save bbdd_2012, replace

******************************************************************
******************************************************************
*1. Para tabla de Altura y Peso promedio según quintil************
******************************************************************
******************************************************************

*2010*************************************************************
use bbdd_2010, clear

egen ingtotal=rowtotal(d1m d2m d3m d4m d5m d6m d7m d8m d9m)
egen yhogar=total(ingtotal), by(folio)
gen ypc=.
replace ypc=yhogar/tot_per
replace ypc=. if ypc==0
xtile qypc=ypc [pw=fexp_hog], nq(5)

save bbdd_2010, replace

*ALTURA10
replace g23=. if g23==99

ci g23 if qypc==1 [aw=fexp_hog]
gen icsup=.
replace icsup=r(ub) if qypc==1
gen icinf=.
replace icinf=r(lb) if qypc==1
gen altquin=.
replace altquin=r(mean) if qypc==1

ci g23 if qypc==2 [aw=fexp_hog]
replace icsup=r(ub) if qypc==2
replace icinf=r(lb) if qypc==2
replace altquin=r(mean) if qypc==2

ci g23 if qypc==3 [aw=fexp_hog]
replace icsup=r(ub) if qypc==3
replace icinf=r(lb) if qypc==3
replace altquin=r(mean) if qypc==3

ci g23 if qypc==4 [aw=fexp_hog]
replace icsup=r(ub) if qypc==4
replace icinf=r(lb) if qypc==4
replace altquin=r(mean) if qypc==4

ci g23 if qypc==5 [aw=fexp_hog]
replace icsup=r(ub) if qypc==5
replace icinf=r(lb) if qypc==5
replace altquin=r(mean) if qypc==5

sort qypc
twoway(scatter altquin qypc, connect(direct) title("Altura al Nacer e Ingreso - ELPI 2010") subtitle("Intérvalo de Confianza al 95%"))(scatter icsup qypc, connect(direct))(scatter icinf qypc, connect(direct))

*ZALTURA10
sum g23
gen zaltura=(g23-r(mean))/r(sd)

ci zaltura if qypc==1 [aw=fexp_hog]

gen zicsup=.
replace zicsup=r(ub) if qypc==1
gen zicinf=.
replace zicinf=r(lb) if qypc==1
gen zaltquin=.
replace zaltquin=r(mean) if qypc==1

ci zaltura if qypc==2 [aw=fexp_hog]
replace zicsup=r(ub) if qypc==2
replace zicinf=r(lb) if qypc==2
replace zaltquin=r(mean) if qypc==2

ci zaltura if qypc==3 [aw=fexp_hog]
replace zicsup=r(ub) if qypc==3
replace zicinf=r(lb) if qypc==3
replace zaltquin=r(mean) if qypc==3

ci zaltura if qypc==4 [aw=fexp_hog]
replace zicsup=r(ub) if qypc==4
replace zicinf=r(lb) if qypc==4
replace zaltquin=r(mean) if qypc==4

ci zaltura if qypc==5 [aw=fexp_hog]
replace zicsup=r(ub) if qypc==5
replace zicinf=r(lb) if qypc==5
replace zaltquin=r(mean) if qypc==5

twoway(scatter zaltquin qypc, connect(direct) title("Z-Altura al Nacer e Ingreso - ELPI 2010") subtitle("Intérvalo de Confianza al 95%"))(scatter zicsup qypc, connect(direct))(scatter zicinf qypc, connect(direct))

*PESO10
replace g24=. if g24==99

ci g24 if qypc==1 [aw=fexp_hog]
gen icsuppe=.
replace icsuppe=r(ub) if qypc==1
gen icinfpe=.
replace icinfpe=r(lb) if qypc==1
gen pesquin=.
replace pesquin=r(mean) if qypc==1

ci g24 if qypc==2 [aw=fexp_hog]
replace icsuppe=r(ub) if qypc==2
replace icinfpe=r(lb) if qypc==2
replace pesquin=r(mean) if qypc==2

ci g24 if qypc==3 [aw=fexp_hog]
replace icsuppe=r(ub) if qypc==3
replace icinfpe=r(lb) if qypc==3
replace pesquin=r(mean) if qypc==3

ci g24 if qypc==4 [aw=fexp_hog]
replace icsuppe=r(ub) if qypc==4
replace icinfpe=r(lb) if qypc==4
replace pesquin=r(mean) if qypc==4

ci g24 if qypc==5 [aw=fexp_hog]
replace icsuppe=r(ub) if qypc==5
replace icinfpe=r(lb) if qypc==5
replace pesquin=r(mean) if qypc==5

sort qypc
twoway(scatter pesquin qypc, connect(direct) title("Peso al Nacer e Ingreso - ELPI 2010") subtitle("Intérvalo de Confianza al 95%"))(scatter icsuppe qypc, connect(direct))(scatter icinfpe qypc, connect(direct))

*ZPESO10
sum g24
gen zpeso=(g24-r(mean))/r(sd)

ci zpeso if qypc==1 [aw=fexp_hog]
gen zicsuppe=.
replace zicsuppe=r(ub) if qypc==1
gen zicinfpe=.
replace zicinfpe=r(lb) if qypc==1
gen zpesquin=.
replace zpesquin=r(mean) if qypc==1

ci zpeso if qypc==2 [aw=fexp_hog]
replace zicsuppe=r(ub) if qypc==2
replace zicinfpe=r(lb) if qypc==2
replace zpesquin=r(mean) if qypc==2

ci zpeso if qypc==3 [aw=fexp_hog]
replace zicsuppe=r(ub) if qypc==3
replace zicinfpe=r(lb) if qypc==3
replace zpesquin=r(mean) if qypc==3

ci zpeso if qypc==4 [aw=fexp_hog]
replace zicsuppe=r(ub) if qypc==4
replace zicinfpe=r(lb) if qypc==4
replace zpesquin=r(mean) if qypc==4

ci zpeso if qypc==5 [aw=fexp_hog]
replace zicsuppe=r(ub) if qypc==5
replace zicinfpe=r(lb) if qypc==5
replace zpesquin=r(mean) if qypc==5

sort qypc
twoway(scatter zpesquin qypc, connect(direct) title("Z-Peso al Nacer e Ingreso - ELPI 2010") subtitle("Intérvalo de Confianza al 95%"))(scatter zicsuppe qypc, connect(direct))(scatter zicinfpe qypc, connect(direct))

*2012*************************************************************
use bbdd_2012, clear

egen ingtotal=rowtotal(l1_monto l2_monto l3_monto l4_monto l5_monto l6_monto l8_monto)
egen yhogar=total(ingtotal), by(folio)
gen ypc=.
egen tot_per=count(folio), by(folio)
replace ypc=yhogar/tot_per
replace ypc=. if ypc==0
xtile qypc=ypc [pw=fexp_hog0], nq(5)

save bbdd_2012, replace

*CORRECCIONES Y AJUSTE DE LAS VARIABLES
*Altura
replace b27=. if b27==99
*Peso
replace b28_gr=. if b28_gr==999
replace b28_gr=b28_gr*(1/1000)
replace b28_k=. if b28_k==9
gen peso=.
replace peso=b28_k+b28_gr

*ALTURA12

ci b27 if qypc==1 [aw=fexp_hog0]
gen icsup=.
replace icsup=r(ub) if qypc==1
gen icinf=.
replace icinf=r(lb) if qypc==1
gen altquin=.
replace altquin=r(mean) if qypc==1

ci b27 if qypc==2 [aw=fexp_hog0]
replace icsup=r(ub) if qypc==2
replace icinf=r(lb) if qypc==2
replace altquin=r(mean) if qypc==2

ci b27 if qypc==3 [aw=fexp_hog0]
replace icsup=r(ub) if qypc==3
replace icinf=r(lb) if qypc==3
replace altquin=r(mean) if qypc==3

ci b27 if qypc==4 [aw=fexp_hog0]
replace icsup=r(ub) if qypc==4
replace icinf=r(lb) if qypc==4
replace altquin=r(mean) if qypc==4

ci b27 if qypc==5 [aw=fexp_hog0]
replace icsup=r(ub) if qypc==5
replace icinf=r(lb) if qypc==5
replace altquin=r(mean) if qypc==5

sort qypc
twoway(scatter altquin qypc, connect(direct) title("Altura al Nacer e Ingreso - ELPI 2012") subtitle("Intérvalo de Confianza al 95%"))(scatter icsup qypc, connect(direct))(scatter icinf qypc, connect(direct))

*ZALTURA12
sum b27
gen zaltura=(b27-r(mean))/r(sd)

ci zaltura if qypc==1 [aw=fexp_hog0]

gen zicsup=.
replace zicsup=r(ub) if qypc==1
gen zicinf=.
replace zicinf=r(lb) if qypc==1
gen zaltquin=.
replace zaltquin=r(mean) if qypc==1

ci zaltura if qypc==2 [aw=fexp_hog0]
replace zicsup=r(ub) if qypc==2
replace zicinf=r(lb) if qypc==2
replace zaltquin=r(mean) if qypc==2

ci zaltura if qypc==3 [aw=fexp_hog0]
replace zicsup=r(ub) if qypc==3
replace zicinf=r(lb) if qypc==3
replace zaltquin=r(mean) if qypc==3

ci zaltura if qypc==4 [aw=fexp_hog0]
replace zicsup=r(ub) if qypc==4
replace zicinf=r(lb) if qypc==4
replace zaltquin=r(mean) if qypc==4

ci zaltura if qypc==5 [aw=fexp_hog0]
replace zicsup=r(ub) if qypc==5
replace zicinf=r(lb) if qypc==5
replace zaltquin=r(mean) if qypc==5

twoway(scatter zaltquin qypc, connect(direct) title("Z-Altura al Nacer e Ingreso - ELPI 2012") subtitle("Intérvalo de Confianza al 95%"))(scatter zicsup qypc, connect(direct))(scatter zicinf qypc, connect(direct))

*PESO12
ci peso if qypc==1 [aw=fexp_hog0]
gen icsuppe=.
replace icsuppe=r(ub) if qypc==1
gen icinfpe=.
replace icinfpe=r(lb) if qypc==1
gen pesquin=.
replace pesquin=r(mean) if qypc==1

ci peso if qypc==2 [aw=fexp_hog0]
replace icsuppe=r(ub) if qypc==2
replace icinfpe=r(lb) if qypc==2
replace pesquin=r(mean) if qypc==2

ci peso if qypc==3 [aw=fexp_hog0]
replace icsuppe=r(ub) if qypc==3
replace icinfpe=r(lb) if qypc==3
replace pesquin=r(mean) if qypc==3

ci peso if qypc==4 [aw=fexp_hog0]
replace icsuppe=r(ub) if qypc==4
replace icinfpe=r(lb) if qypc==4
replace pesquin=r(mean) if qypc==4

ci peso if qypc==5 [aw=fexp_hog0]
replace icsuppe=r(ub) if qypc==5
replace icinfpe=r(lb) if qypc==5
replace pesquin=r(mean) if qypc==5

sort qypc
twoway(scatter pesquin qypc, connect(direct) title("Peso al Nacer e Ingreso - ELPI 2012") subtitle("Intérvalo de Confianza al 95%"))(scatter icsuppe qypc, connect(direct))(scatter icinfpe qypc, connect(direct))

*ZPESO12

sum peso
gen zpeso=(peso-r(mean))/r(sd)

ci zpeso if qypc==1 [aw=fexp_hog0]
gen zicsuppe=.
replace zicsuppe=r(ub) if qypc==1
gen zicinfpe=.
replace zicinfpe=r(lb) if qypc==1
gen zpesquin=.
replace zpesquin=r(mean) if qypc==1

ci zpeso if qypc==2 [aw=fexp_hog0]
replace zicsuppe=r(ub) if qypc==2
replace zicinfpe=r(lb) if qypc==2
replace zpesquin=r(mean) if qypc==2

ci zpeso if qypc==3 [aw=fexp_hog0]
replace zicsuppe=r(ub) if qypc==3
replace zicinfpe=r(lb) if qypc==3
replace zpesquin=r(mean) if qypc==3

ci zpeso if qypc==4 [aw=fexp_hog0]
replace zicsuppe=r(ub) if qypc==4
replace zicinfpe=r(lb) if qypc==4
replace zpesquin=r(mean) if qypc==4

ci zpeso if qypc==5 [aw=fexp_hog0]
replace zicsuppe=r(ub) if qypc==5
replace zicinfpe=r(lb) if qypc==5
replace zpesquin=r(mean) if qypc==5

sort qypc
twoway(scatter zpesquin qypc, connect(direct) title("Z-Peso al Nacer e Ingreso - ELPI 2012") subtitle("Intérvalo de Confianza al 95%"))(scatter zicsuppe qypc, connect(direct))(scatter zicinfpe qypc, connect(direct))

******************************************************************
******************************************************************
*2. Para tabla de TVIP promedio según quintil*********************
******************************************************************
******************************************************************

**************************************************************************************************************
use bbdd_2010, clear
**************************************************************************************************************

ci tvip_pt if qypc==1 [aw=fexp_hog]
gen tvipsup=.
replace tvipsup=r(ub) if qypc==1
gen tvipinf=.
replace tvipinf=r(lb) if qypc==1
gen tvipquin=.
replace tvipquin=r(mean) if qypc==1

ci tvip_pt if qypc==2 [aw=fexp_hog]
replace tvipsup=r(ub) if qypc==2
replace tvipinf=r(lb) if qypc==2
replace tvipquin=r(mean) if qypc==2

ci tvip_pt if qypc==3 [aw=fexp_hog]
replace tvipsup=r(ub) if qypc==3
replace tvipinf=r(lb) if qypc==3
replace tvipquin=r(mean) if qypc==3

ci tvip_pt if qypc==4 [aw=fexp_hog]
replace tvipsup=r(ub) if qypc==4
replace tvipinf=r(lb) if qypc==4
replace tvipquin=r(mean) if qypc==4

ci tvip_pt if qypc==5 [aw=fexp_hog]
replace tvipsup=r(ub) if qypc==5
replace tvipinf=r(lb) if qypc==5
replace tvipquin=r(mean) if qypc==5

sort qypc
twoway(scatter tvipquin qypc, connect(direct) title("TVIP e Ingreso - ELPI 2010") subtitle("Intérvalo de Confianza al 95%"))(scatter tvipsup qypc, connect(direct))(scatter tvipinf qypc, connect(direct))

*******************

sum tvip_pt
gen ztvip=((tvip_pt)-r(mean))/r(sd)

ci ztvip if qypc==1 [aw=fexp_hog]
gen ztvipsup=.
replace ztvipsup=r(ub) if qypc==1
gen ztvipinf=.
replace ztvipinf=r(lb) if qypc==1
gen ztvipquin=.
replace ztvipquin=r(mean) if qypc==1

ci ztvip if qypc==2 [aw=fexp_hog]
replace ztvipsup=r(ub) if qypc==2
replace ztvipinf=r(lb) if qypc==2
replace ztvipquin=r(mean) if qypc==2

ci ztvip if qypc==3 [aw=fexp_hog]
replace ztvipsup=r(ub) if qypc==3
replace ztvipinf=r(lb) if qypc==3
replace ztvipquin=r(mean) if qypc==3

ci ztvip if qypc==4 [aw=fexp_hog]
replace ztvipsup=r(ub) if qypc==4
replace ztvipinf=r(lb) if qypc==4
replace ztvipquin=r(mean) if qypc==4

ci ztvip if qypc==5 [aw=fexp_hog]
replace ztvipsup=r(ub) if qypc==5
replace ztvipinf=r(lb) if qypc==5
replace ztvipquin=r(mean) if qypc==5

sort qypc
twoway(scatter ztvipquin qypc, connect(direct) title("Z-TVIP e Ingreso - ELPI 2010") subtitle("Intérvalo de Confianza al 95%"))(scatter ztvipsup qypc, connect(direct))(scatter ztvipinf qypc, connect(direct))

**************************************************


**************************************************************************************************************
use bbdd_2012, clear
**************************************************************************************************************

ci tvip_pt if qypc==1 [aw=fexp_hog0]
gen tvipsup=.
replace tvipsup=r(ub) if qypc==1
gen tvipinf=.
replace tvipinf=r(lb) if qypc==1
gen tvipquin=.
replace tvipquin=r(mean) if qypc==1

ci tvip_pt if qypc==2 [aw=fexp_hog0]
replace tvipsup=r(ub) if qypc==2
replace tvipinf=r(lb) if qypc==2
replace tvipquin=r(mean) if qypc==2

ci tvip_pt if qypc==3 [aw=fexp_hog0]
replace tvipsup=r(ub) if qypc==3
replace tvipinf=r(lb) if qypc==3
replace tvipquin=r(mean) if qypc==3

ci tvip_pt if qypc==4 [aw=fexp_hog0]
replace tvipsup=r(ub) if qypc==4
replace tvipinf=r(lb) if qypc==4
replace tvipquin=r(mean) if qypc==4

ci tvip_pt if qypc==5 [aw=fexp_hog0]
replace tvipsup=r(ub) if qypc==5
replace tvipinf=r(lb) if qypc==5
replace tvipquin=r(mean) if qypc==5

sort qypc
twoway(scatter tvipquin qypc, connect(direct) title("TVIP e Ingreso - ELPI 2012") subtitle("Intérvalo de Confianza al 95%"))(scatter tvipsup qypc, connect(direct))(scatter tvipinf qypc, connect(direct))


*****************
*ZTVIP2012

sum tvip_pt
gen ztvip=((tvip_pt)-r(mean))/r(sd)

ci ztvip if qypc==1 [aw=fexp_hog0]
gen ztvipsup=.
replace ztvipsup=r(ub) if qypc==1
gen ztvipinf=.
replace ztvipinf=r(lb) if qypc==1
gen ztvipquin=.
replace ztvipquin=r(mean) if qypc==1

ci ztvip if qypc==2 [aw=fexp_hog0]
replace ztvipsup=r(ub) if qypc==2
replace ztvipinf=r(lb) if qypc==2
replace ztvipquin=r(mean) if qypc==2

ci ztvip if qypc==3 [aw=fexp_hog0]
replace ztvipsup=r(ub) if qypc==3
replace ztvipinf=r(lb) if qypc==3
replace ztvipquin=r(mean) if qypc==3

ci ztvip if qypc==4 [aw=fexp_hog0]
replace ztvipsup=r(ub) if qypc==4
replace ztvipinf=r(lb) if qypc==4
replace ztvipquin=r(mean) if qypc==4

ci ztvip if qypc==5 [aw=fexp_hog0]
replace ztvipsup=r(ub) if qypc==5
replace ztvipinf=r(lb) if qypc==5
replace ztvipquin=r(mean) if qypc==5

sort qypc
twoway(scatter ztvipquin qypc, connect(direct) title("Z-TVIP e Ingreso - ELPI 2012") subtitle("Intérvalo de Confianza al 95%"))(scatter ztvipsup qypc, connect(direct))(scatter ztvipinf qypc, connect(direct))

************************************************
*3.2.*******************************************
************************************************

clear all
set more off

cd "C:\PABLO\Documentos\FEN\20171 Otoño\Microeconomía III\Problems Set\PS3\3"
use "Casen 2015"

*1
*Decil Ingreso Total
xtile dytot = ytot [pw=expr], nq(10)
tabstat ytot esc tot_per [fw=expr] , by(dytot)

*Decil Ingreso Total del Hogar
xtile dytoth = ytoth [pw=expr], nq(10)
tabstat ytoth esc tot_per [fw=expr] , by(dytoth)

*2
sort ytot
drop if ytot==.
gen i=_n-(expr)/2+0.5
egen yprom=mean(ytot)
gen sumando=ytot*(_N+1-i)
egen suma=total(sumando)
gen gini=1+1/(_N)-2*suma/(yprom*(_N)^2)
sum gini
****************************************************************
****************************************************************
use "Casen 2015", clear
sort ytoth
drop if ytoth==.
drop if o!=1
gen i=_n-(expr)/2+0.5
egen yprom=mean(ytoth)
gen sumando=ytoth*(_N+1-i)
egen suma=total(sumando)
gen ginih=1+1/(_N)-2*suma/(yprom*(_N)^2)
sum gini
****************************************************************
****************************************************************

*3

forvalues i=1/15{
   use "Casen 2015", clear
   sort ytot
   drop if ytot==.
   drop if region!=`i'
   gen i=_n-(expr)/2+0.5
   egen yprom=mean(ytot)
   gen sumando=ytot*(_N+1-i)
   egen suma=total(sumando)
   gen gini=1+1/(_N)-2*suma/(yprom*(_N)^2)
   sum gini

}

forvalues i=1/2{
   use "Casen 2015", clear
   sort ytot
   drop if ytot==.
   drop if sexo!=`i'
   gen i=_n-(expr)/2+0.5
   egen yprom=mean(ytot)
   gen sumando=ytot*(_N+1-i)
   egen suma=total(sumando)
   gen gini=1+1/(_N)-2*suma/(yprom*(_N)^2)
   sum gini
}

*4
use "Casen 2015", clear
sort ytot
drop if ytot==.
egen yprom=mean(ytot)
gen sumando=(ytot/yprom)*ln(ytot/yprom)
egen suma=total(sumando)
gen theil=suma/_N
sum theil


*5
sum ytot, detail
return list

************************************************************
*Pregunta 4

clear all
set more off

use "C:\Users\nnnnn\Dropbox\Universidad\7mo Semestre - Otoño 2017\Microeconomía III\Paper\CASEN\Casen 2015.dta", clear

*Para factores de expansión: fweight, variable es expr (regional).

*Re-ordenamos variable sexo
replace sexo=0 if sexo==1
replace sexo=1 if sexo==2

label define Genero 0 "Hombre" 1 "Mujer"
label values sexo Genero
label list Genero

*Generamos quintiles, según ingreso del hogar.
xtile quintil=ytotcorh [fw=expr], nq(5)

*Recodificamos zona (urbano y rural)
recode zona (1=0) (2=1)

*Región es "region"
*Escolaridad es "esc"

/****************************************************
1)				Estadística descriptiva
****************************************************/
/**OPCIÓN A (Todos)
*Escolaridad promedio
summ esc [fw=expr] 
*Por quintil
summ esc if quintil==1 [fw=expr]
summ esc if quintil==2 [fw=expr]
summ esc if quintil==3 [fw=expr]
summ esc if quintil==4 [fw=expr]
summ esc if quintil==5 [fw=expr]
*Por zona
summ esc if zona==0 [fw=expr]
summ esc if zona==1 [fw=expr]
*Por región
summ esc if region==1 [fw=expr]
summ esc if region==2 [fw=expr]
summ esc if region==3 [fw=expr]
summ esc if region==4 [fw=expr]
summ esc if region==5 [fw=expr]
summ esc if region==6 [fw=expr]
summ esc if region==7 [fw=expr]
summ esc if region==8 [fw=expr]
summ esc if region==9 [fw=expr]
summ esc if region==10 [fw=expr]
summ esc if region==11 [fw=expr]
summ esc if region==12 [fw=expr]
summ esc if region==13 [fw=expr]
summ esc if region==14 [fw=expr]
summ esc if region==15 [fw=expr]
*Por género
summ esc if sexo==0 [fw=expr]
summ esc if sexo==1 [fw=expr]
*/

*OPCIÓN B (los que no asisten)

drop if e3==1
*Escolaridad promedio
summ esc [fw=expr] 
*Por quintil
summ esc if quintil==1 [fw=expr]
summ esc if quintil==2 [fw=expr]
summ esc if quintil==3 [fw=expr]
summ esc if quintil==4 [fw=expr]
summ esc if quintil==5 [fw=expr]
*Por zona
summ esc if zona==0 [fw=expr]
summ esc if zona==1 [fw=expr]
*Por región
summ esc if region==1 [fw=expr]
summ esc if region==2 [fw=expr]
summ esc if region==3 [fw=expr]
summ esc if region==4 [fw=expr]
summ esc if region==5 [fw=expr]
summ esc if region==6 [fw=expr]
summ esc if region==7 [fw=expr]
summ esc if region==8 [fw=expr]
summ esc if region==9 [fw=expr]
summ esc if region==10 [fw=expr]
summ esc if region==11 [fw=expr]
summ esc if region==12 [fw=expr]
summ esc if region==13 [fw=expr]
summ esc if region==14 [fw=expr]
summ esc if region==15 [fw=expr]
*Por género
summ esc if sexo==0 [fw=expr]
summ esc if sexo==1 [fw=expr]

/**OPCIÓN C (Mayores de edad)
preserve
drop if edad<18
*Escolaridad promedio
summ esc if [fw=expr] 
*Por quintil
summ esc if quintil==1 [fw=expr]
summ esc if quintil==2 [fw=expr]
summ esc if quintil==3 [fw=expr]
summ esc if quintil==4 [fw=expr]
summ esc if quintil==5 [fw=expr]
*Por zona
summ esc if zona==0 [fw=expr]
summ esc if zona==1 [fw=expr]
*Por región
summ esc if region==1 [fw=expr]
summ esc if region==2 [fw=expr]
summ esc if region==3 [fw=expr]
summ esc if region==4 [fw=expr]
summ esc if region==5 [fw=expr]
summ esc if region==6 [fw=expr]
summ esc if region==7 [fw=expr]
summ esc if region==8 [fw=expr]
summ esc if region==9 [fw=expr]
summ esc if region==10 [fw=expr]
summ esc if region==11 [fw=expr]
summ esc if region==12 [fw=expr]
summ esc if region==13 [fw=expr]
summ esc if region==14 [fw=expr]
summ esc if region==15 [fw=expr]
*Por género
summ esc if sexo==0 [fw=expr]
summ esc if sexo==1 [fw=expr]
restore
*/

/****************************************************
2)			Educación de padre y madre
****************************************************/
*Educación de la madre
gen edum=.
replace edum=1 if r10a==1 // Nunca asistió
replace edum=2 if r10a==2 | r10a==3 // Preescolar, primaria, básica
replace edum=3 if r10a==4 | r10a==5 | r10a==6 | r10a==7 // Media
replace edum=4 if r10a==8 | r10a==9 | r10a==10 // Superior
*Educación del padre
gen edup=.
replace edup=1 if r10b==1 // Nunca asistió
replace edup=2 if r10b==2 | r10b==3 // Preescolar, primaria, básica
replace edup=3 if r10b==4 | r10b==5 | r10b==6 | r10b==7 // Media
replace edup=4 if r10b==8 | r10b==9 | r10b==10 // Superior
*Escolaridad individuo
gen escolaridad=.
replace escolaridad=1 if educ==0 & e3==2
replace escolaridad=2 if (educ==1 | educ==2 | educ==3 | educ==4) & e3==2
replace escolaridad=3 if (educ==5 | educ==6 |  educ==7 | educ==9) & e3==2
replace escolaridad=4 if (educ==8 | educ==10 | educ==11 | educ==12) & e3==2

*Regresionamos (No por tramos)
reg esc edup if sexo==0 [fw=expr], r
reg esc edup if sexo==1 [fw=expr], r

reg esc edum if sexo==0 [fw=expr], r
reg esc edum if sexo==1 [fw=expr], r

/****************************************************
3)		Educación de padre y madre, por quintiles
****************************************************/
reg esc edup if sexo==0 & quintil==1 [fw=expr], r
reg esc edup if sexo==0 & quintil==2 [fw=expr], r
reg esc edup if sexo==0 & quintil==3 [fw=expr], r
reg esc edup if sexo==0 & quintil==4 [fw=expr], r
reg esc edup if sexo==0 & quintil==5 [fw=expr], r

reg esc edup if sexo==1 & quintil==1 [fw=expr], r
reg esc edup if sexo==1 & quintil==2 [fw=expr], r
reg esc edup if sexo==1 & quintil==3 [fw=expr], r
reg esc edup if sexo==1 & quintil==4 [fw=expr], r
reg esc edup if sexo==1 & quintil==5 [fw=expr], r

reg esc edum if sexo==0 & quintil==1 [fw=expr], r
reg esc edum if sexo==0 & quintil==2 [fw=expr], r
reg esc edum if sexo==0 & quintil==3 [fw=expr], r
reg esc edum if sexo==0 & quintil==4 [fw=expr], r
reg esc edum if sexo==0 & quintil==5 [fw=expr], r

reg esc edum if sexo==1 & quintil==1 [fw=expr], r
reg esc edum if sexo==1 & quintil==2 [fw=expr], r
reg esc edum if sexo==1 & quintil==3 [fw=expr], r
reg esc edum if sexo==1 & quintil==4 [fw=expr], r
reg esc edum if sexo==1 & quintil==5 [fw=expr], r

/****************************************************
4)			Educación de la madre, controles
****************************************************/

***Creamos controles
*Edad ya creada
*Estado civil --> variable "ecivil"

*Dummies región
gen re1=0
replace re1=1 if region==1
gen re2=0
replace re2=1 if region==2
gen re3=0
replace re3=1 if region==3
gen re4=0
replace re4=1 if region==4
gen re5=0
replace re5=1 if region==5
gen re6=0
replace re6=1 if region==6
gen re7=0
replace re7=1 if region==7
gen re8=0
replace re8=1 if region==8
gen re9=0
replace re9=1 if region==9
gen re10=0
replace re10=1 if region==10
gen re11=0
replace re11=1 if region==11
gen re12=0
replace re12=1 if region==12
gen re13=0
replace re13=1 if region==13
gen re14=0
replace re14=1 if region==14
gen re15=0
replace re15=1 if region==15

*Dummies ocupación
gen ocup1=0
replace ocup1=1 if oficio1==0 //FF. AA.
gen ocup2=0
replace ocup2=1 if oficio1==1 //Ejecutivo y Legislativo
gen ocup3=0
replace ocup3=1 if oficio1==2 //Profesionales
gen ocup4=0
replace ocup4=1 if oficio1==3 //Tec-prof nivel medio
gen ocup5=0
replace ocup5=1 if oficio1==4 //Empleados oficina
gen ocup6=0
replace ocup6=1 if oficio1==5 //Trabajadores comercio y servicio
gen ocup7=0
replace ocup7=1 if oficio1==6 //Agricultores
gen ocup8=0
replace ocup8=1 if oficio1==7 //Mecánica
gen ocup9=0
replace ocup9=1 if oficio1==8 //Operadores
gen ocup10=0
replace ocup10=1 if oficio1==9 //No calificados

*a) Sin controles
reg esc edum if sexo==0 [fw=expr], r
reg esc edum if sexo==1 [fw=expr], r

*b) Controlando edad y estado civil
reg esc edum edad ecivil if sexo==0 [fw=expr], r
reg esc edum edad ecivil if sexo==1 [fw=expr], r

*c) Controlando edad, estado civil y región
reg esc edum edad ecivil re1 re2 re3 re4 re5 re6 re7 re8 re9 re10 re11 re12 re13 re14 re15 if sexo==0 [fw=expr], r noconstant
reg esc edum edad ecivil re1 re2 re3 re4 re5 re6 re7 re8 re9 re10 re11 re12 re13 re14 re15 if sexo==1 [fw=expr], r noconstant

*d) Controlando edad, estado civil, región y ocupación
reg esc edum edad ecivil re1 re2 re3 re4 re5 re6 re7 re8 re9 re10 re11 re12 re13 re14 re15 ocup1 ocup2 ocup3 ocup4 ocup5 ocup6 ocup7 ocup8 ocup9 ocup10 if sexo==0 [fw=expr], r noconstant
reg esc edum edad ecivil re1 re2 re3 re4 re5 re6 re7 re8 re9 re10 re11 re12 re13 re14 re15 ocup1 ocup2 ocup3 ocup4 ocup5 ocup6 ocup7 ocup8 ocup9 ocup10 if sexo==1 [fw=expr], r noconstant
